const std = @import("std");
const builtin = @import("builtin");
const Vulkan = @import("Vulkan.zig");

const Ezel = @This();

window: *Window,
renderer: Renderer,

pub const Dimensions = struct {
    width: u32,
    height: u32,
};

pub fn init(allocator: std.mem.Allocator) !*Ezel {
    const ezel = try allocator.create(Ezel);
    errdefer allocator.destroy(ezel);

    const window = try Window.init(allocator);
    errdefer window.deinit(allocator);

    ezel.window = window;

    if (Vulkan.init(allocator, window)) |vulkan| {
        ezel.renderer = .{ .vulkan = vulkan };
    } else |err| switch (err) {
        error.OutOfMemory => {
            return err;
        },
        else => {
            const renderer = try allocator.create(NativeRenderer);
            ezel.renderer = .{ .native = renderer };
        },
    }

    return ezel;
}

pub fn deinit(ezel: *Ezel, allocator: std.mem.Allocator) void {
    ezel.window.deinit(allocator);
    ezel.renderer.deinit(allocator);
    allocator.destroy(ezel);
}

pub const Window = switch (builtin.os.tag) {
    .windows => @import("windows/Window.zig"),
    else => @compileError("unsupported platform"),
};

const NativeRenderer = switch (builtin.os.tag) {
    .windows => @import("windows/Renderer.zig"),
    else => @compileError("unsupported platform"),
};

pub const Renderer = union(enum) {
    vulkan: *Vulkan,
    native: *NativeRenderer,

    pub fn deinit(
        renderer: Renderer,
        allocator: std.mem.Allocator,
    ) void {
        switch (renderer) {
            inline else => |r| r.deinit(allocator),
        }
    }
};
