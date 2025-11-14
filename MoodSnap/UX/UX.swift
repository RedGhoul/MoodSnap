import SwiftUI

/**
 Struct defining UX theme.
 */
struct ThemeStruct: Identifiable {
    var id: UUID = UUID()
    var version: Int = 1

    // Name
    var name: String = "Primary"

    // Colors
    var elevationColor: Color = Color.green
    var depressionColor: Color = Color.red
    var anxietyColor: Color = Color.orange
    var irritabilityColor: Color = Color.yellow

    var gridColor: Color = Color.gray.opacity(0.2)
    var buttonColor: Color = Color.primary
    var iconColor: Color = Color.primary
    var controlColor: Color = Color.primary
    var emergencyColor: Color = Color.red
    var logoColor: Color = Color(0x2D65AF)
    
    var menstrualColor: Color = Color(0xF47157)
    var menstrualLabelColor: Color = Color(0x5D5BDD)
    var walkingRunningColor: Color = Color(0xFE6532)
    var energyColor: Color = Color(0xFE6532)
    var weightColor: Color = Color(0xB15FE9)
    var sleepColor: Color = Color(0x86E2E0)

    // MARK: - Design System Properties

    // Spacing System (replaces magic numbers with consistent scale)
    var spacing1: CGFloat = 4      // Tight - Component internal spacing
    var spacing2: CGFloat = 8      // Compact - Tight layout
    var spacing3: CGFloat = 12     // Standard - Default spacing
    var spacing4: CGFloat = 16     // Comfortable - Relaxed spacing
    var spacing5: CGFloat = 24     // Relaxed - Section spacing
    var spacing6: CGFloat = 32     // Spacious - Page margins

    // Corner Radius System
    var cornerRadiusSmall: CGFloat = 8    // Small buttons, badges
    var cornerRadiusMedium: CGFloat = 12  // Cards, toggles
    var cornerRadiusLarge: CGFloat = 16   // Major cards, modals
    var cornerRadiusXL: CGFloat = 24      // Hero elements

    // Shadow System
    var shadowRadius: CGFloat = 8         // Card shadow blur radius
    var shadowY: CGFloat = 2              // Shadow vertical offset
    var shadowOpacity: Double = 0.1       // Shadow opacity
    var shadowColor: Color = Color.black.opacity(0.1)  // Shadow color

    // Card Styling
    var cardBackgroundOpacity: Double = 0.5
    var cardPadding: CGFloat = 16

    // Typography Scale
    var fontLargeTitle: Font = .largeTitle.bold()   // 34pt Bold - Page titles
    var fontTitle: Font = .title2.bold()            // 28pt Bold - Section titles
    var fontTitle2: Font = .title3.bold()           // 22pt Bold - Card titles
    var fontHeadline: Font = .headline              // 17pt Semibold - Emphasis
    var fontBody: Font = .body                      // 17pt Regular - Default text
    var fontCallout: Font = .callout                // 16pt Regular - Secondary text
    var fontSubheadline: Font = .subheadline        // 15pt - Tertiary text
    var fontCaption: Font = .caption                // 12pt Regular - Labels
    var fontCaption2: Font = .caption2              // 11pt Regular - Minimal text

    // Icon Sizes (Enhanced with full scale)
    var iconSizeTiny: CGFloat = 16
    var iconSizeSmall: CGFloat = 20
    var iconSizeMedium: CGFloat = 24
    var iconSizeLarge: CGFloat = 32
    var iconSizeXL: CGFloat = 48

    // Gradients (New feature for modern styling)
    var useGradients: Bool = true
    var elevationGradient: [Color] = [Color.green.opacity(0.8), Color.green]
    var depressionGradient: [Color] = [Color.red.opacity(0.8), Color.red]
    var anxietyGradient: [Color] = [Color.orange.opacity(0.8), Color.orange]
    var irritabilityGradient: [Color] = [Color.yellow.opacity(0.8), Color.yellow]
    var accentGradient: [Color] = [Color.blue.opacity(0.8), Color.blue]

    // Legacy Dimensions (kept for backwards compatibility)
    var hBarHeight: CGFloat = 11
    var hBarRadius: CGFloat = 5
    var hBarFontSize: CGFloat = 12
    var controlIconSize: CGFloat = 25
    var controlBigIconSize: CGFloat = 40
    var closeButtonIconSize: CGFloat = 25

    var sliderSpacing: CGFloat = -5
    var historyGridSpacing: CGFloat = 7
    var moodSnapGridSpacing: CGFloat = 0

    var barShadeOffset: CGFloat = 1.0
}

/**
 Primary theme constructor.
 */
func PrimaryTheme() -> ThemeStruct {
    var theme = ThemeStruct()

    // Gradients (Default iOS colors with subtle gradients)
    theme.elevationGradient = [Color(0x66DD88), Color.green]
    theme.depressionGradient = [Color(0xFF6B6B), Color.red]
    theme.anxietyGradient = [Color(0xFFAA66), Color.orange]
    theme.irritabilityGradient = [Color(0xFFDD66), Color.yellow]
    theme.accentGradient = [Color(0x5DADE2), Color.blue]

    // Standard shadow
    theme.shadowColor = Color.black.opacity(0.1)

    return theme
}

/**
 Color blind theme constructor.
 */
