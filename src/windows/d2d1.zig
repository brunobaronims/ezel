const std = @import("std");
const user32 = @import("user32.zig");
const dwrite = @import("dwrite.zig");
const wic = @import("wic.zig");
const windows = @import("root.zig");

pub fn NewFactory() !*IFactory {
    var factory: ?*IFactory = null;
    const hr = D2D1CreateFactory(
        FACTORY_TYPE.SINGLE_THREADED,
        &IID_IFactory,
        null,
        &factory,
    );
    if (hr < 0) {
        // TODO: discriminate error
        return error.FailedToCreateFactory;
    }

    return factory.?;
}

const IID_IFactory = windows.GUID{
    .Data1 = 0x06152247,
    .Data2 = 0x6f50,
    .Data3 = 0x465a,
    .Data4 = [8]u8{ 0x92, 0x45, 0x11, 0x8b, 0xfd, 0x3b, 0x60, 0x07 },
};

pub const RECT_F = extern struct {
    left: windows.FLOAT,
    top: windows.FLOAT,
    right: windows.FLOAT,
    bottom: windows.FLOAT,
};

pub const RECT_U = extern struct {
    left: windows.UINT32,
    top: windows.UINT32,
    right: windows.UINT32,
    bottom: windows.UINT32,
};

const ROUNDED_RECT = extern struct {
    rect: RECT_F,
    radiusX: windows.FLOAT,
    radiusY: windows.FLOAT,
};

const POINT_2F = extern struct { x: windows.FLOAT, y: windows.FLOAT };

const POINT_2U = extern struct { x: windows.UINT32, y: windows.UINT32 };

pub const MATRIX_3X2_F = extern union {
    DUMMYSTRUCTNAME: extern struct {
        m11: windows.FLOAT,
        m12: windows.FLOAT,
        m21: windows.FLOAT,
        m22: windows.FLOAT,
        dx: windows.FLOAT,
        dy: windows.FLOAT,
    },
    DUMMYSTRUCTNAME2: extern struct {
        _11: windows.FLOAT,
        _12: windows.FLOAT,
        _21: windows.FLOAT,
        _22: windows.FLOAT,
        _31: windows.FLOAT,
        _32: windows.FLOAT,
    },
    m: [3][2]windows.FLOAT,
};

const FACTORY_OPTIONS = extern struct { debugLevel: DEBUG_LEVEL };

const BEZIER_SEGMENT = extern struct {
    point1: POINT_2F,
    point2: POINT_2F,
    point3: POINT_2F,
};

const QUADRATIC_BEZIER_SEGMENT = extern struct {
    point1: POINT_2F,
    point2: POINT_2F,
};

const TRIANGLE = BEZIER_SEGMENT;

const SIZE_F = extern struct {
    width: windows.FLOAT,
    height: windows.FLOAT,
};

pub const SIZE_U = extern struct {
    width: windows.UINT32 = 0,
    height: windows.UINT32 = 0,
};

const ARC_SEGMENT = extern struct {
    point: POINT_2F,
    size: SIZE_F,
    rotationAngle: windows.FLOAT,
    sweepDirection: SWEEP_DIRECTION,
    arcSize: ARC_SIZE,
};

const ELLIPSE = extern struct {
    point: POINT_2F,
    radiusX: windows.FLOAT,
    radiusY: windows.FLOAT,
};

const STROKE_STYLE_PROPERTIES = extern struct {
    startCap: CAP_STYLE,
    endCap: CAP_STYLE,
    dashCap: CAP_STYLE,
    lineJoin: LINE_JOIN,
    miterLimit: windows.FLOAT,
    dashStyle: DASH_STYLE,
    dashOffset: windows.FLOAT,
};

const DRAWING_STATE_DESCRIPTION = extern struct {
    antialiasMode: ANTIALIAS_MODE,
    textAntialiasMode: TEXT_ANTIALIAS_MODE,
    tag1: windows.TAG,
    tag2: windows.TAG,
    transform: MATRIX_3X2_F,
};

const PIXEL_FORMAT = extern struct {
    format: DXGI_FORMAT = DXGI_FORMAT.UNKNOWN,
    alphaMode: ALPHA_MODE = ALPHA_MODE.UNKNOWN,
};

pub const RENDER_TARGET_PROPERTIES = extern struct {
    type: RENDER_TARGET_TYPE = RENDER_TARGET_TYPE.DEFAULT,
    pixelFormat: PIXEL_FORMAT,
    dpiX: windows.FLOAT = 0.0,
    dpiY: windows.FLOAT = 0.0,
    usage: RENDER_TARGET_USAGE = RENDER_TARGET_USAGE.NONE,
    minLevel: FEATURE_LEVEL = FEATURE_LEVEL.DEFAULT,
};

pub const HWND_RENDER_TARGET_PROPERTIES = extern struct {
    hwnd: windows.HWND = undefined,
    pixelSize: SIZE_U,
    presentOptions: PRESENT_OPTIONS = PRESENT_OPTIONS.NONE,
};

const BITMAP_PROPERTIES = extern struct {
    pixelFormat: PIXEL_FORMAT,
    dpiX: windows.FLOAT,
    dpiY: windows.FLOAT,
};

const BITMAP_BRUSH_PROPERTIES = extern struct {
    extendModeX: EXTEND_MODE,
    extendModeY: EXTEND_MODE,
    interpolationMode: BITMAP_INTERPOLATION_MODE,
};

const BRUSH_PROPERTIES = extern struct {
    opacity: windows.FLOAT,
    transform: MATRIX_3X2_F,
};

pub const COLOR_F = extern struct {
    r: windows.FLOAT,
    g: windows.FLOAT,
    b: windows.FLOAT,
    a: windows.FLOAT,
};

const GRADIENT_STOP = extern struct {
    position: windows.FLOAT,
    color: COLOR_F,
};

const LINEAR_GRADIENT_BRUSH_PROPERTIES = extern struct {
    startPoint: POINT_2F,
    endPoint: POINT_2F,
};

const RADIAL_GRADIENT_BRUSH_PROPERTIES = extern struct {
    center: POINT_2F,
    gradientOriginOffset: POINT_2F,
    radiusX: windows.FLOAT,
    radiusY: windows.FLOAT,
};

const LAYER_PARAMETERS = extern struct {
    contentBounds: RECT_F,
    geometricMask: *IGeometry,
    maskAntialiasMode: ANTIALIAS_MODE,
    maskTransform: MATRIX_3X2_F,
    opacity: windows.FLOAT,
    opacityBrush: *IBrush,
    layerOptions: LAYER_OPTIONS,
};

pub const ERR_RECREATE_TARGET = 0x8899000C;

const FACTORY_TYPE = enum(c_int) {
    SINGLE_THREADED = 0,
    MULTI_THREADED = 1,
};

const DEBUG_LEVEL = enum(c_int) {
    NONE = 0,
    ERROR = 1,
    WARNING = 2,
    INFORMATION = 3,
};

const CAP_STYLE = enum(c_int) {
    CAP_STYLE_FLAT = 0,
    CAP_STYLE_SQUARE = 1,
    CAP_STYLE_ROUND = 2,
    CAP_STYLE_TRIANGLE = 3,
};

const LINE_JOIN = enum(c_int) {
    LINE_JOIN_MITER = 0,
    LINE_JOIN_BEVEL = 1,
    LINE_JOIN_ROUND = 2,
    LINE_JOIN_MITER_OR_BEVEL = 3,
};

const DASH_STYLE = enum(c_int) {
    DASH_STYLE_SOLID = 0,
    DASH_STYLE_DASH = 1,
    DASH_STYLE_DOT = 2,
    DASH_STYLE_DASH_DOT = 3,
    DASH_STYLE_DASH_DOT_DOT = 4,
    DASH_STYLE_CUSTOM = 5,
};

const GEOMETRY_RELATION = enum(c_int) {
    GEOMETRY_RELATION_UNKNOWN = 0,
    GEOMETRY_RELATION_DISJOINT = 1,
    GEOMETRY_RELATION_IS_CONTAINED = 2,
    GEOMETRY_RELATION_CONTAINS = 3,
    GEOMETRY_RELATION_OVERLAP = 4,
};

const GEOMETRY_SIMPLIFICATION_OPTION = enum(c_int) {
    GEOMETRY_SIMPLIFICATION_OPTION_CUBICS_AND_LINES = 0,
    GEOMETRY_SIMPLIFICATION_OPTION_LINES = 1,
};

const FILL_MODE = enum(c_int) {
    FILL_MODE_ALTERNATE = 0,
    FILL_MODE_WINDING = 1,
};

const PATH_SEGMENT = enum(c_int) {
    PATH_SEGMENT_NONE = 0x00000000,
    PATH_SEGMENT_FORCE_UNSTROKED = 0x00000001,
    PATH_SEGMENT_FORCE_ROUND_LINE_JOIN = 0x00000002,
};

const FIGURE_BEGIN = enum(c_int) {
    FIGURE_BEGIN_FILLED = 0,
    FIGURE_BEGIN_HOLLOW = 1,
};

const FIGURE_END = enum(c_int) {
    FIGURE_END_OPEN = 0,
    FIGURE_END_CLOSED = 1,
};

const COMBINE_MODE = enum(c_int) {
    COMBINE_MODE_UNION = 0,
    COMBINE_MODE_INTERSECT = 1,
    COMBINE_MODE_XOR = 2,
    COMBINE_MODE_EXCLUDE = 3,
};

const SWEEP_DIRECTION = enum(c_int) {
    SWEEP_DIRECTION_COUNTER_CLOCKWISE = 0,
    SWEEP_DIRECTION_CLOCKWISE = 1,
};

const ARC_SIZE = enum(c_int) {
    ARC_SIZE_SMALL = 0,
    ARC_SIZE_LARGE = 1,
};

const ANTIALIAS_MODE = enum(c_int) {
    ANTIALIAS_MODE_PER_PRIMITIVE = 0,
    ANTIALIAS_MODE_ALIASED = 1,
};

const TEXT_ANTIALIAS_MODE = enum(c_int) {
    TEXT_ANTIALIAS_MODE_DEFAULT = 0,
    TEXT_ANTIALIAS_MODE_CLEARTYPE = 1,
    TEXT_ANTIALIAS_MODE_GRAYSCALE = 2,
    TEXT_ANTIALIAS_MODE_ALIASED = 3,
};

const LAYER_OPTIONS = enum(c_int) {
    LAYER_OPTIONS_NONE = 0x00000000,
    LAYER_OPTIONS_INITIALIZE_FOR_CLEARTYPE = 0x00000001,
};

const WINDOW_STATE = enum(c_int) {
    WINDOW_STATE_NONE = 0x0000000,
    WINDOW_STATE_OCCLUDED = 0x0000001,
};

