const std = @import("std");
pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{
        .default_target = .{
            .cpu_arch = .x86_64,
            .os_tag = .windows,
            .abi = .gnu,
        },
    });
    const optimize = b.standardOptimizeOption(.{});
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
        exe.root_module.addImport("win_user", win_user_mod);

        exe.root_module.linkSystemLibrary("user32", .{});
    }

    const vk_mod = vk.createModule();
    exe.root_module.addImport("vulkan_c", vk_mod);
    exe.root_module.addLibraryPath(.{
        .cwd_relative = b.pathJoin(&.{ vulkan_path.?, "Lib" }),
    });
    exe.root_module.linkSystemLibrary("vulkan-1", .{});

    b.installArtifact(exe);
    const run_step = b.step("run", "Run the app");
    const run_cmd = b.addRunArtifact(exe);
    run_step.dependOn(&run_cmd.step);
    run_cmd.step.dependOn(b.getInstallStep());
}
