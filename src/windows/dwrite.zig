const std = @import("std");
const win32 = @import("win32.zig");
const d2d1 = @import("d2d1.zig");
const windows = @import("root.zig");

const TRIMMING = extern struct {
    granularity: TRIMMING_GRANULARITY,
    delimiter: windows.UINT32,
    delimiterCount: windows.UINT32,
};

const MATRIX = extern struct {
    m11: windows.FLOAT,
    m12: windows.FLOAT,
    m21: windows.FLOAT,
    m22: windows.FLOAT,
    dx: windows.FLOAT,
    dy: windows.FLOAT,
};

const FONT_METRICS = extern struct {
    designUnitsPerEm: windows.UINT16,
    ascent: windows.UINT16,
    descent: windows.UINT16,
    lineGap: windows.INT16,
    capHeight: windows.UINT16,
    xHeight: windows.UINT16,
    underlinePosition: windows.INT16,
    underlineThickness: windows.UINT16,
    strikethroughPosition: windows.INT16,
    strikethroughThickness: windows.UINT16,
};

const GLYPH_METRICS = extern struct {
    leftSideBearing: windows.INT32,
    advanceWidth: windows.UINT32,
    rightSideBearing: windows.INT32,
    topSideBearing: windows.INT32,
    advanceHeight: windows.UINT32,
    bottomSideBearing: windows.INT32,
    verticalOriginY: windows.INT32,
};

const GLYPH_OFFSET = extern struct {
    advanceOffset: windows.FLOAT,
    ascenderOffset: windows.FLOAT,
};

pub const GLYPH_RUN = extern struct {
    fontFace: *IFontFace,
    fontEmSize: windows.FLOAT,
    glyphCount: windows.UINT32,
    glyphIndices: [*]const windows.UINT16,
    glyphAdvances: [*]const windows.FLOAT,
    glyphOffsets: [*]const GLYPH_OFFSET,
    isSideways: windows.BOOL,
    bidiLevel: windows.UINT32,
};

const GLYPH_RUN_DESCRIPTION = extern struct {
    localeName: [*]const windows.WCHAR,
    string: [*]const windows.WCHAR,
    stringLength: windows.UINT32,
    clusterMap: [*]const windows.UINT16,
    textPosition: windows.UINT32,
};

const UNDERLINE = extern struct {
    width: windows.FLOAT,
    thickness: windows.FLOAT,
    offset: windows.FLOAT,
    runHeight: windows.FLOAT,
    readingDirection: READING_DIRECTION,
    flowDirection: FLOW_DIRECTION,
    localeName: [*]const windows.WCHAR,
    measuringMode: MEASURING_MODE,
};

const STRIKETHROUGH = extern struct {
    width: windows.FLOAT,
    thickness: windows.FLOAT,
    offset: windows.FLOAT,
    readingDirection: READING_DIRECTION,
    flowDirection: FLOW_DIRECTION,
    localeName: [*]const windows.WCHAR,
    measuringMode: MEASURING_MODE,
};

const INLINE_OBJECT_METRICS = extern struct {
    width: windows.FLOAT,
    height: windows.FLOAT,
    baseline: windows.FLOAT,
    supportsSideways: windows.BOOL,
};

const OVERHANG_METRICS = extern struct {
    left: windows.FLOAT,
    top: windows.FLOAT,
    right: windows.FLOAT,
    bottom: windows.FLOAT,
};

const TEXT_RANGE = extern struct {
    startPosition: windows.UINT32,
    length: windows.UINT32,
};

const FONT_FEATURE = extern struct {
    nameTag: FONT_FEATURE_TAG,
    parameter: windows.UINT32,
};

const LINE_METRICS = extern struct {
    length: windows.UINT32,
    trailingWhitespaceLength: windows.UINT32,
    newlineLength: windows.UINT32,
    height: windows.FLOAT,
    baseline: windows.FLOAT,
    isTrimmed: windows.BOOL,
};

const TEXT_METRICS = extern struct {
    left: windows.FLOAT,
    top: windows.FLOAT,
    width: windows.FLOAT,
    widthIncludingTrailingWhitespace: windows.FLOAT,
    height: windows.FLOAT,
    layoutWidth: windows.FLOAT,
    layoutHeight: windows.FLOAT,
    maxBidiReorderingDepth: windows.UINT32,
    lineCount: windows.UINT32,
};

const CLUSTER_METRICS = extern struct {
    width: windows.FLOAT,
    length: windows.UINT16,
    canWrapLineAfter: windows.UINT16 = 1,
    isWhitespace: windows.UINT16 = 1,
    isNewline: windows.UINT16 = 1,
    isSoftHyphen: windows.UINT16 = 1,
    isRightToLeft: windows.UINT16 = 1,
    padding: windows.UINT16 = 11,
};

const HIT_TEST_METRICS = extern struct {
    textPosition: windows.UINT32,
    length: windows.UINT32,
    left: windows.FLOAT,
    top: windows.FLOAT,
    width: windows.FLOAT,
    height: windows.FLOAT,
    bidiLevel: windows.UINT32,
    isText: windows.BOOL,
    isTrimmed: windows.BOOL,
};

const PIXEL_GEOMETRY = enum(c_int) {
    FLAT,
    RGB,
    BGR,
};

const RENDERING_MODE = enum(c_int) {
    DDEFAULT,
    ALIASED,
    GDI_CLASSIC,
    GDI_NATURAL,
    NATURAL,
    NATURAL_SYMMETRIC,
    OUTLINE,
    CLEARTYPE_GDI_CLASSIC,
    CLEARTYPE_GDI_NATURAL,
    CLEARTYPE_NATURAL,
    CLEARTYPE_NATURAL_SYMMETRIC,
};

pub const MEASURING_MODE = enum(c_int) {
    NATURAL,
    GDI_CLASSIC,
    GDI_NATURAL,
};

