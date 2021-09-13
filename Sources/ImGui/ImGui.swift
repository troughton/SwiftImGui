import CImGui

extension SIMD2 where Scalar == Float {
    @inlinable
    init(_ imVec: ImVec2) {
        self.init(imVec.x, imVec.y)
    }
}

extension SIMD4 where Scalar == Float {
    @inlinable
    init(_ imVec: ImVec4) {
        self.init(imVec.x, imVec.y, imVec.z, imVec.w)
    }
}

extension ImVec2 {
    @inlinable
    init(_ v: SIMD2<Float>) {
        self.init(x: v.x, y: v.y)
    }
}

extension ImVec4 {
    @inlinable
    init(_ v: SIMD4<Float>) {
        self.init(x: v.x, y: v.y, z: v.z, w: v.w)
    }
}

extension SIMD {
    @inlinable
    mutating func withMutableMemberPointer<R>(_ perform: (UnsafeMutablePointer<Scalar>) -> R) -> R {
        return withUnsafeMutableBytes(of: &self) { buffer in
            perform(buffer.baseAddress!.assumingMemoryBound(to: Scalar.self))
        }
    }
}

@inlinable
func withMutableMembers<T, R>(of tuple: inout (T, T),  _ perform: (UnsafeMutablePointer<T>) -> R) -> R {
    return withUnsafeMutableBytes(of: &tuple) { buffer in
        perform(buffer.baseAddress!.assumingMemoryBound(to: T.self))
    }
}

public enum ImGui {
    public struct Axis: OptionSet  {
        public var rawValue: Int32

        public init(rawValue: Self.RawValue) {
            self.rawValue = rawValue
        }

        public static var none: Axis { return Axis(rawValue: -1) }
        public static var y: Axis { return Axis(rawValue: 1) }
    }

    public struct BackendFlags: OptionSet  {
        public var rawValue: Int32

        public init(rawValue: Self.RawValue) {
            self.rawValue = rawValue
        }

        public static var hasGamepad: BackendFlags { return BackendFlags(rawValue: 1) }
        public static var hasMouseCursors: BackendFlags { return BackendFlags(rawValue: 2) }
        public static var hasSetMousePos: BackendFlags { return BackendFlags(rawValue: 4) }
        public static var rendererHasVtxOffset: BackendFlags { return BackendFlags(rawValue: 8) }
    }

    public struct ButtonFlags: OptionSet  {
        public var rawValue: Int32

        public init(rawValue: Self.RawValue) {
            self.rawValue = rawValue
        }

        public static var mouseButtonLeft: ButtonFlags { return ButtonFlags(rawValue: 1) }
        public static var mouseButtonRight: ButtonFlags { return ButtonFlags(rawValue: 2) }
        public static var mouseButtonMiddle: ButtonFlags { return ButtonFlags(rawValue: 4) }
        public static var mouseButtonMask: ButtonFlags { return ButtonFlags(rawValue: 7) }
        public static var mouseButtonDefault: ButtonFlags { return ButtonFlags(rawValue: 1) }
    }

    public struct ButtonFlagsPrivate: OptionSet  {
        public var rawValue: Int32

        public init(rawValue: Self.RawValue) {
            self.rawValue = rawValue
        }

        public static var pressedOnClick: ButtonFlagsPrivate { return ButtonFlagsPrivate(rawValue: 16) }
        public static var pressedOnClickRelease: ButtonFlagsPrivate { return ButtonFlagsPrivate(rawValue: 32) }
        public static var pressedOnClickReleaseAnywhere: ButtonFlagsPrivate { return ButtonFlagsPrivate(rawValue: 64) }
        public static var pressedOnRelease: ButtonFlagsPrivate { return ButtonFlagsPrivate(rawValue: 128) }
        public static var pressedOnDoubleClick: ButtonFlagsPrivate { return ButtonFlagsPrivate(rawValue: 256) }
        public static var pressedOnDragDropHold: ButtonFlagsPrivate { return ButtonFlagsPrivate(rawValue: 512) }
        public static var `repeat`: ButtonFlagsPrivate { return ButtonFlagsPrivate(rawValue: 1024) }
        public static var flattenChildren: ButtonFlagsPrivate { return ButtonFlagsPrivate(rawValue: 2048) }
        public static var allowItemOverlap: ButtonFlagsPrivate { return ButtonFlagsPrivate(rawValue: 4096) }
        public static var dontClosePopups: ButtonFlagsPrivate { return ButtonFlagsPrivate(rawValue: 8192) }
        public static var alignTextBaseLine: ButtonFlagsPrivate { return ButtonFlagsPrivate(rawValue: 32768) }
        public static var noKeyModifiers: ButtonFlagsPrivate { return ButtonFlagsPrivate(rawValue: 65536) }
        public static var noHoldingActiveId: ButtonFlagsPrivate { return ButtonFlagsPrivate(rawValue: 131072) }
        public static var noNavFocus: ButtonFlagsPrivate { return ButtonFlagsPrivate(rawValue: 262144) }
        public static var noHoveredOnFocus: ButtonFlagsPrivate { return ButtonFlagsPrivate(rawValue: 524288) }
        public static var pressedOnMask: ButtonFlagsPrivate { return ButtonFlagsPrivate(rawValue: 1008) }
        public static var pressedOnDefault: ButtonFlagsPrivate { return ButtonFlagsPrivate(rawValue: 32) }
    }

    public struct Color: OptionSet  {
        public var rawValue: Int32

        public init(rawValue: Self.RawValue) {
            self.rawValue = rawValue
        }

        public static var textDisabled: Color { return Color(rawValue: 1) }
        public static var windowBg: Color { return Color(rawValue: 2) }
        public static var childBg: Color { return Color(rawValue: 3) }
        public static var popupBg: Color { return Color(rawValue: 4) }
        public static var border: Color { return Color(rawValue: 5) }
        public static var borderShadow: Color { return Color(rawValue: 6) }
        public static var frameBg: Color { return Color(rawValue: 7) }
        public static var frameBgHovered: Color { return Color(rawValue: 8) }
        public static var frameBgActive: Color { return Color(rawValue: 9) }
        public static var titleBg: Color { return Color(rawValue: 10) }
        public static var titleBgActive: Color { return Color(rawValue: 11) }
        public static var titleBgCollapsed: Color { return Color(rawValue: 12) }
        public static var menuBarBg: Color { return Color(rawValue: 13) }
        public static var scrollbarBg: Color { return Color(rawValue: 14) }
        public static var scrollbarGrab: Color { return Color(rawValue: 15) }
        public static var scrollbarGrabHovered: Color { return Color(rawValue: 16) }
        public static var scrollbarGrabActive: Color { return Color(rawValue: 17) }
        public static var checkMark: Color { return Color(rawValue: 18) }
        public static var sliderGrab: Color { return Color(rawValue: 19) }
        public static var sliderGrabActive: Color { return Color(rawValue: 20) }
        public static var button: Color { return Color(rawValue: 21) }
        public static var buttonHovered: Color { return Color(rawValue: 22) }
        public static var buttonActive: Color { return Color(rawValue: 23) }
        public static var header: Color { return Color(rawValue: 24) }
        public static var headerHovered: Color { return Color(rawValue: 25) }
        public static var headerActive: Color { return Color(rawValue: 26) }
        public static var separator: Color { return Color(rawValue: 27) }
        public static var separatorHovered: Color { return Color(rawValue: 28) }
        public static var separatorActive: Color { return Color(rawValue: 29) }
        public static var resizeGrip: Color { return Color(rawValue: 30) }
        public static var resizeGripHovered: Color { return Color(rawValue: 31) }
        public static var resizeGripActive: Color { return Color(rawValue: 32) }
        public static var tab: Color { return Color(rawValue: 33) }
        public static var tabHovered: Color { return Color(rawValue: 34) }
        public static var tabActive: Color { return Color(rawValue: 35) }
        public static var tabUnfocused: Color { return Color(rawValue: 36) }
        public static var tabUnfocusedActive: Color { return Color(rawValue: 37) }
        public static var plotLines: Color { return Color(rawValue: 38) }
        public static var plotLinesHovered: Color { return Color(rawValue: 39) }
        public static var plotHistogram: Color { return Color(rawValue: 40) }
        public static var plotHistogramHovered: Color { return Color(rawValue: 41) }
        public static var tableHeaderBg: Color { return Color(rawValue: 42) }
        public static var tableBorderStrong: Color { return Color(rawValue: 43) }
        public static var tableBorderLight: Color { return Color(rawValue: 44) }
        public static var tableRowBg: Color { return Color(rawValue: 45) }
        public static var tableRowBgAlt: Color { return Color(rawValue: 46) }
        public static var textSelectedBg: Color { return Color(rawValue: 47) }
        public static var dragDropTarget: Color { return Color(rawValue: 48) }
        public static var navHighlight: Color { return Color(rawValue: 49) }
        public static var navWindowingHighlight: Color { return Color(rawValue: 50) }
        public static var navWindowingDimBg: Color { return Color(rawValue: 51) }
        public static var modalWindowDimBg: Color { return Color(rawValue: 52) }
    }

    public struct ColorEditFlags: OptionSet  {
        public var rawValue: Int32

        public init(rawValue: Self.RawValue) {
            self.rawValue = rawValue
        }

        public static var noAlpha: ColorEditFlags { return ColorEditFlags(rawValue: 2) }
        public static var noPicker: ColorEditFlags { return ColorEditFlags(rawValue: 4) }
        public static var noOptions: ColorEditFlags { return ColorEditFlags(rawValue: 8) }
        public static var noSmallPreview: ColorEditFlags { return ColorEditFlags(rawValue: 16) }
        public static var noInputs: ColorEditFlags { return ColorEditFlags(rawValue: 32) }
        public static var noTooltip: ColorEditFlags { return ColorEditFlags(rawValue: 64) }
        public static var noLabel: ColorEditFlags { return ColorEditFlags(rawValue: 128) }
        public static var noSidePreview: ColorEditFlags { return ColorEditFlags(rawValue: 256) }
        public static var noDragDrop: ColorEditFlags { return ColorEditFlags(rawValue: 512) }
        public static var noBorder: ColorEditFlags { return ColorEditFlags(rawValue: 1024) }
        public static var alphaBar: ColorEditFlags { return ColorEditFlags(rawValue: 65536) }
        public static var alphaPreview: ColorEditFlags { return ColorEditFlags(rawValue: 131072) }
        public static var alphaPreviewHalf: ColorEditFlags { return ColorEditFlags(rawValue: 262144) }
        public static var hDR: ColorEditFlags { return ColorEditFlags(rawValue: 524288) }
        public static var displayRGB: ColorEditFlags { return ColorEditFlags(rawValue: 1048576) }
        public static var displayHSV: ColorEditFlags { return ColorEditFlags(rawValue: 2097152) }
        public static var displayHex: ColorEditFlags { return ColorEditFlags(rawValue: 4194304) }
        public static var uint8: ColorEditFlags { return ColorEditFlags(rawValue: 8388608) }
        public static var float: ColorEditFlags { return ColorEditFlags(rawValue: 16777216) }
        public static var pickerHueBar: ColorEditFlags { return ColorEditFlags(rawValue: 33554432) }
        public static var pickerHueWheel: ColorEditFlags { return ColorEditFlags(rawValue: 67108864) }
        public static var inputRGB: ColorEditFlags { return ColorEditFlags(rawValue: 134217728) }
        public static var inputHSV: ColorEditFlags { return ColorEditFlags(rawValue: 268435456) }
        public static var defaultOptions: ColorEditFlags { return ColorEditFlags(rawValue: 177209344) }
        public static var displayMask: ColorEditFlags { return ColorEditFlags(rawValue: 7340032) }
        public static var dataTypeMask: ColorEditFlags { return ColorEditFlags(rawValue: 25165824) }
        public static var pickerMask: ColorEditFlags { return ColorEditFlags(rawValue: 100663296) }
        public static var inputMask: ColorEditFlags { return ColorEditFlags(rawValue: 402653184) }
    }

    public struct ComboFlags: OptionSet  {
        public var rawValue: Int32

        public init(rawValue: Self.RawValue) {
            self.rawValue = rawValue
        }

        public static var popupAlignLeft: ComboFlags { return ComboFlags(rawValue: 1) }
        public static var heightSmall: ComboFlags { return ComboFlags(rawValue: 2) }
        public static var heightRegular: ComboFlags { return ComboFlags(rawValue: 4) }
        public static var heightLarge: ComboFlags { return ComboFlags(rawValue: 8) }
        public static var heightLargest: ComboFlags { return ComboFlags(rawValue: 16) }
        public static var noArrowButton: ComboFlags { return ComboFlags(rawValue: 32) }
        public static var noPreview: ComboFlags { return ComboFlags(rawValue: 64) }
        public static var heightMask: ComboFlags { return ComboFlags(rawValue: 30) }
    }

    public struct ComboFlagsPrivate: OptionSet  {
        public var rawValue: Int32

        public init(rawValue: Self.RawValue) {
            self.rawValue = rawValue
        }

        public static var customPreview: ComboFlagsPrivate { return ComboFlagsPrivate(rawValue: 1048576) }
    }

    public struct Cond: OptionSet  {
        public var rawValue: Int32

        public init(rawValue: Self.RawValue) {
            self.rawValue = rawValue
        }

        public static var always: Cond { return Cond(rawValue: 1) }
        public static var once: Cond { return Cond(rawValue: 2) }
        public static var firstUseEver: Cond { return Cond(rawValue: 4) }
        public static var appearing: Cond { return Cond(rawValue: 8) }
    }

    public struct ConfigFlags: OptionSet  {
        public var rawValue: Int32

        public init(rawValue: Self.RawValue) {
            self.rawValue = rawValue
        }

        public static var navEnableKeyboard: ConfigFlags { return ConfigFlags(rawValue: 1) }
        public static var navEnableGamepad: ConfigFlags { return ConfigFlags(rawValue: 2) }
        public static var navEnableSetMousePos: ConfigFlags { return ConfigFlags(rawValue: 4) }
        public static var navNoCaptureKeyboard: ConfigFlags { return ConfigFlags(rawValue: 8) }
        public static var noMouse: ConfigFlags { return ConfigFlags(rawValue: 16) }
        public static var noMouseCursorChange: ConfigFlags { return ConfigFlags(rawValue: 32) }
        public static var isSRGB: ConfigFlags { return ConfigFlags(rawValue: 1048576) }
        public static var isTouchScreen: ConfigFlags { return ConfigFlags(rawValue: 2097152) }
    }

    public struct ContextHookType: OptionSet  {
        public var rawValue: Int32

        public init(rawValue: Self.RawValue) {
            self.rawValue = rawValue
        }

        public static var newFramePost: ContextHookType { return ContextHookType(rawValue: 1) }
        public static var endFramePre: ContextHookType { return ContextHookType(rawValue: 2) }
        public static var endFramePost: ContextHookType { return ContextHookType(rawValue: 3) }
        public static var renderPre: ContextHookType { return ContextHookType(rawValue: 4) }
        public static var renderPost: ContextHookType { return ContextHookType(rawValue: 5) }
        public static var shutdown: ContextHookType { return ContextHookType(rawValue: 6) }
        public static var pendingRemoval: ContextHookType { return ContextHookType(rawValue: 7) }
    }

    public struct DataType: OptionSet  {
        public var rawValue: Int32

        public init(rawValue: Self.RawValue) {
            self.rawValue = rawValue
        }

        public static var u8: DataType { return DataType(rawValue: 1) }
        public static var s16: DataType { return DataType(rawValue: 2) }
        public static var u16: DataType { return DataType(rawValue: 3) }
        public static var s32: DataType { return DataType(rawValue: 4) }
        public static var u32: DataType { return DataType(rawValue: 5) }
        public static var s64: DataType { return DataType(rawValue: 6) }
        public static var u64: DataType { return DataType(rawValue: 7) }
        public static var float: DataType { return DataType(rawValue: 8) }
        public static var double: DataType { return DataType(rawValue: 9) }
    }

    public struct DataTypePrivate: OptionSet  {
        public var rawValue: Int32

        public init(rawValue: Self.RawValue) {
            self.rawValue = rawValue
        }

        public static var string: DataTypePrivate { return DataTypePrivate(rawValue: 11) }
        public static var pointer: DataTypePrivate { return DataTypePrivate(rawValue: 12) }
        public static var iD: DataTypePrivate { return DataTypePrivate(rawValue: 13) }
    }

    public struct Dir: OptionSet  {
        public var rawValue: Int32

        public init(rawValue: Self.RawValue) {
            self.rawValue = rawValue
        }

        public static var none: Dir { return Dir(rawValue: -1) }
        public static var right: Dir { return Dir(rawValue: 1) }
        public static var up: Dir { return Dir(rawValue: 2) }
        public static var down: Dir { return Dir(rawValue: 3) }
    }

    public struct DragDropFlags: OptionSet  {
        public var rawValue: Int32

        public init(rawValue: Self.RawValue) {
            self.rawValue = rawValue
        }

        public static var sourceNoPreviewTooltip: DragDropFlags { return DragDropFlags(rawValue: 1) }
        public static var sourceNoDisableHover: DragDropFlags { return DragDropFlags(rawValue: 2) }
        public static var sourceNoHoldToOpenOthers: DragDropFlags { return DragDropFlags(rawValue: 4) }
        public static var sourceAllowNullID: DragDropFlags { return DragDropFlags(rawValue: 8) }
        public static var sourceExtern: DragDropFlags { return DragDropFlags(rawValue: 16) }
        public static var sourceAutoExpirePayload: DragDropFlags { return DragDropFlags(rawValue: 32) }
        public static var acceptBeforeDelivery: DragDropFlags { return DragDropFlags(rawValue: 1024) }
        public static var acceptNoDrawDefaultRect: DragDropFlags { return DragDropFlags(rawValue: 2048) }
        public static var acceptNoPreviewTooltip: DragDropFlags { return DragDropFlags(rawValue: 4096) }
        public static var acceptPeekOnly: DragDropFlags { return DragDropFlags(rawValue: 3072) }
    }

    public struct DrawFlags: OptionSet  {
        public var rawValue: Int32

        public init(rawValue: Self.RawValue) {
            self.rawValue = rawValue
        }

        public static var closed: DrawFlags { return DrawFlags(rawValue: 1) }
        public static var roundCornersTopLeft: DrawFlags { return DrawFlags(rawValue: 16) }
        public static var roundCornersTopRight: DrawFlags { return DrawFlags(rawValue: 32) }
        public static var roundCornersBottomLeft: DrawFlags { return DrawFlags(rawValue: 64) }
        public static var roundCornersBottomRight: DrawFlags { return DrawFlags(rawValue: 128) }
        public static var roundCornersNone: DrawFlags { return DrawFlags(rawValue: 256) }
        public static var roundCornersTop: DrawFlags { return DrawFlags(rawValue: 48) }
        public static var roundCornersBottom: DrawFlags { return DrawFlags(rawValue: 192) }
        public static var roundCornersLeft: DrawFlags { return DrawFlags(rawValue: 80) }
        public static var roundCornersRight: DrawFlags { return DrawFlags(rawValue: 160) }
        public static var roundCornersAll: DrawFlags { return DrawFlags(rawValue: 240) }
        public static var roundCornersDefault: DrawFlags { return DrawFlags(rawValue: 240) }
        public static var roundCornersMask: DrawFlags { return DrawFlags(rawValue: 496) }
    }

    public struct DrawListFlags: OptionSet  {
        public var rawValue: Int32

        public init(rawValue: Self.RawValue) {
            self.rawValue = rawValue
        }

        public static var antiAliasedLines: DrawListFlags { return DrawListFlags(rawValue: 1) }
        public static var antiAliasedLinesUseTex: DrawListFlags { return DrawListFlags(rawValue: 2) }
        public static var antiAliasedFill: DrawListFlags { return DrawListFlags(rawValue: 4) }
        public static var allowVtxOffset: DrawListFlags { return DrawListFlags(rawValue: 8) }
    }

    public struct FocusedFlags: OptionSet  {
        public var rawValue: Int32

        public init(rawValue: Self.RawValue) {
            self.rawValue = rawValue
        }

        public static var childWindows: FocusedFlags { return FocusedFlags(rawValue: 1) }
        public static var rootWindow: FocusedFlags { return FocusedFlags(rawValue: 2) }
        public static var anyWindow: FocusedFlags { return FocusedFlags(rawValue: 4) }
        public static var rootAndChildWindows: FocusedFlags { return FocusedFlags(rawValue: 3) }
    }

    public struct FontAtlasFlags: OptionSet  {
        public var rawValue: Int32

        public init(rawValue: Self.RawValue) {
            self.rawValue = rawValue
        }

        public static var noPowerOfTwoHeight: FontAtlasFlags { return FontAtlasFlags(rawValue: 1) }
        public static var noMouseCursors: FontAtlasFlags { return FontAtlasFlags(rawValue: 2) }
        public static var noBakedLines: FontAtlasFlags { return FontAtlasFlags(rawValue: 4) }
    }

    public struct HoveredFlags: OptionSet  {
        public var rawValue: Int32

        public init(rawValue: Self.RawValue) {
            self.rawValue = rawValue
        }

