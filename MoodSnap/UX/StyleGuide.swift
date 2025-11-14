//
//  StyleGuide.swift
//  MoodSnap
//
//  Modern UI/UX Style Components
//  Provides reusable ViewModifiers for consistent, award-worthy design
//

import SwiftUI

// MARK: - Card Styles

/**
 Modern card style with shadow, rounded corners, and optional background

 Usage:
 ```
 VStack {
     // content
 }
 .modifier(CardStyle(theme: themes[data.settings.theme]))
 ```
 */
struct CardStyle: ViewModifier {
    let theme: ThemeStruct
    var backgroundColor: Color = Color(.systemBackground)
    var useShadow: Bool = true

    func body(content: Content) -> some View {
        content
            .padding(theme.cardPadding)
            .background(backgroundColor)
            .cornerRadius(theme.cornerRadiusMedium)
            .shadow(
                color: useShadow ? theme.shadowColor : Color.clear,
                radius: theme.shadowRadius,
                x: 0,
                y: theme.shadowY
            )
    }
}

/**
 Large card style for prominent UI elements
 */
struct LargeCardStyle: ViewModifier {
    let theme: ThemeStruct
    var backgroundColor: Color = Color(.systemBackground)

    func body(content: Content) -> some View {
        content
            .padding(theme.spacing5)
            .background(backgroundColor)
            .cornerRadius(theme.cornerRadiusLarge)
            .shadow(
                color: theme.shadowColor,
                radius: theme.shadowRadius * 1.5,
                x: 0,
                y: theme.shadowY * 1.5
            )
    }
}

/**
 Glass morphism effect for modern, frosted UI elements
 */
struct GlassMorphismStyle: ViewModifier {
    let theme: ThemeStruct
    var tintColor: Color = Color.white
    var blur: CGFloat = 10

    func body(content: Content) -> some View {
        content
            .background(
                tintColor.opacity(theme.cardBackgroundOpacity)
                    .blur(radius: blur)
            )
            .cornerRadius(theme.cornerRadiusMedium)
            .overlay(
                RoundedRectangle(cornerRadius: theme.cornerRadiusMedium)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            )
            .shadow(
                color: theme.shadowColor,
                radius: theme.shadowRadius,
                x: 0,
                y: theme.shadowY
            )
    }
}

// MARK: - Section Headers

/**
 Modern section header with icon and consistent styling

 Usage:
 ```
 Text("Section Title")
     .modifier(SectionHeaderStyle(theme: themes[data.settings.theme]))
 ```
 */
struct SectionHeaderStyle: ViewModifier {
    let theme: ThemeStruct

    func body(content: Content) -> some View {
        content
            .font(theme.fontHeadline)
            .foregroundColor(theme.iconColor)
            .padding(.leading, theme.spacing3)
            .padding(.top, theme.spacing4)
            .padding(.bottom, theme.spacing2)
    }
}

/**
 Compact section header for dense layouts
 */
struct CompactSectionHeaderStyle: ViewModifier {
    let theme: ThemeStruct

    func body(content: Content) -> some View {
        content
            .font(theme.fontCallout)
            .foregroundColor(.secondary)
            .padding(.leading, theme.spacing3)
            .padding(.top, theme.spacing2)
            .padding(.bottom, theme.spacing1)
    }
}

// MARK: - Button Styles

/**
 Floating action button style with gradient and shadow
 */
