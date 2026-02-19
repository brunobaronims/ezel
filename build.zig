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

    const vk = b.addTranslateC(.{
        .root_source_file = .{
            .cwd_relative = b.pathJoin(&.{
                vulkan_path.?,
                "/Include/vulkan/vulkan.h",
            }),
        },
        .target = target,
        .optimize = optimize,
    });
    vk.addIncludePath(.{
        .cwd_relative = b.pathJoin(&.{ vulkan_path.?, "/Include" }),
    });

    if (is_windows) {
        vk.defineCMacro("VK_USE_PLATFORM_WIN32_KHR", null);

        const windows_sdk_path = b.option(
            []const u8,
            "windows-sdk",
            "Windows SDK path",
        ) orelse b.graph.environ_map.get("WINDOWS_SDK");
        if (windows_sdk_path == null or std.mem.trim(
            u8,
            windows_sdk_path.?,
            &std.ascii.whitespace,
        ).len == 0) {
            b.getInstallStep().dependOn(&b.addFail(
                "Windows SDK path not configured",
            ).step);
            return;
        }

        const win_user = b.addTranslateC(.{
            .root_source_file = .{
                .cwd_relative = b.pathJoin(&.{
                    windows_sdk_path.?,
                    "/um/Windows.h",
                }),
            },
            .target = target,
            .optimize = optimize,
            .link_libc = true,
        });
        win_user.defineCMacro("WIN32_LEAN_AND_MEAN", null);
        const win_user_mod = win_user.createModule();
        ezel_mod.addImport("win_user", win_user_mod);
        exe.root_module.addImport("win_user", win_user_mod);

        ezel_mod.linkSystemLibrary("user32", .{});
        exe.root_module.linkSystemLibrary("user32", .{});
    }

    const vk_mod = vk.createModule();
    ezel_mod.addImport("vulkan_c", vk_mod);
    exe.root_module.addImport("vulkan_c", vk_mod);
    ezel_mod.addLibraryPath(.{
        .cwd_relative = b.pathJoin(&.{ vulkan_path.?, "/Lib" }),
    });
    ezel_mod.linkSystemLibrary("vulkan-1", .{});
    exe.root_module.addLibraryPath(.{
        .cwd_relative = b.pathJoin(&.{ vulkan_path.?, "/Lib" }),
    });
    exe.root_module.linkSystemLibrary("vulkan-1", .{});

    b.installArtifact(exe);
    const run_step = b.step("run", "Run the app");
    const run_cmd = b.addRunArtifact(exe);
    run_step.dependOn(&run_cmd.step);
    run_cmd.step.dependOn(b.getInstallStep());
}
