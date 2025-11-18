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
    vk: vk.Api,

    pub fn init(allocator: std.mem.Allocator) !Application {
        var vk_api = try vk.Api.init(allocator);
        errdefer vk_api.deinit();

        const platform = Window{
            .windows = try windows.NewWindow(allocator),
        };

        return .{ .platform = platform, .vk = vk_api };
    }

    pub fn run(self: *Application) void {
        self.platform.run();
    }

    pub fn release(self: *Application, allocator: std.mem.Allocator) void {
        self.vk.deinit();
        self.platform.deinit(allocator);
    }
};