        public static var childWindows: HoveredFlags { return HoveredFlags(rawValue: 1) }
        public static var rootWindow: HoveredFlags { return HoveredFlags(rawValue: 2) }
        public static var anyWindow: HoveredFlags { return HoveredFlags(rawValue: 4) }
        public static var allowWhenBlockedByPopup: HoveredFlags { return HoveredFlags(rawValue: 8) }
        public static var allowWhenBlockedByActiveItem: HoveredFlags { return HoveredFlags(rawValue: 32) }
        public static var allowWhenOverlapped: HoveredFlags { return HoveredFlags(rawValue: 64) }
        public static var allowWhenDisabled: HoveredFlags { return HoveredFlags(rawValue: 128) }
        public static var rectOnly: HoveredFlags { return HoveredFlags(rawValue: 104) }
        public static var rootAndChildWindows: HoveredFlags { return HoveredFlags(rawValue: 3) }
    }

    public struct InputReadMode: OptionSet  {
        public var rawValue: Int32

        public init(rawValue: Self.RawValue) {
            self.rawValue = rawValue
        }

        public static var pressed: InputReadMode { return InputReadMode(rawValue: 1) }
        public static var released: InputReadMode { return InputReadMode(rawValue: 2) }
        public static var `repeat`: InputReadMode { return InputReadMode(rawValue: 3) }
        public static var repeatSlow: InputReadMode { return InputReadMode(rawValue: 4) }
        public static var repeatFast: InputReadMode { return InputReadMode(rawValue: 5) }
    }

    public struct InputSource: OptionSet  {
        public var rawValue: Int32

        public init(rawValue: Self.RawValue) {
            self.rawValue = rawValue
        }

        public static var mouse: InputSource { return InputSource(rawValue: 1) }
        public static var keyboard: InputSource { return InputSource(rawValue: 2) }
        public static var gamepad: InputSource { return InputSource(rawValue: 3) }
        public static var nav: InputSource { return InputSource(rawValue: 4) }
        public static var clipboard: InputSource { return InputSource(rawValue: 5) }
    }

    public struct InputTextFlags: OptionSet  {
        public var rawValue: Int32

        public init(rawValue: Self.RawValue) {
            self.rawValue = rawValue
        }

        public static var charsDecimal: InputTextFlags { return InputTextFlags(rawValue: 1) }
        public static var charsHexadecimal: InputTextFlags { return InputTextFlags(rawValue: 2) }
        public static var charsUppercase: InputTextFlags { return InputTextFlags(rawValue: 4) }
        public static var charsNoBlank: InputTextFlags { return InputTextFlags(rawValue: 8) }
        public static var autoSelectAll: InputTextFlags { return InputTextFlags(rawValue: 16) }
        public static var enterReturnsTrue: InputTextFlags { return InputTextFlags(rawValue: 32) }
        public static var callbackCompletion: InputTextFlags { return InputTextFlags(rawValue: 64) }
        public static var callbackHistory: InputTextFlags { return InputTextFlags(rawValue: 128) }
        public static var callbackAlways: InputTextFlags { return InputTextFlags(rawValue: 256) }
        public static var callbackCharFilter: InputTextFlags { return InputTextFlags(rawValue: 512) }
        public static var allowTabInput: InputTextFlags { return InputTextFlags(rawValue: 1024) }
        public static var ctrlEnterForNewLine: InputTextFlags { return InputTextFlags(rawValue: 2048) }
        public static var noHorizontalScroll: InputTextFlags { return InputTextFlags(rawValue: 4096) }
        public static var alwaysOverwrite: InputTextFlags { return InputTextFlags(rawValue: 8192) }
        public static var readOnly: InputTextFlags { return InputTextFlags(rawValue: 16384) }
        public static var password: InputTextFlags { return InputTextFlags(rawValue: 32768) }
        public static var noUndoRedo: InputTextFlags { return InputTextFlags(rawValue: 65536) }
        public static var charsScientific: InputTextFlags { return InputTextFlags(rawValue: 131072) }
        public static var callbackResize: InputTextFlags { return InputTextFlags(rawValue: 262144) }
        public static var callbackEdit: InputTextFlags { return InputTextFlags(rawValue: 524288) }
    }

    public struct InputTextFlagsPrivate: OptionSet  {
        public var rawValue: Int32

        public init(rawValue: Self.RawValue) {
            self.rawValue = rawValue
        }

        public static var multiline: InputTextFlagsPrivate { return InputTextFlagsPrivate(rawValue: 67108864) }
        public static var noMarkEdited: InputTextFlagsPrivate { return InputTextFlagsPrivate(rawValue: 134217728) }
        public static var mergedItem: InputTextFlagsPrivate { return InputTextFlagsPrivate(rawValue: 268435456) }
    }

    public struct ItemAddFlags: OptionSet  {
        public var rawValue: Int32

        public init(rawValue: Self.RawValue) {
            self.rawValue = rawValue
        }

        public static var focusable: ItemAddFlags { return ItemAddFlags(rawValue: 1) }
    }

    public struct ItemFlags: OptionSet  {
        public var rawValue: Int32

        public init(rawValue: Self.RawValue) {
            self.rawValue = rawValue
        }

        public static var noTabStop: ItemFlags { return ItemFlags(rawValue: 1) }
        public static var buttonRepeat: ItemFlags { return ItemFlags(rawValue: 2) }
        public static var disabled: ItemFlags { return ItemFlags(rawValue: 4) }
        public static var noNav: ItemFlags { return ItemFlags(rawValue: 8) }
        public static var noNavDefaultFocus: ItemFlags { return ItemFlags(rawValue: 16) }
        public static var selectableDontClosePopup: ItemFlags { return ItemFlags(rawValue: 32) }
        public static var mixedValue: ItemFlags { return ItemFlags(rawValue: 64) }
        public static var readOnly: ItemFlags { return ItemFlags(rawValue: 128) }
    }

    public struct ItemStatusFlags: OptionSet  {
        public var rawValue: Int32

        public init(rawValue: Self.RawValue) {
            self.rawValue = rawValue
        }

        public static var hoveredRect: ItemStatusFlags { return ItemStatusFlags(rawValue: 1) }
        public static var hasDisplayRect: ItemStatusFlags { return ItemStatusFlags(rawValue: 2) }
        public static var edited: ItemStatusFlags { return ItemStatusFlags(rawValue: 4) }
        public static var toggledSelection: ItemStatusFlags { return ItemStatusFlags(rawValue: 8) }
        public static var toggledOpen: ItemStatusFlags { return ItemStatusFlags(rawValue: 16) }
        public static var hasDeactivated: ItemStatusFlags { return ItemStatusFlags(rawValue: 32) }
        public static var deactivated: ItemStatusFlags { return ItemStatusFlags(rawValue: 64) }
        public static var hoveredWindow: ItemStatusFlags { return ItemStatusFlags(rawValue: 128) }
        public static var focusedByCode: ItemStatusFlags { return ItemStatusFlags(rawValue: 256) }
        public static var focusedByTabbing: ItemStatusFlags { return ItemStatusFlags(rawValue: 512) }
        public static var focused: ItemStatusFlags { return ItemStatusFlags(rawValue: 768) }
    }

    public struct Key: OptionSet  {
        public var rawValue: Int32

        public init(rawValue: Self.RawValue) {
            self.rawValue = rawValue
        }

        public static var leftArrow: Key { return Key(rawValue: 1) }
        public static var rightArrow: Key { return Key(rawValue: 2) }
        public static var upArrow: Key { return Key(rawValue: 3) }
        public static var downArrow: Key { return Key(rawValue: 4) }
        public static var pageUp: Key { return Key(rawValue: 5) }
        public static var pageDown: Key { return Key(rawValue: 6) }
        public static var home: Key { return Key(rawValue: 7) }
        public static var end: Key { return Key(rawValue: 8) }
        public static var insert: Key { return Key(rawValue: 9) }
        public static var delete: Key { return Key(rawValue: 10) }
        public static var backspace: Key { return Key(rawValue: 11) }
        public static var space: Key { return Key(rawValue: 12) }
        public static var enter: Key { return Key(rawValue: 13) }
        public static var escape: Key { return Key(rawValue: 14) }
        public static var keyPadEnter: Key { return Key(rawValue: 15) }
        public static var a: Key { return Key(rawValue: 16) }
        public static var c: Key { return Key(rawValue: 17) }
        public static var v: Key { return Key(rawValue: 18) }
        public static var x: Key { return Key(rawValue: 19) }
        public static var y: Key { return Key(rawValue: 20) }
        public static var z: Key { return Key(rawValue: 21) }
    }

    public struct KeyModFlags: OptionSet  {
        public var rawValue: Int32

        public init(rawValue: Self.RawValue) {
            self.rawValue = rawValue
        }

        public static var ctrl: KeyModFlags { return KeyModFlags(rawValue: 1) }
        public static var shift: KeyModFlags { return KeyModFlags(rawValue: 2) }
        public static var alt: KeyModFlags { return KeyModFlags(rawValue: 4) }
        public static var `super`: KeyModFlags { return KeyModFlags(rawValue: 8) }
    }

    public struct LayoutType: OptionSet  {
        public var rawValue: Int32

        public init(rawValue: Self.RawValue) {
            self.rawValue = rawValue
        }

        public static var vertical: LayoutType { return LayoutType(rawValue: 1) }
    }

    public struct LogType: OptionSet  {
        public var rawValue: Int32

        public init(rawValue: Self.RawValue) {
            self.rawValue = rawValue
        }

        public static var tTY: LogType { return LogType(rawValue: 1) }
        public static var file: LogType { return LogType(rawValue: 2) }
        public static var buffer: LogType { return LogType(rawValue: 3) }
        public static var clipboard: LogType { return LogType(rawValue: 4) }
    }

    public struct MouseButton: OptionSet  {
        public var rawValue: Int32

        public init(rawValue: Self.RawValue) {
            self.rawValue = rawValue
        }

        public static var right: MouseButton { return MouseButton(rawValue: 1) }
        public static var middle: MouseButton { return MouseButton(rawValue: 2) }
    }

    public struct MouseCursor: OptionSet  {
        public var rawValue: Int32

        public init(rawValue: Self.RawValue) {
            self.rawValue = rawValue
        }

        public static var none: MouseCursor { return MouseCursor(rawValue: -1) }
        public static var textInput: MouseCursor { return MouseCursor(rawValue: 1) }
        public static var resizeAll: MouseCursor { return MouseCursor(rawValue: 2) }
        public static var resizeNS: MouseCursor { return MouseCursor(rawValue: 3) }
        public static var resizeEW: MouseCursor { return MouseCursor(rawValue: 4) }
        public static var resizeNESW: MouseCursor { return MouseCursor(rawValue: 5) }
        public static var resizeNWSE: MouseCursor { return MouseCursor(rawValue: 6) }
        public static var hand: MouseCursor { return MouseCursor(rawValue: 7) }
        public static var notAllowed: MouseCursor { return MouseCursor(rawValue: 8) }
    }

    public struct NavDirSourceFlags: OptionSet  {
        public var rawValue: Int32

        public init(rawValue: Self.RawValue) {
            self.rawValue = rawValue
        }

        public static var keyboard: NavDirSourceFlags { return NavDirSourceFlags(rawValue: 1) }
        public static var padDPad: NavDirSourceFlags { return NavDirSourceFlags(rawValue: 2) }
        public static var padLStick: NavDirSourceFlags { return NavDirSourceFlags(rawValue: 4) }
    }

    public struct NavForward: OptionSet  {
        public var rawValue: Int32

        public init(rawValue: Self.RawValue) {
            self.rawValue = rawValue
        }

        public static var forwardQueued: NavForward { return NavForward(rawValue: 1) }
        public static var forwardActive: NavForward { return NavForward(rawValue: 2) }
    }

    public struct NavHighlightFlags: OptionSet  {
        public var rawValue: Int32

        public init(rawValue: Self.RawValue) {
            self.rawValue = rawValue
        }

        public static var typeDefault: NavHighlightFlags { return NavHighlightFlags(rawValue: 1) }
        public static var typeThin: NavHighlightFlags { return NavHighlightFlags(rawValue: 2) }
        public static var alwaysDraw: NavHighlightFlags { return NavHighlightFlags(rawValue: 4) }
        public static var noRounding: NavHighlightFlags { return NavHighlightFlags(rawValue: 8) }
    }

    public struct NavInput: OptionSet  {
        public var rawValue: Int32

        public init(rawValue: Self.RawValue) {
            self.rawValue = rawValue
        }

        public static var cancel: NavInput { return NavInput(rawValue: 1) }
        public static var input: NavInput { return NavInput(rawValue: 2) }
        public static var menu: NavInput { return NavInput(rawValue: 3) }
        public static var dpadLeft: NavInput { return NavInput(rawValue: 4) }
        public static var dpadRight: NavInput { return NavInput(rawValue: 5) }
        public static var dpadUp: NavInput { return NavInput(rawValue: 6) }
        public static var dpadDown: NavInput { return NavInput(rawValue: 7) }
        public static var lStickLeft: NavInput { return NavInput(rawValue: 8) }
        public static var lStickRight: NavInput { return NavInput(rawValue: 9) }
        public static var lStickUp: NavInput { return NavInput(rawValue: 10) }
        public static var lStickDown: NavInput { return NavInput(rawValue: 11) }
        public static var focusPrev: NavInput { return NavInput(rawValue: 12) }
        public static var focusNext: NavInput { return NavInput(rawValue: 13) }
        public static var tweakSlow: NavInput { return NavInput(rawValue: 14) }
        public static var tweakFast: NavInput { return NavInput(rawValue: 15) }
        public static var keyLeft: NavInput { return NavInput(rawValue: 16) }
        public static var keyRight: NavInput { return NavInput(rawValue: 17) }
        public static var keyUp: NavInput { return NavInput(rawValue: 18) }
        public static var keyDown: NavInput { return NavInput(rawValue: 19) }
        public static var internalStart: NavInput { return NavInput(rawValue: 16) }
    }

    public struct NavLayer: OptionSet  {
        public var rawValue: Int32

        public init(rawValue: Self.RawValue) {
            self.rawValue = rawValue
        }

        public static var menu: NavLayer { return NavLayer(rawValue: 1) }
    }

    public struct NavMoveFlags: OptionSet  {
        public var rawValue: Int32

        public init(rawValue: Self.RawValue) {
            self.rawValue = rawValue
        }

        public static var loopX: NavMoveFlags { return NavMoveFlags(rawValue: 1) }
        public static var loopY: NavMoveFlags { return NavMoveFlags(rawValue: 2) }
        public static var wrapX: NavMoveFlags { return NavMoveFlags(rawValue: 4) }
        public static var wrapY: NavMoveFlags { return NavMoveFlags(rawValue: 8) }
        public static var allowCurrentNavId: NavMoveFlags { return NavMoveFlags(rawValue: 16) }
        public static var alsoScoreVisibleSet: NavMoveFlags { return NavMoveFlags(rawValue: 32) }
        public static var scrollToEdge: NavMoveFlags { return NavMoveFlags(rawValue: 64) }
    }

    public struct NextItemDataFlags: OptionSet  {
        public var rawValue: Int32

        public init(rawValue: Self.RawValue) {
            self.rawValue = rawValue
        }

        public static var hasWidth: NextItemDataFlags { return NextItemDataFlags(rawValue: 1) }
        public static var hasOpen: NextItemDataFlags { return NextItemDataFlags(rawValue: 2) }
    }

    public struct NextWindowDataFlags: OptionSet  {
        public var rawValue: Int32

        public init(rawValue: Self.RawValue) {
            self.rawValue = rawValue
        }

        public static var hasPos: NextWindowDataFlags { return NextWindowDataFlags(rawValue: 1) }
        public static var hasSize: NextWindowDataFlags { return NextWindowDataFlags(rawValue: 2) }
        public static var hasContentSize: NextWindowDataFlags { return NextWindowDataFlags(rawValue: 4) }
        public static var hasCollapsed: NextWindowDataFlags { return NextWindowDataFlags(rawValue: 8) }
        public static var hasSizeConstraint: NextWindowDataFlags { return NextWindowDataFlags(rawValue: 16) }
        public static var hasFocus: NextWindowDataFlags { return NextWindowDataFlags(rawValue: 32) }
        public static var hasBgAlpha: NextWindowDataFlags { return NextWindowDataFlags(rawValue: 64) }
        public static var hasScroll: NextWindowDataFlags { return NextWindowDataFlags(rawValue: 128) }
    }

    public struct OldColumnFlags: OptionSet  {
        public var rawValue: Int32

        public init(rawValue: Self.RawValue) {
            self.rawValue = rawValue
        }

        public static var noBorder: OldColumnFlags { return OldColumnFlags(rawValue: 1) }
        public static var noResize: OldColumnFlags { return OldColumnFlags(rawValue: 2) }
        public static var noPreserveWidths: OldColumnFlags { return OldColumnFlags(rawValue: 4) }
        public static var noForceWithinWindow: OldColumnFlags { return OldColumnFlags(rawValue: 8) }
        public static var growParentContentsSize: OldColumnFlags { return OldColumnFlags(rawValue: 16) }
    }

    public struct PlotType: OptionSet  {
        public var rawValue: Int32

        public init(rawValue: Self.RawValue) {
            self.rawValue = rawValue
        }

        public static var histogram: PlotType { return PlotType(rawValue: 1) }
    }

    public struct PopupFlags: OptionSet  {
        public var rawValue: Int32

        public init(rawValue: Self.RawValue) {
            self.rawValue = rawValue
        }

        public static var mouseButtonRight: PopupFlags { return PopupFlags(rawValue: 1) }
        public static var mouseButtonMiddle: PopupFlags { return PopupFlags(rawValue: 2) }
        public static var mouseButtonMask: PopupFlags { return PopupFlags(rawValue: 31) }
        public static var mouseButtonDefault: PopupFlags { return PopupFlags(rawValue: 1) }
        public static var noOpenOverExistingPopup: PopupFlags { return PopupFlags(rawValue: 32) }
        public static var noOpenOverItems: PopupFlags { return PopupFlags(rawValue: 64) }
        public static var anyPopupId: PopupFlags { return PopupFlags(rawValue: 128) }
        public static var anyPopupLevel: PopupFlags { return PopupFlags(rawValue: 256) }
        public static var anyPopup: PopupFlags { return PopupFlags(rawValue: 384) }
    }

    public struct PopupPositionPolicy: OptionSet  {
        public var rawValue: Int32

        public init(rawValue: Self.RawValue) {
            self.rawValue = rawValue
        }

        public static var comboBox: PopupPositionPolicy { return PopupPositionPolicy(rawValue: 1) }
        public static var tooltip: PopupPositionPolicy { return PopupPositionPolicy(rawValue: 2) }
    }

    public struct SelectableFlags: OptionSet  {
        public var rawValue: Int32

        public init(rawValue: Self.RawValue) {
            self.rawValue = rawValue
        }

        public static var dontClosePopups: SelectableFlags { return SelectableFlags(rawValue: 1) }
        public static var spanAllColumns: SelectableFlags { return SelectableFlags(rawValue: 2) }
        public static var allowDoubleClick: SelectableFlags { return SelectableFlags(rawValue: 4) }
        public static var disabled: SelectableFlags { return SelectableFlags(rawValue: 8) }
        public static var allowItemOverlap: SelectableFlags { return SelectableFlags(rawValue: 16) }
    }

    public struct SelectableFlagsPrivate: OptionSet  {
        public var rawValue: Int32

        public init(rawValue: Self.RawValue) {
            self.rawValue = rawValue
        }

        public static var noHoldingActiveID: SelectableFlagsPrivate { return SelectableFlagsPrivate(rawValue: 1048576) }
        public static var selectOnNav: SelectableFlagsPrivate { return SelectableFlagsPrivate(rawValue: 2097152) }
        public static var selectOnClick: SelectableFlagsPrivate { return SelectableFlagsPrivate(rawValue: 4194304) }
        public static var selectOnRelease: SelectableFlagsPrivate { return SelectableFlagsPrivate(rawValue: 8388608) }
        public static var spanAvailWidth: SelectableFlagsPrivate { return SelectableFlagsPrivate(rawValue: 16777216) }
        public static var drawHoveredWhenHeld: SelectableFlagsPrivate { return SelectableFlagsPrivate(rawValue: 33554432) }
        public static var setNavIdOnHover: SelectableFlagsPrivate { return SelectableFlagsPrivate(rawValue: 67108864) }
        public static var noPadWithHalfSpacing: SelectableFlagsPrivate { return SelectableFlagsPrivate(rawValue: 134217728) }
    }

    public struct SeparatorFlags: OptionSet  {
        public var rawValue: Int32

        public init(rawValue: Self.RawValue) {
            self.rawValue = rawValue
        }

        public static var horizontal: SeparatorFlags { return SeparatorFlags(rawValue: 1) }
        public static var vertical: SeparatorFlags { return SeparatorFlags(rawValue: 2) }
        public static var spanAllColumns: SeparatorFlags { return SeparatorFlags(rawValue: 4) }
    }

    public struct SliderFlags: OptionSet  {
        public var rawValue: Int32

        public init(rawValue: Self.RawValue) {
            self.rawValue = rawValue
        }

        public static var alwaysClamp: SliderFlags { return SliderFlags(rawValue: 16) }
        public static var logarithmic: SliderFlags { return SliderFlags(rawValue: 32) }
        public static var noRoundToFormat: SliderFlags { return SliderFlags(rawValue: 64) }
        public static var noInput: SliderFlags { return SliderFlags(rawValue: 128) }
        public static var invalidMask: SliderFlags { return SliderFlags(rawValue: 1879048207) }
    }

