const std = @import("std");
const windows = std.os.windows;

const FLOAT = windows.FLOAT;
const GUID = windows.GUID;
const HRESULT = windows.HRESULT;
const ULONG = windows.ULONG;
const BOOL = windows.BOOL;
const UINT32 = u32;
const UINT16 = u16;
const UINT64 = u64;
const INT16 = i16;
const INT32 = i32;
const D2D1_TAG = u64;
const UINT = windows.UINT;
const INT = windows.INT;
const WICColor = UINT32;
const double = f64;
const WICPixelFormatGUID = GUID;
const BYTE = windows.BYTE;
const DWORD = windows.DWORD;
const WICInProcPointer = [*]BYTE;
const HWND = windows.HWND;
const REFIID = *const GUID;
const WCHAR = windows.WCHAR;

const D2D1_RECT_F = extern struct {
    left: FLOAT,
    top: FLOAT,
    right: FLOAT,
    bottom: FLOAT,
};

const D2D1_RECT_U = extern struct {
    left: UINT32,
    top: UINT32,
    right: UINT32,
    bottom: UINT32,
};

const D2D1_ROUNDED_RECT = extern struct {
    rect: D2D1_RECT_F,
    radiusX: FLOAT,
    radiusY: FLOAT,
};

const D2D1_POINT_2F = extern struct { x: FLOAT, y: FLOAT };

const D2D1_POINT_2U = extern struct { x: UINT32, y: UINT32 };