const TEXT_ALIGNMENT = enum(c_int) {
    LEADING,
    TRAILING,
    CENTER,
    JUSTIFIED,
};

const PARAGRAPH_ALIGNMENT = enum(c_int) {
    NEAR,
    FAR,
    CENTER,
};

const WORD_WRAPPING = enum(c_int) {
    WRAP = 0,
    NO_WRAP = 1,
    EMERGENCY_BREAK = 2,
    WHOLE_WORD = 3,
    CHARACTER = 4,
};

const READING_DIRECTION = enum(c_int) {
    LEFT_TO_RIGHT = 0,
    RIGHT_TO_LEFT = 1,
    TOP_TO_BOTTOM = 2,
    BOTTOM_TO_TOP = 3,
};

const FLOW_DIRECTION = enum(c_int) {
    TOP_TO_BOTTOM = 0,
    BOTTOM_TO_TOP = 1,
    LEFT_TO_RIGHT = 2,
    RIGHT_TO_LEFT = 3,
};

const TRIMMING_GRANULARITY = enum(c_int) {
    NONE,
    CHARACTER,
    WORD,
};

const LINE_SPACING_METHOD = enum(c_int) {
    DEFAULT,
    UNIFORM,
    PROPORTIONAL,
};

const FONT_WEIGHT = enum(c_int) {
    THIN = 100,
    EXTRA_LIGHT = 200,
    LIGHT = 300,
    SEMI_LIGHT = 350,
    REGULAR = 400,
    MEDIUM = 500,
    SEMI_BOLD = 600,
    BOLD = 700,
    EXTRA_BOLD = 800,
    BLACK = 900,
    EXTRA_BLACK = 950,
};

const FONT_STYLE = enum(c_int) {
    NORMAL,
    OBLIQUE,
    ITALIC,
};

const FONT_STRETCH = enum(c_int) {
    UNDEFINED = 0,
    ULTRA_CONDENSED = 1,
    EXTRA_CONDENSED = 2,
    CONDENSED = 3,
    SEMI_CONDENSED = 4,
    NORMAL = 5,
    SEMI_EXPANDED = 6,
    EXPANDED = 7,
    EXTRA_EXPANDED = 8,
    ULTRA_EXPANDED = 9,
};

const FONT_FACE_TYPE = enum(c_int) {
    CFF,
    TRUETYPE,
    OPENTYPE_COLLECTION,
    TYPE1,
    VECTOR,
    BITMAP,
    UNKNOWN,
    RAW_CFF,
    TRUETYPE_COLLECTION,
};

const FONT_SIMULATIONS = enum(c_int) {
    NONE = 0x0000,
    BOLD = 0x0001,
    OBLIQUE = 0x0002,
};

const FONT_FILE_TYPE = enum(c_int) {
    UNKNOWN,
    CFF,
    TRUETYPE,
    OPENTYPE_COLLECTION,
    TYPE1_PFM,
    TYPE1_PFB,
    VECTOR,
    BITMAP,
    TRUETYPE_COLLECTION,
};

const BREAK_CONDITION = enum(c_int) {
    NEUTRAL,
    CAN_BREAK,
    MAY_NOT_BREAK,
    MUST_BREAK,
};

const INFORMATIONAL_STRING_ID = enum(c_int) {
    NONE,
    COPYRIGHT_NOTICE,
    VERSION_STRINGS,
    TRADEMARK,
    MANUFACTURER,
    DESIGNER,
    DESIGNER_URL,
    DESCRIPTION,
    FONT_VENDOR_URL,
    LICENSE_DESCRIPTION,
    LICENSE_INFO_URL,
    WIN32_FAMILY_NAMES,
    WIN32_SUBFAMILY_NAMES,
    TYPOGRAPHIC_FAMILY_NAMES,
    TYPOGRAPHIC_SUBFAMILY_NAMES,
    SAMPLE_TEXT,
    FULL_NAME,
    POSTSCRIPT_NAME,
    POSTSCRIPT_CID_NAME,
    WEIGHT_STRETCH_STYLE_FAMILY_NAME,
    DESIGN_SCRIPT_LANGUAGE_TAG,
    SUPPORTED_SCRIPT_LANGUAGE_TAG,
    PREFERRED_FAMILY_NAMES,
    PREFERRED_SUBFAMILY_NAMES,
    WWS_FAMILY_NAME,
};

