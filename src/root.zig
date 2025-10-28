const std = @import("std");
const builtin = @import("builtin");
const windows = @import("windows/root.zig");

pub const Application = union(enum) {
    windows: *windows.Application,

    pub fn drawRectangle(self: *Application) !void {
        switch (self.*) {
            inline else => |app| app.drawRectangle(),
        }
    }

    pub fn release(self: *Application) void {
        switch (self.*) {
            inline else => |app| app.release(),
        }
    }

    pub fn run(self: *Application) void {
        switch (self.*) {
            inline else => |app| app.run(),
        }
    }

    pub fn deinit(self: *Application, allocator: std.mem.Allocator) void {
        switch (self.*) {
            inline else => |app| allocator.destroy(app),
        }
    }
};

pub fn NewApplication(allocator: std.mem.Allocator) !Application {
    switch (builtin.target.os.tag) {
        .windows => {
            return Application{ .windows = try windows.NewApplication(allocator) };
        },
        else => @compileError("Unsupported OS"),
    }
}