const D2D1_MATRIX_3X2_F = extern union {
    DUMMYSTRUCTNAME: extern struct {
        m11: FLOAT,
        m12: FLOAT,
        m21: FLOAT,
        m22: FLOAT,
        dx: FLOAT,
        dy: FLOAT,
    },
    DUMMYSTRUCTNAME2: extern struct {
        _11: FLOAT,
        _12: FLOAT,
        _21: FLOAT,
        _22: FLOAT,
        _31: FLOAT,
        _32: FLOAT,
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
    width: FLOAT,
    height: FLOAT,
};

const D2D1_SIZE_U = extern struct {
    width: UINT32,
    height: UINT32,
};

const D2D1_ARC_SEGMENT = extern struct {
    point: D2D1_POINT_2F,
    size: D2D1_SIZE_F,
    rotationAngle: FLOAT,
    sweepDirection: D2D1_SWEEP_DIRECTION,
    arcSize: D2D1_ARC_SIZE,
};

const D2D1_ELLIPSE = extern struct {
    point: D2D1_POINT_2F,
    radiusX: FLOAT,
    radiusY: FLOAT,
};

const D2D1_STROKE_STYLE_PROPERTIES = extern struct {
    startCap: D2D1_CAP_STYLE,
    endCap: D2D1_CAP_STYLE,
    dashCap: D2D1_CAP_STYLE,
    lineJoin: D2D1_LINE_JOIN,
    miterLimit: FLOAT,
    dashStyle: D2D1_DASH_STYLE,
    dashOffset: FLOAT,
};

const D2D1_DRAWING_STATE_DESCRIPTION = extern struct {
    antialiasMode: D2D1_ANTIALIAS_MODE,
    textAntialiasMode: D2D1_TEXT_ANTIALIAS_MODE,
    tag1: D2D1_TAG,
    tag2: D2D1_TAG,
    transform: D2D1_MATRIX_3X2_F,
};

const D2D1_PIXEL_FORMAT = extern struct {
    format: DXGI_FORMAT,
    alphaMode: D2D1_ALPHA_MODE,
};

const D2D1_RENDER_TARGET_PROPERTIES = extern struct {
    type: D2D1_RENDER_TARGET_TYPE,
    pixelFormat: D2D1_PIXEL_FORMAT,
    dpiX: FLOAT,
    dpiY: FLOAT,
    usage: D2D1_RENDER_TARGET_USAGE,
    minLevel: D2D1_FEATURE_LEVEL,
};

const D2D1_HWND_RENDER_TARGET_PROPERTIES = extern struct {
    hwnd: HWND,
    pixelSize: D2D1_SIZE_U,
    presentOptions: D2D1_PRESENT_OPTIONS,
};

const D2D1_BITMAP_PROPERTIES = extern struct {
    pixelFormat: D2D1_PIXEL_FORMAT,
    dpiX: FLOAT,
    dpiY: FLOAT,
};

const WICRect = extern struct {
    X: INT,
    Y: INT,
    Width: INT,
    Height: INT,
};

const D2D1_BITMAP_BRUSH_PROPERTIES = extern struct {
    extendModeX: D2D1_EXTEND_MODE,
    extendModeY: D2D1_EXTEND_MODE,
    interpolationMode: D2D1_BITMAP_INTERPOLATION_MODE,
};

const D2D1_BRUSH_PROPERTIES = extern struct {
    opacity: FLOAT,
    transform: D2D1_MATRIX_3X2_F,
};

const D2D1_COLOR_F = extern struct {
    r: FLOAT,
    g: FLOAT,
    b: FLOAT,
    a: FLOAT,
};

const D2D1_GRADIENT_STOP = extern struct {
    position: FLOAT,
    color: D2D1_COLOR_F,
};

const D2D1_LINEAR_GRADIENT_BRUSH_PROPERTIES = extern struct {
    startPoint: D2D1_POINT_2F,
    endPoint: D2D1_POINT_2F,
};

const D2D1_RADIAL_GRADIENT_BRUSH_PROPERTIES = extern struct {
    center: D2D1_POINT_2F,
    gradientOriginOffset: D2D1_POINT_2F,
    radiusX: FLOAT,
    radiusY: FLOAT,
};

const DWRITE_TRIMMING = extern struct {
    granularity: DWRITE_TRIMMING_GRANULARITY,
    delimiter: UINT32,
    delimiterCount: UINT32,
};

const DWRITE_MATRIX = extern struct {
    m11: FLOAT,
    m12: FLOAT,
    m21: FLOAT,
    m22: FLOAT,
    dx: FLOAT,
    dy: FLOAT,
};

const DWRITE_FONT_METRICS = extern struct {
    designUnitsPerEm: UINT16,
    ascent: UINT16,
    descent: UINT16,
    lineGap: INT16,
    capHeight: UINT16,
    xHeight: UINT16,
    underlinePosition: INT16,
    underlineThickness: UINT16,
    strikethroughPosition: INT16,
    strikethroughThickness: UINT16,
};

const DWRITE_GLYPH_METRICS = extern struct {
    leftSideBearing: INT32,
    advanceWidth: UINT32,
    rightSideBearing: INT32,
    topSideBearing: INT32,
    advanceHeight: UINT32,
    bottomSideBearing: INT32,
    verticalOriginY: INT32,
};

const DWRITE_GLYPH_OFFSET = extern struct {
    advanceOffset: FLOAT,
    ascenderOffset: FLOAT,
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

const DWRITE_RENDERING_MODE = enum(c_int) {
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

const DWRITE_MEASURING_MODE = enum(c_int) {
    DWRITE_MEASURING_MODE_NATURAL,
    DWRITE_MEASURING_MODE_GDI_CLASSIC,
    DWRITE_MEASURING_MODE_GDI_NATURAL,
};

const DWRITE_TEXT_ALIGNMENT = enum(c_int) {
    DWRITE_TEXT_ALIGNMENT_LEADING,
    DWRITE_TEXT_ALIGNMENT_TRAILING,
    DWRITE_TEXT_ALIGNMENT_CENTER,
    DWRITE_TEXT_ALIGNMENT_JUSTIFIED,
};

const DWRITE_PARAGRAPH_ALIGNMENT = enum(c_int) {
    DWRITE_PARAGRAPH_ALIGNMENT_NEAR,
    DWRITE_PARAGRAPH_ALIGNMENT_FAR,
    DWRITE_PARAGRAPH_ALIGNMENT_CENTER,
};

const DWRITE_WORD_WRAPPING = enum(c_int) {
    DWRITE_WORD_WRAPPING_WRAP = 0,
    DWRITE_WORD_WRAPPING_NO_WRAP = 1,
    DWRITE_WORD_WRAPPING_EMERGENCY_BREAK = 2,
    DWRITE_WORD_WRAPPING_WHOLE_WORD = 3,
    DWRITE_WORD_WRAPPING_CHARACTER = 4,
};

const DWRITE_READING_DIRECTION = enum(c_int) {
    DWRITE_READING_DIRECTION_LEFT_TO_RIGHT = 0,
    DWRITE_READING_DIRECTION_RIGHT_TO_LEFT = 1,
    DWRITE_READING_DIRECTION_TOP_TO_BOTTOM = 2,
    DWRITE_READING_DIRECTION_BOTTOM_TO_TOP = 3,
};

const DWRITE_FLOW_DIRECTION = enum(c_int) {
    DWRITE_FLOW_DIRECTION_TOP_TO_BOTTOM = 0,
    DWRITE_FLOW_DIRECTION_BOTTOM_TO_TOP = 1,
    DWRITE_FLOW_DIRECTION_LEFT_TO_RIGHT = 2,
    DWRITE_FLOW_DIRECTION_RIGHT_TO_LEFT = 3,
};

const DWRITE_TRIMMING_GRANULARITY = enum(c_int) {
    DWRITE_TRIMMING_GRANULARITY_NONE,
    DWRITE_TRIMMING_GRANULARITY_CHARACTER,
    DWRITE_TRIMMING_GRANULARITY_WORD,
};

const DWRITE_LINE_SPACING_METHOD = enum(c_int) {
    DWRITE_LINE_SPACING_METHOD_DEFAULT,
    DWRITE_LINE_SPACING_METHOD_UNIFORM,
    DWRITE_LINE_SPACING_METHOD_PROPORTIONAL,
};

const DWRITE_FONT_WEIGHT = enum(c_int) {
    DWRITE_FONT_WEIGHT_THIN = 100,
    DWRITE_FONT_WEIGHT_EXTRA_LIGHT = 200,
    DWRITE_FONT_WEIGHT_ULTRA_LIGHT = 200,
    DWRITE_FONT_WEIGHT_LIGHT = 300,
    DWRITE_FONT_WEIGHT_SEMI_LIGHT = 350,
    DWRITE_FONT_WEIGHT_NORMAL = 400,
    DWRITE_FONT_WEIGHT_REGULAR = 400,
    DWRITE_FONT_WEIGHT_MEDIUM = 500,
    DWRITE_FONT_WEIGHT_DEMI_BOLD = 600,
    DWRITE_FONT_WEIGHT_SEMI_BOLD = 600,
    DWRITE_FONT_WEIGHT_BOLD = 700,
    DWRITE_FONT_WEIGHT_EXTRA_BOLD = 800,
    DWRITE_FONT_WEIGHT_ULTRA_BOLD = 800,
    DWRITE_FONT_WEIGHT_BLACK = 900,
    DWRITE_FONT_WEIGHT_HEAVY = 900,
    DWRITE_FONT_WEIGHT_EXTRA_BLACK = 950,
    DWRITE_FONT_WEIGHT_ULTRA_BLACK = 950,
};

const DWRITE_FONT_STYLE = enum(c_int) {
    DWRITE_FONT_STYLE_NORMAL,
    DWRITE_FONT_STYLE_OBLIQUE,
    DWRITE_FONT_STYLE_ITALIC,
};

const DWRITE_FONT_STRECTH = enum(c_int) {
    DWRITE_FONT_STRETCH_UNDEFINED = 0,
    DWRITE_FONT_STRETCH_ULTRA_CONDENSED = 1,
    DWRITE_FONT_STRETCH_EXTRA_CONDENSED = 2,
    DWRITE_FONT_STRETCH_CONDENSED = 3,
    DWRITE_FONT_STRETCH_SEMI_CONDENSED = 4,
    DWRITE_FONT_STRETCH_NORMAL = 5,
    DWRITE_FONT_STRETCH_MEDIUM = 5,
    DWRITE_FONT_STRETCH_SEMI_EXPANDED = 6,
    DWRITE_FONT_STRETCH_EXPANDED = 7,
    DWRITE_FONT_STRETCH_EXTRA_EXPANDED = 8,
    DWRITE_FONT_STRETCH_ULTRA_EXPANDED = 9,
};

const WICBitmapPaletteType = enum(c_int) {
    WICBitmapPaletteTypeCustom = 0,
    WICBitmapPaletteTypeMedianCut = 0x1,
    WICBitmapPaletteTypeFixedBW = 0x2,
    WICBitmapPaletteTypeFixedHalftone8 = 0x3,
    WICBitmapPaletteTypeFixedHalftone27 = 0x4,
    WICBitmapPaletteTypeFixedHalftone64 = 0x5,
    WICBitmapPaletteTypeFixedHalftone125 = 0x6,
    WICBitmapPaletteTypeFixedHalftone216 = 0x7,
    WICBitmapPaletteTypeFixedWebPalette,
    WICBitmapPaletteTypeFixedHalftone252 = 0x8,
    WICBitmapPaletteTypeFixedHalftone256 = 0x9,
    WICBitmapPaletteTypeFixedGray4 = 0xa,
    WICBitmapPaletteTypeFixedGray16 = 0xb,
    WICBitmapPaletteTypeFixedGray256 = 0xc,
    WICBITMAPPALETTETYPE_FORCE_DWORD = 0x7fffffff,
};

const DXGI_FORMAT = enum(c_int) {
    DXGI_FORMAT_UNKNOWN = 0,
    DXGI_FORMAT_R32G32B32A32_TYPELESS = 1,
    DXGI_FORMAT_R32G32B32A32_FLOAT = 2,
    DXGI_FORMAT_R32G32B32A32_UINT = 3,
    DXGI_FORMAT_R32G32B32A32_SINT = 4,
    DXGI_FORMAT_R32G32B32_TYPELESS = 5,
    DXGI_FORMAT_R32G32B32_FLOAT = 6,
    DXGI_FORMAT_R32G32B32_UINT = 7,
    DXGI_FORMAT_R32G32B32_SINT = 8,
    DXGI_FORMAT_R16G16B16A16_TYPELESS = 9,
    DXGI_FORMAT_R16G16B16A16_FLOAT = 10,
    DXGI_FORMAT_R16G16B16A16_UNORM = 11,
    DXGI_FORMAT_R16G16B16A16_UINT = 12,
    DXGI_FORMAT_R16G16B16A16_SNORM = 13,
    DXGI_FORMAT_R16G16B16A16_SINT = 14,
    DXGI_FORMAT_R32G32_TYPELESS = 15,
    DXGI_FORMAT_R32G32_FLOAT = 16,
    DXGI_FORMAT_R32G32_UINT = 17,
    DXGI_FORMAT_R32G32_SINT = 18,
    DXGI_FORMAT_R32G8X24_TYPELESS = 19,
    DXGI_FORMAT_D32_FLOAT_S8X24_UINT = 20,
    DXGI_FORMAT_R32_FLOAT_X8X24_TYPELESS = 21,
    DXGI_FORMAT_X32_TYPELESS_G8X24_UINT = 22,
    DXGI_FORMAT_R10G10B10A2_TYPELESS = 23,
    DXGI_FORMAT_R10G10B10A2_UNORM = 24,
    DXGI_FORMAT_R10G10B10A2_UINT = 25,
    DXGI_FORMAT_R11G11B10_FLOAT = 26,
    DXGI_FORMAT_R8G8B8A8_TYPELESS = 27,
    DXGI_FORMAT_R8G8B8A8_UNORM = 28,
    DXGI_FORMAT_R8G8B8A8_UNORM_SRGB = 29,
    DXGI_FORMAT_R8G8B8A8_UINT = 30,
    DXGI_FORMAT_R8G8B8A8_SNORM = 31,
    DXGI_FORMAT_R8G8B8A8_SINT = 32,
    DXGI_FORMAT_R16G16_TYPELESS = 33,
    DXGI_FORMAT_R16G16_FLOAT = 34,
    DXGI_FORMAT_R16G16_UNORM = 35,
    DXGI_FORMAT_R16G16_UINT = 36,
    DXGI_FORMAT_R16G16_SNORM = 37,
    DXGI_FORMAT_R16G16_SINT = 38,
    DXGI_FORMAT_R32_TYPELESS = 39,
    DXGI_FORMAT_D32_FLOAT = 40,
    DXGI_FORMAT_R32_FLOAT = 41,
    DXGI_FORMAT_R32_UINT = 42,
    DXGI_FORMAT_R32_SINT = 43,
    DXGI_FORMAT_R24G8_TYPELESS = 44,
    DXGI_FORMAT_D24_UNORM_S8_UINT = 45,
    DXGI_FORMAT_R24_UNORM_X8_TYPELESS = 46,
    DXGI_FORMAT_X24_TYPELESS_G8_UINT = 47,
    DXGI_FORMAT_R8G8_TYPELESS = 48,
    DXGI_FORMAT_R8G8_UNORM = 49,
    DXGI_FORMAT_R8G8_UINT = 50,
    DXGI_FORMAT_R8G8_SNORM = 51,
    DXGI_FORMAT_R8G8_SINT = 52,
    DXGI_FORMAT_R16_TYPELESS = 53,
    DXGI_FORMAT_R16_FLOAT = 54,
    DXGI_FORMAT_D16_UNORM = 55,
    DXGI_FORMAT_R16_UNORM = 56,
    DXGI_FORMAT_R16_UINT = 57,
    DXGI_FORMAT_R16_SNORM = 58,
    DXGI_FORMAT_R16_SINT = 59,
    DXGI_FORMAT_R8_TYPELESS = 60,
    DXGI_FORMAT_R8_UNORM = 61,
    DXGI_FORMAT_R8_UINT = 62,
    DXGI_FORMAT_R8_SNORM = 63,
    DXGI_FORMAT_R8_SINT = 64,
    DXGI_FORMAT_A8_UNORM = 65,
    DXGI_FORMAT_R1_UNORM = 66,
    DXGI_FORMAT_R9G9B9E5_SHAREDEXP = 67,
    DXGI_FORMAT_R8G8_B8G8_UNORM = 68,
    DXGI_FORMAT_G8R8_G8B8_UNORM = 69,
    DXGI_FORMAT_BC1_TYPELESS = 70,
    DXGI_FORMAT_BC1_UNORM = 71,
    DXGI_FORMAT_BC1_UNORM_SRGB = 72,
    DXGI_FORMAT_BC2_TYPELESS = 73,
    DXGI_FORMAT_BC2_UNORM = 74,
    DXGI_FORMAT_BC2_UNORM_SRGB = 75,
    DXGI_FORMAT_BC3_TYPELESS = 76,
    DXGI_FORMAT_BC3_UNORM = 77,
    DXGI_FORMAT_BC3_UNORM_SRGB = 78,
    DXGI_FORMAT_BC4_TYPELESS = 79,
    DXGI_FORMAT_BC4_UNORM = 80,
    DXGI_FORMAT_BC4_SNORM = 81,
    DXGI_FORMAT_BC5_TYPELESS = 82,
    DXGI_FORMAT_BC5_UNORM = 83,
    DXGI_FORMAT_BC5_SNORM = 84,
    DXGI_FORMAT_B5G6R5_UNORM = 85,
    DXGI_FORMAT_B5G5R5A1_UNORM = 86,
    DXGI_FORMAT_B8G8R8A8_UNORM = 87,
    DXGI_FORMAT_B8G8R8X8_UNORM = 88,
    DXGI_FORMAT_R10G10B10_XR_BIAS_A2_UNORM = 89,
    DXGI_FORMAT_B8G8R8A8_TYPELESS = 90,
    DXGI_FORMAT_B8G8R8A8_UNORM_SRGB = 91,
    DXGI_FORMAT_B8G8R8X8_TYPELESS = 92,
    DXGI_FORMAT_B8G8R8X8_UNORM_SRGB = 93,
    DXGI_FORMAT_BC6H_TYPELESS = 94,
    DXGI_FORMAT_BC6H_UF16 = 95,
    DXGI_FORMAT_BC6H_SF16 = 96,
    DXGI_FORMAT_BC7_TYPELESS = 97,
    DXGI_FORMAT_BC7_UNORM = 98,
    DXGI_FORMAT_BC7_UNORM_SRGB = 99,
    DXGI_FORMAT_AYUV = 100,
    DXGI_FORMAT_Y410 = 101,
    DXGI_FORMAT_Y416 = 102,
    DXGI_FORMAT_NV12 = 103,
    DXGI_FORMAT_P010 = 104,
    DXGI_FORMAT_P016 = 105,
    DXGI_FORMAT_420_OPAQUE = 106,
    DXGI_FORMAT_YUY2 = 107,
    DXGI_FORMAT_Y210 = 108,
    DXGI_FORMAT_Y216 = 109,
    DXGI_FORMAT_NV11 = 110,
    DXGI_FORMAT_AI44 = 111,
    DXGI_FORMAT_IA44 = 112,
    DXGI_FORMAT_P8 = 113,
    DXGI_FORMAT_A8P8 = 114,
    DXGI_FORMAT_B4G4R4A4_UNORM = 115,
    DXGI_FORMAT_P208 = 130,
    DXGI_FORMAT_V208 = 131,
    DXGI_FORMAT_V408 = 132,
    DXGI_FORMAT_SAMPLER_FEEDBACK_MIN_MIP_OPAQUE = 189,
    DXGI_FORMAT_SAMPLER_FEEDBACK_MIP_REGION_USED_OPAQUE = 190,
    DXGI_FORMAT_FORCE_UINT = 0xffffffff,
};

const D2D1_ALPHA_MODE = enum(c_int) {
    D2D1_ALPHA_MODE_UNKNOWN = 0,
    D2D1_ALPHA_MODE_PREMULTIPLIED = 1,
    D2D1_ALPHA_MODE_STRAIGHT = 2,
    D2D1_ALPHA_MODE_IGNORE = 3,
    D2D1_ALPHA_MODE_FORCE_DWORD = 0xffffffff,
};

const D2D1_RENDER_TARGET_TYPE = enum(c_int) {
    D2D1_RENDER_TARGET_TYPE_DEFAULT = 0,
    D2D1_RENDER_TARGET_TYPE_SOFTWARE = 1,
    D2D1_RENDER_TARGET_TYPE_HARDWARE = 2,
    D2D1_RENDER_TARGET_TYPE_FORCE_DWORD = 0xffffffff,
};

const D2D1_RENDER_TARGET_USAGE = enum(c_int) {
    D2D1_RENDER_TARGET_USAGE_NONE = 0x00000000,
    D2D1_RENDER_TARGET_USAGE_FORCE_BITMAP_REMOTING = 0x00000001,
    D2D1_RENDER_TARGET_USAGE_GDI_COMPATIBLE = 0x00000002,
    D2D1_RENDER_TARGET_USAGE_FORCE_DWORD = 0xffffffff,
};

const D2D1_FEATURE_LEVEL = enum(c_int) {
    D2D1_FEATURE_LEVEL_DEFAULT = 0,
    D2D1_FEATURE_LEVEL_9,
    D2D1_FEATURE_LEVEL_10,
    D2D1_FEATURE_LEVEL_FORCE_DWORD = 0xffffffff,
};

const D2D1_PRESENT_OPTIONS = enum(c_int) {
    D2D1_PRESENT_OPTIONS_NONE = 0x00000000,
    D2D1_PRESENT_OPTIONS_RETAIN_CONTENTS = 0x00000001,
    D2D1_PRESENT_OPTIONS_IMMEDIATELY = 0x00000002,
    D2D1_PRESENT_OPTIONS_FORCE_DWORD = 0xffffffff,
};

const D2D1_EXTEND_MODE = enum(c_int) {
    D2D1_EXTEND_MODE_CLAMP = 0,
    D2D1_EXTEND_MODE_WRAP = 1,
    D2D1_EXTEND_MODE_MIRROR = 2,
    D2D1_EXTEND_MODE_FORCE_DWORD = 0xffffffff,
};

const D2D1_BITMAP_INTERPOLATION_MODE = enum(c_int) {
    D2D1_BITMAP_INTERPOLATION_MODE_NEAREST_NEIGHBOR,
    D2D1_BITMAP_INTERPOLATION_MODE_LINEAR,
    D2D1_BITMAP_INTERPOLATION_MODE_FORCE_DWORD = 0xffffffff,
};

const D2D1_GAMMA = enum(c_int) {
    D2D1_GAMMA_2_2 = 0,
    D2D1_GAMMA_1_0 = 1,
    D2D1_GAMMA_FORCE_DWORD = 0xffffffff,
};

const D2D1_COMPATIBLE_RENDER_TARGET_OPTIONS = enum(c_int) {
    D2D1_COMPATIBLE_RENDER_TARGET_OPTIONS_NONE = 0x00000000,
    D2D1_COMPATIBLE_RENDER_TARGET_OPTIONS_GDI_COMPATIBLE = 0x00000001,
    D2D1_COMPATIBLE_RENDER_TARGET_OPTIONS_FORCE_DWORD = 0xffffffff,
};

const D2D1_OPACITY_MASK_CONTENT = enum(c_int) {
    D2D1_OPACITY_MASK_CONTENT_GRAPHICS = 0,
    D2D1_OPACITY_MASK_CONTENT_TEXT_NATURAL = 1,
    D2D1_OPACITY_MASK_CONTENT_TEXT_GDI_COMPATIBLE = 2,
    D2D1_OPACITY_MASK_CONTENT_FORCE_DWORD = 0xffffffff,
};

const D2D1_DRAW_TEXT_OPTIONS = enum(c_int) {
    D2D1_DRAW_TEXT_OPTIONS_NO_SNAP = 0x00000001,
    D2D1_DRAW_TEXT_OPTIONS_CLIP = 0x00000002,
    D2D1_DRAW_TEXT_OPTIONS_ENABLE_COLOR_FONT = 0x00000004,
    D2D1_DRAW_TEXT_OPTIONS_DISABLE_COLOR_BITMAP_SNAPPING = 0x00000008,
    D2D1_DRAW_TEXT_OPTIONS_NONE = 0x00000000,
    D2D1_DRAW_TEXT_OPTIONS_FORCE_DWORD = 0xffffffff,
};

const DWRITE_FONT_FACE_TYPE = enum(c_int) {
    DWRITE_FONT_FACE_TYPE_CFF,
    DWRITE_FONT_FACE_TYPE_TRUETYPE,
    DWRITE_FONT_FACE_TYPE_OPENTYPE_COLLECTION,
    DWRITE_FONT_FACE_TYPE_TYPE1,
    DWRITE_FONT_FACE_TYPE_VECTOR,
    DWRITE_FONT_FACE_TYPE_BITMAP,
    DWRITE_FONT_FACE_TYPE_UNKNOWN,
    DWRITE_FONT_FACE_TYPE_RAW_CFF,
    DWRITE_FONT_FACE_TYPE_TRUETYPE_COLLECTION,
};

const DWRITE_FONT_SIMULATIONS = enum(c_int) {
    DWRITE_FONT_SIMULATIONS_NONE = 0x0000,
    DWRITE_FONT_SIMULATIONS_BOLD = 0x0001,
    DWRITE_FONT_SIMULATIONS_OBLIQUE = 0x0002,
};

const DWRITE_FONT_FILE_TYPE = enum(c_int) {
    DWRITE_FONT_FILE_TYPE_UNKNOWN,
    DWRITE_FONT_FILE_TYPE_CFF,
    DWRITE_FONT_FILE_TYPE_TRUETYPE,
    DWRITE_FONT_FILE_TYPE_OPENTYPE_COLLECTION,
    DWRITE_FONT_FILE_TYPE_TYPE1_PFM,
    DWRITE_FONT_FILE_TYPE_TYPE1_PFB,
    DWRITE_FONT_FILE_TYPE_VECTOR,
    DWRITE_FONT_FILE_TYPE_BITMAP,
    DWRITE_FONT_FILE_TYPE_TRUETYPE_COLLECTION,
};

extern "d2d1" fn D2D1CreateFactory(
    factoryType: D2D1_FACTORY_TYPE,
    riid: REFIID,
    pFactoryOptions: ?*const D2D1_FACTORY_OPTIONS,
    ppIFactory: *?*ID2D1Factory,
) callconv(.winapi) HRESULT;

const ID2D1Factory = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *ID2D1Factory,
            REFIID,
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
            REFIID,
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

const ID2D1Layer = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *ID2D1Layer,
            REFIID,
            *?*anyopaque,
        ) callconv(.winapi) HRESULT,
        AddRef: *const fn (*ID2D1Layer) callconv(.winapi) ULONG,
        Release: *const fn (*ID2D1Layer) callconv(.winapi) ULONG,

        GetFactory: *const fn (*ID2D1Layer, **ID2D1Factory) callconv(.winapi) void,

        GetSize: *const fn (*ID2D1Layer) callconv(.winapi) D2D1_SIZE_F,
    };

    pub fn Release(self: *ID2D1Layer) ULONG {
        return self.v.Release(self);
    }

    pub fn GetFactory(self: *ID2D1Layer, factory: **ID2D1Factory) void {
        return self.v.GetFactory(self, factory);
    }
};

