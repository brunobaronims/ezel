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

        const vk_config = switch (builtin.os.tag) {
            .windows => vk.Config{
                .required_extensions = &required_extensions,
                .required_layers = &required_layers,
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
