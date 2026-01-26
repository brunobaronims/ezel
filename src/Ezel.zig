const std = @import("std");
const builtin = @import("builtin");
const Windows = @import("Windows.zig");
const Vulkan = @import("Vulkan.zig");

platform: Platform,

pub fn init(allocator: std.mem.Allocator) !Platform {
    var platform = switch (builtin.os.tag) {
        .windows => Platform{ .windows = try Windows.init(allocator) },
        else => @compileError("unsupported platform"),
    };

    var required_layers = std.ArrayList([*:0]const u8).empty;
    defer required_layers.deinit(allocator);
    var required_extensions = try std.ArrayList([*:0]const u8).initCapacity(allocator, 2);
    defer required_extensions.deinit(allocator);

    switch (builtin.os.tag) {
        .windows => {
            try required_extensions.append(allocator, "VK_KHR_surface");
            try required_extensions.append(allocator, "VK_KHR_win32_surface");
        },
        else => @compileError("unsupported platform"),
    }

    const vk_config: Vulkan.Config = .{
        .required_extensions = &required_extensions,
        .required_layers = &required_layers,
    };

    try Vulkan.init(allocator, vk_config, &platform);

    return platform;
}

pub const Platform = union(enum) {
    windows: *Windows,

    pub fn run(platform: *Platform) void {
        switch (platform.*) {
            inline else => |w| w.run(),
        }
    }

    pub fn deinit(platform: *Platform, allocator: std.mem.Allocator) void {
        switch (platform.*) {
            inline else => |w| {
                w.deinit(allocator);
                allocator.destroy(w);
            },
        }
    }
};