const FONT_FEATURE_TAG = enum(c_int) {
    ALTERNATIVE_FRACTIONS,
    PETITE_CAPITALS_FROM_CAPITALS,
    SMALL_CAPITALS_FROM_CAPITALS,
    CONTEXTUAL_ALTERNATES,
    CASE_SENSITIVE_FORMS,
    GLYPH_COMPOSITION_DECOMPOSITION,
    CONTEXTUAL_LIGATURES,
    CAPITAL_SPACING,
    CONTEXTUAL_SWASH,
    CURSIVE_POSITIONING,
    DEFAULT,
    DISCRETIONARY_LIGATURES,
    EXPERT_FORMS,
    FRACTIONS,
    FULL_WIDTH,
    HALF_FORMS,
    HALANT_FORMS,
    ALTERNATE_HALF_WIDTH,
    HISTORICAL_FORMS,
    HORIZONTAL_KANA_ALTERNATES,
    HISTORICAL_LIGATURES,
    HALF_WIDTH,
    HOJO_KANJI_FORMS,
    JIS04_FORMS,
    JIS78_FORMS,
    JIS83_FORMS,
    JIS90_FORMS,
    KERNING,
    STANDARD_LIGATURES,
    LINING_FIGURES,
    LOCALIZED_FORMS,
    MARK_POSITIONING,
    MATHEMATICAL_GREEK,
    MARK_TO_MARK_POSITIONING,
    ALTERNATE_ANNOTATION_FORMS,
    NLC_KANJI_FORMS,
    OLD_STYLE_FIGURES,
    ORDINALS,
    PROPORTIONAL_ALTERNATE_WIDTH,
    PETITE_CAPITALS,
    PROPORTIONAL_FIGURES,
    PROPORTIONAL_WIDTHS,
    QUARTER_WIDTHS,
    REQUIRED_LIGATURES,
    RUBY_NOTATION_FORMS,
    STYLISTIC_ALTERNATES,
    SCIENTIFIC_INFERIORS,
    SMALL_CAPITALS,
    SIMPLIFIED_FORMS,
    STYLISTIC_SET_1,
    STYLISTIC_SET_2,
    STYLISTIC_SET_3,
    STYLISTIC_SET_4,
    STYLISTIC_SET_5,
    STYLISTIC_SET_6,
    STYLISTIC_SET_7,
    STYLISTIC_SET_8,
    STYLISTIC_SET_9,
    STYLISTIC_SET_10,
    STYLISTIC_SET_11,
    STYLISTIC_SET_12,
    STYLISTIC_SET_13,
    STYLISTIC_SET_14,
    STYLISTIC_SET_15,
    STYLISTIC_SET_16,
    STYLISTIC_SET_17,
    STYLISTIC_SET_18,
    STYLISTIC_SET_19,
    STYLISTIC_SET_20,
    SUBSCRIPT,
    SUPERSCRIPT,
    SWASH,
    TITLING,
    TRADITIONAL_NAME_FORMS,
    TABULAR_FIGURES,
    TRADITIONAL_FORMS,
    THIRD_WIDTHS,
    UNICASE,
    VERTICAL_WRITING,
    VERTICAL_ALTERNATES_AND_ROTATION,
    SLASHED_ZERO,
};

const ITypography = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *ITypography,
            windows.REFIID,
            *?*anyopaque,
        ) callconv(.winapi) windows.HRESULT,
        AddRef: *const fn (*ITypography) callconv(.winapi) windows.ULONG,
        Release: *const fn (*ITypography) callconv(.winapi) windows.ULONG,

        AddFontFeature: *const fn (
            *ITypography,
            FONT_FEATURE,
        ) callconv(.winapi) windows.HRESULT,
        GetFontFeatureCount: *const fn (*ITypography) callconv(.winapi) windows.UINT32,
        GetFontFeature: *const fn (
            *ITypography,
            windows.UINT32,
            *FONT_FEATURE,
        ) callconv(.winapi) windows.HRESULT,
    };
};

const IFontFace = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *IFontFace,
            windows.REFIID,
            *?*anyopaque,
        ) callconv(.winapi) windows.HRESULT,
        AddRef: *const fn (*IFontFace) callconv(.winapi) windows.ULONG,
        Release: *const fn (*IFontFace) callconv(.winapi) windows.ULONG,

        GetType: *const fn (*IFontFace) callconv(.winapi) FONT_FACE_TYPE,
        GetFiles: *const fn (
            *IFontFace,
            *windows.UINT32,
            *?[*]*IFontFile,
        ) callconv(.winapi) windows.HRESULT,
        GetIndex: *const fn (*IFontFace) callconv(.winapi) windows.UINT32,
        GetSimulations: *const fn (
            *IFontFace,
        ) callconv(.winapi) FONT_SIMULATIONS,
        IsSymbolFont: *const fn (*IFontFace) callconv(.winapi) windows.BOOL,
        GetMetrics: *const fn (
            *IFontFace,
            *FONT_METRICS,
        ) callconv(.winapi) void,
        GetGlyphCount: *const fn (*IFontFace) callconv(.winapi) windows.UINT16,
        GetDesignGlyphMetrics: *const fn (
            *IFontFace,
            [*]const windows.UINT16,
            windows.UINT32,
            [*]GLYPH_METRICS,
            windows.BOOL,
        ) callconv(.winapi) windows.HRESULT,
        GetGlyphIndices: *const fn (
            *IFontFace,
            [*]const windows.UINT32,
            windows.UINT32,
            [*]windows.UINT16,
        ) callconv(.winapi) windows.HRESULT,
        TryGetFontTable: *const fn (
            *IFontFace,
            windows.UINT32,
            *[*]const windows.BYTE,
            *windows.UINT32,
            **anyopaque,
            *windows.BOOL,
        ) callconv(.winapi) windows.HRESULT,
        ReleaseFontTable: *const fn (
            *IFontFace,
            *anyopaque,
        ) callconv(.winapi) void,
        GetGlyphRunOutline: *const fn (
            windows.FLOAT,
            [*]const windows.UINT16,
            ?[*]const windows.FLOAT,
            ?[*]const GLYPH_OFFSET,
            windows.UINT32,
            windows.BOOL,
            windows.BOOL,
            *IGeometrySink,
        ) callconv(.winapi) windows.HRESULT,
        GetRecommendedRenderingMode: *const fn (
            windows.FLOAT,
            windows.FLOAT,
            MEASURING_MODE,
            *IRenderingParams,
            *RENDERING_MODE,
        ) callconv(.winapi) windows.HRESULT,
        GetGdiCompatibleMetrics: *const fn (
            windows.FLOAT,
            windows.FLOAT,
            ?*const MATRIX,
            *FONT_METRICS,
        ) callconv(.winapi) windows.HRESULT,
        GetGdiCompatibleGlyphMetrics: *const fn (
            windows.FLOAT,
            windows.FLOAT,
            ?*const MATRIX,
            windows.BOOL,
            [*]const windows.UINT16,
            windows.UINT32,
            [*]GLYPH_METRICS,
            windows.BOOL,
        ) callconv(.winapi) windows.HRESULT,
    };
};

