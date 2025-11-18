const std = @import("std");
const d2d1 = @import("d2d1.zig");
const user32 = @import("user32.zig");
const windows = std.os.windows;

pub const HWND = windows.HWND;
pub const UINT = windows.UINT;
pub const WPARAM = windows.WPARAM;
pub const LPARAM = windows.LPARAM;
pub const LRESULT = windows.LRESULT;
pub const HINSTANCE = windows.HINSTANCE;
pub const PWSTR = windows.PWSTR;
pub const WCHAR = windows.WCHAR;
pub const HICON = windows.HICON;
pub const HMENU = windows.HMENU;
pub const HCURSOR = windows.HCURSOR;
pub const HBRUSH = windows.HBRUSH;
pub const LPCWSTR = windows.LPCWSTR;
pub const DWORD = windows.DWORD;
pub const ATOM = windows.ATOM;
pub const BOOL = windows.BOOL;
pub const POINT = windows.POINT;
pub const HDC = windows.HDC;
pub const RECT = windows.RECT;
pub const BYTE = windows.BYTE;
pub const FLOAT = windows.FLOAT;
pub const GUID = windows.GUID;
pub const HRESULT = windows.HRESULT;
pub const ULONG = windows.ULONG;
pub const LONG = windows.LONG;
pub const INT = windows.INT;
pub const TAG = u64;
pub const UINT32 = u32;
pub const UINT16 = u16;
pub const UINT64 = u64;
pub const INT16 = i16;
pub const INT32 = i32;
pub const REFIID = *const GUID;
pub const Color = UINT32;
pub const PixelFormatGUID = GUID;
pub const InProcPointer = [*]BYTE;
pub const double = f64;
pub const LONG_PTR = windows.LONG_PTR;
pub const LPVOID = windows.LPVOID;

const COINIT = enum(c_int) {
    APARTMENTTHREADED = 0x2,
    MULTITHREADED = 0x0,
    DISABLE_OLE1DDE = 0x4,
    SPEED_OVER_MEMORY = 0x8,
};

pub const Window = struct {
    factory: *d2d1.IFactory,
    render_target: ?*d2d1.IHwndRenderTarget,
    brushes: [1]?*d2d1.ISolidColorBrush,
    hwnd: HWND,
    dpiX: FLOAT = 0,
    dpiY: FLOAT = 0,

    pub fn drawRectangle() !void {
        return error.NotImplemented;
    }

    pub fn release(self: *Window) void {
        if (self.render_target != null) {
            _ = self.render_target.?.Release();
        }
        for (self.brushes) |brush| {
            _ = brush.?.Release();
        }
        _ = self.factory.Release();
        CoUninitialize();
    }

    pub fn run(self: *Window) void {
        _ = self;
        user32.run();
    }
};

// TODO: errors
pub fn NewWindow(allocator: std.mem.Allocator) !*Window {
    const hr = CoInitializeEx(null, COINIT.MULTITHREADED);
    if (hr < 0) {
        return error.InitFailed;
    }

    var app = try allocator.create(Window);
    errdefer allocator.destroy(app);

    app.* = .{
        .factory = undefined,
        .render_target = null,
        .brushes = [_]?*d2d1.ISolidColorBrush{null},
        .hwnd = undefined,
    };

    const h_module = windows.kernel32.GetModuleHandleW(null) orelse {
        return error.InitFailed;
    };
    const h_instance: HINSTANCE = @ptrCast(h_module);

    app.factory = try d2d1.NewFactory();
    errdefer _ = app.factory.Release();

    app.hwnd = try user32.NewHwnd(h_instance, app);

    return app;
}

pub const SetLastError = windows.kernel32.SetLastError;
pub const GetLastError = windows.kernel32.GetLastError;
extern "ole32" fn CoInitializeEx(?LPVOID, COINIT) callconv(.winapi) HRESULT;
extern "ole32" fn CoUninitialize() callconv(.winapi) void;
