const std = @import("std");
const Vulkan = @import("Vulkan.zig");
const Ezel = @import("Ezel.zig");
const c = @import("win_user");

const Windows = @This();

vk: *Vulkan,
hwnd: c.HWND,
hinstance: c.HINSTANCE,
dpiX: c.FLOAT = 0,
dpiY: c.FLOAT = 0,

pub fn init(allocator: std.mem.Allocator) InitializationError!*Windows {
    var windows = try allocator.create(Windows);
    errdefer allocator.destroy(windows);

    if (!c.SUCCEEDED(c.SetProcessDpiAwarenessContext(c
        .DPI_AWARENESS_CONTEXT_PER_MONITOR_AWARE_V2)))
    {
        return InitializationError.CouldNotSetDpiAwareness;
    }

    const hmodule = c.GetModuleHandleW(null) orelse {
        return InitializationError.CouldNotGetModuleHandle;
    };
    const hinstance: c.HINSTANCE = @ptrCast(hmodule);

    windows.hinstance = hinstance;
    windows.hwnd = try NewHwnd(hinstance, windows);

    return windows;
}

pub fn run(windows: *Windows) void {
    _ = windows;

    var msg: c.MSG = undefined;
    while (c.GetMessageW(&msg, null, 0, 0) > 0) {
        _ = c.TranslateMessage(&msg);
        _ = c.DispatchMessageW(&msg);
    }
}

pub fn deinit(windows: *Windows, allocator: std.mem.Allocator) void {
    windows.vk.deinit(allocator);
}

pub fn GetWindowSize(windows: *Windows) !Ezel.Dimensions {
    var rc: c.RECT = undefined;
    if (c.GetClientRect(windows.hwnd, &rc) == 0) {
        std.log.err(
            "GetClientRect failed: {}",
            .{c.GetLastError()},
        );
        return error.FailedToGetDimensions;
    }

    const width = rc.right - rc.left;
    const height = rc.bottom - rc.top;

    return .{
        .height = @intCast(height),
        .width = @intCast(width),
    };
}

pub fn NewHwnd(hinstance: c.HINSTANCE, window: *Windows) !c.HWND {
    const class_name = std.unicode.utf8ToUtf16LeStringLiteral("ezel");
    const window_title = std.unicode.utf8ToUtf16LeStringLiteral("ezel");
    const cursor = @as(c.LPCWSTR, @ptrFromInt(32512));

    var wc: c.WNDCLASSEXW = .{
        .cbSize = @sizeOf(c.WNDCLASSEXW),
        .style = c.CS_HREDRAW | c.CS_VREDRAW,
        .lpfnWndProc = windowProc,
        .cbWndExtra = @sizeOf(c.LONG_PTR),
        .hInstance = hinstance,
        .lpszClassName = class_name,
        .hCursor = c.LoadCursorW(null, cursor),
    };

    if (c.RegisterClassExW(&wc) == 0) {
        return InitializationError.CouldNotRegisterWindowClass;
    }

    const hwnd = c.CreateWindowExW(
        0,
        class_name,
        window_title,
        c.WS_OVERLAPPEDWINDOW,
        c.CW_USEDEFAULT,
        c.CW_USEDEFAULT,
        c.CW_USEDEFAULT,
        c.CW_USEDEFAULT,
        null,
        null,
        hinstance,
        window,
    ) orelse {
        return InitializationError.CouldNotCreateWindow;
    };

    _ = c.ShowWindow(hwnd, c.SW_SHOWMAXIMIZED);
    _ = c.UpdateWindow(hwnd);

    return hwnd;
}

fn windowProc(
    hwnd: c.HWND,
    uMsg: c.UINT,
    wParam: c.WPARAM,
    lParam: c.LPARAM,
) callconv(.winapi) c.LRESULT {
    if (uMsg == c.WM_CREATE) {
        const pcs: *c.CREATESTRUCTW = @ptrFromInt(@as(usize, @bitCast(lParam)));
        const window: *Windows = @ptrCast(@alignCast(pcs.lpCreateParams));

        const result = c.SetWindowLongPtrW(
            hwnd,
            c.GWLP_USERDATA,
            @bitCast(@intFromPtr(window)),
        );
        if (result == 0 and c.GetLastError() != 0) {
            // TODO: error
            return -1;
        }

        return 1;
    }

    const p = c.GetWindowLongPtrW(hwnd, c.GWLP_USERDATA);
    const window: ?*Windows = if (p != 0)
        @ptrFromInt(@as(usize, @intCast(p)))
    else
        null;

    var was_handled = false;

    if (window != null) {
        switch (uMsg) {
            c.WM_PAINT => {
                _ = c.ValidateRect(hwnd, null);

                was_handled = true;
                return 0;
            },
            c.WM_SIZE => {
                was_handled = true;
                return 0;
            },
            c.WM_DISPLAYCHANGE => {
                _ = c.InvalidateRect(hwnd, null, 0);

                was_handled = true;
                return 0;
            },
            c.WM_DESTROY => {
                c.PostQuitMessage(0);
                was_handled = true;
                return 1;
            },
            else => {},
        }
    }

    if (!was_handled) {
        return c.DefWindowProcW(hwnd, uMsg, wParam, lParam);
    }

    return 0;
}

const WndProc = *const fn (
    c.HWND,
    c.UINT,
    c.WPARAM,
    c.LPARAM,
) callconv(.winapi) c.LRESULT;

const InitializationError = error{
    CouldNotSetDpiAwareness,
    CouldNotGetModuleHandle,
    CouldNotRegisterWindowClass,
    CouldNotCreateWindow,
} || error{OutOfMemory};
