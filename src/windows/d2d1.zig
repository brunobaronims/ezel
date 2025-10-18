const std = @import("std");
const windows = std.os.windows;

const FLOAT = windows.FLOAT;
const GUID = windows.GUID;
const HRESULT = windows.HRESULT;
const ULONG = windows.ULONG;
const BOOL = windows.BOOL;
const UINT32 = u32;
const D2D1_TAG = u64;

const D2D1_RECT_F = extern struct {
    left: FLOAT = 0,
    top: FLOAT = 0,
    right: FLOAT = 0,
    bottom: FLOAT = 0,
};

const D2D1_ROUNDED_RECT = extern struct {
    rect: D2D1_RECT_F,
    radiusX: FLOAT = 0,
    radiusY: FLOAT = 0,
};

const D2D1_POINT_2F = extern struct { x: FLOAT = 0, y: FLOAT = 0 };

const D2D1_MATRIX_3X2_F = extern union {
    DUMMYSTRUCTNAME: extern struct {
        m11: FLOAT = 0,
        m12: FLOAT = 0,
        m21: FLOAT = 0,
        m22: FLOAT = 0,
        dx: FLOAT = 0,
        dy: FLOAT = 0,
    },
    DUMMYSTRUCTNAME2: extern struct {
        _11: FLOAT = 0,
        _12: FLOAT = 0,
        _21: FLOAT = 0,
        _22: FLOAT = 0,
        _31: FLOAT = 0,
        _32: FLOAT = 0,
    },
    m: [3][2]FLOAT,
};

const D2D1_FACTORY_OPTIONS = extern struct { debugLevel: D2D1_DEBUG_LEVEL };

const D2D1_BEZIER_SEGMENT = extern struct {
    point1: D2D1_POINT_2F,
    point2: D2D1_POINT_2F,
    point3: D2D1_POINT_2F,
};

const D2D1_QUADRATIC_BEZIER_SEGMENT = extern struct {
    point1: D2D1_POINT_2F,
    point2: D2D1_POINT_2F,
};

const D2D1_TRIANGLE = D2D1_BEZIER_SEGMENT;

const D2D1_SIZE_F = extern struct {
    width: FLOAT = 0,
    height: FLOAT = 0,
};

const D2D1_ARC_SEGMENT = extern struct {
    point: D2D1_POINT_2F,
    size: D2D1_SIZE_F,
    rotationAngle: FLOAT = 0,
    sweepDirection: D2D1_SWEEP_DIRECTION = D2D1_SWEEP_DIRECTION.D2D1_SWEEP_DIRECTION_CLOCKWISE,
    arcSize: D2D1_ARC_SIZE = D2D1_ARC_SIZE.D2D1_ARC_SIZE_SMALL,
};

const D2D1_ELLIPSE = extern struct {
    point: D2D1_POINT_2F,
    radiusX: FLOAT = 0,
    radiusY: FLOAT = 0,
};

const D2D1_STROKE_STYLE_PROPERTIES = extern struct {
    startCap: D2D1_CAP_STYLE = D2D1_CAP_STYLE.D2D1_CAP_STYLE_FLAT,
    endCap: D2D1_CAP_STYLE = D2D1_CAP_STYLE.D2D1_CAP_STYLE_FLAT,
    dashCap: D2D1_CAP_STYLE = D2D1_CAP_STYLE.D2D1_CAP_STYLE_FLAT,
    lineJoin: D2D1_LINE_JOIN = D2D1_LINE_JOIN.D2D1_LINE_JOIN_BEVEL,
    miterLimit: FLOAT = 0,
    dashStyle: D2D1_DASH_STYLE = D2D1_DASH_STYLE.D2D1_DASH_STYLE_DASH,
    dashOffset: FLOAT = 0,
};

const D2D1_DRAWING_STATE_DESCRIPTION = extern struct {
    antialiasMode: D2D1_ANTIALIAS_MODE = D2D1_ANTIALIAS_MODE.D2D1_ANTIALIAS_MODE_ALIASED,
    textAntialiasMode: D2D1_TEXT_ANTIALIAS_MODE = D2D1_TEXT_ANTIALIAS_MODE.D2D1_TEXT_ANTIALIAS_MODE_ALIASED,
    tag1: D2D1_TAG,
    tag2: D2D1_TAG,
    transform: D2D1_MATRIX_3X2_F,
};

const D2D1_FACTORY_TYPE = enum(c_int) {
    D2D1_FACTORY_TYPE_SINGLE_THREADED = 0,
    D2D1_FACTORY_TYPE_MULTI_THREADED = 1,
    D2D1_FACTORY_TYPE_FORCE_DWORD = 0xffffffff,
};

const D2D1_DEBUG_LEVEL = enum(c_int) {
    D2D1_DEBUG_LEVEL_NONE = 0,
    D2D1_DEBUG_LEVEL_ERROR = 1,
    D2D1_DEBUG_LEVEL_WARNING = 2,
    D2D1_DEBUG_LEVEL_INFORMATION = 3,
    D2D1_DEBUG_LEVEL_FORCE_DWORD = 0xffffffff,
};

const D2D1_CAP_STYLE = enum(c_int) {
    D2D1_CAP_STYLE_FLAT = 0,
    D2D1_CAP_STYLE_SQUARE = 1,
    D2D1_CAP_STYLE_ROUND = 2,
    D2D1_CAP_STYLE_TRIANGLE = 3,
    D2D1_CAP_STYLE_FORCE_DWORD = 0xffffffff,
};

const D2D1_LINE_JOIN = enum(c_int) {
    D2D1_LINE_JOIN_MITER = 0,
    D2D1_LINE_JOIN_BEVEL = 1,
    D2D1_LINE_JOIN_ROUND = 2,
    D2D1_LINE_JOIN_MITER_OR_BEVEL = 3,
    D2D1_LINE_JOIN_FORCE_DWORD = 0xffffffff,
};