const DXGI_FORMAT = enum(c_int) {
    UNKNOWN = 0,
    R32G32B32A32_TYPELESS = 1,
    R32G32B32A32_FLOAT = 2,
    R32G32B32A32_UINT = 3,
    R32G32B32A32_SINT = 4,
    R32G32B32_TYPELESS = 5,
    R32G32B32_FLOAT = 6,
    R32G32B32_UINT = 7,
    R32G32B32_SINT = 8,
    R16G16B16A16_TYPELESS = 9,
    R16G16B16A16_FLOAT = 10,
    R16G16B16A16_UNORM = 11,
    R16G16B16A16_UINT = 12,
    R16G16B16A16_SNORM = 13,
    R16G16B16A16_SINT = 14,
    R32G32_TYPELESS = 15,
    R32G32_FLOAT = 16,
    R32G32_UINT = 17,
    R32G32_SINT = 18,
    R32G8X24_TYPELESS = 19,
    D32_FLOAT_S8X24_UINT = 20,
    R32_FLOAT_X8X24_TYPELESS = 21,
    X32_TYPELESS_G8X24_UINT = 22,
    R10G10B10A2_TYPELESS = 23,
    R10G10B10A2_UNORM = 24,
    R10G10B10A2_UINT = 25,
    R11G11B10_FLOAT = 26,
    R8G8B8A8_TYPELESS = 27,
    R8G8B8A8_UNORM = 28,
    R8G8B8A8_UNORM_SRGB = 29,
    R8G8B8A8_UINT = 30,
    R8G8B8A8_SNORM = 31,
    R8G8B8A8_SINT = 32,
    R16G16_TYPELESS = 33,
    R16G16_FLOAT = 34,
    R16G16_UNORM = 35,
    R16G16_UINT = 36,
    R16G16_SNORM = 37,
    R16G16_SINT = 38,
    R32_TYPELESS = 39,
    D32_FLOAT = 40,
    R32_FLOAT = 41,
    R32_UINT = 42,
    R32_SINT = 43,
    R24G8_TYPELESS = 44,
    D24_UNORM_S8_UINT = 45,
    R24_UNORM_X8_TYPELESS = 46,
    X24_TYPELESS_G8_UINT = 47,
    R8G8_TYPELESS = 48,
    R8G8_UNORM = 49,
    R8G8_UINT = 50,
    R8G8_SNORM = 51,
    R8G8_SINT = 52,
    R16_TYPELESS = 53,
    R16_FLOAT = 54,
    D16_UNORM = 55,
    R16_UNORM = 56,
    R16_UINT = 57,
    R16_SNORM = 58,
    R16_SINT = 59,
    R8_TYPELESS = 60,
    R8_UNORM = 61,
    R8_UINT = 62,
    R8_SNORM = 63,
    R8_SINT = 64,
    A8_UNORM = 65,
    R1_UNORM = 66,
    R9G9B9E5_SHAREDEXP = 67,
    R8G8_B8G8_UNORM = 68,
    G8R8_G8B8_UNORM = 69,
    BC1_TYPELESS = 70,
    BC1_UNORM = 71,
    BC1_UNORM_SRGB = 72,
    BC2_TYPELESS = 73,
    BC2_UNORM = 74,
    BC2_UNORM_SRGB = 75,
    BC3_TYPELESS = 76,
    BC3_UNORM = 77,
    BC3_UNORM_SRGB = 78,
    BC4_TYPELESS = 79,
    BC4_UNORM = 80,
    BC4_SNORM = 81,
    BC5_TYPELESS = 82,
    BC5_UNORM = 83,
    BC5_SNORM = 84,
    B5G6R5_UNORM = 85,
    B5G5R5A1_UNORM = 86,
    B8G8R8A8_UNORM = 87,
    B8G8R8X8_UNORM = 88,
    R10G10B10_XR_BIAS_A2_UNORM = 89,
    B8G8R8A8_TYPELESS = 90,
    B8G8R8A8_UNORM_SRGB = 91,
    B8G8R8X8_TYPELESS = 92,
    B8G8R8X8_UNORM_SRGB = 93,
    BC6H_TYPELESS = 94,
    BC6H_UF16 = 95,
    BC6H_SF16 = 96,
    BC7_TYPELESS = 97,
    BC7_UNORM = 98,
    BC7_UNORM_SRGB = 99,
    AYUV = 100,
    Y410 = 101,
    Y416 = 102,
    NV12 = 103,
    P010 = 104,
    P016 = 105,
    _420_OPAQUE = 106,
    YUY2 = 107,
    Y210 = 108,
    Y216 = 109,
    NV11 = 110,
    AI44 = 111,
    IA44 = 112,
    P8 = 113,
    A8P8 = 114,
    B4G4R4A4_UNORM = 115,
    P208 = 130,
    V208 = 131,
    V408 = 132,
    SAMPLER_FEEDBACK_MIN_MIP_OPAQUE = 189,
    SAMPLER_FEEDBACK_MIP_REGION_USED_OPAQUE = 190,
};

const ALPHA_MODE = enum(c_int) {
    UNKNOWN = 0,
    PREMULTIPLIED = 1,
    STRAIGHT = 2,
    IGNORE = 3,
};

const RENDER_TARGET_TYPE = enum(c_int) {
    DEFAULT = 0,
    SOFTWARE = 1,
    HARDWARE = 2,
};

const RENDER_TARGET_USAGE = enum(c_int) {
    NONE = 0x00000000,
    FORCE_BITMAP_REMOTING = 0x00000001,
    GDI_COMPATIBLE = 0x00000002,
};

const FEATURE_LEVEL = enum(c_int) {
    DEFAULT = 0,
    _9,
    _10,
};

const PRESENT_OPTIONS = enum(c_int) {
    NONE = 0x00000000,
    RETAIN_CONTENTS = 0x00000001,
    IMMEDIATELY = 0x00000002,
};

const EXTEND_MODE = enum(c_int) {
    EXTEND_MODE_CLAMP = 0,
    EXTEND_MODE_WRAP = 1,
    EXTEND_MODE_MIRROR = 2,
};

const BITMAP_INTERPOLATION_MODE = enum(c_int) {
    BITMAP_INTERPOLATION_MODE_NEAREST_NEIGHBOR,
    BITMAP_INTERPOLATION_MODE_LINEAR,
};

const GAMMA = enum(c_int) {
    GAMMA_2_2 = 0,
    GAMMA_1_0 = 1,
};

const COMPATIBLE_RENDER_TARGET_OPTIONS = enum(c_int) {
    COMPATIBLE_RENDER_TARGET_OPTIONS_NONE = 0x00000000,
    COMPATIBLE_RENDER_TARGET_OPTIONS_GDI_COMPATIBLE = 0x00000001,
};

const OPACITY_MASK_CONTENT = enum(c_int) {
    OPACITY_MASK_CONTENT_GRAPHICS = 0,
    OPACITY_MASK_CONTENT_TEXT_NATURAL = 1,
    OPACITY_MASK_CONTENT_TEXT_GDI_COMPATIBLE = 2,
};

const DRAW_TEXT_OPTIONS = enum(c_int) {
    DRAW_TEXT_OPTIONS_NO_SNAP = 0x00000001,
    DRAW_TEXT_OPTIONS_CLIP = 0x00000002,
    DRAW_TEXT_OPTIONS_ENABLE_COLOR_FONT = 0x00000004,
    DRAW_TEXT_OPTIONS_DISABLE_COLOR_BITMAP_SNAPPING = 0x00000008,
    DRAW_TEXT_OPTIONS_NONE = 0x00000000,
};

pub const IFactory = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *IFactory,
            windows.REFIID,
            *?*anyopaque,
        ) callconv(.winapi) windows.HRESULT,
        AddRef: *const fn (*IFactory) callconv(.winapi) windows.ULONG,
        Release: *const fn (*IFactory) callconv(.winapi) windows.ULONG,

        ReloadSystemMetrics: *const fn (*IFactory) callconv(.winapi) windows.HRESULT,
        GetDesktopDpi: *const fn (*IFactory, *windows.FLOAT, *windows.FLOAT) callconv(.winapi) void,
        CreateRectangleGeometry: *const fn (
            *IFactory,
            *const RECT_F,
            **IRectangleGeometry,
        ) callconv(.winapi) windows.HRESULT,
        CreateRoundedRectangleGeometry: *const fn (
            *IFactory,
            *const ROUNDED_RECT,
            **IRoundedRectangleGeometry,
        ) callconv(.winapi) windows.HRESULT,
        CreateEllipseGeometry: *const fn (
            *IFactory,
            *const ELLIPSE,
            **IEllipseGeometry,
        ) callconv(.winapi) windows.HRESULT,
        CreateGeometryGroup: *const fn (
            *IFactory,
            FILL_MODE,
            [*]*IGeometry,
            windows.UINT32,
            **IGeometryGroup,
        ) callconv(.winapi) windows.HRESULT,
        CreateTransformedGeometry: *const fn (
            *IFactory,
            *IGeometry,
            *const MATRIX_3X2_F,
            **ITransformedGeometry,
        ) callconv(.winapi) windows.HRESULT,
        CreatePathGeometry: *const fn (
            *IFactory,
            **IPathGeometry,
        ) callconv(.winapi) windows.HRESULT,
        CreateStrokeStyle: *const fn (
            *IFactory,
            *const STROKE_STYLE_PROPERTIES,
            ?[*]const windows.FLOAT,
            windows.UINT32,
            **IStrokeStyle,
        ) callconv(.winapi) windows.HRESULT,
        CreateDrawingStateBlock: *const fn (
            *IFactory,
            ?*const DRAWING_STATE_DESCRIPTION,
            ?*dwrite.IRenderingParams,
            **IDrawingStateBlock,
        ) callconv(.winapi) windows.HRESULT,
        CreateWicBitmapRenderTarget: *const fn (
            *IFactory,
            *wic.IBitmap,
            *const RENDER_TARGET_PROPERTIES,
            *?*IRenderTarget,
        ) callconv(.winapi) windows.HRESULT,
        CreateHwndRenderTarget: *const fn (
            *IFactory,
            *const RENDER_TARGET_PROPERTIES,
            *const HWND_RENDER_TARGET_PROPERTIES,
            *?*IHwndRenderTarget,
        ) callconv(.winapi) windows.HRESULT,
    };

    pub fn Release(self: *IFactory) windows.ULONG {
        return self.v.Release(self);
    }

    pub fn GetDesktopDpi(self: *IFactory) struct { x: windows.FLOAT, y: windows.FLOAT } {
        var dpi_x: windows.FLOAT = 0;
        var dpi_y: windows.FLOAT = 0;

        self.v.GetDesktopDpi(self, &dpi_x, &dpi_y);

        return .{ .x = dpi_x, .y = dpi_y };
    }

    pub fn CreateHwndRenderTarget(
        self: *IFactory,
        hwnd: windows.HWND,
    ) !*IHwndRenderTarget {
        _ = windows.SetLastError(.SUCCESS);
        var rc: windows.RECT = undefined;
        const success = user32.GetClientRect(hwnd, &rc);
        if (success == 0) return error.FailedToCreateRenderTarget;

        const size: SIZE_U = .{
            .width = @intCast(rc.right - rc.left),
            .height = @intCast(rc.bottom - rc.top),
        };

        const render_target_properties: RENDER_TARGET_PROPERTIES = .{ .pixelFormat = .{} };
        const hwnd_render_target_properties: HWND_RENDER_TARGET_PROPERTIES = .{
            .hwnd = hwnd,
            .pixelSize = size,
        };
        var render_target: ?*IHwndRenderTarget = null;
        const hr = self.v.CreateHwndRenderTarget(self, &render_target_properties, &hwnd_render_target_properties, &render_target);
        if (hr < 0) {
            return error.FailedToCreateRenderTarget;
        }

        return render_target.?;
    }
};

