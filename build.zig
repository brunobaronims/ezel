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
            .link_libc = true,
        }),
    });

    const vk = b.addTranslateC(.{
        .root_source_file = .{ .cwd_relative = "/mnt/c/VulkanSDK/1.4.328.1/Include/vulkan/vulkan_core.h" },
        .target = target,
        .optimize = optimize,
    });
    vk.addIncludePath(.{ .cwd_relative = "/mnt/c/VulkanSDK/1.4.328.1/Include" });
    const vk_mod = vk.createModule();

    const win_user = b.addTranslateC(.{
        .root_source_file = .{ .cwd_relative = "/mnt/c/Program Files (x86)/Windows Kits/10/Include/10.0.26100.0/um/Windows.h" },
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });
    const win_user_mod = win_user.createModule();

    exe.root_module.addImport("win_user", win_user_mod);
    exe.root_module.addImport("vulkan_c", vk_mod);
    exe.addLibraryPath(.{ .cwd_relative = "/mnt/c/VulkanSDK/1.4.328.1/Lib" });
    exe.linkSystemLibrary("user32");
    exe.linkSystemLibrary("vulkan-1");

    b.installArtifact(exe);

    const run_step = b.step("run", "Run the app");

    const run_cmd = b.addRunArtifact(exe);
    run_step.dependOn(&run_cmd.step);

    run_cmd.step.dependOn(b.getInstallStep());

    const test_step = b.step("test", "Run unit tests");

    const lib_tests = b.addTest(.{ .root_module = b.createModule(.{
        .root_source_file = b.path("src/Ezel.zig"),
        .target = target,
        .optimize = optimize,
    }) });

    const run_lib_tests = b.addRunArtifact(lib_tests);
    test_step.dependOn(&run_lib_tests.step);
}