const IFontFile = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *IFontFile,
            windows.REFIID,
            *?*anyopaque,
        ) callconv(.winapi) windows.HRESULT,
        AddRef: *const fn (*IFontFile) callconv(.winapi) windows.ULONG,
        Release: *const fn (*IFontFile) callconv(.winapi) windows.ULONG,

        GetReferenceKey: *const fn (
            *IFontFile,
            *[*]const windows.BYTE,
            *windows.UINT32,
        ) callconv(.winapi) windows.HRESULT,
        GetLoader: *const fn (
            *IFontFile,
            **IFontFileLoader,
        ) callconv(.winapi) windows.HRESULT,
        Analyze: *const fn (
            *IFontFile,
            *windows.BOOL,
            *FONT_FILE_TYPE,
            ?*FONT_FACE_TYPE,
            *windows.UINT32,
        ) callconv(.winapi) windows.HRESULT,
    };
};

const IFontFileLoader = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *IFontFileLoader,
            windows.REFIID,
            *?*anyopaque,
        ) callconv(.winapi) windows.HRESULT,
        AddRef: *const fn (*IFontFileLoader) callconv(.winapi) windows.ULONG,
        Release: *const fn (*IFontFileLoader) callconv(.winapi) windows.ULONG,

        CreateStreamFromKey: *const fn (
            *IFontFileLoader,
            [*]const windows.BYTE,
            windows.UINT32,
            **IFontFileStream,
        ) callconv(.winapi) windows.HRESULT,
    };
};

const IFontFileStream = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *IFontFileStream,
            windows.REFIID,
            *?*anyopaque,
        ) callconv(.winapi) windows.HRESULT,
        AddRef: *const fn (*IFontFileStream) callconv(.winapi) windows.ULONG,
        Release: *const fn (*IFontFileStream) callconv(.winapi) windows.ULONG,

        ReadFileFragment: *const fn (
            *IFontFileStream,
            *[*]const windows.BYTE,
            windows.UINT64,
            windows.UINT64,
            **anyopaque,
        ) callconv(.winapi) windows.HRESULT,
       ReleaseFileFragment: *const fn (
            *IFontFileStream,
            *anyopaque,
        ) callconv(.winapi) void,
        GetFileSize: *const fn (
            *IFontFileStream,
            *windows.UINT64,
        ) callconv(.winapi) windows.HRESULT,
        GetLastWriteTime: *const fn (
            *IFontFileStream,
            *windows.UINT64,
        ) callconv(.winapi) windows.HRESULT,
    };
};

pub const IRenderingParams = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *IRenderingParams,
            windows.REFIID,
            *?*anyopaque,
        ) callconv(.winapi) windows.HRESULT,
        AddRef: *const fn (*IRenderingParams) callconv(.winapi) windows.ULONG,
        Release: *const fn (*IRenderingParams) callconv(.winapi) windows.ULONG,

        GetGamma: *const fn (*IRenderingParams) callconv(.winapi) windows.FLOAT,
        GetEnhancedContrast: *const fn (*IRenderingParams) callconv(.winapi) windows.FLOAT,
        GetClearTypeLevel: *const fn (*IRenderingParams) callconv(.winapi) windows.FLOAT,
        GetPixelGeometry: *const fn (
            *IRenderingParams,
        ) callconv(.winapi) PIXEL_GEOMETRY,
        GetRenderingMode: *const fn (
            *IRenderingParams,
        ) callconv(.winapi) RENDERING_MODE,
    };

    pub fn Release(self: *IRenderingParams) windows.ULONG {
        return self.v.Release(self);
    }
};

pub const ITextFormat = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *ITextFormat,
            windows.REFIID,
            *?*anyopaque,
        ) callconv(.winapi) windows.HRESULT,
        AddRef: *const fn (*ITextFormat) callconv(.winapi) windows.ULONG,
        Release: *const fn (*ITextFormat) callconv(.winapi) windows.ULONG,

        SetTextAlignment: *const fn (
            *ITextFormat,
            TEXT_ALIGNMENT,
        ) callconv(.winapi) windows.HRESULT,
        SetParagraphAlignment: *const fn (
            *ITextFormat,
            PARAGRAPH_ALIGNMENT,
        ) callconv(.winapi) windows.HRESULT,
        SetWordWrapping: *const fn (
            *ITextFormat,
            WORD_WRAPPING,
        ) callconv(.winapi) windows.HRESULT,
        SetReadingDirection: *const fn (
            *ITextFormat,
            READING_DIRECTION,
        ) callconv(.winapi) windows.HRESULT,
        SetFlowDirection: *const fn (
            *ITextFormat,
            FLOW_DIRECTION,
        ) callconv(.winapi) windows.HRESULT,
        SetIncrementalTabStop: *const fn (
            *ITextFormat,
            windows.FLOAT,
        ) callconv(.winapi) windows.HRESULT,
        SetTrimming: *const fn (
            *ITextFormat,
            *const TRIMMING,
            ?*IInlineObject,
        ) callconv(.winapi) windows.HRESULT,
        SetLineSpacing: *const fn (
            *ITextFormat,
            LINE_SPACING_METHOD,
            windows.FLOAT,
            windows.FLOAT,
        ) callconv(.winapi) windows.HRESULT,
        GetTextAlignment: *const fn (
            *ITextFormat,
        ) callconv(.winapi) TEXT_ALIGNMENT,
        GetParagraphAlignment: *const fn (
            *ITextFormat,
        ) callconv(.winapi) PARAGRAPH_ALIGNMENT,
        GetWordWrapping: *const fn (
            *ITextFormat,
        ) callconv(.winapi) WORD_WRAPPING,
        GetReadingDirection: *const fn (
            *ITextFormat,
        ) callconv(.winapi) READING_DIRECTION,
        GetFlowDirection: *const fn (
            *ITextFormat,
        ) callconv(.winapi) FLOW_DIRECTION,
        GetIncrementalTabStop: *const fn () callconv(.winapi) windows.FLOAT,
        GetTrimming: *const fn (
            *ITextFormat,
            *TRIMMING,
            **IInlineObject,
        ) callconv(.winapi) windows.HRESULT,
        GetLineSpacing: *const fn (
            *ITextFormat,
            *LINE_SPACING_METHOD,
            *windows.FLOAT,
            *windows.FLOAT,
        ) callconv(.winapi) windows.HRESULT,
        GetFontCollection: *const fn (
            *ITextFormat,
            **IFontCollection,
        ) callconv(.winapi) windows.HRESULT,
        GetFontFamilyNameLength: *const fn (*ITextFormat) callconv(.winapi) windows.UINT32,
        GetFontFamilyName: *const fn (
            *ITextFormat,
            [*:0]windows.WCHAR,
            windows.UINT32,
        ) callconv(.winapi) windows.HRESULT,
        GetFontWeight: *const fn (*ITextFormat) callconv(.winapi) FONT_WEIGHT,
        GetFontStyle: *const fn (*ITextFormat) callconv(.winapi) FONT_STYLE,
        GetFontStretch: *const fn (*ITextFormat) callconv(.winapi) FONT_STRETCH,
        GetFontSize: *const fn (*ITextFormat) callconv(.winapi) windows.FLOAT,
        GetLocaleNameLength: *const fn (*ITextFormat) callconv(.winapi) windows.UINT32,
        GetLocaleName: *const fn (
            *ITextFormat,
            [*:0]windows.WCHAR,
            windows.UINT32,
        ) callconv(.winapi) windows.HRESULT,
    };

    pub fn Release(self: *ITextFormat) windows.ULONG {
        return self.v.Release(self);
    }
};