const IResource = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *IResource,
            windows.REFIID,
            *?*anyopaque,
        ) callconv(.winapi) windows.HRESULT,
        AddRef: *const fn (*IResource) callconv(.winapi) windows.ULONG,
        Release: *const fn (*IResource) callconv(.winapi) windows.ULONG,

        GetFactory: *const fn (*IResource, **IFactory) callconv(.winapi) void,
    };

    pub fn Release(self: *IResource) windows.ULONG {
        return self.v.Release(self);
    }

    pub fn GetFactory(self: *IResource, factory: **IFactory) void {
        return self.v.GetFactory(self, factory);
    }
};

const ILayer = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *ILayer,
            windows.REFIID,
            *?*anyopaque,
        ) callconv(.winapi) windows.HRESULT,
        AddRef: *const fn (*ILayer) callconv(.winapi) windows.ULONG,
        Release: *const fn (*ILayer) callconv(.winapi) windows.ULONG,

        GetFactory: *const fn (*ILayer, **IFactory) callconv(.winapi) void,

        GetSize: *const fn (*ILayer) callconv(.winapi) SIZE_F,
    };

    pub fn Release(self: *ILayer) windows.ULONG {
        return self.v.Release(self);
    }

    pub fn GetFactory(self: *ILayer, factory: **IFactory) void {
        return self.v.GetFactory(self, factory);
    }
};

const IMesh = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *IMesh,
            windows.REFIID,
            *?*anyopaque,
        ) callconv(.winapi) windows.HRESULT,
        AddRef: *const fn (*IMesh) callconv(.winapi) windows.ULONG,
        Release: *const fn (*IMesh) callconv(.winapi) windows.ULONG,

        GetFactory: *const fn (*IMesh, **IFactory) callconv(.winapi) void,

        Open: *const fn (*IMesh, **ITesselationSink) callconv(.winapi) windows.HRESULT,
    };

    pub fn Release(self: *IMesh) windows.ULONG {
        return self.v.Release(self);
    }

    pub fn GetFactory(self: *IMesh, factory: **IFactory) void {
        return self.v.GetFactory(self, factory);
    }
};

const IGradientStopCollection = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *IGradientStopCollection,
            windows.REFIID,
            *?*anyopaque,
        ) callconv(.winapi) windows.HRESULT,
        AddRef: *const fn (*IGradientStopCollection) callconv(.winapi) windows.ULONG,
        Release: *const fn (*IGradientStopCollection) callconv(.winapi) windows.ULONG,

        GetFactory: *const fn (*IGradientStopCollection, **IFactory) callconv(.winapi) void,

        GetGradientStopCount: *const fn (*IGradientStopCollection) callconv(.winapi) windows.UINT32,
        GetGradientStops: *const fn (
            *IGradientStopCollection,
            [*]GRADIENT_STOP,
            windows.UINT32,
        ) callconv(.winapi) void,
        GetColorInterpolationGamma: *const fn (*IGradientStopCollection) callconv(.winapi) GAMMA,
        GetExtendMode: *const fn (*IGradientStopCollection) callconv(.winapi) EXTEND_MODE,
    };

    pub fn Release(self: *IGradientStopCollection) windows.ULONG {
        return self.v.Release(self);
    }

    pub fn GetFactory(self: *IGradientStopCollection, factory: **IFactory) void {
        return self.v.GetFactory(self, factory);
    }
};

const IBrush = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *IBrush,
            windows.REFIID,
            *?*anyopaque,
        ) callconv(.winapi) windows.HRESULT,
        AddRef: *const fn (*IBrush) callconv(.winapi) windows.ULONG,
        Release: *const fn (*IBrush) callconv(.winapi) windows.ULONG,

        GetFactory: *const fn (*IBrush, **IFactory) callconv(.winapi) void,

        SetOpacity: *const fn (*IBrush, windows.FLOAT) callconv(.winapi) void,
        SetTransform: *const fn (*IBrush, *const MATRIX_3X2_F) callconv(.winapi) void,
        GetOpacity: *const fn (*IBrush) callconv(.winapi) windows.FLOAT,
        GetTransform: *const fn (*IBrush, *MATRIX_3X2_F) callconv(.winapi) void,
    };

    pub fn Release(self: *IBrush) windows.ULONG {
        return self.v.Release(self);
    }
};

const IRadialGradientBrush = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *IRadialGradientBrush,
            windows.REFIID,
            *?*anyopaque,
        ) callconv(.winapi) windows.HRESULT,
        AddRef: *const fn (*IRadialGradientBrush) callconv(.winapi) windows.ULONG,
        Release: *const fn (*IRadialGradientBrush) callconv(.winapi) windows.ULONG,

        GetFactory: *const fn (
            *IRadialGradientBrush,
            **IFactory,
        ) callconv(.winapi) void,

        SetOpacity: *const fn (*IRadialGradientBrush, windows.FLOAT) callconv(.winapi) void,
        SetTransform: *const fn (
            *IRadialGradientBrush,
            *const MATRIX_3X2_F,
        ) callconv(.winapi) void,
        GetOpacity: *const fn (*IRadialGradientBrush) callconv(.winapi) windows.FLOAT,
        GetTransform: *const fn (
            *IRadialGradientBrush,
            *MATRIX_3X2_F,
        ) callconv(.winapi) void,

        SetCenter: *const fn (*IRadialGradientBrush, POINT_2F) callconv(.winapi) void,
        SetGradientOriginOffset: *const fn (
            *IRadialGradientBrush,
            POINT_2F,
        ) callconv(.winapi) void,
        SetRadiusX: *const fn (*IRadialGradientBrush, windows.FLOAT) callconv(.winapi) void,
        SetRadiusY: *const fn (*IRadialGradientBrush, windows.FLOAT) callconv(.winapi) void,
        GetCenter: *const fn (*IRadialGradientBrush) callconv(.winapi) POINT_2F,
        GetGradientOriginOffset: *const fn (
            *IRadialGradientBrush,
        ) callconv(.winapi) POINT_2F,
        GetRadiusX: *const fn (*IRadialGradientBrush) callconv(.winapi) windows.FLOAT,
        GetRadiusY: *const fn (*IRadialGradientBrush) callconv(.winapi) windows.FLOAT,
        GetGradientStopCollection: *const fn (
            *IRadialGradientBrush,
            **IGradientStopCollection,
        ) callconv(.winapi) void,
    };

    pub fn Release(self: *IRadialGradientBrush) windows.ULONG {
        return self.v.Release(self);
    }
};

const ILinearGradientBrush = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *ILinearGradientBrush,
            windows.REFIID,
            *?*anyopaque,
        ) callconv(.winapi) windows.HRESULT,
        AddRef: *const fn (*ILinearGradientBrush) callconv(.winapi) windows.ULONG,
        Release: *const fn (*ILinearGradientBrush) callconv(.winapi) windows.ULONG,

        GetFactory: *const fn (*ILinearGradientBrush, **IFactory) callconv(.winapi) void,

        SetOpacity: *const fn (*ILinearGradientBrush, windows.FLOAT) callconv(.winapi) void,
        SetTransform: *const fn (
            *ILinearGradientBrush,
            *const MATRIX_3X2_F,
        ) callconv(.winapi) void,
        GetOpacity: *const fn (*ILinearGradientBrush) callconv(.winapi) windows.FLOAT,
        GetTransform: *const fn (
            *ILinearGradientBrush,
            *MATRIX_3X2_F,
        ) callconv(.winapi) void,

        SetStartPoint: *const fn (*ILinearGradientBrush, POINT_2F) callconv(.winapi) void,
        SetEndPoint: *const fn (*ILinearGradientBrush, POINT_2F) callconv(.winapi) void,
        GetStartPoint: *const fn (*ILinearGradientBrush) callconv(.winapi) POINT_2F,
        GetEndPoint: *const fn (*ILinearGradientBrush) callconv(.winapi) POINT_2F,
        GetGradientStopCollection: *const fn (ILinearGradientBrush, **IGradientStopCollection) callconv(.winapi) void,
    };

    pub fn Release(self: *ILinearGradientBrush) windows.ULONG {
        return self.v.Release(self);
    }
};

const IBitmapBrush = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *IBitmapBrush,
            windows.REFIID,
            *?*anyopaque,
        ) callconv(.winapi) windows.HRESULT,
        AddRef: *const fn (*IBitmapBrush) callconv(.winapi) windows.ULONG,
        Release: *const fn (*IBitmapBrush) callconv(.winapi) windows.ULONG,

        GetFactory: *const fn (*IBitmapBrush, **IFactory) callconv(.winapi) void,

        SetOpacity: *const fn (*IBitmapBrush, windows.FLOAT) callconv(.winapi) void,
        SetTransform: *const fn (
            *IBitmapBrush,
            *const MATRIX_3X2_F,
        ) callconv(.winapi) void,
        GetOpacity: *const fn (*IBitmapBrush) callconv(.winapi) windows.FLOAT,
        GetTransform: *const fn (*IBitmapBrush, *MATRIX_3X2_F) callconv(.winapi) void,

        SetExtendModeX: *const fn (*IBitmapBrush, EXTEND_MODE) callconv(.winapi) void,
        SetExtendModeY: *const fn (*IBitmapBrush, EXTEND_MODE) callconv(.winapi) void,
        SetInterpolationMode: *const fn (
            *IBitmapBrush,
            BITMAP_INTERPOLATION_MODE,
        ) callconv(.winapi) void,
        SetBitmap: *const fn (*IBitmapBrush, ?*IBitmap) callconv(.winapi) void,
        GetExtendModeX: *const fn (*IBitmapBrush) callconv(.winapi) EXTEND_MODE,
        GetExtendModeY: *const fn (*IBitmapBrush) callconv(.winapi) EXTEND_MODE,
        GetInterpolationMode: *const fn (
            *IBitmapBrush,
        ) callconv(.winapi) BITMAP_INTERPOLATION_MODE,
        GetBitmap: *const fn (*IBitmapBrush, *?*IBitmap) callconv(.winapi) void,
    };

    pub fn Release(self: *IBitmapBrush) windows.ULONG {
        return self.v.Release(self);
    }
};

pub const ISolidColorBrush = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *ISolidColorBrush,
            windows.REFIID,
            *?*anyopaque,
        ) callconv(.winapi) windows.HRESULT,
        AddRef: *const fn (*ISolidColorBrush) callconv(.winapi) windows.ULONG,
        Release: *const fn (*ISolidColorBrush) callconv(.winapi) windows.ULONG,

        GetFactory: *const fn (*ISolidColorBrush, **IFactory) callconv(.winapi) void,

        SetOpacity: *const fn (*ISolidColorBrush, windows.FLOAT) callconv(.winapi) void,
        SetTransform: *const fn (*ISolidColorBrush, *const MATRIX_3X2_F) callconv(.winapi) void,
        GetOpacity: *const fn (*ISolidColorBrush) callconv(.winapi) windows.FLOAT,
        GetTransform: *const fn (*ISolidColorBrush, *MATRIX_3X2_F) callconv(.winapi) void,

        SetColor: *const fn (*ISolidColorBrush, *const COLOR_F) callconv(.winapi) void,
        GetColor: *const fn (*ISolidColorBrush) callconv(.winapi) COLOR_F,
    };

    pub fn Release(self: *ISolidColorBrush) windows.ULONG {
        return self.v.Release(self);
    }
};

