const std = @import("std");
const Vulkan = @import("Vulkan.zig");
const windows = std.os.windows;

const Self = @This();

vk: *Vulkan,
hwnd: windows.HWND,
dpiX: windows.FLOAT = 0,
dpiY: windows.FLOAT = 0,

pub fn init(allocator: std.mem.Allocator, vk: *Vulkan) !*Self {
    const hr = CoInitializeEx(null, CoInit.multithreaded);
    if (hr < 0) {
        return error.InitFailed;
    }

    var window = try allocator.create(Self);
    errdefer allocator.destroy(window);

    window.* = .{
        .hwnd = undefined,
        .vk = undefined,
    };

    const h_module = windows.kernel32.GetModuleHandleW(null) orelse {
        return error.InitFailed;
    };
    const h_instance: windows.HINSTANCE = @ptrCast(h_module);

    window.hwnd = try NewHwnd(h_instance, window);
    window.vk = vk;

    return window;
}

pub fn drawRectangle() !void {
    return error.NotImplemented;
}

pub fn run(self: *Self) void {
    _ = self;

    var msg: MSG = undefined;
    while (GetMessageW(&msg, null, 0, 0) > 0) {
        _ = TranslateMessage(&msg);
        _ = DispatchMessageW(&msg);
    }
}

pub fn deinit(self: *Self, allocator: std.mem.Allocator) void {
    self.vk.deinit(allocator);
    CoUninitialize();
}

pub fn NewHwnd(h_instance: windows.HINSTANCE, window: *Self) !windows.HWND {
    const class_name = std.unicode.utf8ToUtf16LeStringLiteral("ezel");
    const window_title = std.unicode.utf8ToUtf16LeStringLiteral("ezel");
    const cursor = @as(windows.LPCWSTR, @ptrFromInt(32512));

    var wc: WNDCLASSEXW = .{
        .cbSize = @sizeOf(WNDCLASSEXW),
        .style = cs_hredraw | cs_vredraw,
        .lpfnWndProc = windowProc,
        .cbWndExtra = @sizeOf(windows.LONG_PTR),
        .hInstance = h_instance,
        .lpszClassName = class_name,
        .hCursor = LoadCursorW(null, cursor),
    };

    // TODO: treat return
    _ = windows.kernel32.SetLastError(.SUCCESS);
    if (RegisterClassExW(&wc) == 0) {
        std.log.err(
            "error while registering window class: {}",
            .{windows.kernel32.GetLastError()},
        );
        return error.InitFailed;
    }

    _ = windows.kernel32.SetLastError(.SUCCESS);
    const hwnd = CreateWindowExW(
        0,
        class_name,
        window_title,
        ws_overlappedwindow,
        cw_usedefault,
        cw_usedefault,
        cw_usedefault,
        cw_usedefault,
        null,
        null,
        h_instance,
        window,
    ) orelse {
        std.log.err(
            "error while creating window: {}",
            .{windows.kernel32.GetLastError()},
        );
        return error.InitFailed;
    };

    const dpi = GetDpiForWindow(hwnd);
    const scaled_width = @ceil(
        1280.0 * @as(
            f32,
            @floatFromInt(dpi),
        ) / 96.0,
    );
    const scaled_height = @ceil(
        1024.0 * @as(
            f32,
            @floatFromInt(dpi),
        ) / 96.0,
    );

    _ = windows.kernel32.SetLastError(.SUCCESS);
    if (SetWindowPos(
        hwnd,
        null,
        0,
        0,
        @intFromFloat(scaled_width),
        @intFromFloat(scaled_height),
        swp_nomove,
    ) == 0) {
        std.log.err(
            "error while setting window position: {}",
            .{windows.kernel32.GetLastError()},
        );
        return error.InitFailed;
    }

    _ = ShowWindow(hwnd, sw_showmaximized);
    _ = UpdateWindow(hwnd);

    return hwnd;
}

fn windowProc(
    hwnd: windows.HWND,
    uMsg: windows.UINT,
    wParam: windows.WPARAM,
    lParam: windows.LPARAM,
) callconv(.winapi) windows.LRESULT {
    if (uMsg == wm_create) {
        const pcs: *CREATESTRUCTW = @ptrFromInt(@as(usize, @bitCast(lParam)));
        const window: *Self = @ptrCast(@alignCast(pcs.lpCreateParams));

        _ = windows.kernel32.SetLastError(.SUCCESS);
        const result = SetWindowLongPtrW(
            hwnd,
            gwlp_userdata,
            @bitCast(@intFromPtr(window)),
        );
        if (result == 0 and windows.kernel32.GetLastError() != .SUCCESS) {
            // TODO: error
            return -1;
        }

        return 1;
    }

    const p = GetWindowLongPtrW(hwnd, gwlp_userdata);
    const window: ?*Self = if (p != 0)
        @ptrFromInt(@as(usize, @intCast(p)))
    else
        null;

    var was_handled = false;

    if (window != null) {
        switch (uMsg) {
            wm_paint => {
                var rc: windows.RECT = undefined;
                if (GetClientRect(hwnd, &rc) == 0) {
                    std.log.err(
                        "GetClientRect failed: {}",
                        .{windows.kernel32.GetLastError()},
                    );
                    return 1;
                }

                _ = ValidateRect(hwnd, null);

                was_handled = true;
                return 0;
            },
            wm_size => {
                was_handled = true;
                return 0;
            },
            wm_displaychange => {
                _ = InvalidateRect(hwnd, null, 0);

                was_handled = true;
                return 0;
            },
            wm_destroy => {
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

const WndProc = *const fn (
    windows.HWND,
    windows.UINT,
    windows.WPARAM,
    windows.LPARAM,
) callconv(.winapi) windows.LRESULT;

const wm_destroy = 0x2;
const wm_lbuttondown = 0x0201;
const wm_paint = 0x000F;
const wm_size = 0x5;
const wm_create = 0x1;
const wm_displaychange = 0x007E;

const ws_overlapped = 0;
const ws_caption = 0x00C00000;
const ws_maximizebox = 0x00010000;
const ws_minimizebox = 0x00020000;
const ws_sysmenu = 0x00080000;
const ws_thickframe = 0x00040000;
const ws_overlappedwindow =
    ws_overlapped |
    ws_caption |
    ws_sysmenu |
    ws_thickframe |
    ws_minimizebox |
    ws_maximizebox;

const cw_usedefault: c_int = -2147483648;
const cs_hredraw: c_int = 0x2;
const cs_vredraw: c_int = 0x1;

const sw_hide = 0;
const sw_shownormal = 1;
const sw_showminimized = 2;
const sw_showmaximized = 3;
const sw_show = 5;

const swp_nomove = 0x2;

const color_window = 5;

const gwlp_userdata: c_int = -21;

const WNDCLASSEXW = extern struct {
    cbSize: windows.UINT = 0,
    style: windows.UINT = 0,
    lpfnWndProc: WndProc,
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

const CoInit = enum(c_int) {
    apartmentthreaded = 0x2,
    multithreaded = 0x0,
    disable_ole1dde = 0x4,
    speed_over_memory = 0x8,
};

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

extern "ole32" fn CoInitializeEx(?windows.LPVOID, CoInit) callconv(.winapi) windows.HRESULT;
extern "ole32" fn CoUninitialize() callconv(.winapi) void;