const D2D1_DASH_STYLE = enum(c_int) {
    D2D1_DASH_STYLE_SOLID = 0,
    D2D1_DASH_STYLE_DASH = 1,
    D2D1_DASH_STYLE_DOT = 2,
    D2D1_DASH_STYLE_DASH_DOT = 3,
    D2D1_DASH_STYLE_DASH_DOT_DOT = 4,
    D2D1_DASH_STYLE_CUSTOM = 5,
    D2D1_DASH_STYLE_FORCE_DWORD = 0xffffffff,
};

const D2D1_GEOMETRY_RELATION = enum(c_int) {
    D2D1_GEOMETRY_RELATION_UNKNOWN = 0,
    D2D1_GEOMETRY_RELATION_DISJOINT = 1,
    D2D1_GEOMETRY_RELATION_IS_CONTAINED = 2,
    D2D1_GEOMETRY_RELATION_CONTAINS = 3,
    D2D1_GEOMETRY_RELATION_OVERLAP = 4,
    D2D1_GEOMETRY_RELATION_FORCE_DWORD = 0xffffffff,
};

const D2D1_GEOMETRY_SIMPLIFICATION_OPTION = enum(c_int) {
    D2D1_GEOMETRY_SIMPLIFICATION_OPTION_CUBICS_AND_LINES = 0,
    D2D1_GEOMETRY_SIMPLIFICATION_OPTION_LINES = 1,
    D2D1_GEOMETRY_SIMPLIFICATION_OPTION_FORCE_DWORD = 0xffffffff,
};

const D2D1_FILL_MODE = enum(c_int) {
    D2D1_FILL_MODE_ALTERNATE = 0,
    D2D1_FILL_MODE_WINDING = 1,
    D2D1_FILL_MODE_FORCE_DWORD = 0xffffffff,
};

const D2D1_PATH_SEGMENT = enum(c_int) {
    D2D1_PATH_SEGMENT_NONE = 0x00000000,
    D2D1_PATH_SEGMENT_FORCE_UNSTROKED = 0x00000001,
    D2D1_PATH_SEGMENT_FORCE_ROUND_LINE_JOIN = 0x00000002,
    D2D1_PATH_SEGMENT_FORCE_DWORD = 0xffffffff,
};

const D2D1_FIGURE_BEGIN = enum(c_int) {
    D2D1_FIGURE_BEGIN_FILLED = 0,
    D2D1_FIGURE_BEGIN_HOLLOW = 1,
    D2D1_FIGURE_BEGIN_FORCE_DWORD = 0xffffffff,
};

const D2D1_FIGURE_END = enum(c_int) {
    D2D1_FIGURE_END_OPEN = 0,
    D2D1_FIGURE_END_CLOSED = 1,
    D2D1_FIGURE_END_FORCE_DWORD = 0xffffffff,
};

const D2D1_COMBINE_MODE = enum(c_int) {
    D2D1_COMBINE_MODE_UNION = 0,
    D2D1_COMBINE_MODE_INTERSECT = 1,
    D2D1_COMBINE_MODE_XOR = 2,
    D2D1_COMBINE_MODE_EXCLUDE = 3,
    D2D1_COMBINE_MODE_FORCE_DWORD = 0xffffffff,
};

const D2D1_SWEEP_DIRECTION = enum(c_int) {
    D2D1_SWEEP_DIRECTION_COUNTER_CLOCKWISE = 0,
    D2D1_SWEEP_DIRECTION_CLOCKWISE = 1,
    D2D1_SWEEP_DIRECTION_FORCE_DWORD = 0xffffffff,
};

const D2D1_ARC_SIZE = enum(c_int) {
    D2D1_ARC_SIZE_SMALL = 0,
    D2D1_ARC_SIZE_LARGE = 1,
    D2D1_ARC_SIZE_FORCE_DWORD = 0xffffffff,
};

const D2D1_ANTIALIAS_MODE = enum(c_int) {
    D2D1_ANTIALIAS_MODE_PER_PRIMITIVE = 0,
    D2D1_ANTIALIAS_MODE_ALIASED = 1,
    D2D1_ANTIALIAS_MODE_FORCE_DWORD = 0xffffffff,
};

const D2D1_TEXT_ANTIALIAS_MODE = enum(c_int) {
    D2D1_TEXT_ANTIALIAS_MODE_DEFAULT = 0,
    D2D1_TEXT_ANTIALIAS_MODE_CLEARTYPE = 1,
    D2D1_TEXT_ANTIALIAS_MODE_GRAYSCALE = 2,
    D2D1_TEXT_ANTIALIAS_MODE_ALIASED = 3,
    D2D1_TEXT_ANTIALIAS_MODE_FORCE_DWORD = 0xffffffff,
};

const DWRITE_PIXEL_GEOMETRY = enum(c_int) {
    DWRITE_PIXEL_GEOMETRY_FLAT,
    DWRITE_PIXEL_GEOMETRY_RGB,
    DWRITE_PIXEL_GEOMETRY_BGR,
};

pub const DWRITE_RENDERING_MODE = enum(c_int) {
    DWRITE_RENDERING_MODE_DDEFAULT,
    DWRITE_RENDERING_MODE_ALIASED,
    DWRITE_RENDERING_MODE_GDI_CLASSIC,
    DWRITE_RENDERING_MODE_GDI_NATURAL,
    DWRITE_RENDERING_MODE_NATURAL,
    DWRITE_RENDERING_MODE_NATURAL_SYMMETRIC,
    DWRITE_RENDERING_MODE_OUTLINE,
    DWRITE_RENDERING_MODE_CLEARTYPE_GDI_CLASSIC,
    DWRITE_RENDERING_MODE_CLEARTYPE_GDI_NATURAL,
    DWRITE_RENDERING_MODE_CLEARTYPE_NATURAL,
    DWRITE_RENDERING_MODE_CLEARTYPE_NATURAL_SYMMETRIC,
};

extern "d2d1" fn D2D1CreateFactory(
    factoryType: D2D1_FACTORY_TYPE,
    riid: *const GUID,
    pFactoryOptions: ?*const D2D1_FACTORY_OPTIONS,
    ppIFactory: *?*ID2D1Factory,
) callconv(.winapi) HRESULT;