const ID2D1Mesh = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *ID2D1Mesh,
            REFIID,
            *?*anyopaque,
        ) callconv(.winapi) HRESULT,
        AddRef: *const fn (*ID2D1Mesh) callconv(.winapi) ULONG,
        Release: *const fn (*ID2D1Mesh) callconv(.winapi) ULONG,

        GetFactory: *const fn (*ID2D1Mesh, **ID2D1Factory) callconv(.winapi) void,

        Open: *const fn (*ID2D1Mesh, **ID2D1TesselationSink) callconv(.winapi) HRESULT,
    };

    pub fn Release(self: *ID2D1Mesh) ULONG {
        return self.v.Release(self);
    }

    pub fn GetFactory(self: *ID2D1Mesh, factory: **ID2D1Factory) void {
        return self.v.GetFactory(self, factory);
    }
};

const ID2D1GradientStopCollection = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *ID2D1GradientStopCollection,
            REFIID,
            *?*anyopaque,
        ) callconv(.winapi) HRESULT,
        AddRef: *const fn (*ID2D1GradientStopCollection) callconv(.winapi) ULONG,
        Release: *const fn (*ID2D1GradientStopCollection) callconv(.winapi) ULONG,

        GetFactory: *const fn (*ID2D1GradientStopCollection, **ID2D1Factory) callconv(.winapi) void,

        GetGradientStopCount: *const fn (*ID2D1GradientStopCollection) callconv(.winapi) UINT32,
        GetGradientStops: *const fn (
            *ID2D1GradientStopCollection,
            [*]D2D1_GRADIENT_STOP,
            UINT32,
        ) callconv(.winapi) void,
        GetColorInterpolationGamma: *const fn (*ID2D1GradientStopCollection) callconv(.winapi) D2D1_GAMMA,
        GetExtendMode: *const fn (*ID2D1GradientStopCollection) callconv(.winapi) D2D1_EXTEND_MODE,
    };

    pub fn Release(self: *ID2D1GradientStopCollection) ULONG {
        return self.v.Release(self);
    }

    pub fn GetFactory(self: *ID2D1GradientStopCollection, factory: **ID2D1Factory) void {
        return self.v.GetFactory(self, factory);
    }
};