    public struct SliderFlagsPrivate: OptionSet  {
        public var rawValue: Int32

        public init(rawValue: Self.RawValue) {
            self.rawValue = rawValue
        }

        public static var vertical: SliderFlagsPrivate { return SliderFlagsPrivate(rawValue: 1048576) }
        public static var readOnly: SliderFlagsPrivate { return SliderFlagsPrivate(rawValue: 2097152) }
    }

    public struct SortDirection: OptionSet  {
        public var rawValue: Int32

        public init(rawValue: Self.RawValue) {
            self.rawValue = rawValue
        }

        public static var ascending: SortDirection { return SortDirection(rawValue: 1) }
        public static var descending: SortDirection { return SortDirection(rawValue: 2) }
    }

    public struct StyleVar: OptionSet  {
        public var rawValue: Int32

        public init(rawValue: Self.RawValue) {
            self.rawValue = rawValue
        }

        public static var disabledAlpha: StyleVar { return StyleVar(rawValue: 1) }
        public static var windowPadding: StyleVar { return StyleVar(rawValue: 2) }
        public static var windowRounding: StyleVar { return StyleVar(rawValue: 3) }
        public static var windowBorderSize: StyleVar { return StyleVar(rawValue: 4) }
        public static var windowMinSize: StyleVar { return StyleVar(rawValue: 5) }
        public static var windowTitleAlign: StyleVar { return StyleVar(rawValue: 6) }
        public static var childRounding: StyleVar { return StyleVar(rawValue: 7) }
        public static var childBorderSize: StyleVar { return StyleVar(rawValue: 8) }
        public static var popupRounding: StyleVar { return StyleVar(rawValue: 9) }
        public static var popupBorderSize: StyleVar { return StyleVar(rawValue: 10) }
        public static var framePadding: StyleVar { return StyleVar(rawValue: 11) }
        public static var frameRounding: StyleVar { return StyleVar(rawValue: 12) }
        public static var frameBorderSize: StyleVar { return StyleVar(rawValue: 13) }
        public static var itemSpacing: StyleVar { return StyleVar(rawValue: 14) }
        public static var itemInnerSpacing: StyleVar { return StyleVar(rawValue: 15) }
        public static var indentSpacing: StyleVar { return StyleVar(rawValue: 16) }
        public static var cellPadding: StyleVar { return StyleVar(rawValue: 17) }
        public static var scrollbarSize: StyleVar { return StyleVar(rawValue: 18) }
        public static var scrollbarRounding: StyleVar { return StyleVar(rawValue: 19) }
        public static var grabMinSize: StyleVar { return StyleVar(rawValue: 20) }
        public static var grabRounding: StyleVar { return StyleVar(rawValue: 21) }
        public static var tabRounding: StyleVar { return StyleVar(rawValue: 22) }
        public static var buttonTextAlign: StyleVar { return StyleVar(rawValue: 23) }
        public static var selectableTextAlign: StyleVar { return StyleVar(rawValue: 24) }
    }

    public struct TabBarFlags: OptionSet  {
        public var rawValue: Int32

        public init(rawValue: Self.RawValue) {
            self.rawValue = rawValue
        }

        public static var reorderable: TabBarFlags { return TabBarFlags(rawValue: 1) }
        public static var autoSelectNewTabs: TabBarFlags { return TabBarFlags(rawValue: 2) }
        public static var tabListPopupButton: TabBarFlags { return TabBarFlags(rawValue: 4) }
        public static var noCloseWithMiddleMouseButton: TabBarFlags { return TabBarFlags(rawValue: 8) }
        public static var noTabListScrollingButtons: TabBarFlags { return TabBarFlags(rawValue: 16) }
        public static var noTooltip: TabBarFlags { return TabBarFlags(rawValue: 32) }
        public static var fittingPolicyResizeDown: TabBarFlags { return TabBarFlags(rawValue: 64) }
        public static var fittingPolicyScroll: TabBarFlags { return TabBarFlags(rawValue: 128) }
        public static var fittingPolicyMask: TabBarFlags { return TabBarFlags(rawValue: 192) }
        public static var fittingPolicyDefault: TabBarFlags { return TabBarFlags(rawValue: 64) }
    }

    public struct TabBarFlagsPrivate: OptionSet  {
        public var rawValue: Int32

        public init(rawValue: Self.RawValue) {
            self.rawValue = rawValue
        }

        public static var dockNode: TabBarFlagsPrivate { return TabBarFlagsPrivate(rawValue: 1048576) }
        public static var isFocused: TabBarFlagsPrivate { return TabBarFlagsPrivate(rawValue: 2097152) }
        public static var saveSettings: TabBarFlagsPrivate { return TabBarFlagsPrivate(rawValue: 4194304) }
    }

    public struct TabItemFlags: OptionSet  {
        public var rawValue: Int32

        public init(rawValue: Self.RawValue) {
            self.rawValue = rawValue
        }

        public static var unsavedDocument: TabItemFlags { return TabItemFlags(rawValue: 1) }
        public static var setSelected: TabItemFlags { return TabItemFlags(rawValue: 2) }
        public static var noCloseWithMiddleMouseButton: TabItemFlags { return TabItemFlags(rawValue: 4) }
        public static var noPushId: TabItemFlags { return TabItemFlags(rawValue: 8) }
        public static var noTooltip: TabItemFlags { return TabItemFlags(rawValue: 16) }
        public static var noReorder: TabItemFlags { return TabItemFlags(rawValue: 32) }
        public static var leading: TabItemFlags { return TabItemFlags(rawValue: 64) }
        public static var trailing: TabItemFlags { return TabItemFlags(rawValue: 128) }
    }

    public struct TabItemFlagsPrivate: OptionSet  {
        public var rawValue: Int32

        public init(rawValue: Self.RawValue) {
            self.rawValue = rawValue
        }

        public static var sectionMask: TabItemFlagsPrivate { return TabItemFlagsPrivate(rawValue: 192) }
        public static var noCloseButton: TabItemFlagsPrivate { return TabItemFlagsPrivate(rawValue: 1048576) }
        public static var button: TabItemFlagsPrivate { return TabItemFlagsPrivate(rawValue: 2097152) }
    }

    public struct TableBgTarget: OptionSet  {
        public var rawValue: Int32

        public init(rawValue: Self.RawValue) {
            self.rawValue = rawValue
        }

        public static var rowBg0: TableBgTarget { return TableBgTarget(rawValue: 1) }
        public static var rowBg1: TableBgTarget { return TableBgTarget(rawValue: 2) }
        public static var cellBg: TableBgTarget { return TableBgTarget(rawValue: 3) }
    }

    public struct TableColumnFlags: OptionSet  {
        public var rawValue: Int32

        public init(rawValue: Self.RawValue) {
            self.rawValue = rawValue
        }

        public static var disabled: TableColumnFlags { return TableColumnFlags(rawValue: 1) }
        public static var defaultHide: TableColumnFlags { return TableColumnFlags(rawValue: 2) }
        public static var defaultSort: TableColumnFlags { return TableColumnFlags(rawValue: 4) }
        public static var widthStretch: TableColumnFlags { return TableColumnFlags(rawValue: 8) }
        public static var widthFixed: TableColumnFlags { return TableColumnFlags(rawValue: 16) }
        public static var noResize: TableColumnFlags { return TableColumnFlags(rawValue: 32) }
        public static var noReorder: TableColumnFlags { return TableColumnFlags(rawValue: 64) }
        public static var noHide: TableColumnFlags { return TableColumnFlags(rawValue: 128) }
        public static var noClip: TableColumnFlags { return TableColumnFlags(rawValue: 256) }
        public static var noSort: TableColumnFlags { return TableColumnFlags(rawValue: 512) }
        public static var noSortAscending: TableColumnFlags { return TableColumnFlags(rawValue: 1024) }
        public static var noSortDescending: TableColumnFlags { return TableColumnFlags(rawValue: 2048) }
        public static var noHeaderLabel: TableColumnFlags { return TableColumnFlags(rawValue: 4096) }
        public static var noHeaderWidth: TableColumnFlags { return TableColumnFlags(rawValue: 8192) }
        public static var preferSortAscending: TableColumnFlags { return TableColumnFlags(rawValue: 16384) }
        public static var preferSortDescending: TableColumnFlags { return TableColumnFlags(rawValue: 32768) }
        public static var indentEnable: TableColumnFlags { return TableColumnFlags(rawValue: 65536) }
        public static var indentDisable: TableColumnFlags { return TableColumnFlags(rawValue: 131072) }
        public static var isEnabled: TableColumnFlags { return TableColumnFlags(rawValue: 16777216) }
        public static var isVisible: TableColumnFlags { return TableColumnFlags(rawValue: 33554432) }
        public static var isSorted: TableColumnFlags { return TableColumnFlags(rawValue: 67108864) }
        public static var isHovered: TableColumnFlags { return TableColumnFlags(rawValue: 134217728) }
        public static var widthMask: TableColumnFlags { return TableColumnFlags(rawValue: 24) }
        public static var indentMask: TableColumnFlags { return TableColumnFlags(rawValue: 196608) }
        public static var statusMask: TableColumnFlags { return TableColumnFlags(rawValue: 251658240) }
        public static var noDirectResize: TableColumnFlags { return TableColumnFlags(rawValue: 1073741824) }
    }

    public struct TableFlags: OptionSet  {
        public var rawValue: Int32

        public init(rawValue: Self.RawValue) {
            self.rawValue = rawValue
        }

        public static var resizable: TableFlags { return TableFlags(rawValue: 1) }
        public static var reorderable: TableFlags { return TableFlags(rawValue: 2) }
        public static var hideable: TableFlags { return TableFlags(rawValue: 4) }
        public static var sortable: TableFlags { return TableFlags(rawValue: 8) }
        public static var noSavedSettings: TableFlags { return TableFlags(rawValue: 16) }
        public static var contextMenuInBody: TableFlags { return TableFlags(rawValue: 32) }
        public static var rowBg: TableFlags { return TableFlags(rawValue: 64) }
        public static var bordersInnerH: TableFlags { return TableFlags(rawValue: 128) }
        public static var bordersOuterH: TableFlags { return TableFlags(rawValue: 256) }
        public static var bordersInnerV: TableFlags { return TableFlags(rawValue: 512) }
        public static var bordersOuterV: TableFlags { return TableFlags(rawValue: 1024) }
        public static var bordersH: TableFlags { return TableFlags(rawValue: 384) }
        public static var bordersV: TableFlags { return TableFlags(rawValue: 1536) }
        public static var bordersInner: TableFlags { return TableFlags(rawValue: 640) }
        public static var bordersOuter: TableFlags { return TableFlags(rawValue: 1280) }
        public static var borders: TableFlags { return TableFlags(rawValue: 1920) }
        public static var noBordersInBody: TableFlags { return TableFlags(rawValue: 2048) }
        public static var noBordersInBodyUntilResize: TableFlags { return TableFlags(rawValue: 4096) }
        public static var sizingFixedFit: TableFlags { return TableFlags(rawValue: 8192) }
        public static var sizingFixedSame: TableFlags { return TableFlags(rawValue: 16384) }
        public static var sizingStretchProp: TableFlags { return TableFlags(rawValue: 24576) }
        public static var sizingStretchSame: TableFlags { return TableFlags(rawValue: 32768) }
        public static var noHostExtendX: TableFlags { return TableFlags(rawValue: 65536) }
        public static var noHostExtendY: TableFlags { return TableFlags(rawValue: 131072) }
        public static var noKeepColumnsVisible: TableFlags { return TableFlags(rawValue: 262144) }
        public static var preciseWidths: TableFlags { return TableFlags(rawValue: 524288) }
        public static var noClip: TableFlags { return TableFlags(rawValue: 1048576) }
        public static var padOuterX: TableFlags { return TableFlags(rawValue: 2097152) }
        public static var noPadOuterX: TableFlags { return TableFlags(rawValue: 4194304) }
        public static var noPadInnerX: TableFlags { return TableFlags(rawValue: 8388608) }
        public static var scrollX: TableFlags { return TableFlags(rawValue: 16777216) }
        public static var scrollY: TableFlags { return TableFlags(rawValue: 33554432) }
        public static var sortMulti: TableFlags { return TableFlags(rawValue: 67108864) }
        public static var sortTristate: TableFlags { return TableFlags(rawValue: 134217728) }
        public static var sizingMask: TableFlags { return TableFlags(rawValue: 57344) }
    }

    public struct TableRowFlags: OptionSet  {
        public var rawValue: Int32

        public init(rawValue: Self.RawValue) {
            self.rawValue = rawValue
        }

        public static var headers: TableRowFlags { return TableRowFlags(rawValue: 1) }
    }

    public struct TextFlags: OptionSet  {
        public var rawValue: Int32

        public init(rawValue: Self.RawValue) {
            self.rawValue = rawValue
        }

        public static var noWidthForLargeClippedText: TextFlags { return TextFlags(rawValue: 1) }
    }

    public struct TooltipFlags: OptionSet  {
        public var rawValue: Int32

        public init(rawValue: Self.RawValue) {
            self.rawValue = rawValue
        }

        public static var overridePreviousTooltip: TooltipFlags { return TooltipFlags(rawValue: 1) }
    }

    public struct TreeNodeFlags: OptionSet  {
        public var rawValue: Int32

        public init(rawValue: Self.RawValue) {
            self.rawValue = rawValue
        }

        public static var selected: TreeNodeFlags { return TreeNodeFlags(rawValue: 1) }
        public static var framed: TreeNodeFlags { return TreeNodeFlags(rawValue: 2) }
        public static var allowItemOverlap: TreeNodeFlags { return TreeNodeFlags(rawValue: 4) }
        public static var noTreePushOnOpen: TreeNodeFlags { return TreeNodeFlags(rawValue: 8) }
        public static var noAutoOpenOnLog: TreeNodeFlags { return TreeNodeFlags(rawValue: 16) }
        public static var defaultOpen: TreeNodeFlags { return TreeNodeFlags(rawValue: 32) }
        public static var openOnDoubleClick: TreeNodeFlags { return TreeNodeFlags(rawValue: 64) }
        public static var openOnArrow: TreeNodeFlags { return TreeNodeFlags(rawValue: 128) }
        public static var leaf: TreeNodeFlags { return TreeNodeFlags(rawValue: 256) }
        public static var bullet: TreeNodeFlags { return TreeNodeFlags(rawValue: 512) }
        public static var framePadding: TreeNodeFlags { return TreeNodeFlags(rawValue: 1024) }
        public static var spanAvailWidth: TreeNodeFlags { return TreeNodeFlags(rawValue: 2048) }
        public static var spanFullWidth: TreeNodeFlags { return TreeNodeFlags(rawValue: 4096) }
        public static var navLeftJumpsBackHere: TreeNodeFlags { return TreeNodeFlags(rawValue: 8192) }
        public static var collapsingHeader: TreeNodeFlags { return TreeNodeFlags(rawValue: 26) }
    }

    public struct TreeNodeFlagsPrivate: OptionSet  {
        public var rawValue: Int32

        public init(rawValue: Self.RawValue) {
            self.rawValue = rawValue
        }

        public static var clipLabelForTrailingButton: TreeNodeFlagsPrivate { return TreeNodeFlagsPrivate(rawValue: 1048576) }
    }

    public struct ViewportFlags: OptionSet  {
        public var rawValue: Int32

        public init(rawValue: Self.RawValue) {
            self.rawValue = rawValue
        }

        public static var isPlatformWindow: ViewportFlags { return ViewportFlags(rawValue: 1) }
        public static var isPlatformMonitor: ViewportFlags { return ViewportFlags(rawValue: 2) }
        public static var ownedByApp: ViewportFlags { return ViewportFlags(rawValue: 4) }
    }

    public struct WindowFlags: OptionSet  {
        public var rawValue: Int32

        public init(rawValue: Self.RawValue) {
            self.rawValue = rawValue
        }

        public static var noTitleBar: WindowFlags { return WindowFlags(rawValue: 1) }
        public static var noResize: WindowFlags { return WindowFlags(rawValue: 2) }
        public static var noMove: WindowFlags { return WindowFlags(rawValue: 4) }
        public static var noScrollbar: WindowFlags { return WindowFlags(rawValue: 8) }
        public static var noScrollWithMouse: WindowFlags { return WindowFlags(rawValue: 16) }
        public static var noCollapse: WindowFlags { return WindowFlags(rawValue: 32) }
        public static var alwaysAutoResize: WindowFlags { return WindowFlags(rawValue: 64) }
        public static var noBackground: WindowFlags { return WindowFlags(rawValue: 128) }
        public static var noSavedSettings: WindowFlags { return WindowFlags(rawValue: 256) }
        public static var noMouseInputs: WindowFlags { return WindowFlags(rawValue: 512) }
        public static var menuBar: WindowFlags { return WindowFlags(rawValue: 1024) }
        public static var horizontalScrollbar: WindowFlags { return WindowFlags(rawValue: 2048) }
        public static var noFocusOnAppearing: WindowFlags { return WindowFlags(rawValue: 4096) }
        public static var noBringToFrontOnFocus: WindowFlags { return WindowFlags(rawValue: 8192) }
        public static var alwaysVerticalScrollbar: WindowFlags { return WindowFlags(rawValue: 16384) }
        public static var alwaysHorizontalScrollbar: WindowFlags { return WindowFlags(rawValue: 32768) }
        public static var alwaysUseWindowPadding: WindowFlags { return WindowFlags(rawValue: 65536) }
        public static var noNavInputs: WindowFlags { return WindowFlags(rawValue: 262144) }
        public static var noNavFocus: WindowFlags { return WindowFlags(rawValue: 524288) }
        public static var unsavedDocument: WindowFlags { return WindowFlags(rawValue: 1048576) }
        public static var noNav: WindowFlags { return WindowFlags(rawValue: 786432) }
        public static var noDecoration: WindowFlags { return WindowFlags(rawValue: 43) }
        public static var noInputs: WindowFlags { return WindowFlags(rawValue: 786944) }
        public static var navFlattened: WindowFlags { return WindowFlags(rawValue: 8388608) }
        public static var childWindow: WindowFlags { return WindowFlags(rawValue: 16777216) }
        public static var tooltip: WindowFlags { return WindowFlags(rawValue: 33554432) }
        public static var popup: WindowFlags { return WindowFlags(rawValue: 67108864) }
        public static var modal: WindowFlags { return WindowFlags(rawValue: 134217728) }
        public static var childMenu: WindowFlags { return WindowFlags(rawValue: 268435456) }
    }

    public static func acceptDragDropPayload(type: String, flags: DragDropFlags = []) -> UnsafePointer<ImGuiPayload> {
        return igAcceptDragDropPayload(type, flags.rawValue)
    }

    public static func alignTextToFramePadding() -> Void {
        igAlignTextToFramePadding()
    }

    @discardableResult
    public static func arrowButton(strId str_id: String, dir: Dir) -> Bool {
        return igArrowButton(str_id, dir.rawValue)
    }

    public static var backgroundDrawList: UnsafeMutablePointer<ImDrawList> {
        return igGetBackgroundDrawList_Nil()
    }

    @discardableResult
    public static func begin(name: String, isOpen p_open: UnsafeMutablePointer<Bool>? = nil, flags: WindowFlags = []) -> Bool {
        return igBegin(name, p_open, flags.rawValue)
    }

    @discardableResult
    public static func beginChild(strId str_id: String, size: SIMD2<Float> = SIMD2<Float>(0, 0), border: Bool = false, flags: WindowFlags = []) -> Bool {
        return igBeginChild_Str(str_id, ImVec2(size), border, flags.rawValue)
    }

    @discardableResult
    public static func beginChild(id: ImGuiID, size: SIMD2<Float> = SIMD2<Float>(0, 0), border: Bool = false, flags: WindowFlags = []) -> Bool {
        return igBeginChild_ID(id, ImVec2(size), border, flags.rawValue)
    }

    @discardableResult
    public static func beginChildFrame(id: ImGuiID, size: SIMD2<Float>, flags: WindowFlags = []) -> Bool {
        return igBeginChildFrame(id, ImVec2(size), flags.rawValue)
    }

    @discardableResult
    public static func beginCombo(label: String, previewValue preview_value: String, flags: ComboFlags = []) -> Bool {
        return igBeginCombo(label, preview_value, flags.rawValue)
    }

    public static func beginDisabled(disabled: Bool = true) -> Void {
        igBeginDisabled(disabled)
    }

    @discardableResult
    public static func beginDragDropSource(flags: DragDropFlags = []) -> Bool {
        return igBeginDragDropSource(flags.rawValue)
    }

    public static func beginDragDropTarget() -> Bool {
        return igBeginDragDropTarget()
    }

    public static func beginGroup() -> Void {
        igBeginGroup()
    }

    @discardableResult
    public static func beginListBox(label: String, size: SIMD2<Float> = SIMD2<Float>(0, 0)) -> Bool {
        return igBeginListBox(label, ImVec2(size))
    }

    public static func beginMainMenuBar() -> Bool {
        return igBeginMainMenuBar()
    }

