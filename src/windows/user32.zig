const std = @import("std");
const d2d1 = @import("d2d1.zig");
const windows = @import("root.zig");

pub fn NewHwnd(h_instance: windows.HINSTANCE) !windows.HWND {
    const class_name_utf16 = std.unicode.utf8ToUtf16LeStringLiteral("ezel");
    const class_name: windows.LPCWSTR = @ptrCast(class_name_utf16);
    const window_title_utf16 = std.unicode.utf8ToUtf16LeStringLiteral("ezel");
    const window_title: windows.LPCWSTR = @ptrCast(window_title_utf16);

    var wc: WNDCLASSEXW = .{
        .cbSize = @sizeOf(WNDCLASSEXW),
        .lpfnWndProc = WindowProc,
        .hInstance = h_instance,
        .lpszClassName = class_name,
    };

    // TODO: treat return
    _ = RegisterClassExW(&wc);

    const hwnd = CreateWindowExW(
        0,
        class_name,
        window_title,
        WS_OVERLAPPEDWINDOW,
        CW_USEDEFAULT,
        CW_USEDEFAULT,
        CW_USEDEFAULT,
        CW_USEDEFAULT,
        null,
        null,
        h_instance,
        null,
    ) orelse {
        // TODO: better error info?
        return error.InitFailed;
    };

    return hwnd;
}

pub fn run(hwnd: windows.HWND) void {
    _ = ShowWindow(hwnd, SW_SHOW);

    var msg: MSG = undefined;
    while (GetMessageW(&msg, null, 0, 0) > 0) {
        _ = TranslateMessage(&msg);
        _ = DispatchMessageW(&msg);
    }
}

fn WindowProc(
    hwnd: windows.HWND,
    uMsg: windows.UINT,
    wParam: windows.WPARAM,
    lParam: windows.LPARAM,
) callconv(.winapi) windows.LRESULT {
    switch (uMsg) {
        WM_PAINT => {
            var rc: windows.RECT = undefined;
            const success = GetClientRect(hwnd, &rc);
            if (success == 0) return 1;

            const p = GetWindowLongPtrW(hwnd, GWLP_USERDATA);
            if (p == 0) {
                var ps: PAINTSTRUCT = undefined;
                _ = BeginPaint(hwnd, &ps);
                _ = EndPaint(hwnd, &ps);
                return 0;
            }

            const app: *windows.Application = @ptrFromInt(@as(usize, @intCast(p)));

            const rectangle: d2d1.RECT_F = .{
                .left = @as(f32, @floatFromInt(rc.left)) + 100.0,
                .top = @as(f32, @floatFromInt(rc.top)) + 100.0,
                .right = @as(f32, @floatFromInt(rc.right)) - 100.0,
                .bottom = @as(f32, @floatFromInt(rc.bottom)) - 100.0,
            };

            app.render_target.BeginDraw();

            app.render_target.DrawRectangle(
                &rectangle,
                @ptrCast(app.brushes[0]),
                1.0,
                null,
                );

            app.render_target.EndDraw();

            return 0;
        },
        WM_DESTROY => {
            PostQuitMessage(0);
            return 0;
        },
        else => return DefWindowProcW(hwnd, uMsg, wParam, lParam),
    }
}

const WNDPROC = *const fn (
    windows.HWND,
    windows.UINT,
    windows.WPARAM,
    windows.LPARAM,
) callconv(.winapi) windows.LRESULT;

const WNDCLASSEXW = extern struct {
    cbSize: windows.UINT = 0,
    style: windows.UINT = 0,
    lpfnWndProc: WNDPROC,
    cbClsExtra: i32 = 0,
    cbWndExtra: i32 = 0,
    hInstance: ?windows.HINSTANCE = null,
    hIcon: ?windows.HICON = null,
    hCursor: ?windows.HCURSOR = null,
    hbrBackground: ?windows.HBRUSH = null,
    lpszMenuName: ?windows.LPCWSTR = null,
    lpszClassName: ?windows.LPCWSTR = null,
    hIconSm: ?windows.HICON = null,
};

const MSG = extern struct {
    hwnd: windows.HWND,
    message: windows.UINT,
    wParam: windows.WPARAM,
    lParam: windows.LPARAM,
    time: windows.DWORD,
    pt: windows.POINT,
};

