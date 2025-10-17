const std = @import("std");
const builtin = @import("builtin");
const windows = std.os.windows;

const HWND = windows.HWND;
const UINT = windows.UINT;
const WPARAM = windows.WPARAM;
const LPARAM = windows.LPARAM;
const LRESULT = windows.LRESULT;
const HINSTANCE = windows.HINSTANCE;
const PWSTR = windows.PWSTR;
const WCHAR = windows.WCHAR;
const HICON = windows.HICON;
const HMENU = windows.HMENU;
const HCURSOR = windows.HCURSOR;
const HBRUSH = windows.HBRUSH;
const LPCWSTR = windows.LPCWSTR;
const DWORD = windows.DWORD;
const ATOM = windows.ATOM;
const BOOL = windows.BOOL;
const POINT = windows.POINT;
const HDC = windows.HDC;
const RECT = windows.RECT;
const BYTE = windows.BYTE;

const WINAPI: std.builtin.CallingConvention = if (builtin.cpu.arch == .x86) .{ .x86_stdcall = .{} } else .c;

const WNDPROC = *const fn (HWND, UINT, WPARAM, LPARAM) callconv(WINAPI) LRESULT;

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
) callconv(WINAPI) LRESULT;
extern "user32" fn PostQuitMessage(hExitCode: i32) callconv(WINAPI) void;
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
) callconv(WINAPI) ?HWND;
extern "user32" fn RegisterClassExW(*const WNDCLASSEXW) callconv(WINAPI) ATOM;
extern "user32" fn ShowWindow(hWnd: HWND, nCmdShow: i32) callconv(WINAPI) BOOL;
extern "user32" fn GetMessageW(
    lpMsg: *MSG,
    hWnd: ?HWND,
    wMsgFilterMin: UINT,
    wMsgFilterMax: UINT,
) callconv(WINAPI) BOOL;
extern "user32" fn TranslateMessage(lpMsg: *const MSG) callconv(WINAPI) BOOL;
extern "user32" fn DispatchMessageW(lpMsg: *const MSG) callconv(WINAPI) LRESULT;
extern "user32" fn BeginPaint(hWnd: HWND, lpPaint: *PAINTSTRUCT) callconv(WINAPI) HDC;
extern "user32" fn EndPaint(hWnd: HWND, lpPaint: *const PAINTSTRUCT) callconv(WINAPI) BOOL;
extern "user32" fn FillRect(
    hDC: HDC,
    lprc: *const RECT,
    hbr: HBRUSH,
) callconv(WINAPI) i32;

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

fn windowProc(
    hwnd: HWND,
    uMsg: UINT,
    wParam: WPARAM,
    lParam: LPARAM,
) callconv(WINAPI) LRESULT {
    switch (uMsg) {
        WM_PAINT => {
            var ps: PAINTSTRUCT = .{};
            const hdc = BeginPaint(hwnd, &ps);

            const hbr: HBRUSH = @as(HBRUSH, @ptrFromInt(COLOR_WINDOW + 1));
            _ = FillRect(hdc, &ps.rcPaint, hbr);

            _ = EndPaint(hwnd, &ps);

            return 0;
        },
        WM_DESTROY => {
            PostQuitMessage(0);
            return 0;
        },
        else => return DefWindowProcW(hwnd, uMsg, wParam, lParam),
    }
}

pub fn wWinMain() callconv(WINAPI) i32 {
    const hModule = windows.kernel32.GetModuleHandleW(null).?;
    const hInstance: HINSTANCE = @ptrCast(hModule);

    const class_name_utf16 = std.unicode.utf8ToUtf16LeStringLiteral("ZigWindow");
    const class_name: LPCWSTR = @ptrCast(class_name_utf16);
    const window_title_utf16 = std.unicode.utf8ToUtf16LeStringLiteral("ZigWindow");
    const window_title: LPCWSTR = @ptrCast(window_title_utf16);

    var wc: WNDCLASSEXW = .{
        .cbSize = @sizeOf(WNDCLASSEXW),
        .lpfnWndProc = windowProc,
        .hInstance = hInstance,
        .lpszClassName = class_name,
    };

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
        hInstance,
        null,
    );

    if (hwnd == null) {
        return 0;
    }

    _ = ShowWindow(hwnd.?, SW_SHOW);

    var msg: MSG = undefined;
    while (GetMessageW(&msg, null, 0, 0) > 0) {
        _ = TranslateMessage(&msg);
        _ = DispatchMessageW(&msg);
    }

    return 1;
}