    @discardableResult
    public static func beginMenu(label: String, enabled: Bool = true) -> Bool {
        return igBeginMenu(label, enabled)
    }

    public static func beginMenuBar() -> Bool {
        return igBeginMenuBar()
    }

    @discardableResult
    public static func beginPopup(strId str_id: String, flags: WindowFlags = []) -> Bool {
        return igBeginPopup(str_id, flags.rawValue)
    }

    @discardableResult
    public static func beginPopupContextItem(strId str_id: UnsafePointer<CChar>? = nil, popupFlags popup_flags: PopupFlags = PopupFlags(rawValue: 1)) -> Bool {
        return igBeginPopupContextItem(str_id, popup_flags.rawValue)
    }

    @discardableResult
    public static func beginPopupContextVoid(strId str_id: UnsafePointer<CChar>? = nil, popupFlags popup_flags: PopupFlags = PopupFlags(rawValue: 1)) -> Bool {
        return igBeginPopupContextVoid(str_id, popup_flags.rawValue)
    }

    @discardableResult
    public static func beginPopupContextWindow(strId str_id: UnsafePointer<CChar>? = nil, popupFlags popup_flags: PopupFlags = PopupFlags(rawValue: 1)) -> Bool {
        return igBeginPopupContextWindow(str_id, popup_flags.rawValue)
    }

    @discardableResult
    public static func beginPopupModal(name: String, isOpen p_open: UnsafeMutablePointer<Bool>? = nil, flags: WindowFlags = []) -> Bool {
        return igBeginPopupModal(name, p_open, flags.rawValue)
    }

    @discardableResult
    public static func beginTabBar(strId str_id: String, flags: TabBarFlags = []) -> Bool {
        return igBeginTabBar(str_id, flags.rawValue)
    }

    @discardableResult
    public static func beginTabItem(label: String, isOpen p_open: UnsafeMutablePointer<Bool>? = nil, flags: TabItemFlags = []) -> Bool {
        return igBeginTabItem(label, p_open, flags.rawValue)
    }

    @discardableResult
    public static func beginTable(strId str_id: String, column: Int, flags: TableFlags = [], outerSize outer_size: SIMD2<Float> = SIMD2<Float>(0.0, 0.0), innerWidth inner_width: Float = 0.0) -> Bool {
        return igBeginTable(str_id, Int32(column), flags.rawValue, ImVec2(outer_size), inner_width)
    }

    public static func beginTooltip() -> Void {
        igBeginTooltip()
    }

    public static func bullet() -> Void {
        igBullet()
    }

    public static func bulletText(format fmt: String) -> Void {
        withVaList([]) { args in
            igBulletTextV(fmt, args)
        }
    }

    @discardableResult
    public static func button(label: String, size: SIMD2<Float> = SIMD2<Float>(0, 0)) -> Bool {
        return igButton(label, ImVec2(size))
    }

    public static func calcItemWidth() -> Float {
        return igCalcItemWidth()
    }

    public static func calcListClipping(itemsCount items_count: Int, itemsHeight items_height: Float) -> (out_items_display_start: Int, out_items_display_end: Int) {
        var out_items_display_start = Int32()
        var out_items_display_end = Int32()
        igCalcListClipping(Int32(items_count), items_height, &out_items_display_start, &out_items_display_end)
        return (Int(out_items_display_start), Int(out_items_display_end))
    }

    public static func calcTextSize(text: String, textEnd text_end: UnsafePointer<CChar>? = nil, hideTextAfterDoubleHash hide_text_after_double_hash: Bool = false, wrapWidth wrap_width: Float = -1.0) -> SIMD2<Float> {
        var pOut = ImVec2()
        igCalcTextSize(&pOut, text, text_end, hide_text_after_double_hash, wrap_width)
        return (SIMD2<Float>(pOut))
    }

    public static func captureKeyboardFromApp(wantCaptureKeyboardValue want_capture_keyboard_value: Bool = true) -> Void {
        igCaptureKeyboardFromApp(want_capture_keyboard_value)
    }

    public static func captureMouseFromApp(wantCaptureMouseValue want_capture_mouse_value: Bool = true) -> Void {
        igCaptureMouseFromApp(want_capture_mouse_value)
    }

    @discardableResult
    public static func checkbox(label: String, value v: inout Bool) -> Bool {
        return igCheckbox(label, &v)
    }

    @discardableResult
    public static func checkboxFlags(label: String, flagsTemp: inout Int, flagsValue flags_value: Int) -> Bool {
        var flags = Int32(flagsTemp)
        defer { flagsTemp = Int(flags) }
        return igCheckboxFlags_IntPtr(label, &flags, Int32(flags_value))
    }

    @discardableResult
    public static func checkboxFlags(label: String, flags: inout UInt32, flagsValue flags_value: UInt32) -> Bool {
        return igCheckboxFlags_UintPtr(label, &flags, flags_value)
    }

    public static var clipboardText: String {
        get {
            return String(cString: igGetClipboardText())
        }
        set(text) {
            igSetClipboardText(text)
        }
    }

    public static func closeCurrentPopup() -> Void {
        igCloseCurrentPopup()
    }

    @discardableResult
    public static func collapsingHeader(label: String, flags: TreeNodeFlags = []) -> Bool {
        return igCollapsingHeader_TreeNodeFlags(label, flags.rawValue)
    }

    @discardableResult
    public static func collapsingHeader(label: String, isVisible p_visible: inout Bool, flags: TreeNodeFlags = []) -> Bool {
        return igCollapsingHeader_BoolPtr(label, &p_visible, flags.rawValue)
    }

    @discardableResult
    public static func colorButton(descriptionId desc_id: String, color col: SIMD4<Float>, flags: ColorEditFlags = [], size: SIMD2<Float> = SIMD2<Float>(0, 0)) -> Bool {
        return igColorButton(desc_id, ImVec4(col), flags.rawValue, ImVec2(size))
    }

    public static func colorConvertFloat4ToU32(_ `in`: SIMD4<Float>) -> UInt32 {
        return igColorConvertFloat4ToU32(ImVec4(`in`))
    }

    public static func colorConvertHSVtoRGB(h: Float, s: Float, value v: Float) -> (out_r: Float, out_g: Float, out_b: Float) {
        var out_r = Float()
        var out_g = Float()
        var out_b = Float()
        igColorConvertHSVtoRGB(h, s, v, &out_r, &out_g, &out_b)
        return (out_r, out_g, out_b)
    }

    public static func colorConvertRGBtoHSV(r: Float, g: Float, b: Float) -> (out_h: Float, out_s: Float, out_v: Float) {
        var out_h = Float()
        var out_s = Float()
        var out_v = Float()
        igColorConvertRGBtoHSV(r, g, b, &out_h, &out_s, &out_v)
        return (out_h, out_s, out_v)
    }

    public static func colorConvertU32ToFloat4(_ `in`: UInt32) -> SIMD4<Float> {
        var pOut = ImVec4()
        igColorConvertU32ToFloat4(&pOut, `in`)
        return (SIMD4<Float>(pOut))
    }

    @discardableResult
    public static func colorEdit3(label: String, color col: inout SIMD3<Float>, flags: ColorEditFlags = []) -> Bool {
        return col.withMutableMemberPointer { col in
            return igColorEdit3(label, col, flags.rawValue)
        }
    }

    @discardableResult
    public static func colorEdit4(label: String, color col: inout SIMD4<Float>, flags: ColorEditFlags = []) -> Bool {
        return col.withMutableMemberPointer { col in
            return igColorEdit4(label, col, flags.rawValue)
        }
    }

    @discardableResult
    public static func colorPicker3(label: String, color col: inout SIMD3<Float>, flags: ColorEditFlags = []) -> Bool {
        return col.withMutableMemberPointer { col in
            return igColorPicker3(label, col, flags.rawValue)
        }
    }

    @discardableResult
    public static func colorPicker4(label: String, color col: inout SIMD4<Float>, flags: ColorEditFlags = [], refColor ref_col: UnsafePointer<Float>? = nil) -> Bool {
        return col.withMutableMemberPointer { col in
            return igColorPicker4(label, col, flags.rawValue, ref_col)
        }
    }

    public static var columnIndex: Int32 {
        return igGetColumnIndex()
    }

    public static func columns(count: Int = 1, id: UnsafePointer<CChar>? = nil, border: Bool = true) -> Void {
        igColumns(Int32(count), id, border)
    }

    public static var columnsCount: Int32 {
        return igGetColumnsCount()
    }

    @discardableResult
    public static func combo(label: String, currentItem current_itemTemp: inout Int, items: UnsafePointer<UnsafePointer<CChar>?>, itemsCount items_count: Int, popupMaxHeightInItems popup_max_height_in_items: Int = -1) -> Bool {
        var current_item = Int32(current_itemTemp)
        defer { current_itemTemp = Int(current_item) }
        return igCombo_Str_arr(label, &current_item, items, Int32(items_count), Int32(popup_max_height_in_items))
    }

    @discardableResult
    public static func combo(label: String, currentItem current_itemTemp: inout Int, itemsSeparatedByZeros items_separated_by_zeros: String, popupMaxHeightInItems popup_max_height_in_items: Int = -1) -> Bool {
        var current_item = Int32(current_itemTemp)
        defer { current_itemTemp = Int(current_item) }
        return igCombo_Str(label, &current_item, items_separated_by_zeros, Int32(popup_max_height_in_items))
    }

    @discardableResult
    public static func combo(label: String, currentItem current_itemTemp: inout Int, itemsGetter items_getter: @escaping @convention(c) (_ data: UnsafeMutableRawPointer?, _ index: Int32, _ outText: UnsafeMutablePointer<UnsafePointer<CChar>?>?) -> Bool, data: UnsafeMutableRawPointer, itemsCount items_count: Int, popupMaxHeightInItems popup_max_height_in_items: Int = -1) -> Bool {
        var current_item = Int32(current_itemTemp)
        defer { current_itemTemp = Int(current_item) }
        return igCombo_FnBoolPtr(label, &current_item, items_getter, data, Int32(items_count), Int32(popup_max_height_in_items))
    }

    public static var contentRegionAvail: SIMD2<Float> {
        var pOut = ImVec2()
        igGetContentRegionAvail(&pOut)
        return (SIMD2<Float>(pOut))
    }

    public static var contentRegionMax: SIMD2<Float> {
        var pOut = ImVec2()
        igGetContentRegionMax(&pOut)
        return (SIMD2<Float>(pOut))
    }

    public static func createContext(sharedFontAtlas shared_font_atlas: UnsafeMutablePointer<ImFontAtlas>? = nil) -> UnsafeMutablePointer<ImGuiContext> {
        return igCreateContext(shared_font_atlas)
    }

    public static var currentContext: UnsafeMutablePointer<ImGuiContext> {
        get {
            return igGetCurrentContext()
        }
        set(ctx) {
            igSetCurrentContext(ctx)
        }
    }

    public static var cursorPos: SIMD2<Float> {
        get {
            var pOut = ImVec2()
            igGetCursorPos(&pOut)
            return (SIMD2<Float>(pOut))
        }
        set(local_pos) {
            igSetCursorPos(ImVec2(local_pos))
        }
    }

    public static var cursorPosX: Float {
        get {
            return igGetCursorPosX()
        }
        set(local_x) {
            igSetCursorPosX(local_x)
        }
    }

    public static var cursorPosY: Float {
        get {
            return igGetCursorPosY()
        }
        set(local_y) {
            igSetCursorPosY(local_y)
        }
    }

    public static var cursorScreenPos: SIMD2<Float> {
        get {
            var pOut = ImVec2()
            igGetCursorScreenPos(&pOut)
            return (SIMD2<Float>(pOut))
        }
        set(pos) {
            igSetCursorScreenPos(ImVec2(pos))
        }
    }

    public static var cursorStartPos: SIMD2<Float> {
        var pOut = ImVec2()
        igGetCursorStartPos(&pOut)
        return (SIMD2<Float>(pOut))
    }

    @discardableResult
    public static func debugCheckVersionAndDataLayout(versionStr version_str: String, szIo sz_io: Int, szStyle sz_style: Int, szVec2 sz_vec2: Int, szVec4 sz_vec4: Int, szDrawvert sz_drawvert: Int, szDrawidx sz_drawidx: Int) -> Bool {
        return igDebugCheckVersionAndDataLayout(version_str, sz_io, sz_style, sz_vec2, sz_vec4, sz_drawvert, sz_drawidx)
    }

    public static func destroyContext(ctx: UnsafeMutablePointer<ImGuiContext>? = nil) -> Void {
        igDestroyContext(ctx)
    }

    public static var dragDropPayload: UnsafePointer<ImGuiPayload> {
        return igGetDragDropPayload()
    }

    @discardableResult
    public static func dragFloat(label: String, value v: inout Float, speed v_speed: Float = 1.0, min v_min: Float = 0.0, max v_max: Float = 0.0, format: String = "%.3f", flags: SliderFlags = []) -> Bool {
        return igDragFloat(label, &v, v_speed, v_min, v_max, format, flags.rawValue)
    }

    @discardableResult
    public static func dragFloat2(label: String, value v: inout SIMD2<Float>, speed v_speed: Float = 1.0, min v_min: Float = 0.0, max v_max: Float = 0.0, format: String = "%.3f", flags: SliderFlags = []) -> Bool {
        return v.withMutableMemberPointer { v in
            return igDragFloat2(label, v, v_speed, v_min, v_max, format, flags.rawValue)
        }
    }

    @discardableResult
    public static func dragFloat3(label: String, value v: inout SIMD3<Float>, speed v_speed: Float = 1.0, min v_min: Float = 0.0, max v_max: Float = 0.0, format: String = "%.3f", flags: SliderFlags = []) -> Bool {
        return v.withMutableMemberPointer { v in
            return igDragFloat3(label, v, v_speed, v_min, v_max, format, flags.rawValue)
        }
    }

    @discardableResult
    public static func dragFloat4(label: String, value v: inout SIMD4<Float>, speed v_speed: Float = 1.0, min v_min: Float = 0.0, max v_max: Float = 0.0, format: String = "%.3f", flags: SliderFlags = []) -> Bool {
        return v.withMutableMemberPointer { v in
            return igDragFloat4(label, v, v_speed, v_min, v_max, format, flags.rawValue)
        }
    }

    @discardableResult
    public static func dragFloatRange2(label: String, currentMin v_current_min: inout Float, currentMax v_current_max: inout Float, speed v_speed: Float = 1.0, min v_min: Float = 0.0, max v_max: Float = 0.0, format: String = "%.3f", formatMax format_max: UnsafePointer<CChar>? = nil, flags: SliderFlags = []) -> Bool {
        return igDragFloatRange2(label, &v_current_min, &v_current_max, v_speed, v_min, v_max, format, format_max, flags.rawValue)
    }

    @discardableResult
    public static func dragInt(label: String, value vTemp: inout Int, speed v_speed: Float = 1.0, min v_min: Int = 0, max v_max: Int = 0, format: String = "%d", flags: SliderFlags = []) -> Bool {
        var v = Int32(vTemp)
        defer { vTemp = Int(v) }
        return igDragInt(label, &v, v_speed, Int32(v_min), Int32(v_max), format, flags.rawValue)
    }

    @discardableResult
    public static func dragInt2(label: String, value v: inout SIMD2<Int32>, speed v_speed: Float = 1.0, min v_min: Int = 0, max v_max: Int = 0, format: String = "%d", flags: SliderFlags = []) -> Bool {
        return v.withMutableMemberPointer { v in
            return igDragInt2(label, v, v_speed, Int32(v_min), Int32(v_max), format, flags.rawValue)
        }
    }

    @discardableResult
    public static func dragInt3(label: String, value v: inout SIMD3<Int32>, speed v_speed: Float = 1.0, min v_min: Int = 0, max v_max: Int = 0, format: String = "%d", flags: SliderFlags = []) -> Bool {
        return v.withMutableMemberPointer { v in
            return igDragInt3(label, v, v_speed, Int32(v_min), Int32(v_max), format, flags.rawValue)
        }
    }

    @discardableResult
    public static func dragInt4(label: String, value v: inout SIMD4<Int32>, speed v_speed: Float = 1.0, min v_min: Int = 0, max v_max: Int = 0, format: String = "%d", flags: SliderFlags = []) -> Bool {
        return v.withMutableMemberPointer { v in
            return igDragInt4(label, v, v_speed, Int32(v_min), Int32(v_max), format, flags.rawValue)
        }
    }

    @discardableResult
    public static func dragIntRange2(label: String, currentMin v_current_minTemp: inout Int, currentMax v_current_maxTemp: inout Int, speed v_speed: Float = 1.0, min v_min: Int = 0, max v_max: Int = 0, format: String = "%d", formatMax format_max: UnsafePointer<CChar>? = nil, flags: SliderFlags = []) -> Bool {
        var v_current_min = Int32(v_current_minTemp)
        defer { v_current_minTemp = Int(v_current_min) }
        var v_current_max = Int32(v_current_maxTemp)
        defer { v_current_maxTemp = Int(v_current_max) }
        return igDragIntRange2(label, &v_current_min, &v_current_max, v_speed, Int32(v_min), Int32(v_max), format, format_max, flags.rawValue)
    }

    @discardableResult
    public static func dragScalar(label: String, dataType data_type: DataType, pData p_data: UnsafeMutableRawPointer, speed v_speed: Float = 1.0, pMin p_min: UnsafeRawPointer? = nil, pMax p_max: UnsafeRawPointer? = nil, format: UnsafePointer<CChar>? = nil, flags: SliderFlags = []) -> Bool {
        return igDragScalar(label, data_type.rawValue, p_data, v_speed, p_min, p_max, format, flags.rawValue)
    }

    @discardableResult
    public static func dragScalarN(label: String, dataType data_type: DataType, pData p_data: UnsafeMutableRawPointer, components: Int, speed v_speed: Float = 1.0, pMin p_min: UnsafeRawPointer? = nil, pMax p_max: UnsafeRawPointer? = nil, format: UnsafePointer<CChar>? = nil, flags: SliderFlags = []) -> Bool {
        return igDragScalarN(label, data_type.rawValue, p_data, Int32(components), v_speed, p_min, p_max, format, flags.rawValue)
    }

    public static var drawData: UnsafeMutablePointer<ImDrawData> {
        return igGetDrawData()
    }

    public static var drawListSharedData: UnsafeMutablePointer<ImDrawListSharedData> {
        return igGetDrawListSharedData()
    }

    public static func dummy(size: SIMD2<Float>) -> Void {
        igDummy(ImVec2(size))
    }

    public static func end() -> Void {
        igEnd()
    }

    public static func endChild() -> Void {
        igEndChild()
    }

    public static func endChildFrame() -> Void {
        igEndChildFrame()
    }

    public static func endCombo() -> Void {
        igEndCombo()
    }

    public static func endDisabled() -> Void {
        igEndDisabled()
    }

    public static func endDragDropSource() -> Void {
        igEndDragDropSource()
    }

    public static func endDragDropTarget() -> Void {
        igEndDragDropTarget()
    }

    public static func endFrame() -> Void {
        igEndFrame()
    }

    public static func endGroup() -> Void {
        igEndGroup()
    }

    public static func endListBox() -> Void {
        igEndListBox()
    }

    public static func endMainMenuBar() -> Void {
        igEndMainMenuBar()
    }

    public static func endMenu() -> Void {
        igEndMenu()
    }

    public static func endMenuBar() -> Void {
        igEndMenuBar()
    }

    public static func endPopup() -> Void {
        igEndPopup()
    }

    public static func endTabBar() -> Void {
        igEndTabBar()
    }

    public static func endTabItem() -> Void {
        igEndTabItem()
    }

    public static func endTable() -> Void {
        igEndTable()
    }

    public static func endTooltip() -> Void {
        igEndTooltip()
    }

    public static var font: UnsafeMutablePointer<ImFont> {
        return igGetFont()
    }

    public static var fontSize: Float {
        return igGetFontSize()
    }

    public static var fontTexUvWhitePixel: SIMD2<Float> {
        var pOut = ImVec2()
        igGetFontTexUvWhitePixel(&pOut)
        return (SIMD2<Float>(pOut))
    }

    public static var foregroundDrawList: UnsafeMutablePointer<ImDrawList> {
        return igGetForegroundDrawList_Nil()
    }

    public static var frameCount: Int32 {
        return igGetFrameCount()
    }

    public static var frameHeight: Float {
        return igGetFrameHeight()
    }

    public static var frameHeightWithSpacing: Float {
        return igGetFrameHeightWithSpacing()
    }

    public static func getAllocatorFunctions(pAllocFunc p_alloc_func: inout ImGuiMemAllocFunc?, pFreeFunc p_free_func: inout ImGuiMemFreeFunc?, pUserData p_user_data: inout UnsafeMutableRawPointer?) -> Void {
        igGetAllocatorFunctions(&p_alloc_func, &p_free_func, &p_user_data)
    }

    public static func getColorU32(idx: Color, alphaMul alpha_mul: Float = 1.0) -> UInt32 {
        return igGetColorU32_Col(idx.rawValue, alpha_mul)
    }

    public static func getColorU32(color col: SIMD4<Float>) -> UInt32 {
        return igGetColorU32_Vec4(ImVec4(col))
    }

    public static func getColorU32(color col: UInt32) -> UInt32 {
        return igGetColorU32_U32(col)
    }

