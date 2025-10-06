const std = @import("std");
const win32 = @import("win32.zig");

pub fn init() void {
    _ = win32.wWinMain();
}
