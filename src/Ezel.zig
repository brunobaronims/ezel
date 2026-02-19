const std = @import("std");
const builtin = @import("builtin");
const Vulkan = @import("Vulkan.zig");

platform: Platform,

pub const Dimensions = struct {
    width: u32,
    height: u32,
};

pub fn init(allocator: std.mem.Allocator) !*Platform {
    const platform = try Platform.init(allocator);
    try Vulkan.init(allocator, platform);
    return platform;
}

pub const Platform = switch (builtin.os.tag) {
    .windows => @import("Windows.zig"),
    else => @compileError("unsupported platform"),
};