    public static func getColumnOffset(columnIndex column_index: Int = -1) -> Float {
        return igGetColumnOffset(Int32(column_index))
    }

    public static func getColumnWidth(columnIndex column_index: Int = -1) -> Float {
        return igGetColumnWidth(Int32(column_index))
    }

    public static func getID(strId str_id: String) -> ImGuiID {
        return igGetID_Str(str_id)
    }

    public static func getID(strIdBegin str_id_begin: String, strIdEnd str_id_end: String) -> ImGuiID {
        return igGetID_StrStr(str_id_begin, str_id_end)
    }

    public static func getID(ptrId ptr_id: UnsafeRawPointer) -> ImGuiID {
        return igGetID_Ptr(ptr_id)
    }

    public static func getKeyIndex(imguiKey imgui_key: Key) -> Int32 {
        return igGetKeyIndex(imgui_key.rawValue)
    }

    public static func getKeyPressedAmount(keyIndex key_index: Int, repeatDelay repeat_delay: Float, rate: Float) -> Int32 {
        return igGetKeyPressedAmount(Int32(key_index), repeat_delay, rate)
    }

    public static func getMouseDragDelta(button: MouseButton = [], lockThreshold lock_threshold: Float = -1.0) -> SIMD2<Float> {
        var pOut = ImVec2()
        igGetMouseDragDelta(&pOut, button.rawValue, lock_threshold)
        return (SIMD2<Float>(pOut))
    }

    public static func getStyleColorName(idx: Color) -> String {
        return String(cString: igGetStyleColorName(idx.rawValue))
    }

    public static func getStyleColorVec4(idx: Color) -> UnsafePointer<ImVec4> {
        return igGetStyleColorVec4(idx.rawValue)
    }

    public static var iO: UnsafeMutablePointer<ImGuiIO> {
        return igGetIO()
    }

    public static func image(userTextureId user_texture_id: ImTextureID, size: SIMD2<Float>, uv0: SIMD2<Float> = SIMD2<Float>(0, 0), uv1: SIMD2<Float> = SIMD2<Float>(1, 1), tintColor tint_col: SIMD4<Float> = SIMD4<Float>(1, 1, 1, 1), borderColor border_col: SIMD4<Float> = SIMD4<Float>(0, 0, 0, 0)) -> Void {
        igImage(user_texture_id, ImVec2(size), ImVec2(uv0), ImVec2(uv1), ImVec4(tint_col), ImVec4(border_col))
    }

    @discardableResult
    public static func imageButton(userTextureId user_texture_id: ImTextureID, size: SIMD2<Float>, uv0: SIMD2<Float> = SIMD2<Float>(0, 0), uv1: SIMD2<Float> = SIMD2<Float>(1, 1), framePadding frame_padding: Int = -1, backgroundColor bg_col: SIMD4<Float> = SIMD4<Float>(0, 0, 0, 0), tintColor tint_col: SIMD4<Float> = SIMD4<Float>(1, 1, 1, 1)) -> Bool {
        return igImageButton(user_texture_id, ImVec2(size), ImVec2(uv0), ImVec2(uv1), Int32(frame_padding), ImVec4(bg_col), ImVec4(tint_col))
    }

    public static func indent(indentW indent_w: Float = 0.0) -> Void {
        igIndent(indent_w)
    }

    @discardableResult
    public static func inputDouble(label: String, value v: inout Double, step: Double = 0.0, stepFast step_fast: Double = 0.0, format: String = "%.6f", flags: InputTextFlags = []) -> Bool {
        return igInputDouble(label, &v, step, step_fast, format, flags.rawValue)
    }

    @discardableResult
    public static func inputFloat(label: String, value v: inout Float, step: Float = 0.0, stepFast step_fast: Float = 0.0, format: String = "%.3f", flags: InputTextFlags = []) -> Bool {
        return igInputFloat(label, &v, step, step_fast, format, flags.rawValue)
    }

    @discardableResult
    public static func inputFloat2(label: String, value v: inout SIMD2<Float>, format: String = "%.3f", flags: InputTextFlags = []) -> Bool {
        return v.withMutableMemberPointer { v in
            return igInputFloat2(label, v, format, flags.rawValue)
        }
    }

    @discardableResult
    public static func inputFloat3(label: String, value v: inout SIMD3<Float>, format: String = "%.3f", flags: InputTextFlags = []) -> Bool {
        return v.withMutableMemberPointer { v in
            return igInputFloat3(label, v, format, flags.rawValue)
        }
    }

    @discardableResult
    public static func inputFloat4(label: String, value v: inout SIMD4<Float>, format: String = "%.3f", flags: InputTextFlags = []) -> Bool {
        return v.withMutableMemberPointer { v in
            return igInputFloat4(label, v, format, flags.rawValue)
        }
    }

    @discardableResult
    public static func inputInt(label: String, value vTemp: inout Int, step: Int = 1, stepFast step_fast: Int = 100, flags: InputTextFlags = []) -> Bool {
        var v = Int32(vTemp)
        defer { vTemp = Int(v) }
        return igInputInt(label, &v, Int32(step), Int32(step_fast), flags.rawValue)
    }

    @discardableResult
    public static func inputInt2(label: String, value v: inout SIMD2<Int32>, flags: InputTextFlags = []) -> Bool {
        return v.withMutableMemberPointer { v in
            return igInputInt2(label, v, flags.rawValue)
        }
    }

    @discardableResult
    public static func inputInt3(label: String, value v: inout SIMD3<Int32>, flags: InputTextFlags = []) -> Bool {
        return v.withMutableMemberPointer { v in
            return igInputInt3(label, v, flags.rawValue)
        }
    }

    @discardableResult
    public static func inputInt4(label: String, value v: inout SIMD4<Int32>, flags: InputTextFlags = []) -> Bool {
        return v.withMutableMemberPointer { v in
            return igInputInt4(label, v, flags.rawValue)
        }
    }

    @discardableResult
    public static func inputScalar(label: String, dataType data_type: DataType, pData p_data: UnsafeMutableRawPointer, pStep p_step: UnsafeRawPointer? = nil, pStepFast p_step_fast: UnsafeRawPointer? = nil, format: UnsafePointer<CChar>? = nil, flags: InputTextFlags = []) -> Bool {
        return igInputScalar(label, data_type.rawValue, p_data, p_step, p_step_fast, format, flags.rawValue)
    }

    @discardableResult
    public static func inputScalarN(label: String, dataType data_type: DataType, pData p_data: UnsafeMutableRawPointer, components: Int, pStep p_step: UnsafeRawPointer? = nil, pStepFast p_step_fast: UnsafeRawPointer? = nil, format: UnsafePointer<CChar>? = nil, flags: InputTextFlags = []) -> Bool {
        return igInputScalarN(label, data_type.rawValue, p_data, Int32(components), p_step, p_step_fast, format, flags.rawValue)
    }

    @discardableResult
    public static func inputText(label: String, buffer buf: UnsafeMutablePointer<CChar>, bufferSize buf_size: Int, flags: InputTextFlags = [], callback: ImGuiInputTextCallback? = nil, userData user_data: UnsafeMutableRawPointer? = nil) -> Bool {
        return igInputText(label, buf, buf_size, flags.rawValue, callback, user_data)
    }

    @discardableResult
    public static func inputTextMultiline(label: String, buffer buf: UnsafeMutablePointer<CChar>, bufferSize buf_size: Int, size: SIMD2<Float> = SIMD2<Float>(0, 0), flags: InputTextFlags = [], callback: ImGuiInputTextCallback? = nil, userData user_data: UnsafeMutableRawPointer? = nil) -> Bool {
        return igInputTextMultiline(label, buf, buf_size, ImVec2(size), flags.rawValue, callback, user_data)
    }

    @discardableResult
    public static func inputTextWithHint(label: String, hint: String, buffer buf: UnsafeMutablePointer<CChar>, bufferSize buf_size: Int, flags: InputTextFlags = [], callback: ImGuiInputTextCallback? = nil, userData user_data: UnsafeMutableRawPointer? = nil) -> Bool {
        return igInputTextWithHint(label, hint, buf, buf_size, flags.rawValue, callback, user_data)
    }

    @discardableResult
    public static func invisibleButton(strId str_id: String, size: SIMD2<Float>, flags: ButtonFlags = []) -> Bool {
        return igInvisibleButton(str_id, ImVec2(size), flags.rawValue)
    }

    public static var isAnyItemActive: Bool {
        return igIsAnyItemActive()
    }

    public static var isAnyItemFocused: Bool {
        return igIsAnyItemFocused()
    }

    public static var isAnyItemHovered: Bool {
        return igIsAnyItemHovered()
    }

    public static var isAnyMouseDown: Bool {
        return igIsAnyMouseDown()
    }

    public static var isItemActivated: Bool {
        return igIsItemActivated()
    }

    public static var isItemActive: Bool {
        return igIsItemActive()
    }

    @discardableResult
    public static func isItemClicked(mouseButton mouse_button: MouseButton = []) -> Bool {
        return igIsItemClicked(mouse_button.rawValue)
    }

    public static var isItemDeactivated: Bool {
        return igIsItemDeactivated()
    }

    public static var isItemDeactivatedAfterEdit: Bool {
        return igIsItemDeactivatedAfterEdit()
    }

    public static var isItemEdited: Bool {
        return igIsItemEdited()
    }

    public static var isItemFocused: Bool {
        return igIsItemFocused()
    }

    @discardableResult
    public static func isItemHovered(flags: HoveredFlags = []) -> Bool {
        return igIsItemHovered(flags.rawValue)
    }

    public static var isItemToggledOpen: Bool {
        return igIsItemToggledOpen()
    }

    public static var isItemVisible: Bool {
        return igIsItemVisible()
    }

    @discardableResult
    public static func isKeyDown(userKeyIndex user_key_index: Int) -> Bool {
        return igIsKeyDown(Int32(user_key_index))
    }

    @discardableResult
    public static func isKeyPressed(userKeyIndex user_key_index: Int, _ `repeat`: Bool = true) -> Bool {
        return igIsKeyPressed(Int32(user_key_index), `repeat`)
    }

    @discardableResult
    public static func isKeyReleased(userKeyIndex user_key_index: Int) -> Bool {
        return igIsKeyReleased(Int32(user_key_index))
    }

    @discardableResult
    public static func isMouseClicked(button: MouseButton, _ `repeat`: Bool = false) -> Bool {
        return igIsMouseClicked(button.rawValue, `repeat`)
    }

    @discardableResult
    public static func isMouseDoubleClicked(button: MouseButton) -> Bool {
        return igIsMouseDoubleClicked(button.rawValue)
    }

    @discardableResult
    public static func isMouseDown(button: MouseButton) -> Bool {
        return igIsMouseDown(button.rawValue)
    }

    @discardableResult
    public static func isMouseDragging(button: MouseButton, lockThreshold lock_threshold: Float = -1.0) -> Bool {
        return igIsMouseDragging(button.rawValue, lock_threshold)
    }

    @discardableResult
    public static func isMouseHoveringRect(rMin r_min: SIMD2<Float>, rMax r_max: SIMD2<Float>, clip: Bool = true) -> Bool {
        return igIsMouseHoveringRect(ImVec2(r_min), ImVec2(r_max), clip)
    }

    @discardableResult
    public static func isMousePosValid(mousePos mouse_pos: UnsafePointer<ImVec2>? = nil) -> Bool {
        return igIsMousePosValid(mouse_pos)
    }

    @discardableResult
    public static func isMouseReleased(button: MouseButton) -> Bool {
        return igIsMouseReleased(button.rawValue)
    }

    @discardableResult
    public static func isPopupOpen(strId str_id: String, flags: PopupFlags = []) -> Bool {
        return igIsPopupOpen_Str(str_id, flags.rawValue)
    }

    @discardableResult
    public static func isRectVisible(size: SIMD2<Float>) -> Bool {
        return igIsRectVisible_Nil(ImVec2(size))
    }

    @discardableResult
    public static func isRectVisible(rectMin rect_min: SIMD2<Float>, rectMax rect_max: SIMD2<Float>) -> Bool {
        return igIsRectVisible_Vec2(ImVec2(rect_min), ImVec2(rect_max))
    }

    public static var isWindowAppearing: Bool {
        return igIsWindowAppearing()
    }

    public static var isWindowCollapsed: Bool {
        return igIsWindowCollapsed()
    }

    @discardableResult
    public static func isWindowFocused(flags: FocusedFlags = []) -> Bool {
        return igIsWindowFocused(flags.rawValue)
    }

    @discardableResult
    public static func isWindowHovered(flags: HoveredFlags = []) -> Bool {
        return igIsWindowHovered(flags.rawValue)
    }

    public static var itemRectMax: SIMD2<Float> {
        var pOut = ImVec2()
        igGetItemRectMax(&pOut)
        return (SIMD2<Float>(pOut))
    }

    public static var itemRectMin: SIMD2<Float> {
        var pOut = ImVec2()
        igGetItemRectMin(&pOut)
        return (SIMD2<Float>(pOut))
    }

    public static var itemRectSize: SIMD2<Float> {
        var pOut = ImVec2()
        igGetItemRectSize(&pOut)
        return (SIMD2<Float>(pOut))
    }

    public static func labelText(label: String, format fmt: String) -> Void {
        withVaList([]) { args in
            igLabelTextV(label, fmt, args)
        }
    }

    @discardableResult
    public static func listBox(label: String, currentItem current_itemTemp: inout Int, items: UnsafePointer<UnsafePointer<CChar>?>, itemsCount items_count: Int, heightInItems height_in_items: Int = -1) -> Bool {
        var current_item = Int32(current_itemTemp)
        defer { current_itemTemp = Int(current_item) }
        return igListBox_Str_arr(label, &current_item, items, Int32(items_count), Int32(height_in_items))
    }

    @discardableResult
    public static func listBox(label: String, currentItem current_itemTemp: inout Int, itemsGetter items_getter: @escaping @convention(c) (_ data: UnsafeMutableRawPointer?, _ index: Int32, _ outText: UnsafeMutablePointer<UnsafePointer<CChar>?>?) -> Bool, data: UnsafeMutableRawPointer, itemsCount items_count: Int, heightInItems height_in_items: Int = -1) -> Bool {
        var current_item = Int32(current_itemTemp)
        defer { current_itemTemp = Int(current_item) }
        return igListBox_FnBoolPtr(label, &current_item, items_getter, data, Int32(items_count), Int32(height_in_items))
    }

    public static func loadIniSettingsFromDisk(iniFilename ini_filename: String) -> Void {
        igLoadIniSettingsFromDisk(ini_filename)
    }

    public static func loadIniSettingsFromMemory(iniData ini_data: String, iniSize ini_size: Int = 0) -> Void {
        igLoadIniSettingsFromMemory(ini_data, ini_size)
    }

    public static func logButtons() -> Void {
        igLogButtons()
    }

    public static func logFinish() -> Void {
        igLogFinish()
    }

    public static func logText(format fmt: String) -> Void {
        withVaList([]) { args in
            igLogTextV(fmt, args)
        }
    }

    public static func logToClipboard(autoOpenDepth auto_open_depth: Int = -1) -> Void {
        igLogToClipboard(Int32(auto_open_depth))
    }

    public static func logToFile(autoOpenDepth auto_open_depth: Int = -1, filename: UnsafePointer<CChar>? = nil) -> Void {
        igLogToFile(Int32(auto_open_depth), filename)
    }

    public static func logToTTY(autoOpenDepth auto_open_depth: Int = -1) -> Void {
        igLogToTTY(Int32(auto_open_depth))
    }

    public static var mainViewport: UnsafeMutablePointer<ImGuiViewport> {
        return igGetMainViewport()
    }

    public static func memAlloc(size: Int) -> UnsafeMutableRawPointer {
        return igMemAlloc(size)
    }

    public static func memFree(ptr: UnsafeMutableRawPointer) -> Void {
        igMemFree(ptr)
    }

    @discardableResult
    public static func menuItem(label: String, shortcut: UnsafePointer<CChar>? = nil, selected: Bool = false, enabled: Bool = true) -> Bool {
        return igMenuItem_Bool(label, shortcut, selected, enabled)
    }

    @discardableResult
    public static func menuItem(label: String, shortcut: String, pSelected p_selected: inout Bool, enabled: Bool = true) -> Bool {
        return igMenuItem_BoolPtr(label, shortcut, &p_selected, enabled)
    }

    public static var mouseCursor: MouseCursor {
        get {
            return MouseCursor(rawValue: igGetMouseCursor())
        }
        set(cursor_type) {
            igSetMouseCursor(cursor_type.rawValue)
        }
    }

    public static var mousePos: SIMD2<Float> {
        var pOut = ImVec2()
        igGetMousePos(&pOut)
        return (SIMD2<Float>(pOut))
    }

    public static var mousePosOnOpeningCurrentPopup: SIMD2<Float> {
        var pOut = ImVec2()
        igGetMousePosOnOpeningCurrentPopup(&pOut)
        return (SIMD2<Float>(pOut))
    }

    public static func newFrame() -> Void {
        igNewFrame()
    }

    public static func newLine() -> Void {
        igNewLine()
    }

    public static func nextColumn() -> Void {
        igNextColumn()
    }

    public static func openPopup(strId str_id: String, popupFlags popup_flags: PopupFlags = []) -> Void {
        igOpenPopup_Str(str_id, popup_flags.rawValue)
    }

    public static func openPopup(id: ImGuiID, popupFlags popup_flags: PopupFlags = []) -> Void {
        igOpenPopup_ID(id, popup_flags.rawValue)
    }

    public static func openPopupOnItemClick(strId str_id: UnsafePointer<CChar>? = nil, popupFlags popup_flags: PopupFlags = PopupFlags(rawValue: 1)) -> Void {
        igOpenPopupOnItemClick(str_id, popup_flags.rawValue)
    }

    public static func plotHistogram(label: String, values: UnsafePointer<Float>, valuesCount values_count: Int, valuesOffset values_offset: Int = 0, overlayText overlay_text: UnsafePointer<CChar>? = nil, scaleMin scale_min: Float = .greatestFiniteMagnitude, scaleMax scale_max: Float = .greatestFiniteMagnitude, graphSize graph_size: SIMD2<Float> = SIMD2<Float>(0, 0), stride: Int = MemoryLayout<Float>.stride) -> Void {
        igPlotHistogram_FloatPtr(label, values, Int32(values_count), Int32(values_offset), overlay_text, scale_min, scale_max, ImVec2(graph_size), Int32(stride))
    }

    public static func plotHistogram(label: String, valuesGetter values_getter: @escaping @convention(c) (_ data: UnsafeMutableRawPointer?, _ index: Int32) -> Float, data: UnsafeMutableRawPointer, valuesCount values_count: Int, valuesOffset values_offset: Int = 0, overlayText overlay_text: UnsafePointer<CChar>? = nil, scaleMin scale_min: Float = .greatestFiniteMagnitude, scaleMax scale_max: Float = .greatestFiniteMagnitude, graphSize graph_size: SIMD2<Float> = SIMD2<Float>(0, 0)) -> Void {
        igPlotHistogram_FnFloatPtr(label, values_getter, data, Int32(values_count), Int32(values_offset), overlay_text, scale_min, scale_max, ImVec2(graph_size))
    }

    public static func plotLines(label: String, values: UnsafePointer<Float>, valuesCount values_count: Int, valuesOffset values_offset: Int = 0, overlayText overlay_text: UnsafePointer<CChar>? = nil, scaleMin scale_min: Float = .greatestFiniteMagnitude, scaleMax scale_max: Float = .greatestFiniteMagnitude, graphSize graph_size: SIMD2<Float> = SIMD2<Float>(0, 0), stride: Int = MemoryLayout<Float>.stride) -> Void {
        igPlotLines_FloatPtr(label, values, Int32(values_count), Int32(values_offset), overlay_text, scale_min, scale_max, ImVec2(graph_size), Int32(stride))
    }

    public static func plotLines(label: String, valuesGetter values_getter: @escaping @convention(c) (_ data: UnsafeMutableRawPointer?, _ index: Int32) -> Float, data: UnsafeMutableRawPointer, valuesCount values_count: Int, valuesOffset values_offset: Int = 0, overlayText overlay_text: UnsafePointer<CChar>? = nil, scaleMin scale_min: Float = .greatestFiniteMagnitude, scaleMax scale_max: Float = .greatestFiniteMagnitude, graphSize graph_size: SIMD2<Float> = SIMD2<Float>(0, 0)) -> Void {
        igPlotLines_FnFloatPtr(label, values_getter, data, Int32(values_count), Int32(values_offset), overlay_text, scale_min, scale_max, ImVec2(graph_size))
    }

    public static func popAllowKeyboardFocus() -> Void {
        igPopAllowKeyboardFocus()
    }

    public static func popButtonRepeat() -> Void {
        igPopButtonRepeat()
    }

    public static func popClipRect() -> Void {
        igPopClipRect()
    }

    public static func popFont() -> Void {
        igPopFont()
    }

    public static func popID() -> Void {
        igPopID()
    }

    public static func popItemWidth() -> Void {
        igPopItemWidth()
    }

    public static func popStyleColor(count: Int = 1) -> Void {
        igPopStyleColor(Int32(count))
    }

    public static func popStyleVar(count: Int = 1) -> Void {
        igPopStyleVar(Int32(count))
    }