const ID2D1Factory = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *ID2D1Factory,
            *const GUID,
            *?*anyopaque,
        ) callconv(.winapi) HRESULT,
        AddRef: *const fn (*ID2D1Factory) callconv(.winapi) ULONG,
        Release: *const fn (*ID2D1Factory) callconv(.winapi) ULONG,

        ReloadSystemMetrics: *const fn (*ID2D1Factory) callconv(.winapi) HRESULT,
        GetDesktopDpi: *const fn (*ID2D1Factory, *FLOAT, *FLOAT) callconv(.winapi) void,
        CreateRectangleGeometry: *const fn (
            *ID2D1Factory,
            *const D2D1_RECT_F,
            **ID2D1RectangleGeometry,
        ) callconv(.winapi) HRESULT,
        CreateRoundedRectangleGeometry: *const fn (
            *ID2D1Factory,
            *const D2D1_ROUNDED_RECT,
            **ID2D1RoundedRectangleGeometry,
        ) callconv(.winapi) HRESULT,
        CreateEllipseGeometry: *const fn (
            *ID2D1Factory,
            *const D2D1_ELLIPSE,
            **ID2D1EllipseGeometry,
        ) callconv(.winapi) HRESULT,
        CreateGeometryGroup: *const fn (
            *ID2D1Factory,
            D2D1_FILL_MODE,
            [*]*ID2D1Geometry,
            UINT32,
            **ID2D1GeometryGroup,
        ) callconv(.winapi) HRESULT,
        CreateTransformedGeometry: *const fn (
            *ID2D1Factory,
            *ID2D1Geometry,
            *const D2D1_MATRIX_3X2_F,
            **ID2D1TransformedGeometry,
        ) callconv(.winapi) HRESULT,
        CreatePathGeometry: *const fn (
            *ID2D1Factory,
            **ID2D1PathGeometry,
        ) callconv(.winapi) HRESULT,
        CreateStrokeStyle: *const fn (
            *ID2D1Factory,
            *const D2D1_STROKE_STYLE_PROPERTIES,
            ?[*]const FLOAT,
            UINT32,
            **ID2D1StrokeStyle,
        ) callconv(.winapi) HRESULT,
        CreateDrawingStateBlock: *const fn (
            ?*const D2D1_DRAWING_STATE_DESCRIPTION,
            ?*IDWriteRenderingParams,
            **ID2D1DrawingStateBlock,
        ) callconv(.winapi) HRESULT,
    };

    pub fn Release(self: *ID2D1Factory) ULONG {
        return self.v.Release(self);
    }
};

const ID2D1Resource = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *ID2D1Resource,
            *const GUID,
            *?*anyopaque,
        ) callconv(.winapi) HRESULT,
        AddRef: *const fn (*ID2D1Resource) callconv(.winapi) ULONG,
        Release: *const fn (*ID2D1Resource) callconv(.winapi) ULONG,

        GetFactory: *const fn (*ID2D1Resource, **ID2D1Factory) callconv(.winapi) void,
    };

    pub fn Release(self: *ID2D1Resource) ULONG {
        return self.v.Release(self);
    }

    pub fn GetFactory(self: *ID2D1Resource, factory: **ID2D1Factory) void {
        return self.v.GetFactory(self, factory);
    }
};

const ID2D1DrawingStateBlock = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *ID2D1DrawingStateBlock,
            *const GUID,
            *?*anyopaque,
        ) callconv(.winapi) HRESULT,
        AddRef: *const fn (*ID2D1DrawingStateBlock) callconv(.winapi) ULONG,
        Release: *const fn (*ID2D1DrawingStateBlock) callconv(.winapi) ULONG,

        GetFactory: *const fn (*ID2D1DrawingStateBlock, **ID2D1Factory) callconv(.winapi) void,

        GetDescription: *const fn (
            *ID2D1DrawingStateBlock,
            *D2D1_DRAWING_STATE_DESCRIPTION,
        ) callconv(.winapi) void,
        SetDescription: *const fn (
            *ID2D1DrawingStateBlock,
            *D2D1_DRAWING_STATE_DESCRIPTION,
        ) callconv(.winapi) void,
        SetTextRenderingParams: *const fn (
            *ID2D1DrawingStateBlock,
            ?*IDWriteRenderingParams,
        ) callconv(.winapi) void,
        GetTextRenderingParams: *const fn (
            *ID2D1DrawingStateBlock,
            *?*IDWriteRenderingParams,
        ) callconv(.winapi) void,
    };

    pub fn Release(self: *ID2D1DrawingStateBlock) ULONG {
        return self.v.Release(self);
    }

    pub fn GetFactory(self: *ID2D1DrawingStateBlock, factory: **ID2D1Factory) void {
        return self.v.GetFactory(self, factory);
    }
};

const ID2D1StrokeStyle = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *ID2D1StrokeStyle,
            *const GUID,
            *?*anyopaque,
        ) callconv(.winapi) HRESULT,
        AddRef: *const fn (*ID2D1StrokeStyle) callconv(.winapi) ULONG,
        Release: *const fn (*ID2D1StrokeStyle) callconv(.winapi) ULONG,

        GetFactory: *const fn (*ID2D1StrokeStyle, **ID2D1Factory) callconv(.winapi) void,

        GetStartCap: *const fn (*ID2D1StrokeStyle) callconv(.winapi) D2D1_CAP_STYLE,
        GetEndCap: *const fn (*ID2D1StrokeStyle) callconv(.winapi) D2D1_CAP_STYLE,
        GetDashCap: *const fn (*ID2D1StrokeStyle) callconv(.winapi) D2D1_CAP_STYLE,
        GetMiterLimit: *const fn (*ID2D1StrokeStyle) callconv(.winapi) FLOAT,
        GetLineJoin: *const fn (*ID2D1StrokeStyle) callconv(.winapi) D2D1_LINE_JOIN,
        GetDashOffset: *const fn (*ID2D1StrokeStyle) callconv(.winapi) FLOAT,
        GetDashStyle: *const fn (*ID2D1StrokeStyle) callconv(.winapi) D2D1_DASH_STYLE,
        GetDashesCount: *const fn (*ID2D1StrokeStyle) callconv(.winapi) UINT32,
        GetDashes: *const fn (*ID2D1StrokeStyle, *FLOAT, UINT32) callconv(.winapi) void,
    };

    pub fn Release(self: *ID2D1StrokeStyle) ULONG {
        return self.v.Release(self);
    }
};