struct FloatingButtonStyle: ButtonStyle {
    let theme: ThemeStruct
    let gradient: [Color]

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(theme.fontHeadline)
            .foregroundColor(.white)
            .padding(.horizontal, theme.spacing5)
            .padding(.vertical, theme.spacing4)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: gradient),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(theme.cornerRadiusLarge)
            .shadow(
                color: theme.shadowColor.opacity(configuration.isPressed ? 0.05 : 0.15),
                radius: configuration.isPressed ? theme.shadowRadius * 0.5 : theme.shadowRadius * 2,
                x: 0,
                y: configuration.isPressed ? theme.shadowY * 0.5 : theme.shadowY * 2
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

/**
 Pill-shaped toggle button style for symptoms, activities, social
 */
struct PillToggleStyle: ToggleStyle {
    let theme: ThemeStruct
    let accentColor: Color

    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
            hapticResponseLight()
        } label: {
            configuration.label
                .font(theme.fontCaption)
                .padding(.horizontal, theme.spacing3)
                .padding(.vertical, theme.spacing2)
                .background(
                    Group {
                        if configuration.isOn {
                            if theme.useGradients {
                                LinearGradient(
                                    gradient: Gradient(colors: [accentColor.opacity(0.8), accentColor]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            } else {
                                accentColor
                            }
                        } else {
                            Color(.systemGray6)
                        }
                    }
                )
                .foregroundColor(configuration.isOn ? .white : .primary)
                .cornerRadius(theme.cornerRadiusSmall)
                .overlay(
                    RoundedRectangle(cornerRadius: theme.cornerRadiusSmall)
                        .stroke(
                            configuration.isOn ? Color.clear : Color(.systemGray4),
                            lineWidth: 1
                        )
                )
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

/**
 Scale animation button style for interactive feedback
 */
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.8), value: configuration.isPressed)
    }
}

// MARK: - Expandable Card

/**
 Expandable card with smooth animation and chevron indicator
 */
struct ExpandableCardStyle: ViewModifier {
    let theme: ThemeStruct
    let isExpanded: Bool
    let icon: String
    let title: String
    let isProcessing: Bool
    let toggleAction: () -> Void

    func body(content: Content) -> some View {
        GroupBox {
            VStack(alignment: .leading, spacing: theme.spacing3) {
                // Header
                Button(action: {
                    hapticResponseLight()
                    toggleAction()
                }) {
                    HStack {
                        Image(systemName: icon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: theme.iconSizeMedium, height: theme.iconSizeMedium)
                            .foregroundColor(theme.iconColor)

                        Text(title)
                            .font(theme.fontHeadline)
                            .foregroundColor(theme.iconColor)

                        Spacer()

                        if isProcessing {
                            ProgressView()
                                .padding(.trailing, theme.spacing2)
                        }

                        Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                            .foregroundColor(.secondary)
                            .font(theme.fontCallout)
                    }
                }
                .buttonStyle(ScaleButtonStyle())

                // Content (with animation)
                if isExpanded {
                    content
                        .transition(.asymmetric(
                            insertion: .opacity.combined(with: .move(edge: .top)),
                            removal: .opacity
                        ))
                }
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isExpanded)
    }
}

// MARK: - Gradient Helpers

/**
 Helper to create linear gradient from theme gradient array
 */
extension View {
    func themeGradient(colors: [Color], startPoint: UnitPoint = .topLeading, endPoint: UnitPoint = .bottomTrailing) -> some View {
        self.background(
            LinearGradient(
                gradient: Gradient(colors: colors),
                startPoint: startPoint,
                endPoint: endPoint
            )
        )
    }
}

// MARK: - Spacing Helpers

/**
 Convenient padding extensions using theme spacing scale
 */
extension View {
    func themePadding(_ theme: ThemeStruct, _ edges: Edge.Set = .all, scale: Int = 3) -> some View {
        let spacing: CGFloat = {
            switch scale {
            case 1: return theme.spacing1
            case 2: return theme.spacing2
            case 3: return theme.spacing3
            case 4: return theme.spacing4
            case 5: return theme.spacing5
            case 6: return theme.spacing6
            default: return theme.spacing3
            }
        }()
        return self.padding(edges, spacing)
    }
}

// MARK: - Slider Style

/**
 Modern slider style with gradient track
 */
struct GradientSliderStyle: ViewModifier {
    let theme: ThemeStruct
    let gradientColors: [Color]
    let value: CGFloat

