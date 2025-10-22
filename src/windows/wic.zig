const std = @import("std");
const windows = @import("root.zig");

const Rect = extern struct {
    X: windows.INT,
    Y: windows.INT,
    Width: windows.INT,
    Height: windows.INT,
};

const BitmapPaletteType = enum(c_int) {
    Custom = 0,
    MedianCut = 0x1,
    FixedBW = 0x2,
    FixedHalftone8 = 0x3,
    FixedHalftone27 = 0x4,
    FixedHalftone64 = 0x5,
    FixedHalftone125 = 0x6,
    FixedHalftone216 = 0x7,
    FixedHalftone252 = 0x8,
    FixedHalftone256 = 0x9,
    FixedGray4 = 0xa,
    FixedGray16 = 0xb,
    FixedGray256 = 0xc,
};

pub const IBitmap = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *IBitmap,
            windows.REFIID,
            *?*anyopaque,
        ) callconv(.winapi) windows.HRESULT,
        AddRef: *const fn (*IBitmap) callconv(.winapi) windows.ULONG,
        Release: *const fn (*IBitmap) callconv(.winapi) windows.ULONG,

        GetSize: *const fn (*IBitmap, *windows.UINT, *windows.UINT) callconv(.winapi) windows.HRESULT,
        GetPixelFormat: *const fn (*IBitmap, *windows.GUID) callconv(.winapi) windows.HRESULT,
        GetResolution: *const fn (*IBitmap, *windows.double, *windows.double) callconv(.winapi) windows.HRESULT,
        CopyPalette: *const fn (*IBitmap, ?*IPalette) callconv(.winapi) windows.HRESULT,
        CopyPixels: *const fn (
            *IBitmap,
            ?*const Rect,
            windows.UINT,
            windows.UINT,
            [*]windows.BYTE,
        ) callconv(.winapi) windows.HRESULT,

        Lock: *const fn (
            *IBitmap,
            ?*const Rect,
            windows.DWORD,
            *?*IBitmapLock,
        ) callconv(.winapi) windows.HRESULT,
        SetPalette: *const fn (
            *IBitmap,
            ?*IPalette,
        ) callconv(.winapi) windows.HRESULT,
        SetResolution: *const fn (
            *IBitmap,
            windows.double,
            windows.double,
        ) callconv(.winapi) windows.HRESULT,
    };
};

pub const IBitmapSource = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *IBitmapSource,
            windows.REFIID,
            *?*anyopaque,
        ) callconv(.winapi) windows.HRESULT,
        AddRef: *const fn (*IBitmapSource) callconv(.winapi) windows.ULONG,
        Release: *const fn (*IBitmapSource) callconv(.winapi) windows.ULONG,

        GetSize: *const fn (*IBitmapSource, *windows.UINT, *windows.UINT) callconv(.winapi) windows.HRESULT,
        GetPixelFormat: *const fn (
            *IBitmapSource,
            *windows.PixelFormatGUID,
        ) callconv(.winapi) windows.HRESULT,
        GetResolution: *const fn (
            *IBitmapSource,
            *windows.double,
            *windows.double,
        ) callconv(.winapi) windows.HRESULT,
        CopyPalette: *const fn (*IBitmapSource, ?*IPalette) callconv(.winapi) windows.HRESULT,
        CopyPixels: *const fn (
            *IBitmapSource,
            ?*const Rect,
            windows.UINT,
            windows.UINT,
            [*]windows.BYTE,
        ) callconv(.winapi) windows.HRESULT,
    };
};

const IBitmapLock = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *IBitmapLock,
            windows.REFIID,
            *?*anyopaque,
        ) callconv(.winapi) windows.HRESULT,
        AddRef: *const fn (*IBitmapLock) callconv(.winapi) windows.ULONG,
        Release: *const fn (*IBitmapLock) callconv(.winapi) windows.ULONG,

        GetSize: *const fn (
            *IBitmapLock,
            *windows.UINT,
            *windows.UINT,
        ) callconv(.winapi) windows.HRESULT,
        GetStride: *const fn (*IBitmapLock, *windows.UINT) callconv(.winapi) windows.HRESULT,
        GetDataPointer: *const fn (
            *IBitmapLock,
            *windows.UINT,
            *?windows.InProcPointer,
        ) callconv(.winapi) windows.HRESULT,
        GetPixelFormat: *const fn (
            *IBitmapLock,
            *windows.PixelFormatGUID,
        ) callconv(.winapi) windows.HRESULT,
    };
};

const IPalette = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *IPalette,
            windows.REFIID,
            *?*anyopaque,
        ) callconv(.winapi) windows.HRESULT,
        AddRef: *const fn (*IPalette) callconv(.winapi) windows.ULONG,
        Release: *const fn (*IPalette) callconv(.winapi) windows.ULONG,

        InitializePredefined: *const fn (
            *IPalette,
            BitmapPaletteType,
            windows.BOOL,
        ) callconv(.winapi) windows.HRESULT,
        InitializeCustom: *const fn (
            *IPalette,
            *windows.Color,
            windows.UINT,
        ) callconv(.winapi) windows.HRESULT,
        InitializeFromBitmap: *const fn (
            *IPalette,
            ?*IBitmapSource,
            windows.UINT,
            windows.BOOL,
        ) callconv(.winapi) windows.HRESULT,
        InitializeFromPalette: *const fn (
            *IPalette,
            ?*IPalette,
        ) callconv(.winapi) windows.HRESULT,
        GetType: *const fn (
            *IPalette,
            *BitmapPaletteType,
        ) callconv(.winapi) windows.HRESULT,
        GetColorCount: *const fn (*IPalette, *windows.UINT) callconv(.winapi) windows.HRESULT,
        GetColors: *const fn (
            *IPalette,
            windows.UINT,
            [*]windows.Color,
            *windows.UINT,
        ) callconv(.winapi) windows.HRESULT,
        IsBlackWhite: *const fn (*IPalette, *windows.BOOL) callconv(.winapi) windows.HRESULT,
        IsGrayscale: *const fn (*IPalette, *windows.BOOL) callconv(.winapi) windows.HRESULT,
        HasAlpha: *const fn (*IPalette, *windows.BOOL) callconv(.winapi) windows.HRESULT,
    };
};
