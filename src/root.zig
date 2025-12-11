const std = @import("std");
const builtin = @import("builtin");
const windows = @import("windows/root.zig");
const vk = @import("vulkan/root.zig");

pub const Window = union(enum) {
    windows: *windows.Window,

    pub fn run(self: *Window) void {
        switch (self.*) {
            inline else => |app| app.run(),
        }
    }

    pub fn deinit(self: *Window, allocator: std.mem.Allocator) void {
        switch (self.*) {
            inline else => |app| allocator.destroy(app),
        }
    }
};

pub const Application = struct {
    platform: Window,
    instance: vk.Instance,

    pub fn init(allocator: std.mem.Allocator) !Application {
        const vk_config = switch (builtin.os.tag) {
            .windows => vk.Config{
                .required_extensions = &[_][*:0]const u8{
                    "VK_KHR_surface",
                    "VK_KHR_win32_surface",
                },
                .required_layers = &[_][*:0]const u8{},
            },
            else => @compileError("unsupported platform"),
        };

        const instance = try vk.init(allocator, vk_config);

        const platform = switch (builtin.os.tag) {
            .windows => Window{ .windows = try windows.NewWindow(allocator) },
            else => @compileError("unsupported platform"),
        };

        return .{ .platform = platform, .instance = instance };
    }

    pub fn run(self: *Application) void {
        self.platform.run();
    }

    pub fn release(self: *Application, allocator: std.mem.Allocator) void {
        self.platform.deinit(allocator);
        vk.deinit(self.instance);
    }
};
