const std = @import("std");
const builtin = @import("builtin");

const Renderer = @This();

pub fn deinit(renderer: *Renderer, allocator: std.mem.Allocator) void {
    _ = renderer;
    _ = allocator;
    std.log.info("not implemented", .{});
}
