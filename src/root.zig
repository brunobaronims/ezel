const std = @import("std");
// const user32 = @import("windows/user32.zig");
const d2d1 = @import("windows/d2d1.zig");

pub fn init() void {
    const factory = d2d1.NewFactory() catch unreachable;
    defer _ = factory.Release();
    std.log.info("created factory!", .{});

    const dpi = factory.GetDesktopDpi();
    std.log.info("x dpi: {d}, y dpi: {d}", .{ dpi.x, dpi.y });
}