pub const ITextLayout = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *ITextLayout,
            windows.REFIID,
            *?*anyopaque,
        ) callconv(.winapi) windows.HRESULT,
        AddRef: *const fn (*ITextLayout) callconv(.winapi) windows.ULONG,
        Release: *const fn (*ITextLayout) callconv(.winapi) windows.ULONG,

        SetTextAlignment: *const fn (
            *ITextLayout,
            TEXT_ALIGNMENT,
        ) callconv(.winapi) windows.HRESULT,
        SetParagraphAlignment: *const fn (
            *ITextLayout,
            PARAGRAPH_ALIGNMENT,
        ) callconv(.winapi) windows.HRESULT,
        SetWordWrapping: *const fn (
            *ITextLayout,
            WORD_WRAPPING,
        ) callconv(.winapi) windows.HRESULT,
        SetReadingDirection: *const fn (
            *ITextLayout,
            READING_DIRECTION,
        ) callconv(.winapi) windows.HRESULT,
        SetFlowDirection: *const fn (
            *ITextLayout,
            FLOW_DIRECTION,
        ) callconv(.winapi) windows.HRESULT,
        SetIncrementalTabStop: *const fn (
            *ITextLayout,
            windows.FLOAT,
        ) callconv(.winapi) windows.HRESULT,
        SetTrimming: *const fn (
            *ITextLayout,
            *const TRIMMING,
            ?*IInlineObject,
        ) callconv(.winapi) windows.HRESULT,
        SetLineSpacing: *const fn (
            *ITextLayout,
            LINE_SPACING_METHOD,
            windows.FLOAT,
            windows.FLOAT,
        ) callconv(.winapi) windows.HRESULT,
        GetTextAlignment: *const fn (
            *ITextLayout,
        ) callconv(.winapi) TEXT_ALIGNMENT,
        GetParagraphAlignment: *const fn (
            *ITextLayout,
        ) callconv(.winapi) PARAGRAPH_ALIGNMENT,
        GetWordWrapping: *const fn (
            *ITextLayout,
        ) callconv(.winapi) WORD_WRAPPING,
        GetReadingDirection: *const fn (
            *ITextLayout,
        ) callconv(.winapi) READING_DIRECTION,
        GetFlowDirection: *const fn (
            *ITextLayout,
        ) callconv(.winapi) FLOW_DIRECTION,
        GetIncrementalTabStop: *const fn () callconv(.winapi) windows.FLOAT,
        GetTrimming: *const fn (
            *ITextLayout,
            *TRIMMING,
            **IInlineObject,
        ) callconv(.winapi) windows.HRESULT,
        GetLineSpacing: *const fn (
            *ITextLayout,
            *LINE_SPACING_METHOD,
            *windows.FLOAT,
            *windows.FLOAT,
        ) callconv(.winapi) windows.HRESULT,

        SetMaxWidth: *const fn (
            *ITextLayout,
            windows.FLOAT,
        ) callconv(.winapi) windows.HRESULT,
        SetMaxHeight: *const fn (
            *ITextLayout,
            windows.FLOAT,
        ) callconv(.winapi) windows.HRESULT,
        SetFontCollection: *const fn (
            *ITextLayout,
            *IFontCollection,
            TEXT_RANGE,
        ) callconv(.winapi) windows.HRESULT,
        SetFontFamilyName: *const fn (
            *ITextLayout,
            [*:0]const windows.WCHAR,
            TEXT_RANGE,
        ) callconv(.winapi) windows.HRESULT,
        SetFontWeight: *const fn (
            *ITextLayout,
            FONT_WEIGHT,
            TEXT_RANGE,
        ) callconv(.winapi) windows.HRESULT,
        SetFontStyle: *const fn (
            *ITextLayout,
            FONT_STYLE,
            TEXT_RANGE,
        ) callconv(.winapi) windows.HRESULT,
        SetFontStretch: *const fn (
            *ITextLayout,
            FONT_STRETCH,
            TEXT_RANGE,
        ) callconv(.winapi) windows.HRESULT,
        SetFontSize: *const fn (
            *ITextLayout,
            windows.FLOAT,
            TEXT_RANGE,
        ) callconv(.winapi) windows.HRESULT,
        SetUnderline: *const fn (
            *ITextLayout,
            windows.BOOL,
            TEXT_RANGE,
        ) callconv(.winapi) windows.HRESULT,
        SetStrikethrough: *const fn (
            *ITextLayout,
            windows.BOOL,
            TEXT_RANGE,
        ) callconv(.winapi) windows.HRESULT,
        SetDrawingEffect: *const fn (
            *ITextLayout,
            *win32.IUnknown,
            TEXT_RANGE,
        ) callconv(.winapi) windows.HRESULT,
        SetInlineObject: *const fn (
            *ITextLayout,
            *IInlineObject,
            TEXT_RANGE,
        ) callconv(.winapi) windows.HRESULT,
        SetTypography: *const fn (
            *ITextLayout,
            *ITypography,
            TEXT_RANGE,
        ) callconv(.winapi) windows.HRESULT,
        SetLocaleName: *const fn (
            *ITextLayout,
            [*:0]const windows.WCHAR,
            TEXT_RANGE,
        ) callconv(.winapi) windows.HRESULT,
        GetMaxWidth: *const fn (*ITextLayout) callconv(.winapi) windows.FLOAT,
        GetMaxHeight: *const fn (*ITextLayout) callconv(.winapi) windows.FLOAT,
        GetFontCollection: *const fn (
            *ITextLayout,
            windows.UINT32,
            **IFontCollection,
            ?*TEXT_RANGE,
        ) callconv(.winapi) windows.HRESULT,
        GetFontFamilyNameLength: *const fn (
            *ITextLayout,
            windows.UINT32,
            *windows.UINT32,
            ?*TEXT_RANGE,
        ) callconv(.winapi) windows.HRESULT,
        GetFontFamilyName: *const fn (
            *ITextLayout,
            windows.UINT32,
            [*:0]windows.WCHAR,
            windows.UINT32,
            ?*TEXT_RANGE,
        ) callconv(.winapi) windows.HRESULT,
        GetFontWeight: *const fn (
            *ITextLayout,
            windows.UINT32,
            *FONT_WEIGHT,
            ?*TEXT_RANGE,
        ) callconv(.winapi) windows.HRESULT,
        GetFontStyle: *const fn (
            *ITextLayout,
            windows.UINT32,
            *FONT_STYLE,
            ?*TEXT_RANGE,
        ) callconv(.winapi) windows.HRESULT,
        GetFontStretch: *const fn (
            *ITextLayout,
            windows.UINT32,
            *FONT_STRETCH,
            ?*TEXT_RANGE,
        ) callconv(.winapi) windows.HRESULT,
        GetFontSize: *const fn (
            *ITextLayout,
            windows.UINT32,
            *windows.FLOAT,
            ?*TEXT_RANGE,
        ) callconv(.winapi) windows.HRESULT,
        GetUnderline: *const fn (
            *ITextLayout,
            windows.UINT32,
            *windows.BOOL,
            ?*TEXT_RANGE,
        ) callconv(.winapi) windows.HRESULT,
        GetStrikethrough: *const fn (
            *ITextLayout,
            windows.UINT32,
            *windows.BOOL,
            ?*TEXT_RANGE,
        ) callconv(.winapi) windows.HRESULT,
        GetDrawingEffect: *const fn (
            *ITextLayout,
            windows.UINT32,
            **win32.IUnknown,
            ?*TEXT_RANGE,
        ) callconv(.winapi) windows.HRESULT,
        GetInlineObject: *const fn (
            *ITextLayout,
            windows.UINT32,
            **IInlineObject,
            ?*TEXT_RANGE,
        ) callconv(.winapi) windows.HRESULT,
        GetTypography: *const fn (
            *ITextLayout,
            windows.UINT32,
            **ITypography,
            ?*TEXT_RANGE,
        ) callconv(.winapi) windows.HRESULT,
        GetLocaleNameLength: *const fn (
            *ITextLayout,
            windows.UINT32,
            *windows.UINT32,
            ?*TEXT_RANGE,
        ) callconv(.winapi) windows.HRESULT,
        GetLocaleName: *const fn (
            *ITextLayout,
            windows.UINT32,
            [*:0]windows.WCHAR,
            windows.UINT32,
            ?*TEXT_RANGE,
        ) callconv(.winapi) windows.HRESULT,
        Draw: *const fn (
            *ITextLayout,
            ?*anyopaque,
            *ITextRenderer,
            windows.FLOAT,
            windows.FLOAT,
        ) callconv(.winapi) windows.HRESULT,
        GetLineMetrics: *const fn (
            *ITextLayout,
            ?[*]LINE_METRICS,
            windows.UINT32,
            *windows.UINT32,
        ) callconv(.winapi) windows.HRESULT,
        GetMetrics: *const fn (
            *ITextLayout,
            *OVERHANG_METRICS,
        ) callconv(.winapi) windows.HRESULT,
        GetClusterMetrics: *const fn (
            *ITextLayout,
            ?[*]CLUSTER_METRICS,
            windows.UINT32,
            *windows.UINT32,
        ) callconv(.winapi) windows.HRESULT,
        DetermineMinWidth: *const fn (
            *ITextLayout,
            *windows.FLOAT,
        ) callconv(.winapi) windows.HRESULT,
        HitTestPoint: *const fn (
            *ITextLayout,
            windows.FLOAT,
            windows.FLOAT,
            *windows.BOOL,
            *windows.BOOL,
            *HIT_TEST_METRICS,
        ) callconv(.winapi) windows.HRESULT,
        HitTestTextPosition: *const fn (
            *ITextLayout,
            windows.UINT32,
            windows.BOOL,
            *windows.FLOAT,
            *windows.FLOAT,
            *HIT_TEST_METRICS,
        ) callconv(.winapi) windows.HRESULT,
        HitTestTextRange: *const fn (
            *ITextLayout,
            windows.UINT32,
            windows.UINT32,
            windows.FLOAT,
            windows.FLOAT,
            ?[*]HIT_TEST_METRICS,
            windows.UINT32,
            *windows.UINT32,
        ) callconv(.winapi) windows.HRESULT,
    };

    pub fn Release(self: *ITextLayout) windows.ULONG {
        return self.v.Release(self);
    }
};

