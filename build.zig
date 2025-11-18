const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "ezel",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });

    const vulkan = b.dependency("vulkan_zig", .{
        .registry = b.path("../../../../../mnt/c/VulkanSDK/1.4.328.1/share/vulkan/registry/vk.xml"),
    }).module("vulkan-zig");

    exe.root_module.addImport("vulkan", vulkan);

    exe.addLibraryPath(.{ .cwd_relative = "lib" });
    exe.linkSystemLibrary("user32");
    exe.linkSystemLibrary("d2d1");
    exe.linkSystemLibrary("ole32");

    b.installArtifact(exe);

    const run_step = b.step("run", "Run the app");

    const run_cmd = b.addRunArtifact(exe);
    run_step.dependOn(&run_cmd.step);

    run_cmd.step.dependOn(b.getInstallStep());

    const test_step = b.step("test", "Run unit tests");

    const lib_tests = b.addTest(.{ .root_module = b.createModule(.{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    }) });

    const run_lib_tests = b.addRunArtifact(lib_tests);
    test_step.dependOn(&run_lib_tests.step);
}
