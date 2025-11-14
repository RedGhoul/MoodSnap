import SwiftUI

/**
 Modern navigation control view with tab bar and floating action button.

 Features:
 - Clean tab bar with 4 main navigation items
 - Floating action button (FAB) for primary action (add mood)
 - Frosted glass background
 - Smooth animations and haptic feedback
 - Responsive design with proper safe area handling
 */
struct ControlView: View {
    @EnvironmentObject var data: DataStoreClass
    @EnvironmentObject var health: HealthManager

    // Primary navigation sheets
    @State private var showingMoodSnapSheet: Bool = false
    @State private var showingSettingsSheet: Bool = false
    @State private var showingStatsSheet: Bool = false

    // Additional feature sheets (accessed via More menu)
    @State private var showingEmergencySheet: Bool = false
    @State private var showingHelpSheet: Bool = false
    @State private var showingNoteSheet: Bool = false
    @State private var showingEventSheet: Bool = false
    @State private var showingMediaSheet: Bool = false
    @State private var showingMoreMenu: Bool = false
    @State private var showingIntroPopover: Bool = false

    // Animation states
    @State private var fabPressed: Bool = false

    var body: some View {
        let theme = themes[data.settings.theme]

        VStack(spacing: 0) {
            // Top divider
            Divider()
                .background(theme.gridColor)

            // Modern tab bar container
            ZStack(alignment: .top) {
                // Background with frosted glass effect
                Color(.systemBackground)
                    .opacity(0.95)
                    .blur(radius: 10)
                    .ignoresSafeArea(edges: .bottom)

                // Tab bar content
                HStack(spacing: 0) {
                    // Timeline tab
                    TabBarButton(
                        icon: "heart.text.square.fill",
                        label: "Timeline",
                        isActive: false,
                        theme: theme
                    ) {
                        // Timeline is always visible, no action needed
                        hapticResponseLight()
                    }

                    Spacer()

                    // Insights tab
                    TabBarButton(
                        icon: "chart.bar.xaxis",
                        label: "Insights",
                        isActive: showingStatsSheet,
                        theme: theme
                    ) {
                        hapticResponseLight()
                        showingStatsSheet.toggle()
                    }
                    .sheet(isPresented: $showingStatsSheet) {
                        InsightsView()
                    }

                    // Center spacer for FAB
                    Spacer()
                        .frame(width: theme.iconSizeXL + theme.spacing5 * 2)

                    // More tab
                    TabBarButton(
                        icon: "ellipsis.circle.fill",
                        label: "More",
                        isActive: showingMoreMenu,
                        theme: theme
                    ) {
                        hapticResponseLight()
                        showingMoreMenu.toggle()
                    }
                    .sheet(isPresented: $showingMoreMenu) {
                        MoreMenuView(
                            showingEventSheet: $showingEventSheet,
                            showingNoteSheet: $showingNoteSheet,
                            showingMediaSheet: $showingMediaSheet,
                            showingHelpSheet: $showingHelpSheet,
                            showingEmergencySheet: $showingEmergencySheet
                        )
                    }

                    Spacer()

                    // Settings tab
                    TabBarButton(
                        icon: "gearshape.fill",
                        label: "Settings",
                        isActive: showingSettingsSheet,
                        theme: theme
                    ) {
                        hapticResponseLight()
                        showingSettingsSheet.toggle()
                    }
                    .sheet(isPresented: $showingSettingsSheet) {
                        SettingsView()
                    }
                }
                .padding(.horizontal, theme.spacing4)
                .padding(.vertical, theme.spacing2)

                // Floating Action Button (FAB) - centered and elevated
                VStack {
                    Button(action: {
                        hapticResponseMedium()
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            fabPressed = true
                        }

                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                fabPressed = false
                            }
                            showingMoodSnapSheet = true
                        }
                    }) {
                        ZStack {
                            // Gradient background
                            if theme.useGradients {
                                LinearGradient(
                                    gradient: Gradient(colors: theme.accentGradient),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            } else {
                                theme.iconColor
                            }

                            // Plus icon
                            Image(systemName: "plus")
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundColor(.white)
                        }
                        .frame(width: theme.iconSizeXL + 8, height: theme.iconSizeXL + 8)
                        .clipShape(Circle())
                        .shadow(
                            color: theme.shadowColor.opacity(fabPressed ? 0.2 : 0.25),
                            radius: fabPressed ? theme.shadowRadius : theme.shadowRadius * 1.5,
                            x: 0,
                            y: fabPressed ? theme.shadowY : theme.shadowY * 2
                        )
                        .scaleEffect(fabPressed ? 0.9 : 1.0)
                    }
                    .offset(y: -8) // Elevate above tab bar
                    .sheet(isPresented: $showingMoodSnapSheet) {
                        MoodSnapView(moodSnap: MoodSnapStruct())
                            .onAppear {
                                hapticPrepare(data: data)
                            }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .frame(height: 60)
        }
        .sheet(isPresented: $showingIntroPopover) {
            IntroPopoverView()
        }
        // Individual sheets for more menu items
        .sheet(isPresented: $showingEventSheet) {
            EventView(moodSnap: MoodSnapStruct())
                .onAppear {
                    hapticPrepare(data: data)
                }
        }
        .sheet(isPresented: $showingNoteSheet) {
            NoteView(moodSnap: MoodSnapStruct())
                .onAppear {
                    hapticPrepare(data: data)
                }
        }
        .sheet(isPresented: $showingMediaSheet) {
            MediaView(moodSnap: MoodSnapStruct())
                .onAppear {
                    hapticPrepare(data: data)
                }
        }
        .sheet(isPresented: $showingHelpSheet) {
            HelpView()
        }
    }
}

/**
 Modern tab bar button with icon and label.

 Features smooth scale animation and active state highlighting.
 */
struct TabBarButton: View {
    let icon: String
    let label: String
    let isActive: Bool
    let theme: ThemeStruct
    let action: () -> Void