const ID2D1Brush = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *ID2D1Brush,
            REFIID,
            *?*anyopaque,
        ) callconv(.winapi) HRESULT,
        AddRef: *const fn (*ID2D1Brush) callconv(.winapi) ULONG,
        Release: *const fn (*ID2D1Brush) callconv(.winapi) ULONG,

        GetFactory: *const fn (*ID2D1Brush, **ID2D1Factory) callconv(.winapi) void,

        SetOpacity: *const fn (*ID2D1Brush, FLOAT) callconv(.winapi) void,
        SetTransform: *const fn (*ID2D1Brush, *const D2D1_MATRIX_3X2_F) callconv(.winapi) void,
        GetOpacity: *const fn (*ID2D1Brush) callconv(.winapi) FLOAT,
        GetTransform: *const fn (*ID2D1Brush, *D2D1_MATRIX_3X2_F) callconv(.winapi) void,
    };

    pub fn Release(self: *ID2D1Brush) ULONG {
        return self.v.Release(self);
    }
};

const ID2D1RadialGradientBrush = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *ID2D1RadialGradientBrush,
            REFIID,
            *?*anyopaque,
        ) callconv(.winapi) HRESULT,
        AddRef: *const fn (*ID2D1RadialGradientBrush) callconv(.winapi) ULONG,
        Release: *const fn (*ID2D1RadialGradientBrush) callconv(.winapi) ULONG,

        GetFactory: *const fn (
            *ID2D1RadialGradientBrush,
            **ID2D1Factory,
        ) callconv(.winapi) void,

        SetOpacity: *const fn (*ID2D1RadialGradientBrush, FLOAT) callconv(.winapi) void,
        SetTransform: *const fn (
            *ID2D1RadialGradientBrush,
            *const D2D1_MATRIX_3X2_F,
        ) callconv(.winapi) void,
        GetOpacity: *const fn (*ID2D1RadialGradientBrush) callconv(.winapi) FLOAT,
        GetTransform: *const fn (
            *ID2D1RadialGradientBrush,
            *D2D1_MATRIX_3X2_F,
        ) callconv(.winapi) void,

        SetCenter: *const fn (*ID2D1RadialGradientBrush, D2D1_POINT_2F) callconv(.winapi) void,
        SetGradientOriginOffset: *const fn (
            *ID2D1RadialGradientBrush,
            D2D1_POINT_2F,
        ) callconv(.winapi) void,
        SetRadiusX: *const fn (*ID2D1RadialGradientBrush, FLOAT) callconv(.winapi) void,
        SetRadiusY: *const fn (*ID2D1RadialGradientBrush, FLOAT) callconv(.winapi) void,
        GetCenter: *const fn (*ID2D1RadialGradientBrush) callconv(.winapi) D2D1_POINT_2F,
        GetGradientOriginOffset: *const fn (
            *ID2D1RadialGradientBrush,
        ) callconv(.winapi) D2D1_POINT_2F,
        GetRadiusX: *const fn (*ID2D1RadialGradientBrush) callconv(.winapi) FLOAT,
        GetRadiusY: *const fn (*ID2D1RadialGradientBrush) callconv(.winapi) FLOAT,
        GetGradientStopCollection: *const fn (
            *ID2D1RadialGradientBrush,
            **ID2D1GradientStopCollection,
        ) callconv(.winapi) void,
    };

    pub fn Release(self: *ID2D1RadialGradientBrush) ULONG {
        return self.v.Release(self);
    }
};