const PAINTSTRUCT = extern struct {
    hdc: ?windows.HDC = null,
    fErase: windows.BOOL = 0,
    rcPaint: windows.RECT = .{
        .bottom = 0,
        .left = 0,
        .right = 0,
        .top = 0,
    },
    fRestore: windows.BOOL = 0,
    fIncUpdate: windows.BOOL = 0,
    rgbReserved: [32]windows.BYTE = std.mem.zeroes([32]windows.BYTE),
};

const WM_DESTROY = 0x2;
const WM_LBUTTONDOWN = 0x0201;
const WM_PAINT = 0x000F;

const WS_OVERLAPPED = 0;
const WS_CAPTION = 0x00C00000;
const WS_MAXIMIZEBOX = 0x00010000;
const WS_MINIMIZEBOX = 0x00020000;
const WS_SYSMENU = 0x00080000;
const WS_THICKFRAME = 0x00040000;
const WS_OVERLAPPEDWINDOW =
    WS_OVERLAPPED |
    WS_CAPTION |
    WS_SYSMENU |
    WS_THICKFRAME |
    WS_MINIMIZEBOX |
    WS_MAXIMIZEBOX;

const CW_USEDEFAULT: c_int = -2147483648;

const SW_HIDE = 0x1;
const SW_SHOW = 0x5;

const COLOR_WINDOW = 5;

pub const GWLP_USERDATA: c_int = -21;

extern "user32" fn DefWindowProcW(
    hWnd: windows.HWND,
    Msg: windows.UINT,
    wParam: windows.WPARAM,
    lParam: windows.LPARAM,
) callconv(.winapi) windows.LRESULT;
extern "user32" fn PostQuitMessage(hExitCode: i32) callconv(.winapi) void;
extern "user32" fn CreateWindowExW(
    dwExStyle: windows.DWORD,
    lpClassName: ?windows.LPCWSTR,
    lpWindowName: ?windows.LPCWSTR,
    dwStyle: windows.DWORD,
    X: i32,
    Y: i32,
    nWidth: i32,
    nHeight: i32,
    hWndParent: ?windows.HWND,
    hMenu: ?windows.HMENU,
    hInstance: ?windows.HINSTANCE,
    lpParam: ?*anyopaque,
) callconv(.winapi) ?windows.HWND;
extern "user32" fn RegisterClassExW(*const WNDCLASSEXW) callconv(.winapi) windows.ATOM;
extern "user32" fn ShowWindow(hWnd: windows.HWND, nCmdShow: i32) callconv(.winapi) windows.BOOL;
extern "user32" fn GetMessageW(
    lpMsg: *MSG,
    hWnd: ?windows.HWND,
    wMsgFilterMin: windows.UINT,
    wMsgFilterMax: windows.UINT,
) callconv(.winapi) windows.BOOL;
extern "user32" fn TranslateMessage(lpMsg: *const MSG) callconv(.winapi) windows.BOOL;
extern "user32" fn DispatchMessageW(lpMsg: *const MSG) callconv(.winapi) windows.LRESULT;
extern "user32" fn BeginPaint(
    hWnd: windows.HWND,
    lpPaint: *PAINTSTRUCT,
) callconv(.winapi) windows.HDC;
extern "user32" fn EndPaint(
    hWnd: windows.HWND,
    lpPaint: *const PAINTSTRUCT,
) callconv(.winapi) windows.BOOL;
extern "user32" fn FillRect(
    hDC: windows.HDC,
    lprc: *const windows.RECT,
    hbr: windows.HBRUSH,
) callconv(.winapi) i32;
pub extern "user32" fn GetClientRect(
    hWnd: windows.HWND,
    lpRect: *windows.RECT,
) callconv(.winapi) windows.BOOL;
pub extern "user32" fn SetWindowLongPtrW(
    hWnd: windows.HWND,
    nIndex: c_int,
    dwNewLong: windows.LONG_PTR,
) callconv(.winapi) windows.LONG_PTR;
extern "user32" fn GetWindowLongPtrW(
    hWnd: windows.HWND,
    nIndex: c_int,
) callconv(.winapi) windows.LONG_PTR;
