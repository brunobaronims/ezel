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

pub const Application = struct {
    factory: *d2d1.IFactory,
    render_target: *d2d1.IHwndRenderTarget,
    hwnd: HWND,

    pub fn drawRectangle() !void {
        return error.NotImplemented;
    }

    pub fn release(self: *Application) void {
        _ = self.factory.Release();
        _ = self.render_target.Release();
    }

    pub fn run(self: *Application) void {
        user32.run(self.hwnd);
    }
};

pub fn NewApplication() !Application {
    const h_module = windows.kernel32.GetModuleHandleW(null) orelse {
        return error.InitFailed;
    };
    const h_instance: HINSTANCE = @ptrCast(h_module);

    const hwnd = try user32.NewHwnd(h_instance);

    const factory = try d2d1.NewFactory();

    const app: Application = .{
        .factory = factory,
        .hwnd = hwnd,
        // create render_target
        .render_target = undefined,
    };

    // const result = user32.SetWindowLongPtrW(hwnd, user32.GWLP_USERDATA, @intCast(@intFromPtr(&app)));
    // if (result == 0) {
    //     // TODO: error
    //     return error.InitFailed;
    // }

    return app;
}