const ID2D1LinearGradientBrush = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *ID2D1LinearGradientBrush,
            REFIID,
            *?*anyopaque,
        ) callconv(.winapi) HRESULT,
        AddRef: *const fn (*ID2D1LinearGradientBrush) callconv(.winapi) ULONG,
        Release: *const fn (*ID2D1LinearGradientBrush) callconv(.winapi) ULONG,

        GetFactory: *const fn (*ID2D1LinearGradientBrush, **ID2D1Factory) callconv(.winapi) void,

        SetOpacity: *const fn (*ID2D1LinearGradientBrush, FLOAT) callconv(.winapi) void,
        SetTransform: *const fn (
            *ID2D1LinearGradientBrush,
            *const D2D1_MATRIX_3X2_F,
        ) callconv(.winapi) void,
        GetOpacity: *const fn (*ID2D1LinearGradientBrush) callconv(.winapi) FLOAT,
        GetTransform: *const fn (
            *ID2D1LinearGradientBrush,
            *D2D1_MATRIX_3X2_F,
        ) callconv(.winapi) void,

        SetStartPoint: *const fn (*ID2D1LinearGradientBrush, D2D1_POINT_2F) callconv(.winapi) void,
        SetEndPoint: *const fn (*ID2D1LinearGradientBrush, D2D1_POINT_2F) callconv(.winapi) void,
        GetStartPoint: *const fn (*ID2D1LinearGradientBrush) callconv(.winapi) D2D1_POINT_2F,
        GetEndPoint: *const fn (*ID2D1LinearGradientBrush) callconv(.winapi) D2D1_POINT_2F,
        GetGradientStopCollection: *const fn (ID2D1LinearGradientBrush, **ID2D1GradientStopCollection) callconv(.winapi) void,
    };

    pub fn Release(self: *ID2D1LinearGradientBrush) ULONG {
        return self.v.Release(self);
    }
};

const ID2D1BitmapBrush = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *ID2D1BitmapBrush,
            REFIID,
            *?*anyopaque,
        ) callconv(.winapi) HRESULT,
        AddRef: *const fn (*ID2D1BitmapBrush) callconv(.winapi) ULONG,
        Release: *const fn (*ID2D1BitmapBrush) callconv(.winapi) ULONG,

        GetFactory: *const fn (*ID2D1BitmapBrush, **ID2D1Factory) callconv(.winapi) void,

        SetOpacity: *const fn (*ID2D1BitmapBrush, FLOAT) callconv(.winapi) void,
        SetTransform: *const fn (
            *ID2D1BitmapBrush,
            *const D2D1_MATRIX_3X2_F,
        ) callconv(.winapi) void,
        GetOpacity: *const fn (*ID2D1BitmapBrush) callconv(.winapi) FLOAT,
        GetTransform: *const fn (*ID2D1BitmapBrush, *D2D1_MATRIX_3X2_F) callconv(.winapi) void,

        SetExtendModeX: *const fn (*ID2D1BitmapBrush, D2D1_EXTEND_MODE) callconv(.winapi) void,
        SetExtendModeY: *const fn (*ID2D1BitmapBrush, D2D1_EXTEND_MODE) callconv(.winapi) void,
        SetInterpolationMode: *const fn (
            *ID2D1BitmapBrush,
            D2D1_BITMAP_INTERPOLATION_MODE,
        ) callconv(.winapi) void,
        SetBitmap: *const fn (*ID2D1BitmapBrush, ?*ID2D1Bitmap) callconv(.winapi) void,
        GetExtendModeX: *const fn (*ID2D1BitmapBrush) callconv(.winapi) D2D1_EXTEND_MODE,
        GetExtendModeY: *const fn (*ID2D1BitmapBrush) callconv(.winapi) D2D1_EXTEND_MODE,
        GetInterpolationMode: *const fn (
            *ID2D1BitmapBrush,
        ) callconv(.winapi) D2D1_BITMAP_INTERPOLATION_MODE,
        GetBitmap: *const fn (*ID2D1BitmapBrush, *?*ID2D1Bitmap) callconv(.winapi) void,
    };

    pub fn Release(self: *ID2D1BitmapBrush) ULONG {
        return self.v.Release(self);
    }
};

const ID2D1SolidColorBrush = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *ID2D1SolidColorBrush,
            REFIID,
            *?*anyopaque,
        ) callconv(.winapi) HRESULT,
        AddRef: *const fn (*ID2D1SolidColorBrush) callconv(.winapi) ULONG,
        Release: *const fn (*ID2D1SolidColorBrush) callconv(.winapi) ULONG,

        GetFactory: *const fn (*ID2D1SolidColorBrush, **ID2D1Factory) callconv(.winapi) void,

        SetOpacity: *const fn (*ID2D1SolidColorBrush, FLOAT) callconv(.winapi) void,
        SetTransform: *const fn (*ID2D1SolidColorBrush, *const D2D1_MATRIX_3X2_F) callconv(.winapi) void,
        GetOpacity: *const fn (*ID2D1SolidColorBrush) callconv(.winapi) FLOAT,
        GetTransform: *const fn (*ID2D1SolidColorBrush, *D2D1_MATRIX_3X2_F) callconv(.winapi) void,

        SetColor: *const fn (*ID2D1SolidColorBrush, *const D2D1_COLOR_F) callconv(.winapi) void,
        GetColor: *const fn (*ID2D1SolidColorBrush) callconv(.winapi) D2D1_COLOR_F,
    };

    pub fn Release(self: *ID2D1SolidColorBrush) ULONG {
        return self.v.Release(self);
    }
};

