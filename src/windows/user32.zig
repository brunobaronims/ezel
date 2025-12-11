const std = @import("std");
const windows = std.os.windows;
const platform = @import("root.zig");

pub fn NewHwnd(h_instance: HINSTANCE, window: *platform.Window) !HWND {
    const class_name = std.unicode.utf8ToUtf16LeStringLiteral("ezel");
    const window_title = std.unicode.utf8ToUtf16LeStringLiteral("ezel");
    const cursor = @as(LPCWSTR, @ptrFromInt(32512));

    var wc: WNDCLASSEXW = .{
        .cbSize = @sizeOf(WNDCLASSEXW),
        .style = CS_HREDRAW | CS_VREDRAW,
        .lpfnWndProc = WindowProc,
        .cbWndExtra = @sizeOf(LONG_PTR),
        .hInstance = h_instance,
        .lpszClassName = class_name,
        .hCursor = LoadCursorW(null, cursor),
    };

    // TODO: treat return
    _ = SetLastError(.SUCCESS);
    if (RegisterClassExW(&wc) == 0) {
        std.log.err("error while registering window class: {}", .{GetLastError()});
        return error.InitFailed;
    }

    _ = SetLastError(.SUCCESS);
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
        window,
    ) orelse {
        std.log.err("error while creating window: {}", .{GetLastError()});
        return error.InitFailed;
    };

    const dpi = GetDpiForWindow(hwnd);
    const scaled_width = @ceil(1280.0 * @as(f32, @floatFromInt(dpi)) / 96.0);
    const scaled_height = @ceil(1024.0 * @as(f32, @floatFromInt(dpi)) / 96.0);

    _ = SetLastError(.SUCCESS);
    if (SetWindowPos(
        hwnd,
        null,
        0,
        0,
        @intFromFloat(scaled_width),
        @intFromFloat(scaled_height),
        SWP_NOMOVE,
    ) == 0) {
        std.log.err("error while setting window position: {}", .{GetLastError()});
        return error.InitFailed;
    }

    _ = ShowWindow(hwnd, SW_SHOWMAXIMIZED);
    _ = UpdateWindow(hwnd);

    return hwnd;
}

pub fn run() void {
    var msg: MSG = undefined;
    while (GetMessageW(&msg, null, 0, 0) > 0) {
        _ = TranslateMessage(&msg);
        _ = DispatchMessageW(&msg);
    }
}

fn WindowProc(
    hwnd: HWND,
    uMsg: UINT,
    wParam: WPARAM,
    lParam: LPARAM,
) callconv(.winapi) LRESULT {
    if (uMsg == WM_CREATE) {
        const pcs: *CREATESTRUCTW = @ptrFromInt(@as(usize, @bitCast(lParam)));
        const window: *platform.Window = @ptrCast(@alignCast(pcs.lpCreateParams));

        _ = SetLastError(.SUCCESS);
        const result = SetWindowLongPtrW(hwnd, GWLP_USERDATA, @bitCast(@intFromPtr(window)));
        if (result == 0 and GetLastError() != .SUCCESS) {
            // TODO: error
            return -1;
        }

        return 1;
    }

    const p = GetWindowLongPtrW(hwnd, GWLP_USERDATA);
    const window: ?*platform.Window = if (p != 0)
        @ptrFromInt(@as(usize, @intCast(p)))
    else
        null;

    var was_handled = false;

    if (window != null) {
        switch (uMsg) {
            WM_PAINT => {
                var rc: RECT = undefined;
                if (GetClientRect(hwnd, &rc) == 0) {
                    std.log.err("GetClientRect failed: {}", .{GetLastError()});
                    return 1;
                }

                _ = ValidateRect(hwnd, null);

                was_handled = true;
                return 0;
            },
            WM_SIZE => {
                was_handled = true;
                return 0;
            },
            WM_DISPLAYCHANGE => {
                _ = InvalidateRect(hwnd, null, 0);

                was_handled = true;
                return 0;
            },
            WM_DESTROY => {
                PostQuitMessage(0);
                was_handled = true;
                return 1;
            },
            else => {},
        }
    }

    if (!was_handled) {
        return DefWindowProcW(hwnd, uMsg, wParam, lParam);
    }

    return 0;
}

const WNDPROC = *const fn (
    HWND,
    UINT,
    WPARAM,
    LPARAM,
) callconv(.winapi) LRESULT;

const WM_DESTROY = 0x2;
const WM_LBUTTONDOWN = 0x0201;
const WM_PAINT = 0x000F;
const WM_SIZE = 0x5;
const WM_CREATE = 0x1;
const WM_DISPLAYCHANGE = 0x007E;

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
const CS_HREDRAW: c_int = 0x2;
const CS_VREDRAW: c_int = 0x1;

const SW_HIDE = 0;
const SW_SHOWNORMAL = 1;
const SW_SHOWMINIMIZED = 2;
const SW_SHOWMAXIMIZED = 3;
const SW_SHOW = 5;

const SWP_NOMOVE = 0x2;

const COLOR_WINDOW = 5;