const IPixelSnapping = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *IPixelSnapping,
            windows.REFIID,
            *?*anyopaque,
        ) callconv(.winapi) windows.HRESULT,
        AddRef: *const fn (*IPixelSnapping) callconv(.winapi) windows.ULONG,
        Release: *const fn (*IPixelSnapping) callconv(.winapi) windows.ULONG,

        IsPixelSnappingDisabled: *const fn (
            *IPixelSnapping,
            ?*anyopaque,
            *windows.BOOL,
        ) callconv(.winapi) windows.HRESULT,
        GetCurrentTransform: *const fn (
            *IPixelSnapping,
            ?*anyopaque,
            *MATRIX,
        ) callconv(.winapi) windows.HRESULT,
        GetPixelsPerDip: *const fn (
            *IPixelSnapping,
            ?*anyopaque,
            *windows.FLOAT,
        ) callconv(.winapi) windows.HRESULT,
    };

    pub fn Release(self: *IPixelSnapping) windows.ULONG {
        return self.v.Release(self);
    }
};

const ITextRenderer = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *ITextRenderer,
            windows.REFIID,
            *?*anyopaque,
        ) callconv(.winapi) windows.HRESULT,
        AddRef: *const fn (*ITextRenderer) callconv(.winapi) windows.ULONG,
        Release: *const fn (*ITextRenderer) callconv(.winapi) windows.ULONG,

        IsTextRendererDisabled: *const fn (
            *ITextRenderer,
            ?*anyopaque,
            *windows.BOOL,
        ) callconv(.winapi) windows.HRESULT,
        GetCurrentTransform: *const fn (
            *ITextRenderer,
            ?*anyopaque,
            *MATRIX,
        ) callconv(.winapi) windows.HRESULT,
        GetPixelsPerDip: *const fn (
            *ITextRenderer,
            ?*anyopaque,
            *windows.FLOAT,
        ) callconv(.winapi) windows.HRESULT,

        DrawGlyphRun: *const fn (
            *ITextRenderer,
            ?*anyopaque,
            windows.FLOAT,
            windows.FLOAT,
            MEASURING_MODE,
            *const GLYPH_RUN,
            *const GLYPH_RUN_DESCRIPTION,
            ?*win32.IUnknown,
        ) callconv(.winapi) windows.HRESULT,
        DrawUnderline: *const fn (
            *ITextRenderer,
            ?*anyopaque,
            windows.FLOAT,
            windows.FLOAT,
            *const UNDERLINE,
            ?*win32.IUnknown,
        ) callconv(.winapi) windows.HRESULT,
        DrawStrikethrough: *const fn (
            *ITextRenderer,
            ?*anyopaque,
            windows.FLOAT,
            windows.FLOAT,
            *const STRIKETHROUGH,
            ?*win32.IUnknown,
        ) callconv(.winapi) windows.HRESULT,
        DrawInlineObject: *const fn (
            *ITextRenderer,
            ?*anyopaque,
            windows.FLOAT,
            windows.FLOAT,
            *const IInlineObject,
            windows.BOOL,
            windows.BOOL,
            ?*win32.IUnknown,
        ) callconv(.winapi) windows.HRESULT,
    };

    pub fn Release(self: *ITextRenderer) windows.ULONG {
        return self.v.Release(self);
    }
};