const ID2D1RenderTarget = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *ID2D1RenderTarget,
            REFIID,
            *?*anyopaque,
        ) callconv(.winapi) HRESULT,
        AddRef: *const fn (*ID2D1RenderTarget) callconv(.winapi) ULONG,
        Release: *const fn (*ID2D1RenderTarget) callconv(.winapi) ULONG,

        GetFactory: *const fn (
            *ID2D1RenderTarget,
            **ID2D1Factory,
        ) callconv(.winapi) void,

        CreateBitmap: *const fn (
            *ID2D1RenderTarget,
            ?*const anyopaque,
            UINT32,
            *const D2D1_BITMAP_PROPERTIES,
            **ID2D1Bitmap,
        ) callconv(.winapi) HRESULT,
        CreateBitmapFromWicBitmap: *const fn (
            *ID2D1RenderTarget,
            *IWICBitmapSource,
            ?*const D2D1_BITMAP_PROPERTIES,
            **ID2D1Bitmap,
        ) callconv(.winapi) HRESULT,
        CreateSharedBitmap: *const fn (
            *ID2D1RenderTarget,
            REFIID,
            *anyopaque,
            ?*const D2D1_BITMAP_PROPERTIES,
            **ID2D1Bitmap,
        ) callconv(.winapi) HRESULT,
        CreateBitmapBrush: *const fn (
            *ID2D1RenderTarget,
            ?*ID2D1Bitmap,
            ?*const D2D1_BITMAP_BRUSH_PROPERTIES,
            ?*const D2D1_BRUSH_PROPERTIES,
            **ID2D1BitmapBrush,
        ) callconv(.winapi) HRESULT,
        CreateSolidColorBrush: *const fn (
            *ID2D1RenderTarget,
            *const D2D1_COLOR_F,
            ?*const D2D1_BRUSH_PROPERTIES,
            **ID2D1SolidColorBrush,
        ) callconv(.winapi) HRESULT,
        CreateGradientStopCollection: *const fn (
            *ID2D1RenderTarget,
            [*]const D2D1_GRADIENT_STOP,
            UINT32,
            D2D1_GAMMA,
            D2D1_EXTEND_MODE,
            **ID2D1GradientStopCollection,
        ) callconv(.winapi) HRESULT,
        CreateLinearGradientBrush: *const fn (
            *ID2D1RenderTarget,
            *const D2D1_LINEAR_GRADIENT_BRUSH_PROPERTIES,
            ?*const D2D1_BRUSH_PROPERTIES,
            *ID2D1GradientStopCollection,
            **ID2D1LinearGradientBrush,
        ) callconv(.winapi) HRESULT,
        CreateRadialGradientBrush: *const fn (
            *ID2D1RenderTarget,
            *const D2D1_RADIAL_GRADIENT_BRUSH_PROPERTIES,
            ?*const D2D1_BRUSH_PROPERTIES,
            *ID2D1GradientStopCollection,
            **ID2D1RadialGradientBrush,
        ) callconv(.winapi) HRESULT,
        CreateCompatibleRenderTarget: *const fn (
            *ID2D1RenderTarget,
            ?*const D2D1_SIZE_F,
            ?*const D2D1_SIZE_U,
            ?*const D2D1_PIXEL_FORMAT,
            D2D1_COMPATIBLE_RENDER_TARGET_OPTIONS,
            **ID2D1BitmapRenderTarget,
        ) callconv(.winapi) HRESULT,
        CreateLayer: *const fn (
            *ID2D1RenderTarget,
            ?*const D2D1_SIZE_F,
            **ID2D1Layer,
        ) callconv(.winapi) HRESULT,
        CreateMesh: *const fn (
            *ID2D1RenderTarget,
            **ID2D1Mesh,
        ) callconv(.winapi) HRESULT,
        DrawLine: *const fn (
            *ID2D1RenderTarget,
            D2D1_POINT_2F,
            D2D1_POINT_2F,
            *ID2D1Brush,
            FLOAT,
            ?*ID2D1StrokeStyle,
        ) callconv(.winapi) void,
        DrawRectangle: *const fn (
            *ID2D1RenderTarget,
            *const D2D1_RECT_F,
            *ID2D1Brush,
            FLOAT,
            ?*ID2D1StrokeStyle,
        ) callconv(.winapi) void,
        FillRectangle: *const fn (
            *ID2D1RenderTarget,
            *const D2D1_RECT_F,
            *ID2D1Brush,
        ) callconv(.winapi) void,
        DrawRoundedRectangle: *const fn (
            *ID2D1RenderTarget,
            *const D2D1_ROUNDED_RECT,
            *ID2D1Brush,
            FLOAT,
            ?*ID2D1StrokeStyle,
        ) callconv(.winapi) void,
        FillRoundedRectangle: *const fn (
            *ID2D1RenderTarget,
            *const D2D1_ROUNDED_RECT,
            *ID2D1Brush,
        ) callconv(.winapi) void,
        DrawEllipse: *const fn (
            *ID2D1RenderTarget,
            *const D2D1_ELLIPSE,
            *ID2D1Brush,
            FLOAT,
            ?*ID2D1StrokeStyle,
        ) callconv(.winapi) void,
        FillEllipse: *const fn (
            *ID2D1RenderTarget,
            *const D2D1_ELLIPSE,
            *ID2D1Brush,
        ) callconv(.winapi) void,
        DrawGeometry: *const fn (
            *ID2D1RenderTarget,
            *ID2D1Geometry,
            *ID2D1Brush,
            FLOAT,
            ?*ID2D1StrokeStyle,
        ) callconv(.winapi) void,
        FillGeometry: *const fn (
            *ID2D1RenderTarget,
            *ID2D1Geometry,
            *ID2D1Brush,
            ?*ID2D1Brush,
        ) callconv(.winapi) void,
        FillMesh: *const fn (
            *ID2D1RenderTarget,
            *ID2D1Mesh,
            *ID2D1Brush,
        ) callconv(.winapi) void,
        FillOpacityMask: *const fn (
            *ID2D1RenderTarget,
            *ID2D1Bitmap,
            *ID2D1Brush,
            D2D1_OPACITY_MASK_CONTENT,
            ?*const D2D1_RECT_F,
            ?*const D2D1_RECT_F,
        ) callconv(.winapi) void,
        DrawBitmap: *const fn (
            *ID2D1RenderTarget,
            *ID2D1Bitmap,
            ?*const D2D1_RECT_F,
            FLOAT,
            D2D1_BITMAP_INTERPOLATION_MODE,
            ?*const D2D1_RECT_F,
        ) callconv(.winapi) void,
        DrawText: *const fn (
            *ID2D1RenderTarget,
            [*]const WCHAR,
            UINT32,
        ) callconv(.winapi) void,
    };

    pub fn Release(self: *ID2D1RenderTarget) ULONG {
        return self.v.Release(self);
    }
};

const ID2D1BitmapRenderTarget = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *ID2D1BitmapRenderTarget,
            REFIID,
            *?*anyopaque,
        ) callconv(.winapi) HRESULT,
        AddRef: *const fn (*ID2D1BitmapRenderTarget) callconv(.winapi) ULONG,
        Release: *const fn (*ID2D1BitmapRenderTarget) callconv(.winapi) ULONG,

        GetFactory: *const fn (
            *ID2D1BitmapRenderTarget,
            **ID2D1Factory,
        ) callconv(.winapi) void,

        CreateBitmap: *const fn (
            *ID2D1BitmapRenderTarget,
            ?*const anyopaque,
            UINT32,
            *const D2D1_BITMAP_PROPERTIES,
            **ID2D1Bitmap,
        ) callconv(.winapi) HRESULT,
        CreateBitmapFromWicBitmap: *const fn (
            *ID2D1BitmapRenderTarget,
            *IWICBitmapSource,
            ?*const D2D1_BITMAP_PROPERTIES,
            **ID2D1Bitmap,
        ) callconv(.winapi) HRESULT,
        CreateSharedBitmap: *const fn (
            *ID2D1BitmapRenderTarget,
            REFIID,
            *anyopaque,
            ?*const D2D1_BITMAP_PROPERTIES,
            **ID2D1Bitmap,
        ) callconv(.winapi) HRESULT,
        CreateBitmapBrush: *const fn (
            *ID2D1BitmapRenderTarget,
            ?*ID2D1Bitmap,
            ?*const D2D1_BITMAP_BRUSH_PROPERTIES,
            ?*const D2D1_BRUSH_PROPERTIES,
            **ID2D1BitmapBrush,
        ) callconv(.winapi) HRESULT,
        CreateSolidColorBrush: *const fn (
            *ID2D1BitmapRenderTarget,
            *const D2D1_COLOR_F,
            ?*const D2D1_BRUSH_PROPERTIES,
            **ID2D1SolidColorBrush,
        ) callconv(.winapi) HRESULT,
    };

    pub fn Release(self: *ID2D1BitmapRenderTarget) ULONG {
        return self.v.Release(self);
    }
};

