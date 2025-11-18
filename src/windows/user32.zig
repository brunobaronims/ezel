const std = @import("std");
const d2d1 = @import("d2d1.zig");
const windows = @import("root.zig");

pub fn NewHwnd(h_instance: windows.HINSTANCE, window: *windows.Window) !windows.HWND {
    const class_name = std.unicode.utf8ToUtf16LeStringLiteral("ezel");
    const window_title = std.unicode.utf8ToUtf16LeStringLiteral("ezel");
    const cursor = @as(windows.LPCWSTR, @ptrFromInt(32512));

    var wc: WNDCLASSEXW = .{
        .cbSize = @sizeOf(WNDCLASSEXW),
        .style = CS_HREDRAW | CS_VREDRAW,
        .lpfnWndProc = WindowProc,
        .cbWndExtra = @sizeOf(windows.LONG_PTR),
        .hInstance = h_instance,
        .lpszClassName = class_name,
        .hCursor = LoadCursorW(null, cursor),
    };

    // TODO: treat return
    _ = windows.SetLastError(.SUCCESS);
    if (RegisterClassExW(&wc) == 0) {
        std.log.err("error while registering window class: {}", .{windows.GetLastError()});
        return error.InitFailed;
    }

    _ = windows.SetLastError(.SUCCESS);
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
        std.log.err("error while creating window: {}", .{windows.GetLastError()});
        return error.InitFailed;
    };

    const dpi = GetDpiForWindow(hwnd);
    const scaled_width = @ceil(1280.0 * @as(f32, @floatFromInt(dpi)) / 96.0);
    const scaled_height = @ceil(1024.0 * @as(f32, @floatFromInt(dpi)) / 96.0);

    _ = windows.SetLastError(.SUCCESS);
    if (SetWindowPos(
        hwnd,
        null,
        0,
        0,
        @intFromFloat(scaled_width),
        @intFromFloat(scaled_height),
        SWP_NOMOVE,
    ) == 0) {
        std.log.err("error while setting window position: {}", .{windows.GetLastError()});
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
    hwnd: windows.HWND,
    uMsg: windows.UINT,
    wParam: windows.WPARAM,
    lParam: windows.LPARAM,
) callconv(.winapi) windows.LRESULT {
    if (uMsg == WM_CREATE) {
        const pcs: *CREATESTRUCTW = @ptrFromInt(@as(usize, @bitCast(lParam)));
        const window: *windows.Window = @ptrCast(@alignCast(pcs.lpCreateParams));

        _ = windows.SetLastError(.SUCCESS);
        const result = SetWindowLongPtrW(hwnd, GWLP_USERDATA, @bitCast(@intFromPtr(window)));
        if (result == 0 and windows.GetLastError() != .SUCCESS) {
            // TODO: error
            return -1;
        }

        return 1;
    }

    const p = GetWindowLongPtrW(hwnd, GWLP_USERDATA);
    const window: ?*windows.Window = if (p != 0)
        @ptrFromInt(@as(usize, @intCast(p)))
    else
        null;

    var was_handled = false;

    if (window) |a| {
        switch (uMsg) {
            WM_PAINT => {
                if (a.render_target == null) {
                    a.render_target = a.factory.CreateHwndRenderTarget(hwnd) catch {
                        return 1;
                    };
                    errdefer _ = a.render_target.?.Release();

                    a.render_target.?.GetDpi(&a.dpiX, &a.dpiY);

                    const color = d2d1.COLOR_F{ .r = 0, .g = 0, .b = 0, .a = 1 };
                    a.brushes[0] = a.render_target.?.CreateSolidColorBrush(
                        &color,
                        null,
                    ) catch {
                        return 1;
                    };
                    errdefer _ = a.brushes[0].Release();
                }

                const rt = a.render_target.?;

                const identity_matrix = d2d1.MATRIX_3X2_F{
                    .DUMMYSTRUCTNAME2 = .{
                        ._11 = 1.0,
                        ._12 = 0.0,
                        ._21 = 0.0,
                        ._22 = 1.0,
                        ._31 = 0.0,
                        ._32 = 0.0,
                    },
                };
                const white = d2d1.COLOR_F{ .r = 1.0, .g = 1.0, .b = 1.0, .a = 1.0 };

                rt.BeginDraw();

                rt.SetTransform(&identity_matrix);
                rt.Clear(&white);

                var rc: windows.RECT = undefined;
                if (GetClientRect(hwnd, &rc) == 0) {
                    std.log.err("GetClientRect failed: {}", .{windows.GetLastError()});
                    return 1;
                }
                const width_dip = @as(f32, @floatFromInt(rc.right - rc.left)) * (96.0 / a.dpiX);
                const height_dip = @as(f32, @floatFromInt(rc.bottom - rc.top)) * (96.0 / a.dpiY);

                const button = d2d1.RECT_F{
                    .left = (width_dip * 0.5) - 100.0,
                    .top = (height_dip * 0.5) - 100.0,
                    .right = (width_dip * 0.5) + 100.0,
                    .bottom = (height_dip * 0.5) + 100.0,
                };

                const brush = a.brushes[0].?;

                rt.FillRectangle(&button, @ptrCast(brush));

                const hr = rt.EndDraw();
                if (hr == d2d1.ERR_RECREATE_TARGET) {
                    a.brushes[0].?.Release();
                    rt.Release();
                }

                _ = ValidateRect(hwnd, null);

                was_handled = true;
                return 0;
            },
            WM_SIZE => {
                if (a.render_target) |rt| {
                    const width: u32 = @intCast(lParam & 0xFFFF);
                    const height: u32 = @intCast((lParam >> 16) & 0xFFFF);

                    const size = d2d1.SIZE_U{
                        .width = width,
                        .height = height,
                    };

                    _ = rt.Resize(&size);
                }

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

const CREATESTRUCTW = extern struct {
    lpCreateParams: windows.LPVOID,
    hInstance: windows.HINSTANCE,
    hMenu: windows.HMENU,
    hWndParent: windows.HWND,
    cy: windows.INT,
    cx: windows.INT,
    y: windows.INT,
    x: windows.INT,
    style: windows.LONG,
    lpszName: windows.LPCWSTR,
    lpszClass: windows.LPCWSTR,
    dwExStyle: windows.DWORD,
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
extern "user32" fn ShowWindow(
    hWnd: windows.HWND,
    nCmdShow: i32,
) callconv(.winapi) windows.BOOL;
extern "user32" fn UpdateWindow(hWnd: windows.HWND) callconv(.winapi) windows.BOOL;
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
extern "user32" fn LoadCursorW(
    hInstance: ?windows.HINSTANCE,
    lpCursorname: windows.LPCWSTR,
) callconv(.winapi) windows.HCURSOR;
extern "user32" fn GetDpiForWindow(hwnd: windows.HWND) callconv(.winapi) windows.UINT;
extern "user32" fn SetWindowPos(
    hWnd: windows.HWND,
    hWndInsertAfter: ?windows.HWND,
    X: windows.INT,
    Y: windows.INT,
    cx: windows.INT,
    cy: windows.INT,
    uFlags: windows.UINT,
) callconv(.winapi) windows.BOOL;
extern "user32" fn ValidateRect(
    hWnd: windows.HWND,
    lpRect: ?*const windows.RECT,
) callconv(.winapi) windows.BOOL;
extern "user32" fn InvalidateRect(
    hWnd: windows.HWND,
    lpRect: ?*const windows.RECT,
    bErase: windows.BOOL,
) callconv(.winapi) windows.BOOL;