const IInlineObject = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *IInlineObject,
            windows.REFIID,
            *?*anyopaque,
        ) callconv(.winapi) windows.HRESULT,
        AddRef: *const fn (*IInlineObject) callconv(.winapi) windows.ULONG,
        Release: *const fn (*IInlineObject) callconv(.winapi) windows.ULONG,

        Draw: *const fn (
            *IInlineObject,
            ?*anyopaque,
            *ITextRenderer,
            windows.FLOAT,
            windows.FLOAT,
            windows.BOOL,
            windows.BOOL,
            ?*win32.IUnknown,
        ) callconv(.winapi) windows.HRESULT,
        GetMetrics: *const fn (
            *IInlineObject,
            *INLINE_OBJECT_METRICS,
        ) callconv(.winapi) windows.HRESULT,
        GetOverhangMetrics: *const fn (
            *IInlineObject,
            *OVERHANG_METRICS,
        ) callconv(.winapi) windows.HRESULT,
        GetBreakCondition: *const fn (
            *IInlineObject,
            *BREAK_CONDITION,
            *BREAK_CONDITION,
        ) callconv(.winapi) windows.HRESULT,
    };
};

const IFontList = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *IFontList,
            windows.REFIID,
            *?*anyopaque,
        ) callconv(.winapi) windows.HRESULT,
        AddRef: *const fn (*IFontList) callconv(.winapi) windows.ULONG,
        Release: *const fn (*IFontList) callconv(.winapi) windows.ULONG,

        GetFontCollection: *const fn (
            *IFontList,
            **IFontCollection,
        ) callconv(.winapi) windows.HRESULT,
        GetFontCount: *const fn (*IFontList) callconv(.winapi) windows.UINT32,
        GetFont: *const fn (
            *IFontList,
            windows.UINT32,
            **IFont,
        ) callconv(.winapi) windows.HRESULT,
    };
};

