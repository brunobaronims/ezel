const std = @import("std");
const user32 = @import("windows/user32.zig");

pub fn init() void {
    const hwnd = user32.NewApplication() catch unreachable;
    
    user32.run(hwnd);
}