func ColorBlindTheme() -> ThemeStruct {
    let ibmColorBlindPaletteBlue = Color(0x648FFF)
    let ibmColorBlindPalettePurple = Color(0x785EF0)
    let ibmColorBlindPalettePink = Color(0xDC267F)
    let ibmColorBlindPaletteOrange = Color(0xFE6100)
    let ibmColorBlindPaletteYellow = Color(0xFFB000)

    var theme: ThemeStruct = ThemeStruct()
    theme.name = "color_blind"
    theme.buttonColor = Color.primary
    theme.iconColor = ibmColorBlindPaletteBlue
    theme.controlColor = ibmColorBlindPaletteBlue
    theme.elevationColor = ibmColorBlindPaletteBlue
    theme.depressionColor = ibmColorBlindPalettePink
    theme.anxietyColor = ibmColorBlindPaletteOrange
    theme.irritabilityColor = ibmColorBlindPaletteYellow
    theme.emergencyColor = ibmColorBlindPalettePurple

    // Gradients (IBM Color Blind Palette with lighter variants)
    theme.elevationGradient = [Color(0x8AACFF), ibmColorBlindPaletteBlue]
    theme.depressionGradient = [Color(0xE85699), ibmColorBlindPalettePink]
    theme.anxietyGradient = [Color(0xFF8533), ibmColorBlindPaletteOrange]
    theme.irritabilityGradient = [Color(0xFFC233), ibmColorBlindPaletteYellow]
    theme.accentGradient = [Color(0x9B7FF4), ibmColorBlindPalettePurple]

    // Shadow color adjusted for theme
    theme.shadowColor = Color.black.opacity(0.12)

    return theme
}

/**
 Pastel theme constructor.
 */
func PastelTheme() -> ThemeStruct {
    let pastelBlue = Color(0x55CBCD)
    let pastelRed = Color(0xFF968A)
    let pastelCyan = Color(0xA2E1DB)
    let pastelOrange = Color(0xFFC8A2)
    let pastelYellow = Color(0xFFFFB5)

    var theme: ThemeStruct = ThemeStruct()
    theme.name = "pastel"
    theme.buttonColor = pastelBlue
    theme.iconColor = pastelBlue
    theme.controlColor = pastelBlue
    theme.elevationColor = pastelCyan
    theme.depressionColor = pastelRed
    theme.anxietyColor = pastelOrange
    theme.irritabilityColor = pastelYellow
    theme.emergencyColor = pastelRed

    // Gradients (Soft pastel gradients)
    theme.elevationGradient = [Color(0xC7F0F0), pastelCyan]
    theme.depressionGradient = [Color(0xFFBEB5), pastelRed]
    theme.anxietyGradient = [Color(0xFFDCC7), pastelOrange]
    theme.irritabilityGradient = [Color(0xFFFFD4), pastelYellow]
    theme.accentGradient = [Color(0x89DBDD), pastelBlue]

    // Softer shadow for pastel theme
    theme.shadowColor = Color.black.opacity(0.08)

    return theme
}

/**
 Summer theme constructor.
 */
func SummerTheme() -> ThemeStruct {
    // let summerWhite = Color(0xF0F2E7)
    let summerRed = Color(0xFF8296)
    let summerCyan = Color(0x75CDD8)
    let summerOrange = Color(0xFFCA27)
    let summerYellow = Color(0xFFEC00)

    var theme: ThemeStruct = ThemeStruct()
    theme.name = "summer"
    theme.buttonColor = summerYellow
    theme.iconColor = summerYellow
    theme.controlColor = summerYellow
    theme.elevationColor = summerCyan
    theme.depressionColor = summerRed
    theme.anxietyColor = summerOrange
    theme.irritabilityColor = summerYellow
    theme.emergencyColor = summerRed

    // Gradients (Bright summer gradients)
    theme.elevationGradient = [Color(0xA1DCE5), summerCyan]
    theme.depressionGradient = [Color(0xFFAAB8), summerRed]
    theme.anxietyGradient = [Color(0xFFD95C), summerOrange]
    theme.irritabilityGradient = [Color(0xFFF34D), summerYellow]
    theme.accentGradient = [Color(0xFFF566), summerYellow]

    // Standard shadow
    theme.shadowColor = Color.black.opacity(0.1)

    return theme
}

/**
 Aqua theme constructor.
 */
func AquaTheme() -> ThemeStruct {
    var theme: ThemeStruct = ThemeStruct()
    theme.name = "Aqua"
    theme.buttonColor = Color.blue
    theme.iconColor = Color.blue
    theme.controlColor = Color.blue

    // Gradients (Aqua/Blue theme with oceanic feel)
    theme.elevationGradient = [Color(0x66CC99), Color(0x33AA77)]
    theme.depressionGradient = [Color(0xFF6B6B), Color(0xEE4444)]
    theme.anxietyGradient = [Color(0xFFAA66), Color(0xFF8833)]
    theme.irritabilityGradient = [Color(0xFFDD66), Color(0xFFCC33)]
    theme.accentGradient = [Color(0x5DADE2), Color(0x3498DB)]

    // Standard shadow
    theme.shadowColor = Color.black.opacity(0.1)

    return theme
}

/**
 Orange theme constructor.
 */
func OrangeTheme() -> ThemeStruct {
    var theme: ThemeStruct = ThemeStruct()
    theme.name = "Orange"
    theme.buttonColor = Color.orange
    theme.iconColor = Color.orange
    theme.controlColor = Color.orange

    // Gradients (Warm orange theme)
    theme.elevationGradient = [Color(0x66DD99), Color(0x33BB66)]
    theme.depressionGradient = [Color(0xFF6B6B), Color(0xEE4444)]
    theme.anxietyGradient = [Color(0xFFAA66), Color(0xFF8833)]
    theme.irritabilityGradient = [Color(0xFFDD66), Color(0xFFCC33)]
    theme.accentGradient = [Color(0xFFAA66), Color(0xFF8833)]

    // Standard shadow
    theme.shadowColor = Color.black.opacity(0.1)

    return theme
}

/**
 Themes list.
 */
let themes = [AquaTheme(), ColorBlindTheme(), OrangeTheme(), PrimaryTheme(), PastelTheme(), SummerTheme()]
