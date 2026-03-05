const std = @import("std");
const Ezel = @import("Ezel.zig");

pub fn main() void {
    var gpa: std.heap.DebugAllocator(.{}) = .init;
    defer {
        const check = gpa.deinit();
        if (check == .leak) {
            std.log.debug("leaked while deinitializing app allocator", .{});
        }
    }
    const allocator = gpa.allocator();

    var ezel = Ezel.init(allocator) catch |err| {
        std.log.err("{}", .{err});
        return;
    };
    defer ezel.deinit(allocator);

    ezel.window.run();
}