const ID2D1Geometry = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *ID2D1Geometry,
            *const GUID,
            *?*anyopaque,
        ) callconv(.winapi) HRESULT,
        AddRef: *const fn (*ID2D1Geometry) callconv(.winapi) ULONG,
        Release: *const fn (*ID2D1Geometry) callconv(.winapi) ULONG,

        GetFactory: *const fn (*ID2D1Geometry, **ID2D1Factory) callconv(.winapi) void,

        GetBounds: *const fn (
            *ID2D1Geometry,
            ?*const D2D1_MATRIX_3X2_F,
            *D2D1_RECT_F,
        ) callconv(.winapi) HRESULT,
        GetWidenedBounds: *const fn (
            *ID2D1Geometry,
            FLOAT,
            ?*ID2D1StrokeStyle,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *D2D1_RECT_F,
        ) callconv(.winapi) HRESULT,
        StrokeContainsPoint: *const fn (
            *ID2D1Geometry,
            D2D1_POINT_2F,
            FLOAT,
            ?*ID2D1StrokeStyle,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *BOOL,
        ) callconv(.winapi) HRESULT,
        FillContainsPoint: *const fn (
            *ID2D1Geometry,
            D2D1_POINT_2F,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *BOOL,
        ) callconv(.winapi) HRESULT,
        CompareWithGeometry: *const fn (
            *ID2D1Geometry,
            *ID2D1Geometry,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *D2D1_GEOMETRY_RELATION,
        ) callconv(.winapi) HRESULT,
        Simplify: *const fn (
            *ID2D1Geometry,
            D2D1_GEOMETRY_SIMPLIFICATION_OPTION,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *ID2D1SimplifiedGeometrySink,
        ) callconv(.winapi) HRESULT,
        Tessellate: *const fn (
            *ID2D1Geometry,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *ID2D1TesselationSink,
        ) callconv(.winapi) HRESULT,
        CombineWithGeometry: *const fn (
            *ID2D1Geometry,
            *ID2D1Geometry,
            D2D1_COMBINE_MODE,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *ID2D1SimplifiedGeometrySink,
        ) callconv(.winapi) HRESULT,
        Outline: *const fn (
            *ID2D1Geometry,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *ID2D1SimplifiedGeometrySink,
        ) callconv(.winapi) HRESULT,
        ComputeArea: *const fn (
            *ID2D1Geometry,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *FLOAT,
        ) callconv(.winapi) HRESULT,
        ComputeLength: *const fn (
            *ID2D1Geometry,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *FLOAT,
        ) callconv(.winapi) HRESULT,
        ComputePointAtLength: *const fn (
            *ID2D1Geometry,
            FLOAT,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            ?*D2D1_POINT_2F,
            ?*D2D1_POINT_2F,
        ) callconv(.winapi) HRESULT,
        Widen: *const fn (
            *ID2D1Geometry,
            FLOAT,
            ?*ID2D1StrokeStyle,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *ID2D1SimplifiedGeometrySink,
        ) callconv(.winapi) HRESULT,
    };
};

const ID2D1SimplifiedGeometrySink = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *ID2D1SimplifiedGeometrySink,
            *const GUID,
            *?*anyopaque,
        ) callconv(.winapi) HRESULT,
        AddRef: *const fn (*ID2D1SimplifiedGeometrySink) callconv(.winapi) ULONG,
        Release: *const fn (*ID2D1SimplifiedGeometrySink) callconv(.winapi) ULONG,

        SetFillMode: *const fn (
            *ID2D1SimplifiedGeometrySink,
            D2D1_FILL_MODE,
        ) callconv(.winapi) void,
        SetSegmentFlags: *const fn (
            *ID2D1SimplifiedGeometrySink,
            D2D1_PATH_SEGMENT,
        ) callconv(.winapi) void,
        BeginFigure: *const fn (
            *ID2D1SimplifiedGeometrySink,
            D2D1_POINT_2F,
            D2D1_FIGURE_BEGIN,
        ) callconv(.winapi) void,
        AddLines: *const fn (
            *ID2D1SimplifiedGeometrySink,
            [*]const D2D1_POINT_2F,
            UINT32,
        ) callconv(.winapi) void,
        AddBeziers: *const fn (
            *ID2D1SimplifiedGeometrySink,
            [*]const D2D1_BEZIER_SEGMENT,
            UINT32,
        ) callconv(.winapi) void,
        EndFigure: *const fn (
            *ID2D1SimplifiedGeometrySink,
            D2D1_FIGURE_END,
        ) callconv(.winapi) void,
        Close: *const fn (*ID2D1SimplifiedGeometrySink) callconv(.winapi) HRESULT,
    };
};