    @State private var isPressed: Bool = false

    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                isPressed = true
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    isPressed = false
                }
            }

            action()
        }) {
            VStack(spacing: theme.spacing1) {
                // Icon
                Image(systemName: icon)
                    .font(.system(size: theme.iconSizeMedium))
                    .foregroundColor(isActive ? theme.iconColor : .secondary)
                    .frame(height: theme.iconSizeMedium)

                // Label
                Text(label.localize())
                    .font(theme.fontCaption2)
                    .foregroundColor(isActive ? theme.iconColor : .secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, theme.spacing1)
            .background(
                Group {
                    if isActive {
                        RoundedRectangle(cornerRadius: theme.cornerRadiusSmall)
                            .fill(theme.iconColor.opacity(0.1))
                    }
                }
            )
            .scaleEffect(isPressed ? 0.9 : 1.0)
        }
        .buttonStyle(.plain)
    }
}

/**
 More menu view with additional features.

 Provides access to Event, Note, Media, Help, and Emergency features.
 */
struct MoreMenuView: View {
    @EnvironmentObject var data: DataStoreClass
    @Environment(\.dismiss) var dismiss

    @Binding var showingEventSheet: Bool
    @Binding var showingNoteSheet: Bool
    @Binding var showingMediaSheet: Bool
    @Binding var showingHelpSheet: Bool
    @Binding var showingEmergencySheet: Bool

    var body: some View {
        let theme = themes[data.settings.theme]

        NavigationView {
            List {
                Section {
                    MoreMenuItem(
                        icon: "star.square.fill",
                        title: "Event",
                        description: "Mark important moments",
                        theme: theme
                    ) {
                        hapticResponseLight()
                        dismiss()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            showingEventSheet = true
                        }
                    }

                    MoreMenuItem(
                        icon: "note.text.badge.plus",
                        title: "Note",
                        description: "Add a quick note",
                        theme: theme
                    ) {
                        hapticResponseLight()
                        dismiss()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            showingNoteSheet = true
                        }
                    }

                    MoreMenuItem(
                        icon: "photo.on.rectangle.angled",
                        title: "Media",
                        description: "Attach photos or media",
                        theme: theme
                    ) {
                        hapticResponseLight()
                        dismiss()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            showingMediaSheet = true
                        }
                    }
                } header: {
                    Text("Quick Actions".localize())
                }

                Section {
                    MoreMenuItem(
                        icon: "questionmark.circle.fill",
                        title: "Help",
                        description: "Get help and support",
                        theme: theme
                    ) {
                        hapticResponseLight()
                        dismiss()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            showingHelpSheet = true
                        }
                    }
                } header: {
                    Text("Support".localize())
                }
            }
            .navigationTitle("More".localize())
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done".localize()) {
                        hapticResponseLight()
                        dismiss()
                    }
                    .foregroundColor(theme.iconColor)
                }
            }
        }
    }
}

/**
 Individual menu item in the More menu.
 */
struct MoreMenuItem: View {
    let icon: String
    let title: String
    let description: String
    let theme: ThemeStruct
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: theme.spacing3) {
                // Icon with circular background
                ZStack {
                    Circle()
                        .fill(theme.iconColor.opacity(0.1))
                        .frame(width: theme.iconSizeLarge, height: theme.iconSizeLarge)

                    Image(systemName: icon)
                        .font(.system(size: theme.iconSizeSmall))
                        .foregroundColor(theme.iconColor)
                }

                VStack(alignment: .leading, spacing: theme.spacing1) {
                    Text(title.localize())
                        .font(theme.fontBody)
                        .foregroundColor(.primary)

                    Text(description.localize())
                        .font(theme.fontCaption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(theme.fontCaption)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, theme.spacing1)
        }
    }
}