const IRenderTarget = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *IRenderTarget,
            windows.REFIID,
            *?*anyopaque,
        ) callconv(.winapi) windows.HRESULT,
        AddRef: *const fn (*IRenderTarget) callconv(.winapi) windows.ULONG,
        Release: *const fn (*IRenderTarget) callconv(.winapi) windows.ULONG,

        GetFactory: *const fn (
            *IRenderTarget,
            **IFactory,
        ) callconv(.winapi) void,

        CreateBitmap: *const fn (
            *IRenderTarget,
            ?*const anyopaque,
            windows.UINT32,
            *const BITMAP_PROPERTIES,
            **IBitmap,
        ) callconv(.winapi) windows.HRESULT,
        CreateBitmapFromWicBitmap: *const fn (
            *IRenderTarget,
            *wic.IBitmapSource,
            ?*const BITMAP_PROPERTIES,
            **IBitmap,
        ) callconv(.winapi) windows.HRESULT,
        CreateSharedBitmap: *const fn (
            *IRenderTarget,
            windows.REFIID,
            *anyopaque,
            ?*const BITMAP_PROPERTIES,
            **IBitmap,
        ) callconv(.winapi) windows.HRESULT,
        CreateBitmapBrush: *const fn (
            *IRenderTarget,
            ?*IBitmap,
            ?*const BITMAP_BRUSH_PROPERTIES,
            ?*const BRUSH_PROPERTIES,
            **IBitmapBrush,
        ) callconv(.winapi) windows.HRESULT,
        CreateSolidColorBrush: *const fn (
            *IRenderTarget,
            *const COLOR_F,
            ?*const BRUSH_PROPERTIES,
            **ISolidColorBrush,
        ) callconv(.winapi) windows.HRESULT,
        CreateGradientStopCollection: *const fn (
            *IRenderTarget,
            [*]const GRADIENT_STOP,
            windows.UINT32,
            GAMMA,
            EXTEND_MODE,
            **IGradientStopCollection,
        ) callconv(.winapi) windows.HRESULT,
        CreateLinearGradientBrush: *const fn (
            *IRenderTarget,
            *const LINEAR_GRADIENT_BRUSH_PROPERTIES,
            ?*const BRUSH_PROPERTIES,
            *IGradientStopCollection,
            **ILinearGradientBrush,
        ) callconv(.winapi) windows.HRESULT,
        CreateRadialGradientBrush: *const fn (
            *IRenderTarget,
            *const RADIAL_GRADIENT_BRUSH_PROPERTIES,
            ?*const BRUSH_PROPERTIES,
            *IGradientStopCollection,
            **IRadialGradientBrush,
        ) callconv(.winapi) windows.HRESULT,
        CreateCompatibleRenderTarget: *const fn (
            *IRenderTarget,
            ?*const SIZE_F,
            ?*const SIZE_U,
            ?*const PIXEL_FORMAT,
            COMPATIBLE_RENDER_TARGET_OPTIONS,
            **IBitmapRenderTarget,
        ) callconv(.winapi) windows.HRESULT,
        CreateLayer: *const fn (
            *IRenderTarget,
            ?*const SIZE_F,
            **ILayer,
        ) callconv(.winapi) windows.HRESULT,
        CreateMesh: *const fn (
            *IRenderTarget,
            **IMesh,
        ) callconv(.winapi) windows.HRESULT,
        DrawLine: *const fn (
            *IRenderTarget,
            POINT_2F,
            POINT_2F,
            *IBrush,
            windows.FLOAT,
            ?*IStrokeStyle,
        ) callconv(.winapi) void,
        DrawRectangle: *const fn (
            *IRenderTarget,
            *const RECT_F,
            *IBrush,
            windows.FLOAT,
            ?*IStrokeStyle,
        ) callconv(.winapi) void,
        FillRectangle: *const fn (
            *IRenderTarget,
            *const RECT_F,
            *IBrush,
        ) callconv(.winapi) void,
        DrawRoundedRectangle: *const fn (
            *IRenderTarget,
            *const ROUNDED_RECT,
            *IBrush,
            windows.FLOAT,
            ?*IStrokeStyle,
        ) callconv(.winapi) void,
        FillRoundedRectangle: *const fn (
            *IRenderTarget,
            *const ROUNDED_RECT,
            *IBrush,
        ) callconv(.winapi) void,
        DrawEllipse: *const fn (
            *IRenderTarget,
            *const ELLIPSE,
            *IBrush,
            windows.FLOAT,
            ?*IStrokeStyle,
        ) callconv(.winapi) void,
        FillEllipse: *const fn (
            *IRenderTarget,
            *const ELLIPSE,
            *IBrush,
        ) callconv(.winapi) void,
        DrawGeometry: *const fn (
            *IRenderTarget,
            *IGeometry,
            *IBrush,
            windows.FLOAT,
            ?*IStrokeStyle,
        ) callconv(.winapi) void,
        FillGeometry: *const fn (
            *IRenderTarget,
            *IGeometry,
            *IBrush,
            ?*IBrush,
        ) callconv(.winapi) void,
        FillMesh: *const fn (
            *IRenderTarget,
            *IMesh,
            *IBrush,
        ) callconv(.winapi) void,
        FillOpacityMask: *const fn (
            *IRenderTarget,
            *IBitmap,
            *IBrush,
            OPACITY_MASK_CONTENT,
            ?*const RECT_F,
            ?*const RECT_F,
        ) callconv(.winapi) void,
        DrawBitmap: *const fn (
            *IRenderTarget,
            *IBitmap,
            ?*const RECT_F,
            windows.FLOAT,
            BITMAP_INTERPOLATION_MODE,
            ?*const RECT_F,
        ) callconv(.winapi) void,
        DrawText: *const fn (
            *IRenderTarget,
            [*]const windows.WCHAR,
            windows.UINT32,
            *dwrite.ITextFormat,
            *const RECT_F,
            *IBrush,
            DRAW_TEXT_OPTIONS,
            dwrite.MEASURING_MODE,
        ) callconv(.winapi) void,
        DrawTextLayout: *const fn (
            *IRenderTarget,
            POINT_2F,
            *dwrite.ITextLayout,
            *IBrush,
            DRAW_TEXT_OPTIONS,
        ) callconv(.winapi) void,
        DrawGlyphRun: *const fn (
            *IRenderTarget,
            POINT_2F,
            *const dwrite.GLYPH_RUN,
            *IBrush,
            dwrite.MEASURING_MODE,
        ) callconv(.winapi) void,
        SetTransform: *const fn (
            *IRenderTarget,
            *const MATRIX_3X2_F,
        ) callconv(.winapi) void,
        GetTransform: *const fn (
            *IRenderTarget,
            *MATRIX_3X2_F,
        ) callconv(.winapi) void,
        SetAntialiasMode: *const fn (
            *IRenderTarget,
            ANTIALIAS_MODE,
        ) callconv(.winapi) void,
        GetAntialiasMode: *const fn (
            *IRenderTarget,
        ) callconv(.winapi) ANTIALIAS_MODE,
        SetTextAntialiasMode: *const fn (
            *IRenderTarget,
            TEXT_ANTIALIAS_MODE,
        ) callconv(.winapi) void,
        GetTextAntialiasMode: *const fn (
            *IRenderTarget,
        ) callconv(.winapi) TEXT_ANTIALIAS_MODE,
        SetTextRenderingParams: *const fn (
            *IRenderTarget,
            ?*dwrite.IRenderingParams,
        ) callconv(.winapi) void,
        GetTextRenderingParams: *const fn (
            *IRenderTarget,
            *?*dwrite.IRenderingParams,
        ) callconv(.winapi) void,
        SetTags: *const fn (
            *IRenderTarget,
            windows.TAG,
            windows.TAG,
        ) callconv(.winapi) void,
        GetTags: *const fn (
            *IRenderTarget,
            ?*windows.TAG,
            ?*windows.TAG,
        ) callconv(.winapi) void,
        PushLayer: *const fn (
            *IRenderTarget,
            *const LAYER_PARAMETERS,
            ?*ILayer,
        ) callconv(.winapi) void,
        PopLayer: *const fn (*IRenderTarget) callconv(.winapi) void,
        Flush: *const fn (
            *IRenderTarget,
            ?*windows.TAG,
            ?*windows.TAG,
        ) callconv(.winapi) windows.HRESULT,
        SaveDrawingState: *const fn (
            *IRenderTarget,
            *IDrawingStateBlock,
        ) callconv(.winapi) void,
        RestoreDrawingState: *const fn (
            *IRenderTarget,
            *IDrawingStateBlock,
        ) callconv(.winapi) void,
        PushAxisAlignedClip: *const fn (
            *IRenderTarget,
            *const RECT_F,
            ANTIALIAS_MODE,
        ) callconv(.winapi) void,
        PopAxisAlignedClip: *const fn (*IRenderTarget) callconv(.winapi) void,
        Clear: *const fn (
            *IRenderTarget,
            ?*const COLOR_F,
        ) callconv(.winapi) void,
        BeginDraw: *const fn (*IRenderTarget) callconv(.winapi) void,
        EndDraw: *const fn (
            *IRenderTarget,
            ?*windows.TAG,
            ?*windows.TAG,
        ) callconv(.winapi) windows.HRESULT,
        GetPixelFormat: *const fn (*IRenderTarget) callconv(.winapi) PIXEL_FORMAT,
        SetDpi: *const fn (
            *IRenderTarget,
            windows.FLOAT,
            windows.FLOAT,
        ) callconv(.winapi) void,
        GetDpi: *const fn (
            *IRenderTarget,
            *windows.FLOAT,
            *windows.FLOAT,
        ) callconv(.winapi) void,
        GetSize: *const fn (*IRenderTarget) callconv(.winapi) SIZE_F,
        GetPixelSize: *const fn (*IRenderTarget) callconv(.winapi) SIZE_U,
        GetMaximumBitmapSize: *const fn (*IRenderTarget) callconv(.winapi) windows.UINT32,
        IsSupported: *const fn (
            *IRenderTarget,
            *const RENDER_TARGET_PROPERTIES,
        ) callconv(.winapi) windows.BOOL,
    };

    pub fn Release(self: *IRenderTarget) windows.ULONG {
        return self.v.Release(self);
    }
};