    func body(content: Content) -> some View {
        VStack(alignment: .leading, spacing: theme.spacing2) {
            content

            // Visual gradient track preview
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background track
                    RoundedRectangle(cornerRadius: theme.cornerRadiusSmall)
                        .fill(Color(.systemGray5))
                        .frame(height: 8)

                    // Gradient fill
                    RoundedRectangle(cornerRadius: theme.cornerRadiusSmall)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: gradientColors),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * (value / 4.0), height: 8)
                }
            }
            .frame(height: 8)
        }
    }
}

// MARK: - Badge Style

/**
 Circular badge for counts and indicators
 */
struct BadgeStyle: ViewModifier {
    let theme: ThemeStruct
    let backgroundColor: Color

    func body(content: Content) -> some View {
        content
            .font(theme.fontCaption2)
            .foregroundColor(.white)
            .padding(.horizontal, theme.spacing2)
            .padding(.vertical, theme.spacing1)
            .background(backgroundColor)
            .cornerRadius(theme.cornerRadiusSmall)
    }
}

// MARK: - Divider Style

/**
 Themed divider with consistent styling
 */
struct ThemedDivider: View {
    let theme: ThemeStruct

    var body: some View {
        Divider()
            .background(theme.gridColor)
    }
}

// MARK: - Empty State Style

/**
 Empty state view with icon, title, and description
 */
struct EmptyStateView: View {
    let theme: ThemeStruct
    let icon: String
    let title: String
    let description: String
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: theme.spacing4) {
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .frame(width: theme.iconSizeXL, height: theme.iconSizeXL)
                .foregroundColor(theme.iconColor.opacity(0.5))

            VStack(spacing: theme.spacing2) {
                Text(title.localize())
                    .font(theme.fontTitle2)
                    .foregroundColor(.primary)

                Text(description.localize())
                    .font(theme.fontCallout)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }

            if let actionTitle = actionTitle, let action = action {
                Button(action: action) {
                    Text(actionTitle.localize())
                        .font(theme.fontHeadline)
                }
                .buttonStyle(FloatingButtonStyle(theme: theme, gradient: theme.accentGradient))
                .padding(.top, theme.spacing2)
            }
        }
        .padding(theme.spacing6)
    }
}

// MARK: - Loading State

/**
 Skeleton loading view for async content
 */
struct SkeletonLoadingView: View {
    let theme: ThemeStruct
    @State private var isAnimating = false

    var body: some View {
        RoundedRectangle(cornerRadius: theme.cornerRadiusSmall)
            .fill(Color(.systemGray5))
            .overlay(
                RoundedRectangle(cornerRadius: theme.cornerRadiusSmall)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.clear,
                                Color.white.opacity(0.5),
                                Color.clear
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .offset(x: isAnimating ? 200 : -200)
            )
            .clipped()
            .onAppear {
                withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    isAnimating = true
                }
            }
    }
}

// MARK: - View Extensions

extension View {
    /**
     Apply modern card styling
     */
    func modernCard(theme: ThemeStruct, backgroundColor: Color = Color(.systemBackground), useShadow: Bool = true) -> some View {
        self.modifier(CardStyle(theme: theme, backgroundColor: backgroundColor, useShadow: useShadow))
    }

    /**
     Apply large card styling
     */
    func largeCard(theme: ThemeStruct, backgroundColor: Color = Color(.systemBackground)) -> some View {
        self.modifier(LargeCardStyle(theme: theme, backgroundColor: backgroundColor))
    }

    /**
     Apply section header styling
     */
    func sectionHeader(theme: ThemeStruct) -> some View {
        self.modifier(SectionHeaderStyle(theme: theme))
    }

    /**
     Apply compact section header styling
     */
    func compactSectionHeader(theme: ThemeStruct) -> some View {
        self.modifier(CompactSectionHeaderStyle(theme: theme))
    }

    /**
     Apply badge styling
     */
    func badge(theme: ThemeStruct, backgroundColor: Color) -> some View {
        self.modifier(BadgeStyle(theme: theme, backgroundColor: backgroundColor))
    }
}
