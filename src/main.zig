const std = @import("std");
const ezel = @import("root.zig");

pub fn main() void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer {
        const check = gpa.deinit();
        if (check == .leak) {
            std.log.debug("leaked while deinitializing app allocator", .{});
        }
    }
    const allocator = gpa.allocator();

    var app = ezel.NewApplication(allocator) catch |err| {
        std.log.err("{}", .{err});
        return;
    };
    defer app.deinit(allocator);
    defer app.release();

    app.run();
}