pub const IHwndRenderTarget = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *IHwndRenderTarget,
            windows.REFIID,
            *?*anyopaque,
        ) callconv(.winapi) windows.HRESULT,
        AddRef: *const fn (*IHwndRenderTarget) callconv(.winapi) windows.ULONG,
        Release: *const fn (*IHwndRenderTarget) callconv(.winapi) windows.ULONG,

        GetFactory: *const fn (
            *IHwndRenderTarget,
            **IFactory,
        ) callconv(.winapi) void,

        CreateBitmap: *const fn (
            *IHwndRenderTarget,
            ?*const anyopaque,
            windows.UINT32,
            *const BITMAP_PROPERTIES,
            **IBitmap,
        ) callconv(.winapi) windows.HRESULT,
        CreateBitmapFromWicBitmap: *const fn (
            *IHwndRenderTarget,
            *wic.IBitmapSource,
            ?*const BITMAP_PROPERTIES,
            **IBitmap,
        ) callconv(.winapi) windows.HRESULT,
        CreateSharedBitmap: *const fn (
            *IHwndRenderTarget,
            windows.REFIID,
            *anyopaque,
            ?*const BITMAP_PROPERTIES,
            **IBitmap,
        ) callconv(.winapi) windows.HRESULT,
        CreateBitmapBrush: *const fn (
            *IHwndRenderTarget,
            ?*IBitmap,
            ?*const BITMAP_BRUSH_PROPERTIES,
            ?*const BRUSH_PROPERTIES,
            **IBitmapBrush,
        ) callconv(.winapi) windows.HRESULT,
        CreateSolidColorBrush: *const fn (
            *IHwndRenderTarget,
            *const COLOR_F,
            ?*const BRUSH_PROPERTIES,
            *?*ISolidColorBrush,
        ) callconv(.winapi) windows.HRESULT,
        CreateGradientStopCollection: *const fn (
            *IHwndRenderTarget,
            [*]const GRADIENT_STOP,
            windows.UINT32,
            GAMMA,
            EXTEND_MODE,
            **IGradientStopCollection,
        ) callconv(.winapi) windows.HRESULT,
        CreateLinearGradientBrush: *const fn (
            *IHwndRenderTarget,
            *const LINEAR_GRADIENT_BRUSH_PROPERTIES,
            ?*const BRUSH_PROPERTIES,
            *IGradientStopCollection,
            **ILinearGradientBrush,
        ) callconv(.winapi) windows.HRESULT,
        CreateRadialGradientBrush: *const fn (
            *IHwndRenderTarget,
            *const RADIAL_GRADIENT_BRUSH_PROPERTIES,
            ?*const BRUSH_PROPERTIES,
            *IGradientStopCollection,
            **IRadialGradientBrush,
        ) callconv(.winapi) windows.HRESULT,
        CreateCompatibleRenderTarget: *const fn (
            *IHwndRenderTarget,
            ?*const SIZE_F,
            ?*const SIZE_U,
            ?*const PIXEL_FORMAT,
            COMPATIBLE_RENDER_TARGET_OPTIONS,
            **IBitmapRenderTarget,
        ) callconv(.winapi) windows.HRESULT,
        CreateLayer: *const fn (
            *IHwndRenderTarget,
            ?*const SIZE_F,
            **ILayer,
        ) callconv(.winapi) windows.HRESULT,
        CreateMesh: *const fn (
            *IHwndRenderTarget,
            **IMesh,
        ) callconv(.winapi) windows.HRESULT,
        DrawLine: *const fn (
            *IHwndRenderTarget,
            POINT_2F,
            POINT_2F,
            *IBrush,
            windows.FLOAT,
            ?*IStrokeStyle,
        ) callconv(.winapi) void,
        DrawRectangle: *const fn (
            *IHwndRenderTarget,
            *const RECT_F,
            *IBrush,
            windows.FLOAT,
            ?*IStrokeStyle,
        ) callconv(.winapi) void,
        FillRectangle: *const fn (
            *IHwndRenderTarget,
            *const RECT_F,
            *IBrush,
        ) callconv(.winapi) void,
        DrawRoundedRectangle: *const fn (
            *IHwndRenderTarget,
            *const ROUNDED_RECT,
            *IBrush,
            windows.FLOAT,
            ?*IStrokeStyle,
        ) callconv(.winapi) void,
        FillRoundedRectangle: *const fn (
            *IHwndRenderTarget,
            *const ROUNDED_RECT,
            *IBrush,
        ) callconv(.winapi) void,
        DrawEllipse: *const fn (
            *IHwndRenderTarget,
            *const ELLIPSE,
            *IBrush,
            windows.FLOAT,
            ?*IStrokeStyle,
        ) callconv(.winapi) void,
        FillEllipse: *const fn (
            *IHwndRenderTarget,
            *const ELLIPSE,
            *IBrush,
        ) callconv(.winapi) void,
        DrawGeometry: *const fn (
            *IHwndRenderTarget,
            *IGeometry,
            *IBrush,
            windows.FLOAT,
            ?*IStrokeStyle,
        ) callconv(.winapi) void,
        FillGeometry: *const fn (
            *IHwndRenderTarget,
            *IGeometry,
            *IBrush,
            ?*IBrush,
        ) callconv(.winapi) void,
        FillMesh: *const fn (
            *IHwndRenderTarget,
            *IMesh,
            *IBrush,
        ) callconv(.winapi) void,
        FillOpacityMask: *const fn (
            *IHwndRenderTarget,
            *IBitmap,
            *IBrush,
            OPACITY_MASK_CONTENT,
            ?*const RECT_F,
            ?*const RECT_F,
        ) callconv(.winapi) void,
        DrawBitmap: *const fn (
            *IHwndRenderTarget,
            *IBitmap,
            ?*const RECT_F,
            windows.FLOAT,
            BITMAP_INTERPOLATION_MODE,
            ?*const RECT_F,
        ) callconv(.winapi) void,
        DrawText: *const fn (
            *IHwndRenderTarget,
            [*]const windows.WCHAR,
            windows.UINT32,
            *dwrite.ITextFormat,
            *const RECT_F,
            *IBrush,
            DRAW_TEXT_OPTIONS,
            dwrite.MEASURING_MODE,
        ) callconv(.winapi) void,
        DrawTextLayout: *const fn (
            *IHwndRenderTarget,
            POINT_2F,
            *dwrite.ITextLayout,
            *IBrush,
            DRAW_TEXT_OPTIONS,
        ) callconv(.winapi) void,
        DrawGlyphRun: *const fn (
            *IHwndRenderTarget,
            POINT_2F,
            *const dwrite.GLYPH_RUN,
            *IBrush,
            dwrite.MEASURING_MODE,
        ) callconv(.winapi) void,
        SetTransform: *const fn (
            *IHwndRenderTarget,
            *const MATRIX_3X2_F,
        ) callconv(.winapi) void,
        GetTransform: *const fn (
            *IHwndRenderTarget,
            *MATRIX_3X2_F,
        ) callconv(.winapi) void,
        SetAntialiasMode: *const fn (
            *IHwndRenderTarget,
            ANTIALIAS_MODE,
        ) callconv(.winapi) void,
        GetAntialiasMode: *const fn (
            *IHwndRenderTarget,
        ) callconv(.winapi) ANTIALIAS_MODE,
        SetTextAntialiasMode: *const fn (
            *IHwndRenderTarget,
            TEXT_ANTIALIAS_MODE,
        ) callconv(.winapi) void,
        GetTextAntialiasMode: *const fn (
            *IHwndRenderTarget,
        ) callconv(.winapi) TEXT_ANTIALIAS_MODE,
        SetTextRenderingParams: *const fn (
            *IHwndRenderTarget,
            ?*dwrite.IRenderingParams,
        ) callconv(.winapi) void,
        GetTextRenderingParams: *const fn (
            *IHwndRenderTarget,
            *?*dwrite.IRenderingParams,
        ) callconv(.winapi) void,
        SetTags: *const fn (
            *IHwndRenderTarget,
            windows.TAG,
            windows.TAG,
        ) callconv(.winapi) void,
        GetTags: *const fn (
            *IHwndRenderTarget,
            ?*windows.TAG,
            ?*windows.TAG,
        ) callconv(.winapi) void,
        PushLayer: *const fn (
            *IHwndRenderTarget,
            *const LAYER_PARAMETERS,
            ?*ILayer,
        ) callconv(.winapi) void,
        PopLayer: *const fn (*IHwndRenderTarget) callconv(.winapi) void,
        Flush: *const fn (
            *IHwndRenderTarget,
            ?*windows.TAG,
            ?*windows.TAG,
        ) callconv(.winapi) windows.HRESULT,
        SaveDrawingState: *const fn (
            *IHwndRenderTarget,
            *IDrawingStateBlock,
        ) callconv(.winapi) void,
        RestoreDrawingState: *const fn (
            *IHwndRenderTarget,
            *IDrawingStateBlock,
        ) callconv(.winapi) void,
        PushAxisAlignedClip: *const fn (
            *IHwndRenderTarget,
            *const RECT_F,
            ANTIALIAS_MODE,
        ) callconv(.winapi) void,
        PopAxisAlignedClip: *const fn (*IHwndRenderTarget) callconv(.winapi) void,
        Clear: *const fn (
            *IHwndRenderTarget,
            ?*const COLOR_F,
        ) callconv(.winapi) void,
        BeginDraw: *const fn (*IHwndRenderTarget) callconv(.winapi) void,
        EndDraw: *const fn (
            *IHwndRenderTarget,
            ?*windows.TAG,
            ?*windows.TAG,
        ) callconv(.winapi) windows.HRESULT,
        GetPixelFormat: *const fn (*IHwndRenderTarget) callconv(.winapi) PIXEL_FORMAT,
        SetDpi: *const fn (
            *IHwndRenderTarget,
            windows.FLOAT,
            windows.FLOAT,
        ) callconv(.winapi) void,
        GetDpi: *const fn (
            *IHwndRenderTarget,
            *windows.FLOAT,
            *windows.FLOAT,
        ) callconv(.winapi) void,
        GetSize: *const fn (*IHwndRenderTarget) callconv(.winapi) SIZE_F,
        GetPixelSize: *const fn (*IHwndRenderTarget) callconv(.winapi) SIZE_U,
        GetMaximumBitmapSize: *const fn (*IHwndRenderTarget) callconv(.winapi) windows.UINT32,
        IsSupported: *const fn (
            *IHwndRenderTarget,
            *const RENDER_TARGET_PROPERTIES,
        ) callconv(.winapi) windows.BOOL,

        CheckWindowState: *const fn (*IHwndRenderTarget) callconv(.winapi) WINDOW_STATE,
        Resize: *const fn (
            *IHwndRenderTarget,
            *const SIZE_U,
        ) callconv(.winapi) windows.HRESULT,
        GetHwnd: *const fn (*IHwndRenderTarget) callconv(.winapi) windows.HWND,
    };

    pub fn Release(self: *IHwndRenderTarget) windows.ULONG {
        return self.v.Release(self);
    }

    pub fn CreateSolidColorBrush(
        self: *IHwndRenderTarget,
        color: *const COLOR_F,
        brush_properties: ?*const BRUSH_PROPERTIES,
    ) !*ISolidColorBrush {
        var brush: ?*ISolidColorBrush = null;
        const hr = self.v.CreateSolidColorBrush(self, color, brush_properties, &brush);
        if (hr < 0) {
            return error.FailedToCreateBrush;
        }

        return brush.?;
    }

    pub fn Resize(self: *IHwndRenderTarget, size: *const SIZE_U) windows.HRESULT {
        return self.v.Resize(self, size);
    }

    pub fn BeginDraw(self: *IHwndRenderTarget) void {
        return self.v.BeginDraw(self);
    }

    pub fn EndDraw(self: *IHwndRenderTarget) windows.HRESULT {
        return self.v.EndDraw(self, null, null);
    }

    pub fn SetTransform(self: *IHwndRenderTarget, transform: *const MATRIX_3X2_F) void {
        return self.v.SetTransform(self, transform);
    }

    pub fn Clear(self: *IHwndRenderTarget, color: ?*const COLOR_F) void {
        return self.v.Clear(self, color);
    }

    pub fn FillRectangle(self: *IHwndRenderTarget, area: *const RECT_F, brush: *IBrush) void {
        return self.v.FillRectangle(self, area, brush);
    }

    pub fn GetSize(self: *IHwndRenderTarget) SIZE_F {
        return self.v.GetSize(self);
    }

    pub fn DrawRectangle(
        self: *IHwndRenderTarget,
        rect: *const RECT_F,
        brush: *IBrush,
        stroke_width: windows.FLOAT,
        stroke_style: ?*IStrokeStyle,
    ) void {
        return self.v.DrawRectangle(self, rect, brush, stroke_width, stroke_style);
    }
};

