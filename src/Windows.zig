const std = @import("std");
const Vulkan = @import("Vulkan.zig");
const c = @import("win_user");

const Windows = @This();

vk: *Vulkan,
hwnd: c.HWND,
hinstance: c.HINSTANCE,
dpiX: c.FLOAT = 0,
dpiY: c.FLOAT = 0,

pub fn init(allocator: std.mem.Allocator, vk: *Vulkan) !*Windows {
    var windows = try allocator.create(Windows);
    errdefer allocator.destroy(windows);

    const hmodule = c.GetModuleHandleW(null) orelse {
        return error.InitFailed;
    };
    const hinstance: c.HINSTANCE = @ptrCast(hmodule);

    try vk.createWindowsSurface(windows);

    windows.hinstance = hinstance;
    windows.hwnd = try NewHwnd(hinstance, windows);
    windows.vk = vk;

    return windows;
}

pub fn drawRectangle(self: *Windows) !void {
    _ = self; 

    return error.NotImplemented;
}

pub fn run(self: *Windows) void {
    _ = self;

    var msg: c.MSG = undefined;
    while (c.GetMessageW(&msg, null, 0, 0) > 0) {
        _ = c.TranslateMessage(&msg);
        _ = c.DispatchMessageW(&msg);
    }
}

pub fn deinit(self: *Windows, allocator: std.mem.Allocator) void {
    self.vk.deinit(allocator);
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

    // TODO: treat return
    _ = c.SetLastError(0);
    if (c.RegisterClassExW(&wc) == 0) {
        std.log.err(
            "error while registering window class: {}",
            .{c.GetLastError()},
        );
        return error.InitFailed;
    }

    _ = c.SetLastError(0);
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
        std.log.err(
            "error while creating window: {}",
            .{c.GetLastError()},
        );
        return error.InitFailed;
    };

    const dpi = c.GetDpiForWindow(hwnd);
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

    _ = c.SetLastError(0);
    if (c.SetWindowPos(
        hwnd,
        null,
        0,
        0,
        @intFromFloat(scaled_width),
        @intFromFloat(scaled_height),
        c.SWP_NOMOVE,
    ) == 0) {
        std.log.err(
            "error while setting window position: {}",
            .{c.GetLastError()},
        );
        return error.InitFailed;
    }

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

        _ = c.SetLastError(0);
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
                var rc: c.RECT = undefined;
                if (c.GetClientRect(hwnd, &rc) == 0) {
                    std.log.err(
                        "GetClientRect failed: {}",
                        .{c.GetLastError()},
                    );
                    return 1;
                }

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