const ID2D1GeometrySink = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *ID2D1GeometrySink,
            *const GUID,
            *?*anyopaque,
        ) callconv(.winapi) HRESULT,
        AddRef: *const fn (*ID2D1GeometrySink) callconv(.winapi) ULONG,
        Release: *const fn (*ID2D1GeometrySink) callconv(.winapi) ULONG,

        SetFillMode: *const fn (
            *ID2D1GeometrySink,
            D2D1_FILL_MODE,
        ) callconv(.winapi) void,
        SetSegmentFlags: *const fn (
            *ID2D1GeometrySink,
            D2D1_PATH_SEGMENT,
        ) callconv(.winapi) void,
        BeginFigure: *const fn (
            *ID2D1GeometrySink,
            D2D1_POINT_2F,
            D2D1_FIGURE_BEGIN,
        ) callconv(.winapi) void,
        AddLines: *const fn (
            *ID2D1GeometrySink,
            [*]const D2D1_POINT_2F,
            UINT32,
        ) callconv(.winapi) void,
        AddBeziers: *const fn (
            *ID2D1GeometrySink,
            [*]const D2D1_BEZIER_SEGMENT,
            UINT32,
        ) callconv(.winapi) void,
        EndFigure: *const fn (
            *ID2D1GeometrySink,
            D2D1_FIGURE_END,
        ) callconv(.winapi) void,
        Close: *const fn (*ID2D1GeometrySink) callconv(.winapi) HRESULT,
        AddLine: *const fn (*ID2D1GeometrySink, D2D1_POINT_2F) callconv(.winapi) void,
        AddBezier: *const fn (
            *ID2D1GeometrySink,
            *const D2D1_BEZIER_SEGMENT,
        ) callconv(.winapi) void,
        AddQuadraticBezier: *const fn (
            *ID2D1GeometrySink,
            *const D2D1_QUADRATIC_BEZIER_SEGMENT,
        ) callconv(.winapi) void,
        AddQuadraticBeziers: *const fn (
            *ID2D1GeometrySink,
            [*]const D2D1_QUADRATIC_BEZIER_SEGMENT,
        ) callconv(.winapi) void,
        AddArc: *const fn (
            *ID2D1GeometrySink,
            *const D2D1_ARC_SEGMENT,
        ) callconv(.winapi) void,
    };
};

const ID2D1TesselationSink = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *ID2D1TesselationSink,
            *const GUID,
            *?*anyopaque,
        ) callconv(.winapi) HRESULT,
        AddRef: *const fn (*ID2D1TesselationSink) callconv(.winapi) ULONG,
        Release: *const fn (*ID2D1TesselationSink) callconv(.winapi) ULONG,

        AddTriangles: *const fn (
            *ID2D1TesselationSink,
            [*]const D2D1_TRIANGLE,
            UINT32,
        ) callconv(.winapi) void,
        Close: *const fn (*ID2D1TesselationSink) callconv(.winapi) HRESULT,
    };
};

const ID2D1RectangleGeometry = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *ID2D1RectangleGeometry,
            *const GUID,
            *?*anyopaque,
        ) callconv(.winapi) HRESULT,
        AddRef: *const fn (*ID2D1RectangleGeometry) callconv(.winapi) ULONG,
        Release: *const fn (*ID2D1RectangleGeometry) callconv(.winapi) ULONG,

        GetFactory: *const fn (*ID2D1RectangleGeometry, **ID2D1Factory) callconv(.winapi) void,

        GetBounds: *const fn (
            *ID2D1RectangleGeometry,
            ?*const D2D1_MATRIX_3X2_F,
            *D2D1_RECT_F,
        ) callconv(.winapi) HRESULT,
        GetWidenedBounds: *const fn (
            *ID2D1RectangleGeometry,
            FLOAT,
            ?*ID2D1StrokeStyle,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *D2D1_RECT_F,
        ) callconv(.winapi) HRESULT,
        StrokeContainsPoint: *const fn (
            *ID2D1RectangleGeometry,
            D2D1_POINT_2F,
            FLOAT,
            ?*ID2D1StrokeStyle,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *BOOL,
        ) callconv(.winapi) HRESULT,
        FillContainsPoint: *const fn (
            *ID2D1RectangleGeometry,
            D2D1_POINT_2F,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *BOOL,
        ) callconv(.winapi) HRESULT,
        CompareWithGeometry: *const fn (
            *ID2D1RectangleGeometry,
            *ID2D1Geometry,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *D2D1_GEOMETRY_RELATION,
        ) callconv(.winapi) HRESULT,
        Simplify: *const fn (
            *ID2D1RectangleGeometry,
            D2D1_GEOMETRY_SIMPLIFICATION_OPTION,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *ID2D1SimplifiedGeometrySink,
        ) callconv(.winapi) HRESULT,
        Tessellate: *const fn (
            *ID2D1RectangleGeometry,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *ID2D1TesselationSink,
        ) callconv(.winapi) HRESULT,
        CombineWithGeometry: *const fn (
            *ID2D1RectangleGeometry,
            *ID2D1Geometry,
            D2D1_COMBINE_MODE,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *ID2D1SimplifiedGeometrySink,
        ) callconv(.winapi) HRESULT,
        Outline: *const fn (
            *ID2D1RectangleGeometry,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *ID2D1SimplifiedGeometrySink,
        ) callconv(.winapi) HRESULT,
        ComputeArea: *const fn (
            *ID2D1RectangleGeometry,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *FLOAT,
        ) callconv(.winapi) HRESULT,
        ComputeLength: *const fn (
            *ID2D1RectangleGeometry,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *FLOAT,
        ) callconv(.winapi) HRESULT,
        ComputePointAtLength: *const fn (
            *ID2D1RectangleGeometry,
            FLOAT,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            ?*D2D1_POINT_2F,
            ?*D2D1_POINT_2F,
        ) callconv(.winapi) HRESULT,
        Widen: *const fn (
            *ID2D1RectangleGeometry,
            FLOAT,
            ?*ID2D1StrokeStyle,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *ID2D1SimplifiedGeometrySink,
        ) callconv(.winapi) HRESULT,
        GetRect: *const fn (*ID2D1RectangleGeometry, *D2D1_RECT_F) callconv(.winapi) void,
    };
};