const IFontCollection = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *IFontCollection,
            windows.REFIID,
            *?*anyopaque,
        ) callconv(.winapi) windows.HRESULT,
        AddRef: *const fn (*IFontCollection) callconv(.winapi) windows.ULONG,
        Release: *const fn (*IFontCollection) callconv(.winapi) windows.ULONG,

        GetFontFamilyCount: *const fn (*IFontCollection) callconv(.winapi) windows.UINT32,
        GetFontFamily: *const fn (
            *IFontCollection,
            windows.UINT32,
            **IFontFamily,
        ) callconv(.winapi) windows.HRESULT,
        FindFamilyName: *const fn (
            *IFontCollection,
            [*:0]const windows.WCHAR,
            *windows.UINT32,
            *windows.BOOL,
        ) callconv(.winapi) windows.HRESULT,
        GetFontFromFontFace: *const fn (
            *IFontCollection,
            *IFontFace,
            **IFont,
        ) callconv(.winapi) windows.HRESULT,
    };
};

const IFont = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *IFont,
            windows.REFIID,
            *?*anyopaque,
        ) callconv(.winapi) windows.HRESULT,
        AddRef: *const fn (*IFont) callconv(.winapi) windows.ULONG,
        Release: *const fn (*IFont) callconv(.winapi) windows.ULONG,

        GetFontFamily: *const fn (
            *IFont,
            **IFontFamily,
        ) callconv(.winapi) windows.HRESULT,
        GetWeight: *const fn (*IFont) callconv(.winapi) FONT_WEIGHT,
        GetStretch: *const fn (*IFont) callconv(.winapi) FONT_STRETCH,
        GetStyle: *const fn (*IFont) callconv(.winapi) FONT_STYLE,
        IsSymbolFont: *const fn (*IFont) callconv(.winapi) windows.BOOL,
        GetFaceNames: *const fn (
            *IFont,
            **ILocalizedStrings,
        ) callconv(.winapi) windows.HRESULT,
        GetInformationalStrings: *const fn (
            *IFont,
            INFORMATIONAL_STRING_ID,
            *?*ILocalizedStrings,
            *windows.BOOL,
        ) callconv(.winapi) windows.HRESULT,
        GetSimulations: *const fn (
            *IFont,
        ) callconv(.winapi) FONT_SIMULATIONS,
        GetMetrics: *const fn (
            *IFont,
            *FONT_METRICS,
        ) callconv(.winapi) void,
        HasCharacter: *const fn (
            *IFont,
            windows.UINT32,
            *windows.BOOL,
        ) callconv(.winapi) windows.HRESULT,
        CreateFontFace: *const fn (
            *IFont,
            **IFontFace,
        ) callconv(.winapi) windows.HRESULT,
    };
};

const IFontFamily = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *IFontFamily,
            windows.REFIID,
            *?*anyopaque,
        ) callconv(.winapi) windows.HRESULT,
        AddRef: *const fn (*IFontFamily) callconv(.winapi) windows.ULONG,
        Release: *const fn (*IFontFamily) callconv(.winapi) windows.ULONG,

        GetFontCollection: *const fn (
            *IFontFamily,
            **IFontCollection,
        ) callconv(.winapi) windows.HRESULT,
        GetFontCount: *const fn (*IFontFamily) callconv(.winapi) windows.UINT32,
        GetFont: *const fn (
            *IFontFamily,
            windows.UINT32,
            **IFont,
        ) callconv(.winapi) windows.HRESULT,

        GetFamilyNames: *const fn (
            *IFontFamily,
            **ILocalizedStrings,
        ) callconv(.winapi) windows.HRESULT,
        GetFirstMatchingFont: *const fn (
            *IFontFamily,
            FONT_WEIGHT,
            FONT_STRETCH,
            FONT_STYLE,
            **IFont,
        ) callconv(.winapi) windows.HRESULT,
        GetMatchingFonts: *const fn (
            *IFontFamily,
            FONT_WEIGHT,
            FONT_STRETCH,
            FONT_STYLE,
            **IFontList,
        ) callconv(.winapi) windows.HRESULT,
    };
};

const ILocalizedStrings = extern struct {
    v: *const VTable,

    const VTable = extern struct {
        QueryInterface: *const fn (
            *ILocalizedStrings,
            windows.REFIID,
            *?*anyopaque,
        ) callconv(.winapi) windows.HRESULT,
        AddRef: *const fn (*ILocalizedStrings) callconv(.winapi) windows.ULONG,
        Release: *const fn (*ILocalizedStrings) callconv(.winapi) windows.ULONG,

        GetCount: *const fn (
            *ILocalizedStrings,
        ) callconv(.winapi) windows.UINT32,
        FindLocaleName: *const fn (
            *ILocalizedStrings,
            [*:0]const windows.WCHAR,
            *windows.UINT32,
            *windows.BOOL,
        ) callconv(.winapi) windows.HRESULT,
        GetLocaleNameLength: *const fn (
            *ILocalizedStrings,
            windows.UINT32,
            *windows.UINT32,
        ) callconv(.winapi) windows.HRESULT,
        GetLocaleName: *const fn (
            *ILocalizedStrings,
            windows.UINT32,
            [*:0]windows.WCHAR,
            windows.UINT32,
        ) callconv(.winapi) windows.HRESULT,
        GetStringLength: *const fn (
            *ILocalizedStrings,
            windows.UINT32,
            *windows.UINT32,
        ) callconv(.winapi) windows.HRESULT,
        GetString: *const fn (
            *ILocalizedStrings,
            windows.UINT32,
            [*:0]windows.WCHAR,
            windows.UINT32,
        ) callconv(.winapi) windows.HRESULT,
    };
};

const IGeometrySink = d2d1.ISimplifiedGeometrySink;
