const std = @import("std");
const windows = @import("root.zig");

pub const IUnknown = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *IUnknown,
            windows.REFIID,
            *?*anyopaque,
        ) callconv(.winapi) windows.HRESULT,
        AddRef: *const fn (*IUnknown) callconv(.winapi) windows.ULONG,
        Release: *const fn (*IUnknown) callconv(.winapi) windows.ULONG,
    };
};