const IBitmapRenderTarget = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *IBitmapRenderTarget,
            windows.REFIID,
            *?*anyopaque,
        ) callconv(.winapi) windows.HRESULT,
        AddRef: *const fn (*IBitmapRenderTarget) callconv(.winapi) windows.ULONG,
        Release: *const fn (*IBitmapRenderTarget) callconv(.winapi) windows.ULONG,

        GetFactory: *const fn (
            *IBitmapRenderTarget,
            **IFactory,
        ) callconv(.winapi) void,

        CreateBitmap: *const fn (
            *IBitmapRenderTarget,
            ?*const anyopaque,
            windows.UINT32,
            *const BITMAP_PROPERTIES,
            **IBitmap,
        ) callconv(.winapi) windows.HRESULT,
        CreateBitmapFromWicBitmap: *const fn (
            *IBitmapRenderTarget,
            *wic.IBitmapSource,
            ?*const BITMAP_PROPERTIES,
            **IBitmap,
        ) callconv(.winapi) windows.HRESULT,
        CreateSharedBitmap: *const fn (
            *IBitmapRenderTarget,
            windows.REFIID,
            *anyopaque,
            ?*const BITMAP_PROPERTIES,
            **IBitmap,
        ) callconv(.winapi) windows.HRESULT,
        CreateBitmapBrush: *const fn (
            *IBitmapRenderTarget,
            ?*IBitmap,
            ?*const BITMAP_BRUSH_PROPERTIES,
            ?*const BRUSH_PROPERTIES,
            **IBitmapBrush,
        ) callconv(.winapi) windows.HRESULT,
        CreateSolidColorBrush: *const fn (
            *IBitmapRenderTarget,
            *const COLOR_F,
            ?*const BRUSH_PROPERTIES,
            **ISolidColorBrush,
        ) callconv(.winapi) windows.HRESULT,
    };

    pub fn Release(self: *IBitmapRenderTarget) windows.ULONG {
        return self.v.Release(self);
    }
};

const IBitmap = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *IBitmap,
            windows.REFIID,
            *?*anyopaque,
        ) callconv(.winapi) windows.HRESULT,
        AddRef: *const fn (*IBitmap) callconv(.winapi) windows.ULONG,
        Release: *const fn (*IBitmap) callconv(.winapi) windows.ULONG,

        GetFactory: *const fn (
            *IBitmap,
            **IFactory,
        ) callconv(.winapi) void,

        GetSize: *const fn (*IBitmap) callconv(.winapi) SIZE_F,
        GetPixelSize: *const fn (*IBitmap) callconv(.winapi) SIZE_U,
        GetPixelFormat: *const fn (*IBitmap) callconv(.winapi) PIXEL_FORMAT,
        GetDpi: *const fn (
            *IBitmap,
            *windows.FLOAT,
            *windows.FLOAT,
        ) callconv(.winapi) void,
        CopyFromBitmap: *const fn (
            *IBitmap,
            ?*const POINT_2U,
            *IBitmap,
            ?*const RECT_U,
        ) callconv(.winapi) windows.HRESULT,
        CopyFromRenderTarget: *const fn (
            *IBitmap,
            ?*const POINT_2U,
            *IRenderTarget,
            ?*const RECT_U,
        ) callconv(.winapi) windows.HRESULT,
        CopyFromMemory: *const fn (
            *IBitmap,
            ?*const RECT_U,
            *const anyopaque,
            windows.UINT32,
        ) callconv(.winapi) windows.HRESULT,
    };
};

const IDrawingStateBlock = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *IDrawingStateBlock,
            windows.REFIID,
            *?*anyopaque,
        ) callconv(.winapi) windows.HRESULT,
        AddRef: *const fn (*IDrawingStateBlock) callconv(.winapi) windows.ULONG,
        Release: *const fn (*IDrawingStateBlock) callconv(.winapi) windows.ULONG,

        GetFactory: *const fn (*IDrawingStateBlock, **IFactory) callconv(.winapi) void,

        GetDescription: *const fn (
            *IDrawingStateBlock,
            *DRAWING_STATE_DESCRIPTION,
        ) callconv(.winapi) void,
        SetDescription: *const fn (
            *IDrawingStateBlock,
            *DRAWING_STATE_DESCRIPTION,
        ) callconv(.winapi) void,
        SetTextRenderingParams: *const fn (
            *IDrawingStateBlock,
            ?*dwrite.IRenderingParams,
        ) callconv(.winapi) void,
        GetTextRenderingParams: *const fn (
            *IDrawingStateBlock,
            *?*dwrite.IRenderingParams,
        ) callconv(.winapi) void,
    };

    pub fn Release(self: *IDrawingStateBlock) windows.ULONG {
        return self.v.Release(self);
    }

    pub fn GetFactory(self: *IDrawingStateBlock, factory: **IFactory) void {
        return self.v.GetFactory(self, factory);
    }
};

const IStrokeStyle = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *IStrokeStyle,
            windows.REFIID,
            *?*anyopaque,
        ) callconv(.winapi) windows.HRESULT,
        AddRef: *const fn (*IStrokeStyle) callconv(.winapi) windows.ULONG,
        Release: *const fn (*IStrokeStyle) callconv(.winapi) windows.ULONG,

        GetFactory: *const fn (*IStrokeStyle, **IFactory) callconv(.winapi) void,

        GetStartCap: *const fn (*IStrokeStyle) callconv(.winapi) CAP_STYLE,
        GetEndCap: *const fn (*IStrokeStyle) callconv(.winapi) CAP_STYLE,
        GetDashCap: *const fn (*IStrokeStyle) callconv(.winapi) CAP_STYLE,
        GetMiterLimit: *const fn (*IStrokeStyle) callconv(.winapi) windows.FLOAT,
        GetLineJoin: *const fn (*IStrokeStyle) callconv(.winapi) LINE_JOIN,
        GetDashOffset: *const fn (*IStrokeStyle) callconv(.winapi) windows.FLOAT,
        GetDashStyle: *const fn (*IStrokeStyle) callconv(.winapi) DASH_STYLE,
        GetDashesCount: *const fn (*IStrokeStyle) callconv(.winapi) windows.UINT32,
        GetDashes: *const fn (*IStrokeStyle, *windows.FLOAT, windows.UINT32) callconv(.winapi) void,
    };

    pub fn Release(self: *IStrokeStyle) windows.ULONG {
        return self.v.Release(self);
    }
};

const IGeometry = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *IGeometry,
            windows.REFIID,
            *?*anyopaque,
        ) callconv(.winapi) windows.HRESULT,
        AddRef: *const fn (*IGeometry) callconv(.winapi) windows.ULONG,
        Release: *const fn (*IGeometry) callconv(.winapi) windows.ULONG,

        GetFactory: *const fn (*IGeometry, **IFactory) callconv(.winapi) void,

        GetBounds: *const fn (
            *IGeometry,
            ?*const MATRIX_3X2_F,
            *RECT_F,
        ) callconv(.winapi) windows.HRESULT,
        GetWidenedBounds: *const fn (
            *IGeometry,
            windows.FLOAT,
            ?*IStrokeStyle,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *RECT_F,
        ) callconv(.winapi) windows.HRESULT,
        StrokeContainsPoint: *const fn (
            *IGeometry,
            POINT_2F,
            windows.FLOAT,
            ?*IStrokeStyle,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *windows.BOOL,
        ) callconv(.winapi) windows.HRESULT,
        FillContainsPoint: *const fn (
            *IGeometry,
            POINT_2F,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *windows.BOOL,
        ) callconv(.winapi) windows.HRESULT,
        CompareWithGeometry: *const fn (
            *IGeometry,
            *IGeometry,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *GEOMETRY_RELATION,
        ) callconv(.winapi) windows.HRESULT,
        Simplify: *const fn (
            *IGeometry,
            GEOMETRY_SIMPLIFICATION_OPTION,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *ISimplifiedGeometrySink,
        ) callconv(.winapi) windows.HRESULT,
        Tessellate: *const fn (
            *IGeometry,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *ITesselationSink,
        ) callconv(.winapi) windows.HRESULT,
        CombineWithGeometry: *const fn (
            *IGeometry,
            *IGeometry,
            COMBINE_MODE,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *ISimplifiedGeometrySink,
        ) callconv(.winapi) windows.HRESULT,
        Outline: *const fn (
            *IGeometry,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *ISimplifiedGeometrySink,
        ) callconv(.winapi) windows.HRESULT,
        ComputeArea: *const fn (
            *IGeometry,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *windows.FLOAT,
        ) callconv(.winapi) windows.HRESULT,
        ComputeLength: *const fn (
            *IGeometry,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *windows.FLOAT,
        ) callconv(.winapi) windows.HRESULT,
        ComputePointAtLength: *const fn (
            *IGeometry,
            windows.FLOAT,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            ?*POINT_2F,
            ?*POINT_2F,
        ) callconv(.winapi) windows.HRESULT,
        Widen: *const fn (
            *IGeometry,
            windows.FLOAT,
            ?*IStrokeStyle,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *ISimplifiedGeometrySink,
        ) callconv(.winapi) windows.HRESULT,
    };
};

pub const ISimplifiedGeometrySink = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *ISimplifiedGeometrySink,
            windows.REFIID,
            *?*anyopaque,
        ) callconv(.winapi) windows.HRESULT,
        AddRef: *const fn (*ISimplifiedGeometrySink) callconv(.winapi) windows.ULONG,
        Release: *const fn (*ISimplifiedGeometrySink) callconv(.winapi) windows.ULONG,

        SetFillMode: *const fn (
            *ISimplifiedGeometrySink,
            FILL_MODE,
        ) callconv(.winapi) void,
        SetSegmentFlags: *const fn (
            *ISimplifiedGeometrySink,
            PATH_SEGMENT,
        ) callconv(.winapi) void,
        BeginFigure: *const fn (
            *ISimplifiedGeometrySink,
            POINT_2F,
            FIGURE_BEGIN,
        ) callconv(.winapi) void,
        AddLines: *const fn (
            *ISimplifiedGeometrySink,
            [*]const POINT_2F,
            windows.UINT32,
        ) callconv(.winapi) void,
        AddBeziers: *const fn (
            *ISimplifiedGeometrySink,
            [*]const BEZIER_SEGMENT,
            windows.UINT32,
        ) callconv(.winapi) void,
        EndFigure: *const fn (
            *ISimplifiedGeometrySink,
            FIGURE_END,
        ) callconv(.winapi) void,
        Close: *const fn (*ISimplifiedGeometrySink) callconv(.winapi) windows.HRESULT,
    };
};

