const std = @import("std");
const windows = std.os.windows;
const user32 = @import("user32.zig");

pub fn NewWindow(allocator: std.mem.Allocator) !*Window {
    const hr = CoInitializeEx(null, COINIT.MULTITHREADED);
    if (hr < 0) {
        return error.InitFailed;
    }

    var app = try allocator.create(Window);
    errdefer allocator.destroy(app);

    app.* = .{
        .hwnd = undefined,
    };

    const h_module = GetModuleHandleW(null) orelse {
        return error.InitFailed;
    };
    const h_instance: HINSTANCE = @ptrCast(h_module);

    app.hwnd = try user32.NewHwnd(h_instance, app);

    return app;
}

const HWND = windows.HWND;
const LPARAM = windows.LPARAM;
const HINSTANCE = windows.HINSTANCE;
const BYTE = windows.BYTE;
const FLOAT = windows.FLOAT;
const GUID = windows.GUID;
const HRESULT = windows.HRESULT;
const UINT32 = u32;
const LPVOID = windows.LPVOID;
const GetModuleHandleW = windows.kernel32.GetModuleHandleW;

pub const Window = struct {
    hwnd: HWND,
    dpiX: FLOAT = 0,
    dpiY: FLOAT = 0,

    pub fn drawRectangle() !void {
        return error.NotImplemented;
    }

    pub fn release() void {
        CoUninitialize();
    }

    pub fn run(self: *Window) void {
        _ = self;
        user32.run();
    }
};

const COINIT = enum(c_int) {
    APARTMENTTHREADED = 0x2,
    MULTITHREADED = 0x0,
    DISABLE_OLE1DDE = 0x4,
    SPEED_OVER_MEMORY = 0x8,
};

extern "ole32" fn CoInitializeEx(?LPVOID, COINIT) callconv(.winapi) HRESULT;
extern "ole32" fn CoUninitialize() callconv(.winapi) void;