    public static func popTextWrapPos() -> Void {
        igPopTextWrapPos()
    }

    public static func progressBar(fraction: Float, sizeArg size_arg: SIMD2<Float> = SIMD2<Float>(-.leastNormalMagnitude, 0), overlay: UnsafePointer<CChar>? = nil) -> Void {
        igProgressBar(fraction, ImVec2(size_arg), overlay)
    }

    public static func pushAllowKeyboardFocus(allowKeyboardFocus allow_keyboard_focus: Bool) -> Void {
        igPushAllowKeyboardFocus(allow_keyboard_focus)
    }

    public static func pushButtonRepeat(_ `repeat`: Bool) -> Void {
        igPushButtonRepeat(`repeat`)
    }

    public static func pushClipRect(clipRectMin clip_rect_min: SIMD2<Float>, clipRectMax clip_rect_max: SIMD2<Float>, intersectWithCurrentClipRect intersect_with_current_clip_rect: Bool) -> Void {
        igPushClipRect(ImVec2(clip_rect_min), ImVec2(clip_rect_max), intersect_with_current_clip_rect)
    }

    public static func pushFont(font: UnsafeMutablePointer<ImFont>) -> Void {
        igPushFont(font)
    }

    public static func pushID(strId str_id: String) -> Void {
        igPushID_Str(str_id)
    }

    public static func pushID(strIdBegin str_id_begin: String, strIdEnd str_id_end: String) -> Void {
        igPushID_StrStr(str_id_begin, str_id_end)
    }

    public static func pushID(ptrId ptr_id: UnsafeRawPointer) -> Void {
        igPushID_Ptr(ptr_id)
    }

    public static func pushID(intId int_id: Int) -> Void {
        igPushID_Int(Int32(int_id))
    }

    public static func pushItemWidth(itemWidth item_width: Float) -> Void {
        igPushItemWidth(item_width)
    }

    public static func pushStyleColor(idx: Color, color col: UInt32) -> Void {
        igPushStyleColor_U32(idx.rawValue, col)
    }

    public static func pushStyleColor(idx: Color, color col: SIMD4<Float>) -> Void {
        igPushStyleColor_Vec4(idx.rawValue, ImVec4(col))
    }

    public static func pushStyleVar(idx: StyleVar, val: Float) -> Void {
        igPushStyleVar_Float(idx.rawValue, val)
    }

    public static func pushStyleVar(idx: StyleVar, val: SIMD2<Float>) -> Void {
        igPushStyleVar_Vec2(idx.rawValue, ImVec2(val))
    }

    public static func pushTextWrapPos(wrapLocalPosX wrap_local_pos_x: Float = 0.0) -> Void {
        igPushTextWrapPos(wrap_local_pos_x)
    }

    @discardableResult
    public static func radioButton(label: String, active: Bool) -> Bool {
        return igRadioButton_Bool(label, active)
    }

    @discardableResult
    public static func radioButton(label: String, value vTemp: inout Int, button v_button: Int) -> Bool {
        var v = Int32(vTemp)
        defer { vTemp = Int(v) }
        return igRadioButton_IntPtr(label, &v, Int32(v_button))
    }

    public static func render() -> Void {
        igRender()
    }

    public static func resetMouseDragDelta(button: MouseButton = []) -> Void {
        igResetMouseDragDelta(button.rawValue)
    }

    public static func sameLine(offsetFromStartX offset_from_start_x: Float = 0.0, spacing: Float = -1.0) -> Void {
        igSameLine(offset_from_start_x, spacing)
    }

    public static func saveIniSettingsToDisk(iniFilename ini_filename: String) -> Void {
        igSaveIniSettingsToDisk(ini_filename)
    }

    public static func saveIniSettingsToMemory(outIniSize out_ini_size: UnsafeMutablePointer<Int>? = nil) -> String {
        return String(cString: igSaveIniSettingsToMemory(out_ini_size))
    }

    public static var scrollMaxX: Float {
        return igGetScrollMaxX()
    }

    public static var scrollMaxY: Float {
        return igGetScrollMaxY()
    }

    public static var scrollX: Float {
        get {
            return igGetScrollX()
        }
        set(scroll_x) {
            igSetScrollX_Float(scroll_x)
        }
    }

    public static var scrollY: Float {
        get {
            return igGetScrollY()
        }
        set(scroll_y) {
            igSetScrollY_Float(scroll_y)
        }
    }

    @discardableResult
    public static func selectable(label: String, selected: Bool = false, flags: SelectableFlags = [], size: SIMD2<Float> = SIMD2<Float>(0, 0)) -> Bool {
        return igSelectable_Bool(label, selected, flags.rawValue, ImVec2(size))
    }

    @discardableResult
    public static func selectable(label: String, pSelected p_selected: inout Bool, flags: SelectableFlags = [], size: SIMD2<Float> = SIMD2<Float>(0, 0)) -> Bool {
        return igSelectable_BoolPtr(label, &p_selected, flags.rawValue, ImVec2(size))
    }

    public static func separator() -> Void {
        igSeparator()
    }

    public static func setAllocatorFunctions(allocFunc alloc_func: @escaping ImGuiMemAllocFunc, freeFunc free_func: @escaping ImGuiMemFreeFunc, userData user_data: UnsafeMutableRawPointer? = nil) -> Void {
        igSetAllocatorFunctions(alloc_func, free_func, user_data)
    }

    public static func setColorEditOptions(flags: ColorEditFlags) -> Void {
        igSetColorEditOptions(flags.rawValue)
    }

    public static func setColumnOffset(columnIndex column_index: Int, offsetX offset_x: Float) -> Void {
        igSetColumnOffset(Int32(column_index), offset_x)
    }

    public static func setColumnWidth(columnIndex column_index: Int, width: Float) -> Void {
        igSetColumnWidth(Int32(column_index), width)
    }

    @discardableResult
    public static func setDragDropPayload(type: String, data: UnsafeRawPointer, sz: Int, cond: Cond = []) -> Bool {
        return igSetDragDropPayload(type, data, sz, cond.rawValue)
    }

    public static func setItemAllowOverlap() -> Void {
        igSetItemAllowOverlap()
    }

    public static func setItemDefaultFocus() -> Void {
        igSetItemDefaultFocus()
    }

    public static func setKeyboardFocusHere(offset: Int = 0) -> Void {
        igSetKeyboardFocusHere(Int32(offset))
    }

    public static func setNextItemOpen(isOpen is_open: Bool, cond: Cond = []) -> Void {
        igSetNextItemOpen(is_open, cond.rawValue)
    }

    public static func setNextItemWidth(itemWidth item_width: Float) -> Void {
        igSetNextItemWidth(item_width)
    }

    public static func setNextWindowBgAlpha(alpha: Float) -> Void {
        igSetNextWindowBgAlpha(alpha)
    }

    public static func setNextWindowCollapsed(collapsed: Bool, cond: Cond = []) -> Void {
        igSetNextWindowCollapsed(collapsed, cond.rawValue)
    }

    public static func setNextWindowContentSize(size: SIMD2<Float>) -> Void {
        igSetNextWindowContentSize(ImVec2(size))
    }

    public static func setNextWindowFocus() -> Void {
        igSetNextWindowFocus()
    }

    public static func setNextWindowPos(position pos: SIMD2<Float>, cond: Cond = [], pivot: SIMD2<Float> = SIMD2<Float>(0, 0)) -> Void {
        igSetNextWindowPos(ImVec2(pos), cond.rawValue, ImVec2(pivot))
    }

    public static func setNextWindowSize(size: SIMD2<Float>, cond: Cond = []) -> Void {
        igSetNextWindowSize(ImVec2(size), cond.rawValue)
    }

    public static func setNextWindowSizeConstraints(sizeMin size_min: SIMD2<Float>, sizeMax size_max: SIMD2<Float>, customCallback custom_callback: ImGuiSizeCallback? = nil, customCallbackData custom_callback_data: UnsafeMutableRawPointer? = nil) -> Void {
        igSetNextWindowSizeConstraints(ImVec2(size_min), ImVec2(size_max), custom_callback, custom_callback_data)
    }

    public static func setScrollFromPosX(localX local_x: Float, centerXRatio center_x_ratio: Float = 0.5) -> Void {
        igSetScrollFromPosX_Float(local_x, center_x_ratio)
    }

    public static func setScrollFromPosY(localY local_y: Float, centerYRatio center_y_ratio: Float = 0.5) -> Void {
        igSetScrollFromPosY_Float(local_y, center_y_ratio)
    }

    public static func setScrollHereX(centerXRatio center_x_ratio: Float = 0.5) -> Void {
        igSetScrollHereX(center_x_ratio)
    }

    public static func setScrollHereY(centerYRatio center_y_ratio: Float = 0.5) -> Void {
        igSetScrollHereY(center_y_ratio)
    }

    public static func setTabItemClosed(tabOrDockedWindowLabel tab_or_docked_window_label: String) -> Void {
        igSetTabItemClosed(tab_or_docked_window_label)
    }

    public static func setTooltip(format fmt: String) -> Void {
        withVaList([]) { args in
            igSetTooltipV(fmt, args)
        }
    }

    public static func setWindowCollapsed(collapsed: Bool, cond: Cond = []) -> Void {
        igSetWindowCollapsed_Bool(collapsed, cond.rawValue)
    }

    public static func setWindowCollapsed(name: String, collapsed: Bool, cond: Cond = []) -> Void {
        igSetWindowCollapsed_Str(name, collapsed, cond.rawValue)
    }

    public static func setWindowFocus() -> Void {
        igSetWindowFocus_Nil()
    }

    public static func setWindowFocus(name: String) -> Void {
        igSetWindowFocus_Str(name)
    }

    public static func setWindowFontScale(scale: Float) -> Void {
        igSetWindowFontScale(scale)
    }

    public static func setWindowPos(position pos: SIMD2<Float>, cond: Cond = []) -> Void {
        igSetWindowPos_Vec2(ImVec2(pos), cond.rawValue)
    }

    public static func setWindowPos(name: String, position pos: SIMD2<Float>, cond: Cond = []) -> Void {
        igSetWindowPos_Str(name, ImVec2(pos), cond.rawValue)
    }

    public static func setWindowSize(size: SIMD2<Float>, cond: Cond = []) -> Void {
        igSetWindowSize_Vec2(ImVec2(size), cond.rawValue)
    }

    public static func setWindowSize(name: String, size: SIMD2<Float>, cond: Cond = []) -> Void {
        igSetWindowSize_Str(name, ImVec2(size), cond.rawValue)
    }

    public static func showAboutWindow(isOpen p_open: UnsafeMutablePointer<Bool>? = nil) -> Void {
        igShowAboutWindow(p_open)
    }

    public static func showDemoWindow(isOpen p_open: UnsafeMutablePointer<Bool>? = nil) -> Void {
        igShowDemoWindow(p_open)
    }

    public static func showFontSelector(label: String) -> Void {
        igShowFontSelector(label)
    }

    public static func showMetricsWindow(isOpen p_open: UnsafeMutablePointer<Bool>? = nil) -> Void {
        igShowMetricsWindow(p_open)
    }

    public static func showStyleEditor(ref: UnsafeMutablePointer<ImGuiStyle>? = nil) -> Void {
        igShowStyleEditor(ref)
    }

    @discardableResult
    public static func showStyleSelector(label: String) -> Bool {
        return igShowStyleSelector(label)
    }

    public static func showUserGuide() -> Void {
        igShowUserGuide()
    }

    @discardableResult
    public static func sliderAngle(label: String, rad v_rad: inout Float, degreesMin v_degrees_min: Float = -360.0, degreesMax v_degrees_max: Float = +360.0, format: String = "%.0f deg", flags: SliderFlags = []) -> Bool {
        return igSliderAngle(label, &v_rad, v_degrees_min, v_degrees_max, format, flags.rawValue)
    }

    @discardableResult
    public static func sliderFloat(label: String, value v: inout Float, min v_min: Float, max v_max: Float, format: String = "%.3f", flags: SliderFlags = []) -> Bool {
        return igSliderFloat(label, &v, v_min, v_max, format, flags.rawValue)
    }

    @discardableResult
    public static func sliderFloat2(label: String, value v: inout SIMD2<Float>, min v_min: Float, max v_max: Float, format: String = "%.3f", flags: SliderFlags = []) -> Bool {
        return v.withMutableMemberPointer { v in
            return igSliderFloat2(label, v, v_min, v_max, format, flags.rawValue)
        }
    }

    @discardableResult
    public static func sliderFloat3(label: String, value v: inout SIMD3<Float>, min v_min: Float, max v_max: Float, format: String = "%.3f", flags: SliderFlags = []) -> Bool {
        return v.withMutableMemberPointer { v in
            return igSliderFloat3(label, v, v_min, v_max, format, flags.rawValue)
        }
    }

    @discardableResult
    public static func sliderFloat4(label: String, value v: inout SIMD4<Float>, min v_min: Float, max v_max: Float, format: String = "%.3f", flags: SliderFlags = []) -> Bool {
        return v.withMutableMemberPointer { v in
            return igSliderFloat4(label, v, v_min, v_max, format, flags.rawValue)
        }
    }

    @discardableResult
    public static func sliderInt(label: String, value vTemp: inout Int, min v_min: Int, max v_max: Int, format: String = "%d", flags: SliderFlags = []) -> Bool {
        var v = Int32(vTemp)
        defer { vTemp = Int(v) }
        return igSliderInt(label, &v, Int32(v_min), Int32(v_max), format, flags.rawValue)
    }

    @discardableResult
    public static func sliderInt2(label: String, value v: inout SIMD2<Int32>, min v_min: Int, max v_max: Int, format: String = "%d", flags: SliderFlags = []) -> Bool {
        return v.withMutableMemberPointer { v in
            return igSliderInt2(label, v, Int32(v_min), Int32(v_max), format, flags.rawValue)
        }
    }

    @discardableResult
    public static func sliderInt3(label: String, value v: inout SIMD3<Int32>, min v_min: Int, max v_max: Int, format: String = "%d", flags: SliderFlags = []) -> Bool {
        return v.withMutableMemberPointer { v in
            return igSliderInt3(label, v, Int32(v_min), Int32(v_max), format, flags.rawValue)
        }
    }

    @discardableResult
    public static func sliderInt4(label: String, value v: inout SIMD4<Int32>, min v_min: Int, max v_max: Int, format: String = "%d", flags: SliderFlags = []) -> Bool {
        return v.withMutableMemberPointer { v in
            return igSliderInt4(label, v, Int32(v_min), Int32(v_max), format, flags.rawValue)
        }
    }

    @discardableResult
    public static func sliderScalar(label: String, dataType data_type: DataType, pData p_data: UnsafeMutableRawPointer, pMin p_min: UnsafeRawPointer, pMax p_max: UnsafeRawPointer, format: UnsafePointer<CChar>? = nil, flags: SliderFlags = []) -> Bool {
        return igSliderScalar(label, data_type.rawValue, p_data, p_min, p_max, format, flags.rawValue)
    }

    @discardableResult
    public static func sliderScalarN(label: String, dataType data_type: DataType, pData p_data: UnsafeMutableRawPointer, components: Int, pMin p_min: UnsafeRawPointer, pMax p_max: UnsafeRawPointer, format: UnsafePointer<CChar>? = nil, flags: SliderFlags = []) -> Bool {
        return igSliderScalarN(label, data_type.rawValue, p_data, Int32(components), p_min, p_max, format, flags.rawValue)
    }

    @discardableResult
    public static func smallButton(label: String) -> Bool {
        return igSmallButton(label)
    }

    public static func spacing() -> Void {
        igSpacing()
    }

    public static var stateStorage: UnsafeMutablePointer<ImGuiStorage> {
        get {
            return igGetStateStorage()
        }
        set(storage) {
            igSetStateStorage(storage)
        }
    }

    public static var style: UnsafeMutablePointer<ImGuiStyle> {
        return igGetStyle()
    }

    public static func styleColorsClassic(dst: UnsafeMutablePointer<ImGuiStyle>? = nil) -> Void {
        igStyleColorsClassic(dst)
    }

    public static func styleColorsDark(dst: UnsafeMutablePointer<ImGuiStyle>? = nil) -> Void {
        igStyleColorsDark(dst)
    }

    public static func styleColorsLight(dst: UnsafeMutablePointer<ImGuiStyle>? = nil) -> Void {
        igStyleColorsLight(dst)
    }

    @discardableResult
    public static func tabItemButton(label: String, flags: TabItemFlags = []) -> Bool {
        return igTabItemButton(label, flags.rawValue)
    }

    public static func tableGetColumnCount() -> Int32 {
        return igTableGetColumnCount()
    }

    public static func tableGetColumnFlags(columnN column_n: Int = -1) -> TableColumnFlags {
        return TableColumnFlags(rawValue: igTableGetColumnFlags(Int32(column_n)))
    }

    public static func tableGetColumnIndex() -> Int32 {
        return igTableGetColumnIndex()
    }

    public static func tableGetColumnName(columnN column_n: Int = -1) -> String {
        return String(cString: igTableGetColumnName_Int(Int32(column_n)))
    }

    public static func tableGetRowIndex() -> Int32 {
        return igTableGetRowIndex()
    }

    public static func tableGetSortSpecs() -> UnsafeMutablePointer<ImGuiTableSortSpecs> {
        return igTableGetSortSpecs()
    }

    public static func tableHeader(label: String) -> Void {
        igTableHeader(label)
    }

    public static func tableHeadersRow() -> Void {
        igTableHeadersRow()
    }

    public static func tableNextColumn() -> Bool {
        return igTableNextColumn()
    }

    public static func tableNextRow(rowFlags row_flags: TableRowFlags = [], minRowHeight min_row_height: Float = 0.0) -> Void {
        igTableNextRow(row_flags.rawValue, min_row_height)
    }

    public static func tableSetBgColor(target: TableBgTarget, color: UInt32, columnN column_n: Int = -1) -> Void {
        igTableSetBgColor(target.rawValue, color, Int32(column_n))
    }

    public static func tableSetColumnEnabled(columnN column_n: Int, value v: Bool) -> Void {
        igTableSetColumnEnabled(Int32(column_n), v)
    }

    @discardableResult
    public static func tableSetColumnIndex(columnN column_n: Int) -> Bool {
        return igTableSetColumnIndex(Int32(column_n))
    }

    public static func tableSetupColumn(label: String, flags: TableColumnFlags = [], initWidthOrWeight init_width_or_weight: Float = 0.0, userId user_id: ImGuiID = 0) -> Void {
        igTableSetupColumn(label, flags.rawValue, init_width_or_weight, user_id)
    }

    public static func tableSetupScrollFreeze(cols: Int, rows: Int) -> Void {
        igTableSetupScrollFreeze(Int32(cols), Int32(rows))
    }

    public static func text(format fmt: String) -> Void {
        withVaList([]) { args in
            igTextV(fmt, args)
        }
    }

    public static func textColored(color col: SIMD4<Float>, format fmt: String) -> Void {
        withVaList([]) { args in
            igTextColoredV(ImVec4(col), fmt, args)
        }
    }

    public static func textDisabled(format fmt: String) -> Void {
        withVaList([]) { args in
            igTextDisabledV(fmt, args)
        }
    }

    public static var textLineHeight: Float {
        return igGetTextLineHeight()
    }

    public static var textLineHeightWithSpacing: Float {
        return igGetTextLineHeightWithSpacing()
    }

    public static func textUnformatted(text: String, textEnd text_end: UnsafePointer<CChar>? = nil) -> Void {
        igTextUnformatted(text, text_end)
    }

    public static func textWrapped(format fmt: String) -> Void {
        withVaList([]) { args in
            igTextWrappedV(fmt, args)
        }
    }

    public static var time: Double {
        return igGetTime()
    }

    @discardableResult
    public static func treeNode(label: String) -> Bool {
        return igTreeNode_Str(label)
    }

    @discardableResult
    public static func treeNode(label: String, flags: TreeNodeFlags = []) -> Bool {
        return igTreeNodeEx_Str(label, flags.rawValue)
    }

    @discardableResult
    public static func treeNode(strId str_id: String, format fmt: String) -> Bool {
        return withVaList([]) { args in
            return igTreeNodeV_Str(str_id, fmt, args)
        }
    }

    @discardableResult
    public static func treeNode(ptrId ptr_id: UnsafeRawPointer, format fmt: String) -> Bool {
        return withVaList([]) { args in
            return igTreeNodeV_Ptr(ptr_id, fmt, args)
        }
    }

    @discardableResult
    public static func treeNodeEx(strId str_id: String, flags: TreeNodeFlags, format fmt: String) -> Bool {
        return withVaList([]) { args in
            return igTreeNodeExV_Str(str_id, flags.rawValue, fmt, args)
        }
    }

    @discardableResult
    public static func treeNodeEx(ptrId ptr_id: UnsafeRawPointer, flags: TreeNodeFlags, format fmt: String) -> Bool {
        return withVaList([]) { args in
            return igTreeNodeExV_Ptr(ptr_id, flags.rawValue, fmt, args)
        }
    }

    public static var treeNodeToLabelSpacing: Float {
        return igGetTreeNodeToLabelSpacing()
    }

    public static func treePop() -> Void {
        igTreePop()
    }

    public static func treePush(strId str_id: String) -> Void {
        igTreePush_Str(str_id)
    }

