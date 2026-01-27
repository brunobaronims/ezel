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

    try Vulkan.init(allocator, &platform);

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