const ID2D1RoundedRectangleGeometry = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *ID2D1RoundedRectangleGeometry,
            *const GUID,
            *?*anyopaque,
        ) callconv(.winapi) HRESULT,
        AddRef: *const fn (*ID2D1RoundedRectangleGeometry) callconv(.winapi) ULONG,
        Release: *const fn (*ID2D1RoundedRectangleGeometry) callconv(.winapi) ULONG,

        GetFactory: *const fn (
            *ID2D1RoundedRectangleGeometry,
            **ID2D1Factory,
        ) callconv(.winapi) void,

        GetBounds: *const fn (
            *ID2D1RoundedRectangleGeometry,
            ?*const D2D1_MATRIX_3X2_F,
            *D2D1_RECT_F,
        ) callconv(.winapi) HRESULT,
        GetWidenedBounds: *const fn (
            *ID2D1RoundedRectangleGeometry,
            FLOAT,
            ?*ID2D1StrokeStyle,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *D2D1_RECT_F,
        ) callconv(.winapi) HRESULT,
        StrokeContainsPoint: *const fn (
            *ID2D1RoundedRectangleGeometry,
            D2D1_POINT_2F,
            FLOAT,
            ?*ID2D1StrokeStyle,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *BOOL,
        ) callconv(.winapi) HRESULT,
        FillContainsPoint: *const fn (
            *ID2D1RoundedRectangleGeometry,
            D2D1_POINT_2F,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *BOOL,
        ) callconv(.winapi) HRESULT,
        CompareWithGeometry: *const fn (
            *ID2D1RoundedRectangleGeometry,
            *ID2D1Geometry,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *D2D1_GEOMETRY_RELATION,
        ) callconv(.winapi) HRESULT,
        Simplify: *const fn (
            *ID2D1RoundedRectangleGeometry,
            D2D1_GEOMETRY_SIMPLIFICATION_OPTION,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *ID2D1SimplifiedGeometrySink,
        ) callconv(.winapi) HRESULT,
        Tessellate: *const fn (
            *ID2D1RoundedRectangleGeometry,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *ID2D1TesselationSink,
        ) callconv(.winapi) HRESULT,
        CombineWithGeometry: *const fn (
            *ID2D1RoundedRectangleGeometry,
            *ID2D1Geometry,
            D2D1_COMBINE_MODE,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *ID2D1SimplifiedGeometrySink,
        ) callconv(.winapi) HRESULT,
        Outline: *const fn (
            *ID2D1RoundedRectangleGeometry,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *ID2D1SimplifiedGeometrySink,
        ) callconv(.winapi) HRESULT,
        ComputeArea: *const fn (
            *ID2D1RoundedRectangleGeometry,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *FLOAT,
        ) callconv(.winapi) HRESULT,
        ComputeLength: *const fn (
            *ID2D1RoundedRectangleGeometry,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *FLOAT,
        ) callconv(.winapi) HRESULT,
        ComputePointAtLength: *const fn (
            *ID2D1RoundedRectangleGeometry,
            FLOAT,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            ?*D2D1_POINT_2F,
            ?*D2D1_POINT_2F,
        ) callconv(.winapi) HRESULT,
        Widen: *const fn (
            *ID2D1RoundedRectangleGeometry,
            FLOAT,
            ?*ID2D1StrokeStyle,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *ID2D1SimplifiedGeometrySink,
        ) callconv(.winapi) HRESULT,
        GetRoundedRect: *const fn (
            *ID2D1RoundedRectangleGeometry,
            *D2D1_ROUNDED_RECT,
        ) callconv(.winapi) void,
    };
};

const ID2D1EllipseGeometry = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *ID2D1EllipseGeometry,
            *const GUID,
            *?*anyopaque,
        ) callconv(.winapi) HRESULT,
        AddRef: *const fn (*ID2D1EllipseGeometry) callconv(.winapi) ULONG,
        Release: *const fn (*ID2D1EllipseGeometry) callconv(.winapi) ULONG,

        GetFactory: *const fn (
            *ID2D1EllipseGeometry,
            **ID2D1Factory,
        ) callconv(.winapi) void,

        GetBounds: *const fn (
            *ID2D1EllipseGeometry,
            ?*const D2D1_MATRIX_3X2_F,
            *D2D1_RECT_F,
        ) callconv(.winapi) HRESULT,
        GetWidenedBounds: *const fn (
            *ID2D1EllipseGeometry,
            FLOAT,
            ?*ID2D1StrokeStyle,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *D2D1_RECT_F,
        ) callconv(.winapi) HRESULT,
        StrokeContainsPoint: *const fn (
            *ID2D1EllipseGeometry,
            D2D1_POINT_2F,
            FLOAT,
            ?*ID2D1StrokeStyle,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *BOOL,
        ) callconv(.winapi) HRESULT,
        FillContainsPoint: *const fn (
            *ID2D1EllipseGeometry,
            D2D1_POINT_2F,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *BOOL,
        ) callconv(.winapi) HRESULT,
        CompareWithGeometry: *const fn (
            *ID2D1EllipseGeometry,
            *ID2D1Geometry,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *D2D1_GEOMETRY_RELATION,
        ) callconv(.winapi) HRESULT,
        Simplify: *const fn (
            *ID2D1EllipseGeometry,
            D2D1_GEOMETRY_SIMPLIFICATION_OPTION,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *ID2D1SimplifiedGeometrySink,
        ) callconv(.winapi) HRESULT,
        Tessellate: *const fn (
            *ID2D1EllipseGeometry,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *ID2D1TesselationSink,
        ) callconv(.winapi) HRESULT,
        CombineWithGeometry: *const fn (
            *ID2D1EllipseGeometry,
            *ID2D1Geometry,
            D2D1_COMBINE_MODE,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *ID2D1SimplifiedGeometrySink,
        ) callconv(.winapi) HRESULT,
        Outline: *const fn (
            *ID2D1EllipseGeometry,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *ID2D1SimplifiedGeometrySink,
        ) callconv(.winapi) HRESULT,
        ComputeArea: *const fn (
            *ID2D1EllipseGeometry,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *FLOAT,
        ) callconv(.winapi) HRESULT,
        ComputeLength: *const fn (
            *ID2D1EllipseGeometry,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *FLOAT,
        ) callconv(.winapi) HRESULT,
        ComputePointAtLength: *const fn (
            *ID2D1EllipseGeometry,
            FLOAT,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            ?*D2D1_POINT_2F,
            ?*D2D1_POINT_2F,
        ) callconv(.winapi) HRESULT,
        Widen: *const fn (
            *ID2D1EllipseGeometry,
            FLOAT,
            ?*ID2D1StrokeStyle,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *ID2D1SimplifiedGeometrySink,
        ) callconv(.winapi) HRESULT,
        GetEllipse: *const fn (
            *ID2D1EllipseGeometry,
            *D2D1_ELLIPSE,
        ) callconv(.winapi) void,
    };
};