    public static func treePush(ptrId ptr_id: UnsafeRawPointer? = nil) -> Void {
        igTreePush_Ptr(ptr_id)
    }

    public static func unindent(indentW indent_w: Float = 0.0) -> Void {
        igUnindent(indent_w)
    }

    @discardableResult
    public static func vSliderFloat(label: String, size: SIMD2<Float>, value v: inout Float, min v_min: Float, max v_max: Float, format: String = "%.3f", flags: SliderFlags = []) -> Bool {
        return igVSliderFloat(label, ImVec2(size), &v, v_min, v_max, format, flags.rawValue)
    }

    @discardableResult
    public static func vSliderInt(label: String, size: SIMD2<Float>, value vTemp: inout Int, min v_min: Int, max v_max: Int, format: String = "%d", flags: SliderFlags = []) -> Bool {
        var v = Int32(vTemp)
        defer { vTemp = Int(v) }
        return igVSliderInt(label, ImVec2(size), &v, Int32(v_min), Int32(v_max), format, flags.rawValue)
    }

    @discardableResult
    public static func vSliderScalar(label: String, size: SIMD2<Float>, dataType data_type: DataType, pData p_data: UnsafeMutableRawPointer, pMin p_min: UnsafeRawPointer, pMax p_max: UnsafeRawPointer, format: UnsafePointer<CChar>? = nil, flags: SliderFlags = []) -> Bool {
        return igVSliderScalar(label, ImVec2(size), data_type.rawValue, p_data, p_min, p_max, format, flags.rawValue)
    }

    public static func value(prefix: String, b: Bool) -> Void {
        igValue_Bool(prefix, b)
    }

    public static func value(prefix: String, value v: Int) -> Void {
        igValue_Int(prefix, Int32(v))
    }

    public static func value(prefix: String, value v: UInt32) -> Void {
        igValue_Uint(prefix, v)
    }

    public static func value(prefix: String, value v: Float, floatFormat float_format: UnsafePointer<CChar>? = nil) -> Void {
        igValue_Float(prefix, v, float_format)
    }

    public static var version: String {
        return String(cString: igGetVersion())
    }

    public static var windowContentRegionMax: SIMD2<Float> {
        var pOut = ImVec2()
        igGetWindowContentRegionMax(&pOut)
        return (SIMD2<Float>(pOut))
    }

    public static var windowContentRegionMin: SIMD2<Float> {
        var pOut = ImVec2()
        igGetWindowContentRegionMin(&pOut)
        return (SIMD2<Float>(pOut))
    }

    public static var windowContentRegionWidth: Float {
        return igGetWindowContentRegionWidth()
    }

    public static var windowDrawList: UnsafeMutablePointer<ImDrawList> {
        return igGetWindowDrawList()
    }

    public static var windowHeight: Float {
        return igGetWindowHeight()
    }

    public static var windowPos: SIMD2<Float> {
        var pOut = ImVec2()
        igGetWindowPos(&pOut)
        return (SIMD2<Float>(pOut))
    }

    public static var windowSize: SIMD2<Float> {
        var pOut = ImVec2()
        igGetWindowSize(&pOut)
        return (SIMD2<Float>(pOut))
    }

    public static var windowWidth: Float {
        return igGetWindowWidth()
    }

}

extension ImColor {
    public static func hsv(h: Float, s: Float, value v: Float, a: Float = 1.0) -> ImColor {
        var pOut = ImColor()
        ImColor_HSV(&pOut, h, s, v, a)
        return (pOut)
    }

    public mutating func setHSV(h: Float, s: Float, value v: Float, a: Float = 1.0) -> Void {
        ImColor_SetHSV(&self, h, s, v, a)
    }

}

extension ImDrawCmd {
    public var texID: ImTextureID {
        mutating get {
            return ImDrawCmd_GetTexID(&self)
        }
    }

}

extension ImDrawData {
    public mutating func clear() -> Void {
        ImDrawData_Clear(&self)
    }

    public mutating func deIndexAllBuffers() -> Void {
        ImDrawData_DeIndexAllBuffers(&self)
    }

    public mutating func scaleClipRects(fbScale fb_scale: SIMD2<Float>) -> Void {
        ImDrawData_ScaleClipRects(&self, ImVec2(fb_scale))
    }

}

extension ImDrawList {
    public mutating func addBezierCubic(p1: SIMD2<Float>, p2: SIMD2<Float>, p3: SIMD2<Float>, p4: SIMD2<Float>, color col: UInt32, thickness: Float, numSegments num_segments: Int = 0) -> Void {
        ImDrawList_AddBezierCubic(&self, ImVec2(p1), ImVec2(p2), ImVec2(p3), ImVec2(p4), col, thickness, Int32(num_segments))
    }

    public mutating func addBezierQuadratic(p1: SIMD2<Float>, p2: SIMD2<Float>, p3: SIMD2<Float>, color col: UInt32, thickness: Float, numSegments num_segments: Int = 0) -> Void {
        ImDrawList_AddBezierQuadratic(&self, ImVec2(p1), ImVec2(p2), ImVec2(p3), col, thickness, Int32(num_segments))
    }

    public mutating func addCallback(callback: @escaping ImDrawCallback, callbackData callback_data: UnsafeMutableRawPointer) -> Void {
        ImDrawList_AddCallback(&self, callback, callback_data)
    }

    public mutating func addCircle(center: SIMD2<Float>, radius: Float, color col: UInt32, numSegments num_segments: Int = 0, thickness: Float = 1.0) -> Void {
        ImDrawList_AddCircle(&self, ImVec2(center), radius, col, Int32(num_segments), thickness)
    }

    public mutating func addCircleFilled(center: SIMD2<Float>, radius: Float, color col: UInt32, numSegments num_segments: Int = 0) -> Void {
        ImDrawList_AddCircleFilled(&self, ImVec2(center), radius, col, Int32(num_segments))
    }

    public mutating func addConvexPolyFilled(points: UnsafePointer<ImVec2>, numPoints num_points: Int, color col: UInt32) -> Void {
        ImDrawList_AddConvexPolyFilled(&self, points, Int32(num_points), col)
    }

    public mutating func addDrawCmd() -> Void {
        ImDrawList_AddDrawCmd(&self)
    }

    public mutating func addImage(userTextureId user_texture_id: ImTextureID, pMin p_min: SIMD2<Float>, pMax p_max: SIMD2<Float>, uvMin uv_min: SIMD2<Float> = SIMD2<Float>(0, 0), uvMax uv_max: SIMD2<Float> = SIMD2<Float>(1, 1), color col: UInt32 = 4294967295) -> Void {
        ImDrawList_AddImage(&self, user_texture_id, ImVec2(p_min), ImVec2(p_max), ImVec2(uv_min), ImVec2(uv_max), col)
    }

    public mutating func addImageQuad(userTextureId user_texture_id: ImTextureID, p1: SIMD2<Float>, p2: SIMD2<Float>, p3: SIMD2<Float>, p4: SIMD2<Float>, uv1: SIMD2<Float> = SIMD2<Float>(0, 0), uv2: SIMD2<Float> = SIMD2<Float>(1, 0), uv3: SIMD2<Float> = SIMD2<Float>(1, 1), uv4: SIMD2<Float> = SIMD2<Float>(0, 1), color col: UInt32 = 4294967295) -> Void {
        ImDrawList_AddImageQuad(&self, user_texture_id, ImVec2(p1), ImVec2(p2), ImVec2(p3), ImVec2(p4), ImVec2(uv1), ImVec2(uv2), ImVec2(uv3), ImVec2(uv4), col)
    }

    public mutating func addImageRounded(userTextureId user_texture_id: ImTextureID, pMin p_min: SIMD2<Float>, pMax p_max: SIMD2<Float>, uvMin uv_min: SIMD2<Float>, uvMax uv_max: SIMD2<Float>, color col: UInt32, rounding: Float, flags: ImGui.DrawFlags = []) -> Void {
        ImDrawList_AddImageRounded(&self, user_texture_id, ImVec2(p_min), ImVec2(p_max), ImVec2(uv_min), ImVec2(uv_max), col, rounding, flags.rawValue)
    }

    public mutating func addLine(p1: SIMD2<Float>, p2: SIMD2<Float>, color col: UInt32, thickness: Float = 1.0) -> Void {
        ImDrawList_AddLine(&self, ImVec2(p1), ImVec2(p2), col, thickness)
    }

    public mutating func addNgon(center: SIMD2<Float>, radius: Float, color col: UInt32, numSegments num_segments: Int, thickness: Float = 1.0) -> Void {
        ImDrawList_AddNgon(&self, ImVec2(center), radius, col, Int32(num_segments), thickness)
    }

    public mutating func addNgonFilled(center: SIMD2<Float>, radius: Float, color col: UInt32, numSegments num_segments: Int) -> Void {
        ImDrawList_AddNgonFilled(&self, ImVec2(center), radius, col, Int32(num_segments))
    }

    public mutating func addPolyline(points: UnsafePointer<ImVec2>, numPoints num_points: Int, color col: UInt32, flags: ImGui.DrawFlags, thickness: Float) -> Void {
        ImDrawList_AddPolyline(&self, points, Int32(num_points), col, flags.rawValue, thickness)
    }

    public mutating func addQuad(p1: SIMD2<Float>, p2: SIMD2<Float>, p3: SIMD2<Float>, p4: SIMD2<Float>, color col: UInt32, thickness: Float = 1.0) -> Void {
        ImDrawList_AddQuad(&self, ImVec2(p1), ImVec2(p2), ImVec2(p3), ImVec2(p4), col, thickness)
    }

    public mutating func addQuadFilled(p1: SIMD2<Float>, p2: SIMD2<Float>, p3: SIMD2<Float>, p4: SIMD2<Float>, color col: UInt32) -> Void {
        ImDrawList_AddQuadFilled(&self, ImVec2(p1), ImVec2(p2), ImVec2(p3), ImVec2(p4), col)
    }

    public mutating func addRect(pMin p_min: SIMD2<Float>, pMax p_max: SIMD2<Float>, color col: UInt32, rounding: Float = 0.0, flags: ImGui.DrawFlags = [], thickness: Float = 1.0) -> Void {
        ImDrawList_AddRect(&self, ImVec2(p_min), ImVec2(p_max), col, rounding, flags.rawValue, thickness)
    }

    public mutating func addRectFilled(pMin p_min: SIMD2<Float>, pMax p_max: SIMD2<Float>, color col: UInt32, rounding: Float = 0.0, flags: ImGui.DrawFlags = []) -> Void {
        ImDrawList_AddRectFilled(&self, ImVec2(p_min), ImVec2(p_max), col, rounding, flags.rawValue)
    }

    public mutating func addRectFilledMultiColor(pMin p_min: SIMD2<Float>, pMax p_max: SIMD2<Float>, colorUprLeft col_upr_left: UInt32, colorUprRight col_upr_right: UInt32, colorBotRight col_bot_right: UInt32, colorBotLeft col_bot_left: UInt32) -> Void {
        ImDrawList_AddRectFilledMultiColor(&self, ImVec2(p_min), ImVec2(p_max), col_upr_left, col_upr_right, col_bot_right, col_bot_left)
    }

    public mutating func addText(position pos: SIMD2<Float>, color col: UInt32, textBegin text_begin: String, textEnd text_end: UnsafePointer<CChar>? = nil) -> Void {
        ImDrawList_AddText_Vec2(&self, ImVec2(pos), col, text_begin, text_end)
    }

    public mutating func addText(font: UnsafePointer<ImFont>, fontSize font_size: Float, position pos: SIMD2<Float>, color col: UInt32, textBegin text_begin: String, textEnd text_end: UnsafePointer<CChar>? = nil, wrapWidth wrap_width: Float = 0.0, cpuFineClipRect cpu_fine_clip_rect: UnsafePointer<ImVec4>? = nil) -> Void {
        ImDrawList_AddText_FontPtr(&self, font, font_size, ImVec2(pos), col, text_begin, text_end, wrap_width, cpu_fine_clip_rect)
    }

    public mutating func addTriangle(p1: SIMD2<Float>, p2: SIMD2<Float>, p3: SIMD2<Float>, color col: UInt32, thickness: Float = 1.0) -> Void {
        ImDrawList_AddTriangle(&self, ImVec2(p1), ImVec2(p2), ImVec2(p3), col, thickness)
    }

    public mutating func addTriangleFilled(p1: SIMD2<Float>, p2: SIMD2<Float>, p3: SIMD2<Float>, color col: UInt32) -> Void {
        ImDrawList_AddTriangleFilled(&self, ImVec2(p1), ImVec2(p2), ImVec2(p3), col)
    }

    public mutating func calcCircleAutoSegmentCount(radius: Float) -> Int32 {
        return ImDrawList__CalcCircleAutoSegmentCount(&self, radius)
    }

    public mutating func channelsMerge() -> Void {
        ImDrawList_ChannelsMerge(&self)
    }

    public mutating func channelsSetCurrent(n: Int) -> Void {
        ImDrawList_ChannelsSetCurrent(&self, Int32(n))
    }

    public mutating func channelsSplit(count: Int) -> Void {
        ImDrawList_ChannelsSplit(&self, Int32(count))
    }

    public mutating func clearFreeMemory() -> Void {
        ImDrawList__ClearFreeMemory(&self)
    }

    public var clipRectMax: SIMD2<Float> {
        mutating get {
            var pOut = ImVec2()
            ImDrawList_GetClipRectMax(&pOut, &self)
            return (SIMD2<Float>(pOut))
        }
    }

    public var clipRectMin: SIMD2<Float> {
        mutating get {
            var pOut = ImVec2()
            ImDrawList_GetClipRectMin(&pOut, &self)
            return (SIMD2<Float>(pOut))
        }
    }

    public mutating func cloneOutput() -> UnsafeMutablePointer<ImDrawList> {
        return ImDrawList_CloneOutput(&self)
    }

    public mutating func onChangedClipRect() -> Void {
        ImDrawList__OnChangedClipRect(&self)
    }

    public mutating func onChangedTextureID() -> Void {
        ImDrawList__OnChangedTextureID(&self)
    }

    public mutating func onChangedVtxOffset() -> Void {
        ImDrawList__OnChangedVtxOffset(&self)
    }

    public mutating func pathArcTo(center: SIMD2<Float>, radius: Float, aMin a_min: Float, aMax a_max: Float, numSegments num_segments: Int = 0) -> Void {
        ImDrawList_PathArcTo(&self, ImVec2(center), radius, a_min, a_max, Int32(num_segments))
    }

    public mutating func pathArcToFast(center: SIMD2<Float>, radius: Float, aMinOf12 a_min_of_12: Int, aMaxOf12 a_max_of_12: Int) -> Void {
        ImDrawList_PathArcToFast(&self, ImVec2(center), radius, Int32(a_min_of_12), Int32(a_max_of_12))
    }

    public mutating func pathArcToFast(center: SIMD2<Float>, radius: Float, aMinSample a_min_sample: Int, aMaxSample a_max_sample: Int, aStep a_step: Int) -> Void {
        ImDrawList__PathArcToFastEx(&self, ImVec2(center), radius, Int32(a_min_sample), Int32(a_max_sample), Int32(a_step))
    }

    public mutating func pathArcToN(center: SIMD2<Float>, radius: Float, aMin a_min: Float, aMax a_max: Float, numSegments num_segments: Int) -> Void {
        ImDrawList__PathArcToN(&self, ImVec2(center), radius, a_min, a_max, Int32(num_segments))
    }

    public mutating func pathBezierCubicCurveTo(p2: SIMD2<Float>, p3: SIMD2<Float>, p4: SIMD2<Float>, numSegments num_segments: Int = 0) -> Void {
        ImDrawList_PathBezierCubicCurveTo(&self, ImVec2(p2), ImVec2(p3), ImVec2(p4), Int32(num_segments))
    }

    public mutating func pathBezierQuadraticCurveTo(p2: SIMD2<Float>, p3: SIMD2<Float>, numSegments num_segments: Int = 0) -> Void {
        ImDrawList_PathBezierQuadraticCurveTo(&self, ImVec2(p2), ImVec2(p3), Int32(num_segments))
    }

    public mutating func pathClear() -> Void {
        ImDrawList_PathClear(&self)
    }

    public mutating func pathFillConvex(color col: UInt32) -> Void {
        ImDrawList_PathFillConvex(&self, col)
    }

    public mutating func pathLineTo(position pos: SIMD2<Float>) -> Void {
        ImDrawList_PathLineTo(&self, ImVec2(pos))
    }

    public mutating func pathLineToMergeDuplicate(position pos: SIMD2<Float>) -> Void {
        ImDrawList_PathLineToMergeDuplicate(&self, ImVec2(pos))
    }

    public mutating func pathRect(rectMin rect_min: SIMD2<Float>, rectMax rect_max: SIMD2<Float>, rounding: Float = 0.0, flags: ImGui.DrawFlags = []) -> Void {
        ImDrawList_PathRect(&self, ImVec2(rect_min), ImVec2(rect_max), rounding, flags.rawValue)
    }

    public mutating func pathStroke(color col: UInt32, flags: ImGui.DrawFlags = [], thickness: Float = 1.0) -> Void {
        ImDrawList_PathStroke(&self, col, flags.rawValue, thickness)
    }

    public mutating func popClipRect() -> Void {
        ImDrawList_PopClipRect(&self)
    }

    public mutating func popTextureID() -> Void {
        ImDrawList_PopTextureID(&self)
    }

    public mutating func popUnusedDrawCmd() -> Void {
        ImDrawList__PopUnusedDrawCmd(&self)
    }

    public mutating func primQuadUV(a: SIMD2<Float>, b: SIMD2<Float>, c: SIMD2<Float>, d: SIMD2<Float>, uvA uv_a: SIMD2<Float>, uvB uv_b: SIMD2<Float>, uvC uv_c: SIMD2<Float>, uvD uv_d: SIMD2<Float>, color col: UInt32) -> Void {
        ImDrawList_PrimQuadUV(&self, ImVec2(a), ImVec2(b), ImVec2(c), ImVec2(d), ImVec2(uv_a), ImVec2(uv_b), ImVec2(uv_c), ImVec2(uv_d), col)
    }

    public mutating func primRect(a: SIMD2<Float>, b: SIMD2<Float>, color col: UInt32) -> Void {
        ImDrawList_PrimRect(&self, ImVec2(a), ImVec2(b), col)
    }

    public mutating func primRectUV(a: SIMD2<Float>, b: SIMD2<Float>, uvA uv_a: SIMD2<Float>, uvB uv_b: SIMD2<Float>, color col: UInt32) -> Void {
        ImDrawList_PrimRectUV(&self, ImVec2(a), ImVec2(b), ImVec2(uv_a), ImVec2(uv_b), col)
    }

    public mutating func primReserve(idxCount idx_count: Int, vtxCount vtx_count: Int) -> Void {
        ImDrawList_PrimReserve(&self, Int32(idx_count), Int32(vtx_count))
    }

    public mutating func primUnreserve(idxCount idx_count: Int, vtxCount vtx_count: Int) -> Void {
        ImDrawList_PrimUnreserve(&self, Int32(idx_count), Int32(vtx_count))
    }

    public mutating func primVtx(position pos: SIMD2<Float>, uv: SIMD2<Float>, color col: UInt32) -> Void {
        ImDrawList_PrimVtx(&self, ImVec2(pos), ImVec2(uv), col)
    }

    public mutating func primWriteIdx(idx: ImDrawIdx) -> Void {
        ImDrawList_PrimWriteIdx(&self, idx)
    }

    public mutating func primWriteVtx(position pos: SIMD2<Float>, uv: SIMD2<Float>, color col: UInt32) -> Void {
        ImDrawList_PrimWriteVtx(&self, ImVec2(pos), ImVec2(uv), col)
    }

    public mutating func pushClipRect(clipRectMin clip_rect_min: SIMD2<Float>, clipRectMax clip_rect_max: SIMD2<Float>, intersectWithCurrentClipRect intersect_with_current_clip_rect: Bool = false) -> Void {
        ImDrawList_PushClipRect(&self, ImVec2(clip_rect_min), ImVec2(clip_rect_max), intersect_with_current_clip_rect)
    }

    public mutating func pushClipRectFullScreen() -> Void {
        ImDrawList_PushClipRectFullScreen(&self)
    }

    public mutating func pushTextureID(textureId texture_id: ImTextureID) -> Void {
        ImDrawList_PushTextureID(&self, texture_id)
    }

    public mutating func resetForNewFrame() -> Void {
        ImDrawList__ResetForNewFrame(&self)
    }

    public mutating func tryMergeDrawCmds() -> Void {
        ImDrawList__TryMergeDrawCmds(&self)
    }

}

extension ImDrawListSplitter {
    public mutating func clear() -> Void {
        ImDrawListSplitter_Clear(&self)
    }

    public mutating func clearFreeMemory() -> Void {
        ImDrawListSplitter_ClearFreeMemory(&self)
    }

    public mutating func merge(drawList draw_list: UnsafeMutablePointer<ImDrawList>) -> Void {
        ImDrawListSplitter_Merge(&self, draw_list)
    }

    public mutating func setCurrentChannel(drawList draw_list: UnsafeMutablePointer<ImDrawList>, channelIdx channel_idx: Int) -> Void {
        ImDrawListSplitter_SetCurrentChannel(&self, draw_list, Int32(channel_idx))
    }