const ID2D1Bitmap = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *ID2D1Bitmap,
            REFIID,
            *?*anyopaque,
        ) callconv(.winapi) HRESULT,
        AddRef: *const fn (*ID2D1Bitmap) callconv(.winapi) ULONG,
        Release: *const fn (*ID2D1Bitmap) callconv(.winapi) ULONG,

        GetFactory: *const fn (
            *ID2D1Bitmap,
            **ID2D1Factory,
        ) callconv(.winapi) void,

        GetSize: *const fn (*ID2D1Bitmap) callconv(.winapi) D2D1_SIZE_F,
        GetPixelSize: *const fn (*ID2D1Bitmap) callconv(.winapi) D2D1_SIZE_U,
        GetPixelFormat: *const fn (*ID2D1Bitmap) callconv(.winapi) D2D1_PIXEL_FORMAT,
        GetDpi: *const fn (
            *ID2D1Bitmap,
            *FLOAT,
            *FLOAT,
        ) callconv(.winapi) void,
        CopyFromBitmap: *const fn (
            *ID2D1Bitmap,
            ?*const D2D1_POINT_2U,
            *ID2D1Bitmap,
            ?*const D2D1_RECT_U,
        ) callconv(.winapi) HRESULT,
        CopyFromRenderTarget: *const fn (
            *ID2D1Bitmap,
            ?*const D2D1_POINT_2U,
            *ID2D1RenderTarget,
            ?*const D2D1_RECT_U,
        ) callconv(.winapi) HRESULT,
        CopyFromMemory: *const fn (
            *ID2D1Bitmap,
            ?*const D2D1_RECT_U,
            *const anyopaque,
            UINT32,
        ) callconv(.winapi) HRESULT,
    };
};

const ID2D1DrawingStateBlock = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *ID2D1DrawingStateBlock,
            REFIID,
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
            REFIID,
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
            REFIID,
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
            REFIID,
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

const IDWriteGeometrySink = ID2D1SimplifiedGeometrySink;

const ID2D1GeometrySink = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *ID2D1GeometrySink,
            REFIID,
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
            REFIID,
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
            REFIID,
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
            REFIID,
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
            REFIID,
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
            REFIID,
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
            REFIID,
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
            REFIID,
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
            REFIID,
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

const IDWriteTextFormat = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *IDWriteTextFormat,
            REFIID,
            *?*anyopaque,
        ) callconv(.winapi) HRESULT,
        AddRef: *const fn (*IDWriteTextFormat) callconv(.winapi) ULONG,
        Release: *const fn (*IDWriteTextFormat) callconv(.winapi) ULONG,

        SetTextAlignment: *const fn (*IDWriteTextFormat) callconv(.winapi) HRESULT,
    };

    pub fn Release(self: *IDWriteTextFormat) ULONG {
        return self.v.Release(self);
    }
};

const IDWritePixelSnapping = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *IDWritePixelSnapping,
            REFIID,
            *?*anyopaque,
        ) callconv(.winapi) HRESULT,
        AddRef: *const fn (*IDWritePixelSnapping) callconv(.winapi) ULONG,
        Release: *const fn (*IDWritePixelSnapping) callconv(.winapi) ULONG,

        IsPixelSnappingDisabled: *const fn (
            *IDWritePixelSnapping,
            ?*anyopaque,
            *BOOL,
        ) callconv(.winapi) HRESULT,
        GetCurrentTransform: *const fn (
            *IDWritePixelSnapping,
            ?*anyopaque,
            *DWRITE_MATRIX,
        ) callconv(.winapi) HRESULT,
        GetPixelsPerDip: *const fn (
            *IDWritePixelSnapping,
            ?*anyopaque,
            *FLOAT,
        ) callconv(.winapi) HRESULT,
    };

    pub fn Release(self: *IDWritePixelSnapping) ULONG {
        return self.v.Release(self);
    }
};

const IDWriteTextRenderer = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *IDWriteTextRenderer,
            REFIID,
            *?*anyopaque,
        ) callconv(.winapi) HRESULT,
        AddRef: *const fn (*IDWriteTextRenderer) callconv(.winapi) ULONG,
        Release: *const fn (*IDWriteTextRenderer) callconv(.winapi) ULONG,

        IsTextRendererDisabled: *const fn (
            *IDWriteTextRenderer,
            ?*anyopaque,
            *BOOL,
        ) callconv(.winapi) HRESULT,
        GetCurrentTransform: *const fn (
            *IDWriteTextRenderer,
            ?*anyopaque,
            *DWRITE_MATRIX,
        ) callconv(.winapi) HRESULT,
        GetPixelsPerDip: *const fn (
            *IDWriteTextRenderer,
            ?*anyopaque,
            *FLOAT,
        ) callconv(.winapi) HRESULT,
    };

    pub fn Release(self: *IDWriteTextRenderer) ULONG {
        return self.v.Release(self);
    }
};

const IWICBitmap = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *IWICBitmap,
            REFIID,
            *?*anyopaque,
        ) callconv(.winapi) HRESULT,
        AddRef: *const fn (*IWICBitmap) callconv(.winapi) ULONG,
        Release: *const fn (*IWICBitmap) callconv(.winapi) ULONG,

        GetSize: *const fn (*IWICBitmap, *UINT, *UINT) callconv(.winapi) HRESULT,
        GetPixelFormat: *const fn (*IWICBitmap, *GUID) callconv(.winapi) HRESULT,
        GetResolution: *const fn (*IWICBitmap, *double, *double) callconv(.winapi) HRESULT,
        CopyPalette: *const fn (*IWICBitmap, ?*IWICPalette) callconv(.winapi) HRESULT,
        CopyPixels: *const fn (
            *IWICBitmap,
            ?*const WICRect,
            UINT,
            UINT,
            [*]BYTE,
        ) callconv(.winapi) HRESULT,

        Lock: *const fn (
            *IWICBitmap,
            ?*const WICRect,
            DWORD,
            *?*IWICBitmapLock,
        ) callconv(.winapi) HRESULT,
        SetPalette: *const fn (
            *IWICBitmap,
            ?*IWICPalette,
        ) callconv(.winapi) HRESULT,
        SetResolution: *const fn (
            *IWICBitmap,
            double,
            double,
        ) callconv(.winapi) HRESULT,
    };
};

const IWICBitmapSource = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *IWICBitmapSource,
            REFIID,
            *?*anyopaque,
        ) callconv(.winapi) HRESULT,
        AddRef: *const fn (*IWICBitmapSource) callconv(.winapi) ULONG,
        Release: *const fn (*IWICBitmapSource) callconv(.winapi) ULONG,

        GetSize: *const fn (*IWICBitmapSource, *UINT, *UINT) callconv(.winapi) HRESULT,
        GetPixelFormat: *const fn (
            *IWICBitmapSource,
            *WICPixelFormatGUID,
        ) callconv(.winapi) HRESULT,
        GetResolution: *const fn (
            *IWICBitmapSource,
            *double,
            *double,
        ) callconv(.winapi) HRESULT,
        CopyPalette: *const fn (*IWICBitmapSource, ?*IWICPalette) callconv(.winapi) HRESULT,
        CopyPixels: *const fn (
            *IWICBitmapSource,
            ?*const WICRect,
            UINT,
            UINT,
            [*]BYTE,
        ) callconv(.winapi) HRESULT,
    };
};