pub const IGeometrySink = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *IGeometrySink,
            windows.REFIID,
            *?*anyopaque,
        ) callconv(.winapi) windows.HRESULT,
        AddRef: *const fn (*IGeometrySink) callconv(.winapi) windows.ULONG,
        Release: *const fn (*IGeometrySink) callconv(.winapi) windows.ULONG,

        SetFillMode: *const fn (
            *IGeometrySink,
            FILL_MODE,
        ) callconv(.winapi) void,
        SetSegmentFlags: *const fn (
            *IGeometrySink,
            PATH_SEGMENT,
        ) callconv(.winapi) void,
        BeginFigure: *const fn (
            *IGeometrySink,
            POINT_2F,
            FIGURE_BEGIN,
        ) callconv(.winapi) void,
        AddLines: *const fn (
            *IGeometrySink,
            [*]const POINT_2F,
            windows.UINT32,
        ) callconv(.winapi) void,
        AddBeziers: *const fn (
            *IGeometrySink,
            [*]const BEZIER_SEGMENT,
            windows.UINT32,
        ) callconv(.winapi) void,
        EndFigure: *const fn (
            *IGeometrySink,
            FIGURE_END,
        ) callconv(.winapi) void,
        Close: *const fn (*IGeometrySink) callconv(.winapi) windows.HRESULT,
        AddLine: *const fn (*IGeometrySink, POINT_2F) callconv(.winapi) void,
        AddBezier: *const fn (
            *IGeometrySink,
            *const BEZIER_SEGMENT,
        ) callconv(.winapi) void,
        AddQuadraticBezier: *const fn (
            *IGeometrySink,
            *const QUADRATIC_BEZIER_SEGMENT,
        ) callconv(.winapi) void,
        AddQuadraticBeziers: *const fn (
            *IGeometrySink,
            [*]const QUADRATIC_BEZIER_SEGMENT,
        ) callconv(.winapi) void,
        AddArc: *const fn (
            *IGeometrySink,
            *const ARC_SEGMENT,
        ) callconv(.winapi) void,
    };
};

const ITesselationSink = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *ITesselationSink,
            windows.REFIID,
            *?*anyopaque,
        ) callconv(.winapi) windows.HRESULT,
        AddRef: *const fn (*ITesselationSink) callconv(.winapi) windows.ULONG,
        Release: *const fn (*ITesselationSink) callconv(.winapi) windows.ULONG,

        AddTriangles: *const fn (
            *ITesselationSink,
            [*]const TRIANGLE,
            windows.UINT32,
        ) callconv(.winapi) void,
        Close: *const fn (*ITesselationSink) callconv(.winapi) windows.HRESULT,
    };
};

const IRectangleGeometry = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *IRectangleGeometry,
            windows.REFIID,
            *?*anyopaque,
        ) callconv(.winapi) windows.HRESULT,
        AddRef: *const fn (*IRectangleGeometry) callconv(.winapi) windows.ULONG,
        Release: *const fn (*IRectangleGeometry) callconv(.winapi) windows.ULONG,

        GetFactory: *const fn (*IRectangleGeometry, **IFactory) callconv(.winapi) void,

        GetBounds: *const fn (
            *IRectangleGeometry,
            ?*const MATRIX_3X2_F,
            *RECT_F,
        ) callconv(.winapi) windows.HRESULT,
        GetWidenedBounds: *const fn (
            *IRectangleGeometry,
            windows.FLOAT,
            ?*IStrokeStyle,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *RECT_F,
        ) callconv(.winapi) windows.HRESULT,
        StrokeContainsPoint: *const fn (
            *IRectangleGeometry,
            POINT_2F,
            windows.FLOAT,
            ?*IStrokeStyle,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *windows.BOOL,
        ) callconv(.winapi) windows.HRESULT,
        FillContainsPoint: *const fn (
            *IRectangleGeometry,
            POINT_2F,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *windows.BOOL,
        ) callconv(.winapi) windows.HRESULT,
        CompareWithGeometry: *const fn (
            *IRectangleGeometry,
            *IGeometry,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *GEOMETRY_RELATION,
        ) callconv(.winapi) windows.HRESULT,
        Simplify: *const fn (
            *IRectangleGeometry,
            GEOMETRY_SIMPLIFICATION_OPTION,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *ISimplifiedGeometrySink,
        ) callconv(.winapi) windows.HRESULT,
        Tessellate: *const fn (
            *IRectangleGeometry,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *ITesselationSink,
        ) callconv(.winapi) windows.HRESULT,
        CombineWithGeometry: *const fn (
            *IRectangleGeometry,
            *IGeometry,
            COMBINE_MODE,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *ISimplifiedGeometrySink,
        ) callconv(.winapi) windows.HRESULT,
        Outline: *const fn (
            *IRectangleGeometry,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *ISimplifiedGeometrySink,
        ) callconv(.winapi) windows.HRESULT,
        ComputeArea: *const fn (
            *IRectangleGeometry,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *windows.FLOAT,
        ) callconv(.winapi) windows.HRESULT,
        ComputeLength: *const fn (
            *IRectangleGeometry,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *windows.FLOAT,
        ) callconv(.winapi) windows.HRESULT,
        ComputePointAtLength: *const fn (
            *IRectangleGeometry,
            windows.FLOAT,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            ?*POINT_2F,
            ?*POINT_2F,
        ) callconv(.winapi) windows.HRESULT,
        Widen: *const fn (
            *IRectangleGeometry,
            windows.FLOAT,
            ?*IStrokeStyle,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *ISimplifiedGeometrySink,
        ) callconv(.winapi) windows.HRESULT,

        GetRect: *const fn (*IRectangleGeometry, *RECT_F) callconv(.winapi) void,
    };
};

const IRoundedRectangleGeometry = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *IRoundedRectangleGeometry,
            windows.REFIID,
            *?*anyopaque,
        ) callconv(.winapi) windows.HRESULT,
        AddRef: *const fn (*IRoundedRectangleGeometry) callconv(.winapi) windows.ULONG,
        Release: *const fn (*IRoundedRectangleGeometry) callconv(.winapi) windows.ULONG,

        GetFactory: *const fn (
            *IRoundedRectangleGeometry,
            **IFactory,
        ) callconv(.winapi) void,

        GetBounds: *const fn (
            *IRoundedRectangleGeometry,
            ?*const MATRIX_3X2_F,
            *RECT_F,
        ) callconv(.winapi) windows.HRESULT,
        GetWidenedBounds: *const fn (
            *IRoundedRectangleGeometry,
            windows.FLOAT,
            ?*IStrokeStyle,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *RECT_F,
        ) callconv(.winapi) windows.HRESULT,
        StrokeContainsPoint: *const fn (
            *IRoundedRectangleGeometry,
            POINT_2F,
            windows.FLOAT,
            ?*IStrokeStyle,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *windows.BOOL,
        ) callconv(.winapi) windows.HRESULT,
        FillContainsPoint: *const fn (
            *IRoundedRectangleGeometry,
            POINT_2F,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *windows.BOOL,
        ) callconv(.winapi) windows.HRESULT,
        CompareWithGeometry: *const fn (
            *IRoundedRectangleGeometry,
            *IGeometry,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *GEOMETRY_RELATION,
        ) callconv(.winapi) windows.HRESULT,
        Simplify: *const fn (
            *IRoundedRectangleGeometry,
            GEOMETRY_SIMPLIFICATION_OPTION,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *ISimplifiedGeometrySink,
        ) callconv(.winapi) windows.HRESULT,
        Tessellate: *const fn (
            *IRoundedRectangleGeometry,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *ITesselationSink,
        ) callconv(.winapi) windows.HRESULT,
        CombineWithGeometry: *const fn (
            *IRoundedRectangleGeometry,
            *IGeometry,
            COMBINE_MODE,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *ISimplifiedGeometrySink,
        ) callconv(.winapi) windows.HRESULT,
        Outline: *const fn (
            *IRoundedRectangleGeometry,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *ISimplifiedGeometrySink,
        ) callconv(.winapi) windows.HRESULT,
        ComputeArea: *const fn (
            *IRoundedRectangleGeometry,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *windows.FLOAT,
        ) callconv(.winapi) windows.HRESULT,
        ComputeLength: *const fn (
            *IRoundedRectangleGeometry,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *windows.FLOAT,
        ) callconv(.winapi) windows.HRESULT,
        ComputePointAtLength: *const fn (
            *IRoundedRectangleGeometry,
            windows.FLOAT,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            ?*POINT_2F,
            ?*POINT_2F,
        ) callconv(.winapi) windows.HRESULT,
        Widen: *const fn (
            *IRoundedRectangleGeometry,
            windows.FLOAT,
            ?*IStrokeStyle,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *ISimplifiedGeometrySink,
        ) callconv(.winapi) windows.HRESULT,

        GetRoundedRect: *const fn (
            *IRoundedRectangleGeometry,
            *ROUNDED_RECT,
        ) callconv(.winapi) void,
    };
};

const IEllipseGeometry = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *IEllipseGeometry,
            windows.REFIID,
            *?*anyopaque,
        ) callconv(.winapi) windows.HRESULT,
        AddRef: *const fn (*IEllipseGeometry) callconv(.winapi) windows.ULONG,
        Release: *const fn (*IEllipseGeometry) callconv(.winapi) windows.ULONG,

        GetFactory: *const fn (
            *IEllipseGeometry,
            **IFactory,
        ) callconv(.winapi) void,

        GetBounds: *const fn (
            *IEllipseGeometry,
            ?*const MATRIX_3X2_F,
            *RECT_F,
        ) callconv(.winapi) windows.HRESULT,
        GetWidenedBounds: *const fn (
            *IEllipseGeometry,
            windows.FLOAT,
            ?*IStrokeStyle,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *RECT_F,
        ) callconv(.winapi) windows.HRESULT,
        StrokeContainsPoint: *const fn (
            *IEllipseGeometry,
            POINT_2F,
            windows.FLOAT,
            ?*IStrokeStyle,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *windows.BOOL,
        ) callconv(.winapi) windows.HRESULT,
        FillContainsPoint: *const fn (
            *IEllipseGeometry,
            POINT_2F,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *windows.BOOL,
        ) callconv(.winapi) windows.HRESULT,
        CompareWithGeometry: *const fn (
            *IEllipseGeometry,
            *IGeometry,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *GEOMETRY_RELATION,
        ) callconv(.winapi) windows.HRESULT,
        Simplify: *const fn (
            *IEllipseGeometry,
            GEOMETRY_SIMPLIFICATION_OPTION,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *ISimplifiedGeometrySink,
        ) callconv(.winapi) windows.HRESULT,
        Tessellate: *const fn (
            *IEllipseGeometry,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *ITesselationSink,
        ) callconv(.winapi) windows.HRESULT,
        CombineWithGeometry: *const fn (
            *IEllipseGeometry,
            *IGeometry,
            COMBINE_MODE,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *ISimplifiedGeometrySink,
        ) callconv(.winapi) windows.HRESULT,
        Outline: *const fn (
            *IEllipseGeometry,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *ISimplifiedGeometrySink,
        ) callconv(.winapi) windows.HRESULT,
        ComputeArea: *const fn (
            *IEllipseGeometry,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *windows.FLOAT,
        ) callconv(.winapi) windows.HRESULT,
        ComputeLength: *const fn (
            *IEllipseGeometry,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *windows.FLOAT,
        ) callconv(.winapi) windows.HRESULT,
        ComputePointAtLength: *const fn (
            *IEllipseGeometry,
            windows.FLOAT,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            ?*POINT_2F,
            ?*POINT_2F,
        ) callconv(.winapi) windows.HRESULT,
        Widen: *const fn (
            *IEllipseGeometry,
            windows.FLOAT,
            ?*IStrokeStyle,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *ISimplifiedGeometrySink,
        ) callconv(.winapi) windows.HRESULT,

        GetEllipse: *const fn (
            *IEllipseGeometry,
            *ELLIPSE,
        ) callconv(.winapi) void,
    };
};

