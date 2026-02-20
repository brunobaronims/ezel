const std = @import("std");
pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const ezel_mod = b.addModule("ezel", .{
        .root_source_file = b.path("src/Ezel.zig"),
        .target = target,
        .optimize = optimize,
    });
    const exe = b.addExecutable(.{
        .name = "ezel",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });

    const is_windows = target.result.os.tag == .windows;

    const vulkan_path = b.option(
        []const u8,
        "vulkan",
        "Vulkan SDK path",
    ) orelse b.graph.environ_map.get("VULKAN_SDK");
    if (vulkan_path == null or std.mem.trim(
        u8,
        vulkan_path.?,
        &std.ascii.whitespace,
    ).len == 0) {
        b.getInstallStep().dependOn(&b.addFail(
            "Vulkan SDK path not configured",
        ).step);
        return;
    }

    if (is_windows) {
        ezel_mod.linkSystemLibrary("user32", .{});
        exe.root_module.linkSystemLibrary("user32", .{});

        ezel_mod.linkSystemLibrary("vulkan-1", .{});
        exe.root_module.linkSystemLibrary("vulkan-1", .{});
    } else {
        ezel_mod.linkSystemLibrary("vulkan", .{});
        exe.root_module.linkSystemLibrary("vulkan", .{});
    }

    ezel_mod.addLibraryPath(.{
        .cwd_relative = b.pathJoin(&.{ vulkan_path.?, "Lib" }),
    });
    exe.root_module.addLibraryPath(.{
        .cwd_relative = b.pathJoin(&.{ vulkan_path.?, "Lib" }),
    });

    b.installArtifact(exe);
    const run_step = b.step("run", "Run the app");
    const run_cmd = b.addRunArtifact(exe);
    run_step.dependOn(&run_cmd.step);
    run_cmd.step.dependOn(b.getInstallStep());
}