const IWICBitmapLock = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *IWICBitmapLock,
            REFIID,
            *?*anyopaque,
        ) callconv(.winapi) HRESULT,
        AddRef: *const fn (*IWICBitmapLock) callconv(.winapi) ULONG,
        Release: *const fn (*IWICBitmapLock) callconv(.winapi) ULONG,

        GetSize: *const fn (
            *IWICBitmapLock,
            *UINT,
            *UINT,
        ) callconv(.winapi) HRESULT,
        GetStride: *const fn (*IWICBitmapLock, *UINT) callconv(.winapi) HRESULT,
        GetDataPointer: *const fn (
            *IWICBitmapLock,
            *UINT,
            *?WICInProcPointer,
        ) callconv(.winapi) HRESULT,
        GetPixelFormat: *const fn (
            *IWICBitmapLock,
            *WICPixelFormatGUID,
        ) callconv(.winapi) HRESULT,
    };
};

const IWICPalette = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *IWICPalette,
            REFIID,
            *?*anyopaque,
        ) callconv(.winapi) HRESULT,
        AddRef: *const fn (*IWICPalette) callconv(.winapi) ULONG,
        Release: *const fn (*IWICPalette) callconv(.winapi) ULONG,

        InitializePredefined: *const fn (
            *IWICPalette,
            WICBitmapPaletteType,
            BOOL,
        ) callconv(.winapi) HRESULT,
        InitializeCustom: *const fn (
            *IWICPalette,
            *WICColor,
            UINT,
        ) callconv(.winapi) HRESULT,
        InitializeFromBitmap: *const fn (
            *IWICPalette,
            ?*IWICBitmapSource,
            UINT,
            BOOL,
        ) callconv(.winapi) HRESULT,
        InitializeFromPalette: *const fn (
            *IWICPalette,
            ?*IWICPalette,
        ) callconv(.winapi) HRESULT,
        GetType: *const fn (
            *IWICPalette,
            *WICBitmapPaletteType,
        ) callconv(.winapi) HRESULT,
        GetColorCount: *const fn (*IWICPalette, *UINT) callconv(.winapi) HRESULT,
        GetColors: *const fn (
            *IWICPalette,
            UINT,
            [*]WICColor,
            *UINT,
        ) callconv(.winapi) HRESULT,
        IsBlackWhite: *const fn (*IWICPalette, *BOOL) callconv(.winapi) HRESULT,
        IsGrayscale: *const fn (*IWICPalette, *BOOL) callconv(.winapi) HRESULT,
        HasAlpha: *const fn (*IWICPalette, *BOOL) callconv(.winapi) HRESULT,
    };
};

const IUnknown = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *IUnknown,
            REFIID,
            *?*anyopaque,
        ) callconv(.winapi) HRESULT,
        AddRef: *const fn (*IUnknown) callconv(.winapi) ULONG,
        Release: *const fn (*IUnknown) callconv(.winapi) ULONG,
    };
};

const IDWriteFontFace = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *IDWriteFontFace,
            REFIID,
            *?*anyopaque,
        ) callconv(.winapi) HRESULT,
        AddRef: *const fn (*IDWriteFontFace) callconv(.winapi) ULONG,
        Release: *const fn (*IDWriteFontFace) callconv(.winapi) ULONG,

        GetType: *const fn (*IDWriteFontFace) callconv(.winapi) DWRITE_FONT_FACE_TYPE,
        GetFiles: *const fn (
            *IDWriteFontFace,
            *UINT32,
            *?[*]*IDWriteFontFile,
        ) callconv(.winapi) HRESULT,
        GetIndex: *const fn (*IDWriteFontFace) callconv(.winapi) UINT32,
        GetSimulations: *const fn (
            *IDWriteFontFace,
        ) callconv(.winapi) DWRITE_FONT_SIMULATIONS,
        IsSymbolFont: *const fn (*IDWriteFontFace) callconv(.winapi) BOOL,
        GetMetrics: *const fn (
            *IDWriteFontFace,
            *DWRITE_FONT_METRICS,
        ) callconv(.winapi) void,
        GetGlyphCount: *const fn (*IDWriteFontFace) callconv(.winapi) UINT16,
        GetDesignGlyphMetrics: *const fn (
            *IDWriteFontFace,
            [*]const UINT16,
            UINT32,
            [*]DWRITE_GLYPH_METRICS,
            BOOL,
        ) callconv(.winapi) HRESULT,
        GetGlyphIndices: *const fn (
            *IDWriteFontFace,
            [*]const UINT32,
            UINT32,
            [*]UINT16,
        ) callconv(.winapi) HRESULT,
        TryGetFontTable: *const fn (
            *IDWriteFontFace,
            UINT32,
            *[*]const anyopaque,
            *UINT32,
            **anyopaque,
            *BOOL,
        ) callconv(.winapi) HRESULT,
        ReleaseFontTable: *const fn (
            *IDWriteFontFace,
            *anyopaque,
        ) callconv(.winapi) void,
        GetGlyphRunOutline: *const fn (
            FLOAT,
            [*]const UINT16,
            ?[*]const FLOAT,
            ?[*]const DWRITE_GLYPH_OFFSET,
            UINT32,
            BOOL,
            BOOL,
            *IDWriteGeometrySink,
        ) callconv(.winapi) HRESULT,
        GetRecommendedRenderingMode: *const fn (
            FLOAT,
            FLOAT,
            DWRITE_MEASURING_MODE,
            *IDWriteRenderingParams,
            *DWRITE_RENDERING_MODE,
        ) callconv(.winapi) HRESULT,
        GetGdiCompatibleMetrics: *const fn (
            FLOAT,
            FLOAT,
            ?*const DWRITE_MATRIX,
            *DWRITE_FONT_METRICS,
        ) callconv(.winapi) HRESULT,
        GetGdiCompatibleGlyphMetrics: *const fn (
            FLOAT,
            FLOAT,
            ?*const DWRITE_MATRIX,
            BOOL,
            [*]const UINT16,
            UINT32,
            [*]DWRITE_GLYPH_METRICS,
            BOOL,
        ) callconv(.winapi) HRESULT,
    };
};

const IDWriteFontFile = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *IDWriteFontFile,
            REFIID,
            *?*anyopaque,
        ) callconv(.winapi) HRESULT,
        AddRef: *const fn (*IDWriteFontFile) callconv(.winapi) ULONG,
        Release: *const fn (*IDWriteFontFile) callconv(.winapi) ULONG,

        GetReferenceKey: *const fn (
            *IDWriteFontFile,
            *[*]const anyopaque,
            *UINT32,
        ) callconv(.winapi) HRESULT,
        GetLoader: *const fn (
            *IDWriteFontFile,
            **IDWriteFontFileLoader,
        ) callconv(.winapi) HRESULT,
        Analyze: *const fn (
            *IDWriteFontFile,
            *BOOL,
            *DWRITE_FONT_FILE_TYPE,
            ?*DWRITE_FONT_FACE_TYPE,
            *UINT32,
        ) callconv(.winapi) HRESULT,
    };
};

const IDWriteFontFileLoader = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *IDWriteFontFileLoader,
            REFIID,
            *?*anyopaque,
        ) callconv(.winapi) HRESULT,
        AddRef: *const fn (*IDWriteFontFileLoader) callconv(.winapi) ULONG,
        Release: *const fn (*IDWriteFontFileLoader) callconv(.winapi) ULONG,

        CreateStreamFromKey: *const fn (
            *IDWriteFontFileLoader,
            [*]const anyopaque,
            UINT32,
            **IDWriteFontFileStream,
        ) callconv(.winapi) HRESULT,
    };
};

const IDWriteFontFileStream = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *IDWriteFontFileStream,
            REFIID,
            *?*anyopaque,
        ) callconv(.winapi) HRESULT,
        AddRef: *const fn (*IDWriteFontFileStream) callconv(.winapi) ULONG,
        Release: *const fn (*IDWriteFontFileStream) callconv(.winapi) ULONG,

        ReadFileFragment: *const fn (
            *IDWriteFontFileStream,
            *[*]const anyopaque,
            UINT64,
            UINT64,
            **anyopaque,
        ) callconv(.winapi) HRESULT,
        ReleaseFileFragment: *const fn (
            *IDWriteFontFileStream,
            *anyopaque,
        ) callconv(.winapi) void,
        GetFileSize: *const fn (
            *IDWriteFontFileStream,
            *UINT64,
        ) callconv(.winapi) HRESULT,
        GetLastWriteTime: *const fn (
            *IDWriteFontFileStream,
            *UINT64,
        ) callconv(.winapi) HRESULT,
    };
};