const IGeometryGroup = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *IGeometryGroup,
            windows.REFIID,
            *?*anyopaque,
        ) callconv(.winapi) windows.HRESULT,
        AddRef: *const fn (*IGeometryGroup) callconv(.winapi) windows.ULONG,
        Release: *const fn (*IGeometryGroup) callconv(.winapi) windows.ULONG,

        GetFactory: *const fn (
            *IGeometryGroup,
            **IFactory,
        ) callconv(.winapi) void,

        GetBounds: *const fn (
            *IGeometryGroup,
            ?*const MATRIX_3X2_F,
            *RECT_F,
        ) callconv(.winapi) windows.HRESULT,
        GetWidenedBounds: *const fn (
            *IGeometryGroup,
            windows.FLOAT,
            ?*IStrokeStyle,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *RECT_F,
        ) callconv(.winapi) windows.HRESULT,
        StrokeContainsPoint: *const fn (
            *IGeometryGroup,
            POINT_2F,
            windows.FLOAT,
            ?*IStrokeStyle,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *windows.BOOL,
        ) callconv(.winapi) windows.HRESULT,
        FillContainsPoint: *const fn (
            *IGeometryGroup,
            POINT_2F,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *windows.BOOL,
        ) callconv(.winapi) windows.HRESULT,
        CompareWithGeometry: *const fn (
            *IGeometryGroup,
            *IGeometry,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *GEOMETRY_RELATION,
        ) callconv(.winapi) windows.HRESULT,
        Simplify: *const fn (
            *IGeometryGroup,
            GEOMETRY_SIMPLIFICATION_OPTION,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *ISimplifiedGeometrySink,
        ) callconv(.winapi) windows.HRESULT,
        Tessellate: *const fn (
            *IGeometryGroup,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *ITesselationSink,
        ) callconv(.winapi) windows.HRESULT,
        CombineWithGeometry: *const fn (
            *IGeometryGroup,
            *IGeometry,
            COMBINE_MODE,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *ISimplifiedGeometrySink,
        ) callconv(.winapi) windows.HRESULT,
        Outline: *const fn (
            *IGeometryGroup,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *ISimplifiedGeometrySink,
        ) callconv(.winapi) windows.HRESULT,
        ComputeArea: *const fn (
            *IGeometryGroup,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *windows.FLOAT,
        ) callconv(.winapi) windows.HRESULT,
        ComputeLength: *const fn (
            *IGeometryGroup,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *windows.FLOAT,
        ) callconv(.winapi) windows.HRESULT,
        ComputePointAtLength: *const fn (
            *IGeometryGroup,
            windows.FLOAT,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            ?*POINT_2F,
            ?*POINT_2F,
        ) callconv(.winapi) windows.HRESULT,
        Widen: *const fn (
            *IGeometryGroup,
            windows.FLOAT,
            ?*IStrokeStyle,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *ISimplifiedGeometrySink,
        ) callconv(.winapi) windows.HRESULT,

        GetFillMode: *const fn (*IGeometryGroup) callconv(.winapi) FILL_MODE,
        GetSourceGeometryCount: *const fn (*IGeometryGroup) callconv(.winapi) windows.UINT32,
        GetSourceGeometries: *const fn (
            *IGeometryGroup,
            [*]*IGeometry,
            windows.UINT32,
        ) callconv(.winapi) void,
    };
};

const ITransformedGeometry = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *ITransformedGeometry,
            windows.REFIID,
            *?*anyopaque,
        ) callconv(.winapi) windows.HRESULT,
        AddRef: *const fn (*ITransformedGeometry) callconv(.winapi) windows.ULONG,
        Release: *const fn (*ITransformedGeometry) callconv(.winapi) windows.ULONG,

        GetFactory: *const fn (
            *ITransformedGeometry,
            **IFactory,
        ) callconv(.winapi) void,

        GetBounds: *const fn (
            *ITransformedGeometry,
            ?*const MATRIX_3X2_F,
            *RECT_F,
        ) callconv(.winapi) windows.HRESULT,
        GetWidenedBounds: *const fn (
            *ITransformedGeometry,
            windows.FLOAT,
            ?*IStrokeStyle,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *RECT_F,
        ) callconv(.winapi) windows.HRESULT,
        StrokeContainsPoint: *const fn (
            *ITransformedGeometry,
            POINT_2F,
            windows.FLOAT,
            ?*IStrokeStyle,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *windows.BOOL,
        ) callconv(.winapi) windows.HRESULT,
        FillContainsPoint: *const fn (
            *ITransformedGeometry,
            POINT_2F,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *windows.BOOL,
        ) callconv(.winapi) windows.HRESULT,
        CompareWithGeometry: *const fn (
            *ITransformedGeometry,
            *IGeometry,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *GEOMETRY_RELATION,
        ) callconv(.winapi) windows.HRESULT,
        Simplify: *const fn (
            *ITransformedGeometry,
            GEOMETRY_SIMPLIFICATION_OPTION,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *ISimplifiedGeometrySink,
        ) callconv(.winapi) windows.HRESULT,
        Tessellate: *const fn (
            *ITransformedGeometry,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *ITesselationSink,
        ) callconv(.winapi) windows.HRESULT,
        CombineWithGeometry: *const fn (
            *ITransformedGeometry,
            *IGeometry,
            COMBINE_MODE,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *ISimplifiedGeometrySink,
        ) callconv(.winapi) windows.HRESULT,
        Outline: *const fn (
            *ITransformedGeometry,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *ISimplifiedGeometrySink,
        ) callconv(.winapi) windows.HRESULT,
        ComputeArea: *const fn (
            *ITransformedGeometry,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *windows.FLOAT,
        ) callconv(.winapi) windows.HRESULT,
        ComputeLength: *const fn (
            *ITransformedGeometry,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *windows.FLOAT,
        ) callconv(.winapi) windows.HRESULT,
        ComputePointAtLength: *const fn (
            *ITransformedGeometry,
            windows.FLOAT,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            ?*POINT_2F,
            ?*POINT_2F,
        ) callconv(.winapi) windows.HRESULT,
        Widen: *const fn (
            *ITransformedGeometry,
            windows.FLOAT,
            ?*IStrokeStyle,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *ISimplifiedGeometrySink,
        ) callconv(.winapi) windows.HRESULT,

        GetSourceGeometry: *const fn (
            *ITransformedGeometry,
            **IGeometry,
        ) callconv(.winapi) void,
        GetTransform: *const fn (
            *ITransformedGeometry,
            *MATRIX_3X2_F,
        ) callconv(.winapi) void,
    };
};

const IPathGeometry = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *IPathGeometry,
            windows.REFIID,
            *?*anyopaque,
        ) callconv(.winapi) windows.HRESULT,
        AddRef: *const fn (*IPathGeometry) callconv(.winapi) windows.ULONG,
        Release: *const fn (*IPathGeometry) callconv(.winapi) windows.ULONG,

        GetFactory: *const fn (
            *IPathGeometry,
            **IFactory,
        ) callconv(.winapi) void,

        GetBounds: *const fn (
            *IPathGeometry,
            ?*const MATRIX_3X2_F,
            *RECT_F,
        ) callconv(.winapi) windows.HRESULT,
        GetWidenedBounds: *const fn (
            *IPathGeometry,
            windows.FLOAT,
            ?*IStrokeStyle,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *RECT_F,
        ) callconv(.winapi) windows.HRESULT,
        StrokeContainsPoint: *const fn (
            *IPathGeometry,
            POINT_2F,
            windows.FLOAT,
            ?*IStrokeStyle,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *windows.BOOL,
        ) callconv(.winapi) windows.HRESULT,
        FillContainsPoint: *const fn (
            *IPathGeometry,
            POINT_2F,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *windows.BOOL,
        ) callconv(.winapi) windows.HRESULT,
        CompareWithGeometry: *const fn (
            *IPathGeometry,
            *IGeometry,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *GEOMETRY_RELATION,
        ) callconv(.winapi) windows.HRESULT,
        Simplify: *const fn (
            *IPathGeometry,
            GEOMETRY_SIMPLIFICATION_OPTION,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *ISimplifiedGeometrySink,
        ) callconv(.winapi) windows.HRESULT,
        Tessellate: *const fn (
            *IPathGeometry,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *ITesselationSink,
        ) callconv(.winapi) windows.HRESULT,
        CombineWithGeometry: *const fn (
            *IPathGeometry,
            *IGeometry,
            COMBINE_MODE,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *ISimplifiedGeometrySink,
        ) callconv(.winapi) windows.HRESULT,
        Outline: *const fn (
            *IPathGeometry,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *ISimplifiedGeometrySink,
        ) callconv(.winapi) windows.HRESULT,
        ComputeArea: *const fn (
            *IPathGeometry,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *windows.FLOAT,
        ) callconv(.winapi) windows.HRESULT,
        ComputeLength: *const fn (
            *IPathGeometry,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *windows.FLOAT,
        ) callconv(.winapi) windows.HRESULT,
        ComputePointAtLength: *const fn (
            *IPathGeometry,
            windows.FLOAT,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            ?*POINT_2F,
            ?*POINT_2F,
        ) callconv(.winapi) windows.HRESULT,
        Widen: *const fn (
            *IPathGeometry,
            windows.FLOAT,
            ?*IStrokeStyle,
            ?*const MATRIX_3X2_F,
            windows.FLOAT,
            *ISimplifiedGeometrySink,
        ) callconv(.winapi) windows.HRESULT,

        Open: *const fn (
            *IPathGeometry,
            **IGeometrySink,
        ) callconv(.winapi) windows.HRESULT,
        Stream: *const fn (
            *IPathGeometry,
            *IGeometrySink,
        ) callconv(.winapi) windows.HRESULT,
        GetSegmentCount: *const fn (
            *IPathGeometry,
            *windows.UINT32,
        ) callconv(.winapi) windows.HRESULT,
        GetFigureCount: *const fn (
            *IPathGeometry,
            *windows.UINT32,
        ) callconv(.winapi) windows.HRESULT,
    };
};

extern "d2d1" fn D2D1CreateFactory(
    factoryType: FACTORY_TYPE,
    riid: windows.REFIID,
    pFactoryOptions: ?*const FACTORY_OPTIONS,
    ppIFactory: *?*IFactory,
) callconv(.winapi) windows.HRESULT;