    public mutating func split(drawList draw_list: UnsafeMutablePointer<ImDrawList>, count: Int) -> Void {
        ImDrawListSplitter_Split(&self, draw_list, Int32(count))
    }

}

extension ImFont {
    public mutating func addGlyph(srcCfg src_cfg: UnsafePointer<ImFontConfig>, c: ImWchar, x0: Float, y0: Float, x1: Float, y1: Float, u0: Float, v0: Float, u1: Float, v1: Float, advanceX advance_x: Float) -> Void {
        ImFont_AddGlyph(&self, src_cfg, c, x0, y0, x1, y1, u0, v0, u1, v1, advance_x)
    }

    public mutating func addRemapChar(dst: ImWchar, src: ImWchar, overwriteDst overwrite_dst: Bool = true) -> Void {
        ImFont_AddRemapChar(&self, dst, src, overwrite_dst)
    }

    public mutating func buildLookupTable() -> Void {
        ImFont_BuildLookupTable(&self)
    }

    public mutating func calcTextSizeA(size: Float, maxWidth max_width: Float, wrapWidth wrap_width: Float, textBegin text_begin: String, textEnd text_end: UnsafePointer<CChar>? = nil, remaining: UnsafeMutablePointer<UnsafePointer<CChar>?>? = nil) -> SIMD2<Float> {
        var pOut = ImVec2()
        ImFont_CalcTextSizeA(&pOut, &self, size, max_width, wrap_width, text_begin, text_end, remaining)
        return (SIMD2<Float>(pOut))
    }

    public mutating func calcWordWrapPositionA(scale: Float, text: String, textEnd text_end: String, wrapWidth wrap_width: Float) -> String {
        return String(cString: ImFont_CalcWordWrapPositionA(&self, scale, text, text_end, wrap_width))
    }

    public mutating func clearOutputData() -> Void {
        ImFont_ClearOutputData(&self)
    }

    public var debugName: String {
        mutating get {
            return String(cString: ImFont_GetDebugName(&self))
        }
    }

    public mutating func findGlyph(c: ImWchar) -> UnsafePointer<ImFontGlyph> {
        return ImFont_FindGlyph(&self, c)
    }

    public mutating func findGlyphNoFallback(c: ImWchar) -> UnsafePointer<ImFontGlyph> {
        return ImFont_FindGlyphNoFallback(&self, c)
    }

    public mutating func getCharAdvance(c: ImWchar) -> Float {
        return ImFont_GetCharAdvance(&self, c)
    }

    public mutating func growIndex(newSize new_size: Int) -> Void {
        ImFont_GrowIndex(&self, Int32(new_size))
    }

    @discardableResult
    public mutating func isGlyphRangeUnused(cBegin c_begin: UInt32, cLast c_last: UInt32) -> Bool {
        return ImFont_IsGlyphRangeUnused(&self, c_begin, c_last)
    }

    public mutating func isLoaded() -> Bool {
        return ImFont_IsLoaded(&self)
    }

    public mutating func renderChar(drawList draw_list: UnsafeMutablePointer<ImDrawList>, size: Float, position pos: SIMD2<Float>, color col: UInt32, c: ImWchar) -> Void {
        ImFont_RenderChar(&self, draw_list, size, ImVec2(pos), col, c)
    }

    public mutating func renderText(drawList draw_list: UnsafeMutablePointer<ImDrawList>, size: Float, position pos: SIMD2<Float>, color col: UInt32, clipRect clip_rect: SIMD4<Float>, textBegin text_begin: String, textEnd text_end: String, wrapWidth wrap_width: Float = 0.0, cpuFineClip cpu_fine_clip: Bool = false) -> Void {
        ImFont_RenderText(&self, draw_list, size, ImVec2(pos), col, ImVec4(clip_rect), text_begin, text_end, wrap_width, cpu_fine_clip)
    }

    public mutating func setGlyphVisible(c: ImWchar, visible: Bool) -> Void {
        ImFont_SetGlyphVisible(&self, c, visible)
    }

}

extension ImFontAtlas {
    public mutating func addCustomRectFontGlyph(font: UnsafeMutablePointer<ImFont>, id: ImWchar, width: Int, height: Int, advanceX advance_x: Float, offset: SIMD2<Float> = SIMD2<Float>(0, 0)) -> Int32 {
        return ImFontAtlas_AddCustomRectFontGlyph(&self, font, id, Int32(width), Int32(height), advance_x, ImVec2(offset))
    }

    public mutating func addCustomRectRegular(width: Int, height: Int) -> Int32 {
        return ImFontAtlas_AddCustomRectRegular(&self, Int32(width), Int32(height))
    }

    public mutating func addFont(fontCfg font_cfg: UnsafePointer<ImFontConfig>) -> UnsafeMutablePointer<ImFont> {
        return ImFontAtlas_AddFont(&self, font_cfg)
    }

    public mutating func addFontDefault(fontCfg font_cfg: UnsafePointer<ImFontConfig>? = nil) -> UnsafeMutablePointer<ImFont> {
        return ImFontAtlas_AddFontDefault(&self, font_cfg)
    }

    public mutating func addFontFromFileTTF(filename: String, sizePixels size_pixels: Float, fontCfg font_cfg: UnsafePointer<ImFontConfig>? = nil, glyphRanges glyph_ranges: UnsafePointer<ImWchar>? = nil) -> UnsafeMutablePointer<ImFont> {
        return ImFontAtlas_AddFontFromFileTTF(&self, filename, size_pixels, font_cfg, glyph_ranges)
    }

    public mutating func addFontFromMemoryCompressedBase85TTF(compressedFontDataBase85 compressed_font_data_base85: String, sizePixels size_pixels: Float, fontCfg font_cfg: UnsafePointer<ImFontConfig>? = nil, glyphRanges glyph_ranges: UnsafePointer<ImWchar>? = nil) -> UnsafeMutablePointer<ImFont> {
        return ImFontAtlas_AddFontFromMemoryCompressedBase85TTF(&self, compressed_font_data_base85, size_pixels, font_cfg, glyph_ranges)
    }

    public mutating func addFontFromMemoryCompressedTTF(compressedFontData compressed_font_data: UnsafeRawPointer, compressedFontSize compressed_font_size: Int, sizePixels size_pixels: Float, fontCfg font_cfg: UnsafePointer<ImFontConfig>? = nil, glyphRanges glyph_ranges: UnsafePointer<ImWchar>? = nil) -> UnsafeMutablePointer<ImFont> {
        return ImFontAtlas_AddFontFromMemoryCompressedTTF(&self, compressed_font_data, Int32(compressed_font_size), size_pixels, font_cfg, glyph_ranges)
    }

    public mutating func addFontFromMemoryTTF(fontData font_data: UnsafeMutableRawPointer, fontSize font_size: Int, sizePixels size_pixels: Float, fontCfg font_cfg: UnsafePointer<ImFontConfig>? = nil, glyphRanges glyph_ranges: UnsafePointer<ImWchar>? = nil) -> UnsafeMutablePointer<ImFont> {
        return ImFontAtlas_AddFontFromMemoryTTF(&self, font_data, Int32(font_size), size_pixels, font_cfg, glyph_ranges)
    }

    public mutating func build() -> Bool {
        return ImFontAtlas_Build(&self)
    }

    public mutating func calcCustomRectUV(rect: UnsafePointer<ImFontAtlasCustomRect>) -> (out_uv_min: SIMD2<Float>, out_uv_max: SIMD2<Float>) {
        var out_uv_min = ImVec2()
        var out_uv_max = ImVec2()
        ImFontAtlas_CalcCustomRectUV(&self, rect, &out_uv_min, &out_uv_max)
        return (SIMD2<Float>(out_uv_min), SIMD2<Float>(out_uv_max))
    }

    public mutating func clear() -> Void {
        ImFontAtlas_Clear(&self)
    }

    public mutating func clearFonts() -> Void {
        ImFontAtlas_ClearFonts(&self)
    }

    public mutating func clearInputData() -> Void {
        ImFontAtlas_ClearInputData(&self)
    }

    public mutating func clearTexData() -> Void {
        ImFontAtlas_ClearTexData(&self)
    }

    public mutating func getCustomRectByIndex(index: Int) -> UnsafeMutablePointer<ImFontAtlasCustomRect> {
        return ImFontAtlas_GetCustomRectByIndex(&self, Int32(index))
    }

    @discardableResult
    public mutating func getMouseCursorTexData(cursor: ImGui.MouseCursor, outOffset out_offsetTemp: inout SIMD2<Float>, outSize out_sizeTemp: inout SIMD2<Float>, outUvBorder out_uv_border: inout (ImVec2, ImVec2), outUvFill out_uv_fill: inout (ImVec2, ImVec2)) -> Bool {
        var out_offset = ImVec2(out_offsetTemp)
        defer { out_offsetTemp = SIMD2<Float>(out_offset) }
        var out_size = ImVec2(out_sizeTemp)
        defer { out_sizeTemp = SIMD2<Float>(out_size) }
        return withMutableMembers(of: &out_uv_border) { out_uv_border in
            return withMutableMembers(of: &out_uv_fill) { out_uv_fill in
                return ImFontAtlas_GetMouseCursorTexData(&self, cursor.rawValue, &out_offset, &out_size, out_uv_border, out_uv_fill)
            }
        }
    }

    public mutating func getTexDataAsAlpha8(outBytesPerPixel out_bytes_per_pixel: UnsafeMutablePointer<Int32>? = nil) -> (out_pixels: UnsafeMutablePointer<UInt8>?, out_width: Int, out_height: Int) {
        var out_pixels: UnsafeMutablePointer<UInt8>? = nil
        var out_width = Int32()
        var out_height = Int32()
        ImFontAtlas_GetTexDataAsAlpha8(&self, &out_pixels, &out_width, &out_height, out_bytes_per_pixel)
        return (out_pixels, Int(out_width), Int(out_height))
    }

    public mutating func getTexDataAsRGBA32(outBytesPerPixel out_bytes_per_pixel: UnsafeMutablePointer<Int32>? = nil) -> (out_pixels: UnsafeMutablePointer<UInt8>?, out_width: Int, out_height: Int) {
        var out_pixels: UnsafeMutablePointer<UInt8>? = nil
        var out_width = Int32()
        var out_height = Int32()
        ImFontAtlas_GetTexDataAsRGBA32(&self, &out_pixels, &out_width, &out_height, out_bytes_per_pixel)
        return (out_pixels, Int(out_width), Int(out_height))
    }

    public var glyphRangesChineseFull: UnsafePointer<ImWchar> {
        mutating get {
            return ImFontAtlas_GetGlyphRangesChineseFull(&self)
        }
    }

    public var glyphRangesChineseSimplifiedCommon: UnsafePointer<ImWchar> {
        mutating get {
            return ImFontAtlas_GetGlyphRangesChineseSimplifiedCommon(&self)
        }
    }

    public var glyphRangesCyrillic: UnsafePointer<ImWchar> {
        mutating get {
            return ImFontAtlas_GetGlyphRangesCyrillic(&self)
        }
    }

    public var glyphRangesDefault: UnsafePointer<ImWchar> {
        mutating get {
            return ImFontAtlas_GetGlyphRangesDefault(&self)
        }
    }

    public var glyphRangesJapanese: UnsafePointer<ImWchar> {
        mutating get {
            return ImFontAtlas_GetGlyphRangesJapanese(&self)
        }
    }

    public var glyphRangesKorean: UnsafePointer<ImWchar> {
        mutating get {
            return ImFontAtlas_GetGlyphRangesKorean(&self)
        }
    }

    public var glyphRangesThai: UnsafePointer<ImWchar> {
        mutating get {
            return ImFontAtlas_GetGlyphRangesThai(&self)
        }
    }

    public var glyphRangesVietnamese: UnsafePointer<ImWchar> {
        mutating get {
            return ImFontAtlas_GetGlyphRangesVietnamese(&self)
        }
    }

    public mutating func isBuilt() -> Bool {
        return ImFontAtlas_IsBuilt(&self)
    }

    public mutating func setTexID(id: ImTextureID) -> Void {
        ImFontAtlas_SetTexID(&self, id)
    }

}

extension ImFontAtlasCustomRect {
    public mutating func isPacked() -> Bool {
        return ImFontAtlasCustomRect_IsPacked(&self)
    }

}

extension ImFontGlyphRangesBuilder {
    public mutating func addChar(c: ImWchar) -> Void {
        ImFontGlyphRangesBuilder_AddChar(&self, c)
    }

    public mutating func addRanges(ranges: UnsafePointer<ImWchar>) -> Void {
        ImFontGlyphRangesBuilder_AddRanges(&self, ranges)
    }

    public mutating func addText(text: String, textEnd text_end: UnsafePointer<CChar>? = nil) -> Void {
        ImFontGlyphRangesBuilder_AddText(&self, text, text_end)
    }

    public mutating func buildRanges() -> ImVector_ImWchar {
        var out_ranges = ImVector_ImWchar()
        ImFontGlyphRangesBuilder_BuildRanges(&self, &out_ranges)
        return (out_ranges)
    }

    public mutating func clear() -> Void {
        ImFontGlyphRangesBuilder_Clear(&self)
    }

    @discardableResult
    public mutating func getBit(n: Int) -> Bool {
        return ImFontGlyphRangesBuilder_GetBit(&self, n)
    }

    public mutating func setBit(n: Int) -> Void {
        ImFontGlyphRangesBuilder_SetBit(&self, n)
    }

}

extension ImGuiIO {
    public mutating func addFocusEvent(focused: Bool) -> Void {
        ImGuiIO_AddFocusEvent(&self, focused)
    }

    public mutating func addInputCharacter(c: UInt32) -> Void {
        ImGuiIO_AddInputCharacter(&self, c)
    }

    public mutating func addInputCharacterUTF16(c: ImWchar16) -> Void {
        ImGuiIO_AddInputCharacterUTF16(&self, c)
    }

    public mutating func addInputCharactersUTF8(str: String) -> Void {
        ImGuiIO_AddInputCharactersUTF8(&self, str)
    }

    public mutating func clearInputCharacters() -> Void {
        ImGuiIO_ClearInputCharacters(&self)
    }

}

extension ImGuiInputTextCallbackData {
    public mutating func clearSelection() -> Void {
        ImGuiInputTextCallbackData_ClearSelection(&self)
    }

    public mutating func deleteChars(position pos: Int, bytesCount bytes_count: Int) -> Void {
        ImGuiInputTextCallbackData_DeleteChars(&self, Int32(pos), Int32(bytes_count))
    }

    public mutating func hasSelection() -> Bool {
        return ImGuiInputTextCallbackData_HasSelection(&self)
    }

    public mutating func insertChars(position pos: Int, text: String, textEnd text_end: UnsafePointer<CChar>? = nil) -> Void {
        ImGuiInputTextCallbackData_InsertChars(&self, Int32(pos), text, text_end)
    }

    public mutating func selectAll() -> Void {
        ImGuiInputTextCallbackData_SelectAll(&self)
    }

}

extension ImGuiListClipper {
    public mutating func begin(itemsCount items_count: Int, itemsHeight items_height: Float = -1.0) -> Void {
        ImGuiListClipper_Begin(&self, Int32(items_count), items_height)
    }

    public mutating func end() -> Void {
        ImGuiListClipper_End(&self)
    }

    public mutating func step() -> Bool {
        return ImGuiListClipper_Step(&self)
    }

}

extension ImGuiPayload {
    public mutating func clear() -> Void {
        ImGuiPayload_Clear(&self)
    }

    @discardableResult
    public mutating func isDataType(type: String) -> Bool {
        return ImGuiPayload_IsDataType(&self, type)
    }

    public mutating func isDelivery() -> Bool {
        return ImGuiPayload_IsDelivery(&self)
    }

    public mutating func isPreview() -> Bool {
        return ImGuiPayload_IsPreview(&self)
    }

}

extension ImGuiStorage {
    public mutating func buildSortByKey() -> Void {
        ImGuiStorage_BuildSortByKey(&self)
    }

    public mutating func clear() -> Void {
        ImGuiStorage_Clear(&self)
    }

    @discardableResult
    public mutating func getBool(key: ImGuiID, defaultVal default_val: Bool = false) -> Bool {
        return ImGuiStorage_GetBool(&self, key, default_val)
    }

    public mutating func getBoolRef(key: ImGuiID, defaultVal default_val: Bool = false) -> UnsafeMutablePointer<Bool> {
        return ImGuiStorage_GetBoolRef(&self, key, default_val)
    }

    public mutating func getFloat(key: ImGuiID, defaultVal default_val: Float = 0.0) -> Float {
        return ImGuiStorage_GetFloat(&self, key, default_val)
    }

    public mutating func getFloatRef(key: ImGuiID, defaultVal default_val: Float = 0.0) -> UnsafeMutablePointer<Float> {
        return ImGuiStorage_GetFloatRef(&self, key, default_val)
    }

    public mutating func getInt(key: ImGuiID, defaultVal default_val: Int = 0) -> Int32 {
        return ImGuiStorage_GetInt(&self, key, Int32(default_val))
    }

    public mutating func getIntRef(key: ImGuiID, defaultVal default_val: Int = 0) -> UnsafeMutablePointer<Int32> {
        return ImGuiStorage_GetIntRef(&self, key, Int32(default_val))
    }

    public mutating func getVoidPtr(key: ImGuiID) -> UnsafeMutableRawPointer {
        return ImGuiStorage_GetVoidPtr(&self, key)
    }

    public mutating func getVoidPtrRef(key: ImGuiID, defaultVal default_val: UnsafeMutableRawPointer? = nil) -> UnsafeMutablePointer<UnsafeMutableRawPointer?> {
        return ImGuiStorage_GetVoidPtrRef(&self, key, default_val)
    }

    public mutating func setAllInt(val: Int) -> Void {
        ImGuiStorage_SetAllInt(&self, Int32(val))
    }

    public mutating func setBool(key: ImGuiID, val: Bool) -> Void {
        ImGuiStorage_SetBool(&self, key, val)
    }

    public mutating func setFloat(key: ImGuiID, val: Float) -> Void {
        ImGuiStorage_SetFloat(&self, key, val)
    }

    public mutating func setInt(key: ImGuiID, val: Int) -> Void {
        ImGuiStorage_SetInt(&self, key, Int32(val))
    }

    public mutating func setVoidPtr(key: ImGuiID, val: UnsafeMutableRawPointer) -> Void {
        ImGuiStorage_SetVoidPtr(&self, key, val)
    }

}

extension ImGuiStyle {
    public mutating func scaleAllSizes(scaleFactor scale_factor: Float) -> Void {
        ImGuiStyle_ScaleAllSizes(&self, scale_factor)
    }

}

extension ImGuiTextBuffer {
    public mutating func append(str: String, strEnd str_end: UnsafePointer<CChar>? = nil) -> Void {
        ImGuiTextBuffer_append(&self, str, str_end)
    }

    public mutating func appendfv(format fmt: String) -> Void {
        withVaList([]) { args in
            ImGuiTextBuffer_appendfv(&self, fmt, args)
        }
    }

    public mutating func begin() -> String {
        return String(cString: ImGuiTextBuffer_begin(&self))
    }

    public mutating func c_str() -> String {
        return String(cString: ImGuiTextBuffer_c_str(&self))
    }

    public mutating func clear() -> Void {
        ImGuiTextBuffer_clear(&self)
    }

    public mutating func empty() -> Bool {
        return ImGuiTextBuffer_empty(&self)
    }

    public mutating func end() -> String {
        return String(cString: ImGuiTextBuffer_end(&self))
    }

    public mutating func reserve(capacity: Int) -> Void {
        ImGuiTextBuffer_reserve(&self, Int32(capacity))
    }

    public mutating func size() -> Int32 {
        return ImGuiTextBuffer_size(&self)
    }

}

extension ImGuiTextFilter {
    public mutating func build() -> Void {
        ImGuiTextFilter_Build(&self)
    }

    public mutating func clear() -> Void {
        ImGuiTextFilter_Clear(&self)
    }

    @discardableResult
    public mutating func draw(label: String = "Filter(inc,-exc)", width: Float = 0.0) -> Bool {
        return ImGuiTextFilter_Draw(&self, label, width)
    }

    public mutating func isActive() -> Bool {
        return ImGuiTextFilter_IsActive(&self)
    }

    @discardableResult
    public mutating func passFilter(text: String, textEnd text_end: UnsafePointer<CChar>? = nil) -> Bool {
        return ImGuiTextFilter_PassFilter(&self, text, text_end)
    }

}

extension ImGuiTextRange {
    public mutating func empty() -> Bool {
        return ImGuiTextRange_empty(&self)
    }

    public mutating func split(separator: CChar) -> ImVector_ImGuiTextRange {
        var out = ImVector_ImGuiTextRange()
        ImGuiTextRange_split(&self, separator, &out)
        return (out)
    }

}

extension ImGuiViewport {
    public var center: SIMD2<Float> {
        mutating get {
            var pOut = ImVec2()
            ImGuiViewport_GetCenter(&pOut, &self)
            return (SIMD2<Float>(pOut))
        }
    }

    public var workCenter: SIMD2<Float> {
        mutating get {
            var pOut = ImVec2()
            ImGuiViewport_GetWorkCenter(&pOut, &self)
            return (SIMD2<Float>(pOut))
        }
    }

}