const ID2D1GeometryGroup = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *ID2D1GeometryGroup,
            *const GUID,
            *?*anyopaque,
        ) callconv(.winapi) HRESULT,
        AddRef: *const fn (*ID2D1GeometryGroup) callconv(.winapi) ULONG,
        Release: *const fn (*ID2D1GeometryGroup) callconv(.winapi) ULONG,

        GetFactory: *const fn (
            *ID2D1GeometryGroup,
            **ID2D1Factory,
        ) callconv(.winapi) void,

        GetBounds: *const fn (
            *ID2D1GeometryGroup,
            ?*const D2D1_MATRIX_3X2_F,
            *D2D1_RECT_F,
        ) callconv(.winapi) HRESULT,
        GetWidenedBounds: *const fn (
            *ID2D1GeometryGroup,
            FLOAT,
            ?*ID2D1StrokeStyle,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *D2D1_RECT_F,
        ) callconv(.winapi) HRESULT,
        StrokeContainsPoint: *const fn (
            *ID2D1GeometryGroup,
            D2D1_POINT_2F,
            FLOAT,
            ?*ID2D1StrokeStyle,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *BOOL,
        ) callconv(.winapi) HRESULT,
        FillContainsPoint: *const fn (
            *ID2D1GeometryGroup,
            D2D1_POINT_2F,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *BOOL,
        ) callconv(.winapi) HRESULT,
        CompareWithGeometry: *const fn (
            *ID2D1GeometryGroup,
            *ID2D1Geometry,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *D2D1_GEOMETRY_RELATION,
        ) callconv(.winapi) HRESULT,
        Simplify: *const fn (
            *ID2D1GeometryGroup,
            D2D1_GEOMETRY_SIMPLIFICATION_OPTION,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *ID2D1SimplifiedGeometrySink,
        ) callconv(.winapi) HRESULT,
        Tessellate: *const fn (
            *ID2D1GeometryGroup,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *ID2D1TesselationSink,
        ) callconv(.winapi) HRESULT,
        CombineWithGeometry: *const fn (
            *ID2D1GeometryGroup,
            *ID2D1Geometry,
            D2D1_COMBINE_MODE,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *ID2D1SimplifiedGeometrySink,
        ) callconv(.winapi) HRESULT,
        Outline: *const fn (
            *ID2D1GeometryGroup,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *ID2D1SimplifiedGeometrySink,
        ) callconv(.winapi) HRESULT,
        ComputeArea: *const fn (
            *ID2D1GeometryGroup,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *FLOAT,
        ) callconv(.winapi) HRESULT,
        ComputeLength: *const fn (
            *ID2D1GeometryGroup,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *FLOAT,
        ) callconv(.winapi) HRESULT,
        ComputePointAtLength: *const fn (
            *ID2D1GeometryGroup,
            FLOAT,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            ?*D2D1_POINT_2F,
            ?*D2D1_POINT_2F,
        ) callconv(.winapi) HRESULT,
        Widen: *const fn (
            *ID2D1GeometryGroup,
            FLOAT,
            ?*ID2D1StrokeStyle,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *ID2D1SimplifiedGeometrySink,
        ) callconv(.winapi) HRESULT,
        GetFillMode: *const fn (*ID2D1GeometryGroup) callconv(.winapi) D2D1_FILL_MODE,
        GetSourceGeometryCount: *const fn (*ID2D1GeometryGroup) callconv(.winapi) UINT32,
        GetSourceGeometries: *const fn (
            *ID2D1GeometryGroup,
            [*]*ID2D1Geometry,
            UINT32,
        ) callconv(.winapi) void,
    };
};

const ID2D1TransformedGeometry = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *ID2D1TransformedGeometry,
            *const GUID,
            *?*anyopaque,
        ) callconv(.winapi) HRESULT,
        AddRef: *const fn (*ID2D1TransformedGeometry) callconv(.winapi) ULONG,
        Release: *const fn (*ID2D1TransformedGeometry) callconv(.winapi) ULONG,

        GetFactory: *const fn (
            *ID2D1TransformedGeometry,
            **ID2D1Factory,
        ) callconv(.winapi) void,

        GetBounds: *const fn (
            *ID2D1TransformedGeometry,
            ?*const D2D1_MATRIX_3X2_F,
            *D2D1_RECT_F,
        ) callconv(.winapi) HRESULT,
        GetWidenedBounds: *const fn (
            *ID2D1TransformedGeometry,
            FLOAT,
            ?*ID2D1StrokeStyle,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *D2D1_RECT_F,
        ) callconv(.winapi) HRESULT,
        StrokeContainsPoint: *const fn (
            *ID2D1TransformedGeometry,
            D2D1_POINT_2F,
            FLOAT,
            ?*ID2D1StrokeStyle,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *BOOL,
        ) callconv(.winapi) HRESULT,
        FillContainsPoint: *const fn (
            *ID2D1TransformedGeometry,
            D2D1_POINT_2F,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *BOOL,
        ) callconv(.winapi) HRESULT,
        CompareWithGeometry: *const fn (
            *ID2D1TransformedGeometry,
            *ID2D1Geometry,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *D2D1_GEOMETRY_RELATION,
        ) callconv(.winapi) HRESULT,
        Simplify: *const fn (
            *ID2D1TransformedGeometry,
            D2D1_GEOMETRY_SIMPLIFICATION_OPTION,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *ID2D1SimplifiedGeometrySink,
        ) callconv(.winapi) HRESULT,
        Tessellate: *const fn (
            *ID2D1TransformedGeometry,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *ID2D1TesselationSink,
        ) callconv(.winapi) HRESULT,
        CombineWithGeometry: *const fn (
            *ID2D1TransformedGeometry,
            *ID2D1Geometry,
            D2D1_COMBINE_MODE,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *ID2D1SimplifiedGeometrySink,
        ) callconv(.winapi) HRESULT,
        Outline: *const fn (
            *ID2D1TransformedGeometry,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *ID2D1SimplifiedGeometrySink,
        ) callconv(.winapi) HRESULT,
        ComputeArea: *const fn (
            *ID2D1TransformedGeometry,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *FLOAT,
        ) callconv(.winapi) HRESULT,
        ComputeLength: *const fn (
            *ID2D1TransformedGeometry,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *FLOAT,
        ) callconv(.winapi) HRESULT,
        ComputePointAtLength: *const fn (
            *ID2D1TransformedGeometry,
            FLOAT,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            ?*D2D1_POINT_2F,
            ?*D2D1_POINT_2F,
        ) callconv(.winapi) HRESULT,
        Widen: *const fn (
            *ID2D1TransformedGeometry,
            FLOAT,
            ?*ID2D1StrokeStyle,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *ID2D1SimplifiedGeometrySink,
        ) callconv(.winapi) HRESULT,
        GetSourceGeometry: *const fn (
            *ID2D1TransformedGeometry,
            **ID2D1Geometry,
        ) callconv(.winapi) void,
        GetTransform: *const fn (
            *ID2D1TransformedGeometry,
            *D2D1_MATRIX_3X2_F,
        ) callconv(.winapi) void,
    };
};