const HWND = windows.HWND;
const UINT = windows.UINT;
const WPARAM = windows.WPARAM;
const LPARAM = windows.LPARAM;
const LRESULT = windows.LRESULT;
const HINSTANCE = windows.HINSTANCE;
const LPCWSTR = windows.LPCWSTR;
const LONG_PTR = windows.LONG_PTR;
const HMENU = windows.HMENU;
const INT = windows.INT;
const LONG = windows.LONG;
const DWORD = windows.DWORD;
const HICON = windows.HICON;
const HCURSOR = windows.HCURSOR;
const HBRUSH = windows.HBRUSH;
const BOOL = windows.BOOL;
const LPVOID = windows.LPVOID;
const HDC = windows.HDC;
const RECT = windows.RECT;
const POINT = windows.POINT;
const BYTE = windows.BYTE;
const ATOM = windows.ATOM;
const SetLastError = windows.kernel32.SetLastError;
const GetLastError = windows.kernel32.GetLastError;

pub const GWLP_USERDATA: c_int = -21;

const WNDCLASSEXW = extern struct {
    cbSize: UINT = 0,
    style: UINT = 0,
    lpfnWndProc: WNDPROC,
    cbClsExtra: i32 = 0,
    cbWndExtra: i32 = 0,
    hInstance: ?HINSTANCE = null,
    hIcon: ?HICON = null,
    hCursor: ?HCURSOR = null,
    hbrBackground: ?HBRUSH = null,
    lpszMenuName: ?LPCWSTR = null,
    lpszClassName: ?LPCWSTR = null,
    hIconSm: ?HICON = null,
};

const CREATESTRUCTW = extern struct {
    lpCreateParams: LPVOID,
    hInstance: HINSTANCE,
    hMenu: HMENU,
    hWndParent: HWND,
    cy: INT,
    cx: INT,
    y: INT,
    x: INT,
    style: LONG,
    lpszName: LPCWSTR,
    lpszClass: LPCWSTR,
    dwExStyle: DWORD,
};

const MSG = extern struct {
    hwnd: HWND,
    message: UINT,
    wParam: WPARAM,
    lParam: LPARAM,
    time: DWORD,
    pt: POINT,
};

const PAINTSTRUCT = extern struct {
    hdc: ?HDC = null,
    fErase: BOOL = 0,
    rcPaint: RECT = .{
        .bottom = 0,
        .left = 0,
        .right = 0,
        .top = 0,
    },
    fRestore: BOOL = 0,
    fIncUpdate: BOOL = 0,
    rgbReserved: [32]BYTE = std.mem.zeroes([32]BYTE),
};


extern "user32" fn DefWindowProcW(
    hWnd: HWND,
    Msg: UINT,
    wParam: WPARAM,
    lParam: LPARAM,
) callconv(.winapi) LRESULT;
extern "user32" fn PostQuitMessage(hExitCode: i32) callconv(.winapi) void;
extern "user32" fn CreateWindowExW(
    dwExStyle: DWORD,
    lpClassName: ?LPCWSTR,
    lpWindowName: ?LPCWSTR,
    dwStyle: DWORD,
    X: i32,
    Y: i32,
    nWidth: i32,
    nHeight: i32,
    hWndParent: ?HWND,
    hMenu: ?HMENU,
    hInstance: ?HINSTANCE,
    lpParam: ?*anyopaque,
) callconv(.winapi) ?HWND;
extern "user32" fn RegisterClassExW(*const WNDCLASSEXW) callconv(.winapi) ATOM;
extern "user32" fn ShowWindow(
    hWnd: HWND,
    nCmdShow: i32,
) callconv(.winapi) BOOL;
extern "user32" fn UpdateWindow(hWnd: HWND) callconv(.winapi) BOOL;
extern "user32" fn GetMessageW(
    lpMsg: *MSG,
    hWnd: ?HWND,
    wMsgFilterMin: UINT,
    wMsgFilterMax: UINT,
) callconv(.winapi) BOOL;
extern "user32" fn TranslateMessage(lpMsg: *const MSG) callconv(.winapi) BOOL;
extern "user32" fn DispatchMessageW(lpMsg: *const MSG) callconv(.winapi) LRESULT;
extern "user32" fn FillRect(
    hDC: HDC,
    lprc: *const RECT,
    hbr: HBRUSH,
) callconv(.winapi) i32;
pub extern "user32" fn GetClientRect(
    hWnd: HWND,
    lpRect: *RECT,
) callconv(.winapi) BOOL;
pub extern "user32" fn SetWindowLongPtrW(
    hWnd: HWND,
    nIndex: c_int,
    dwNewLong: LONG_PTR,
) callconv(.winapi) LONG_PTR;
extern "user32" fn GetWindowLongPtrW(
    hWnd: HWND,
    nIndex: c_int,
) callconv(.winapi) LONG_PTR;
extern "user32" fn LoadCursorW(
    hInstance: ?HINSTANCE,
    lpCursorname: LPCWSTR,
) callconv(.winapi) HCURSOR;
extern "user32" fn GetDpiForWindow(hwnd: HWND) callconv(.winapi) UINT;
extern "user32" fn SetWindowPos(
    hWnd: HWND,
    hWndInsertAfter: ?HWND,
    X: INT,
    Y: INT,
    cx: INT,
    cy: INT,
    uFlags: UINT,
) callconv(.winapi) BOOL;
extern "user32" fn ValidateRect(
    hWnd: HWND,
    lpRect: ?*const RECT,
) callconv(.winapi) BOOL;
extern "user32" fn InvalidateRect(
    hWnd: HWND,
    lpRect: ?*const RECT,
    bErase: BOOL,
) callconv(.winapi) BOOL;


