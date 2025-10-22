const std = @import("std");
const ezel = @import("root.zig");

pub fn main() void {
    var app = ezel.NewApplication() catch |err| {
        std.log.err("{}", .{err});
        return;
    };

    app.run();
}