const ID2D1PathGeometry = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *ID2D1PathGeometry,
            *const GUID,
            *?*anyopaque,
        ) callconv(.winapi) HRESULT,
        AddRef: *const fn (*ID2D1PathGeometry) callconv(.winapi) ULONG,
        Release: *const fn (*ID2D1PathGeometry) callconv(.winapi) ULONG,

        GetFactory: *const fn (
            *ID2D1PathGeometry,
            **ID2D1Factory,
        ) callconv(.winapi) void,

        GetBounds: *const fn (
            *ID2D1PathGeometry,
            ?*const D2D1_MATRIX_3X2_F,
            *D2D1_RECT_F,
        ) callconv(.winapi) HRESULT,
        GetWidenedBounds: *const fn (
            *ID2D1PathGeometry,
            FLOAT,
            ?*ID2D1StrokeStyle,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *D2D1_RECT_F,
        ) callconv(.winapi) HRESULT,
        StrokeContainsPoint: *const fn (
            *ID2D1PathGeometry,
            D2D1_POINT_2F,
            FLOAT,
            ?*ID2D1StrokeStyle,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *BOOL,
        ) callconv(.winapi) HRESULT,
        FillContainsPoint: *const fn (
            *ID2D1PathGeometry,
            D2D1_POINT_2F,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *BOOL,
        ) callconv(.winapi) HRESULT,
        CompareWithGeometry: *const fn (
            *ID2D1PathGeometry,
            *ID2D1Geometry,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *D2D1_GEOMETRY_RELATION,
        ) callconv(.winapi) HRESULT,
        Simplify: *const fn (
            *ID2D1PathGeometry,
            D2D1_GEOMETRY_SIMPLIFICATION_OPTION,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *ID2D1SimplifiedGeometrySink,
        ) callconv(.winapi) HRESULT,
        Tessellate: *const fn (
            *ID2D1PathGeometry,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *ID2D1TesselationSink,
        ) callconv(.winapi) HRESULT,
        CombineWithGeometry: *const fn (
            *ID2D1PathGeometry,
            *ID2D1Geometry,
            D2D1_COMBINE_MODE,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *ID2D1SimplifiedGeometrySink,
        ) callconv(.winapi) HRESULT,
        Outline: *const fn (
            *ID2D1PathGeometry,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *ID2D1SimplifiedGeometrySink,
        ) callconv(.winapi) HRESULT,
        ComputeArea: *const fn (
            *ID2D1PathGeometry,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *FLOAT,
        ) callconv(.winapi) HRESULT,
        ComputeLength: *const fn (
            *ID2D1PathGeometry,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *FLOAT,
        ) callconv(.winapi) HRESULT,
        ComputePointAtLength: *const fn (
            *ID2D1PathGeometry,
            FLOAT,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            ?*D2D1_POINT_2F,
            ?*D2D1_POINT_2F,
        ) callconv(.winapi) HRESULT,
        Widen: *const fn (
            *ID2D1PathGeometry,
            FLOAT,
            ?*ID2D1StrokeStyle,
            ?*const D2D1_MATRIX_3X2_F,
            FLOAT,
            *ID2D1SimplifiedGeometrySink,
        ) callconv(.winapi) HRESULT,
        Open: *const fn (
            *ID2D1PathGeometry,
            **ID2D1GeometrySink,
        ) callconv(.winapi) HRESULT,
        Stream: *const fn (
            *ID2D1PathGeometry,
            *ID2D1GeometrySink,
        ) callconv(.winapi) HRESULT,
        GetSegmentCount: *const fn (
            *ID2D1PathGeometry,
            *UINT32,
        ) callconv(.winapi) HRESULT,
        GetFigureCount: *const fn (
            *ID2D1PathGeometry,
            *UINT32,
        ) callconv(.winapi) HRESULT,
    };
};

const IDWriteRenderingParams = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *IDWriteRenderingParams,
            *const GUID,
            *?*anyopaque,
        ) callconv(.winapi) HRESULT,
        AddRef: *const fn (*IDWriteRenderingParams) callconv(.winapi) ULONG,
        Release: *const fn (*IDWriteRenderingParams) callconv(.winapi) ULONG,

        GetGamma: *const fn (*IDWriteRenderingParams) callconv(.winapi) FLOAT,
        GetEnhancedContrast: *const fn (*IDWriteRenderingParams) callconv(.winapi) FLOAT,
        GetClearTypeLevel: *const fn (*IDWriteRenderingParams) callconv(.winapi) FLOAT,
        GetPixelGeometry: *const fn (
            *IDWriteRenderingParams,
        ) callconv(.winapi) DWRITE_PIXEL_GEOMETRY,
        GetRenderingMode: *const fn (
            *IDWriteRenderingParams,
        ) callconv(.winapi) DWRITE_RENDERING_MODE,
    };

    pub fn Release(self: *IDWriteRenderingParams) ULONG {
        return self.v.Release(self);
    }
};
