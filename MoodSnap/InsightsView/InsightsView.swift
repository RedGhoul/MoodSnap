import SwiftUI

/**
 Modern analytics dashboard with hero stats and beautiful card grid.

 Features:
 - Hero stats section at top
 - Modern card grid with shadows
 - Smooth expand/collapse animations
 - Clean section headers
 - Professional typography hierarchy
 */
struct InsightsView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var data: DataStoreClass
    @EnvironmentObject var health: HealthManager
    @State var timescale: Int = TimeScaleEnum.all.rawValue

    var body: some View {
        let theme = themes[data.settings.theme]
        let convertedTimescale: Int = getTimescale(timescale: timescale, moodSnaps: data.moodSnaps)

        NavigationView {
            ScrollView {
                VStack(spacing: theme.spacing5) {
                    // Time Range Picker
                    ModernSegmentedPicker(selection: $timescale, theme: theme)
                        .padding(.horizontal, theme.spacing4)

                    // Hero Stats (Quick Overview)
                    HeroStatsSection(
                        timescale: convertedTimescale,
                        theme: theme
                    )
                    .padding(.horizontal, theme.spacing4)

                    // HISTORY Section
                    SectionHeader(title: "HISTORY".localize(), theme: theme)
                        .padding(.horizontal, theme.spacing4)

                    VStack(spacing: theme.spacing3) {
                        InsightCard(
                            icon: "brain.head.profile",
                            title: "average_mood".localize(),
                            isExpanded: $data.uxState.isAverageMoodExpanded,
                            isProcessing: data.processingStatus.averages,
                            theme: theme
                        ) {
                            AverageMoodView(timescale: convertedTimescale, showTrend: true)
                        }

                        InsightCard(
                            icon: "chart.bar.xaxis",
                            title: "mood_history".localize(),
                            isExpanded: $data.uxState.isMoodHistoryExpanded,
                            isProcessing: data.processingStatus.history,
                            theme: theme
                        ) {
                            MoodHistoryBarView(timescale: convertedTimescale)
                        }

                        InsightCard(
                            icon: "waveform.path.ecg",
                            title: "moving_average".localize(),
                            isExpanded: $data.uxState.isMovingAverageExpanded,
                            isProcessing: data.processingStatus.history,
                            theme: theme
                        ) {
                            MoodAverageView(timescale: convertedTimescale)
                        }

                        InsightCard(
                            icon: "waveform",
                            title: "volatility".localize(),
                            isExpanded: $data.uxState.isVolatilityExpanded,
                            isProcessing: data.processingStatus.history,
                            theme: theme
                        ) {
                            VolatilityView(timescale: convertedTimescale)
                        }

                        InsightCard(
                            icon: "number",
                            title: "tally".localize(),
                            isExpanded: $data.uxState.isTallyExpanded,
                            isProcessing: data.processingStatus.stats,
                            theme: theme
                        ) {
                            TallyView(timescale: convertedTimescale)
                        }
                    }
                    .padding(.horizontal, theme.spacing4)

                    // INFLUENCES Section
                    SectionHeader(title: "INFLUENCES".localize(), theme: theme)
                        .padding(.horizontal, theme.spacing4)

                    VStack(spacing: theme.spacing3) {
                        InsightCard(
                            icon: "figure.walk",
                            title: "activity".localize(),
                            isExpanded: $data.uxState.isActivitiesExpanded,
                            isProcessing: data.processingStatus.activities,
                            theme: theme
                        ) {
                            ActivitiesView()
                        }

                        InsightCard(
                            icon: "person.2",
                            title: "social".localize(),
                            isExpanded: $data.uxState.isSocialExpanded,
                            isProcessing: data.processingStatus.social,
                            theme: theme
                        ) {
                            SocialView()
                        }

                        InsightCard(
                            icon: "heart.text.square",
                            title: "symptoms".localize(),
                            isExpanded: $data.uxState.isSymptomsExpanded,
                            isProcessing: data.processingStatus.symptoms,
                            theme: theme
                        ) {
                            SymptomsView()
                        }

                        InsightCard(
                            icon: "star.square",
                            title: "Events".localize(),
                            isExpanded: $data.uxState.isEventsExpanded,
                            isProcessing: data.processingStatus.events,
                            theme: theme
                        ) {
                            EventsView(timescale: convertedTimescale)
                        }

                        InsightCard(
                            icon: "number.square",
                            title: "Hashtags".localize(),
                            isExpanded: $data.uxState.isHashtagsExpanded,
                            isProcessing: data.processingStatus.hashtags,
                            theme: theme
                        ) {
                            HashtagsView()
                        }
                    }
                    .padding(.horizontal, theme.spacing4)

                    // Transients
                    SectionHeader(title: "transients".localize(), theme: theme)
                        .padding(.horizontal, theme.spacing4)

                    VStack(spacing: theme.spacing3) {
                        InsightCard(
                            icon: "chart.line.uptrend.xyaxis",
                            title: "Events".localize(),
                            isExpanded: $data.uxState.isButterflyExpanded,
                            isProcessing: data.processingStatus.events,
                            theme: theme
                        ) {
                            ButterflyView()
                        }
                    }
                    .padding(.horizontal, theme.spacing4)

                    // HEALTH Section (conditional)
                    if data.settings.appleHealth && (
                        data.processedData.healthSnapDates.count > 0 ||
                        health.weightSnaps.count > 0 ||
                        health.energySnaps.count > 0 ||
                        health.distanceSnaps.count > 0 ||
                        health.sleepSnaps.count > 0 ||
                        health.menstrualSnaps.count > 0
                    ) {
                        SectionHeader(title: "HEALTH".localize(), theme: theme)
                            .padding(.horizontal, theme.spacing4)

                        VStack(spacing: theme.spacing3) {
                            if health.weightSnaps.count > 0 {
                                InsightCard(
                                    icon: "scalemass",
                                    title: "Weight".localize(),
                                    isExpanded: $data.uxState.isWeightExpanded,
                                    isProcessing: false,
                                    theme: theme
                                ) {
                                    WeightView()
                                }
                            }

                            if health.distanceSnaps.count > 0 {
                                InsightCard(
                                    icon: "figure.walk",
                                    title: "Walking_running_distance".localize(),
                                    isExpanded: $data.uxState.isDistanceExpanded,
                                    isProcessing: false,
                                    theme: theme
                                ) {
                                    DistanceView()
                                }
                            }

                            if health.energySnaps.count > 0 {
                                InsightCard(
                                    icon: "bolt",
                                    title: "Active_energy".localize(),
                                    isExpanded: $data.uxState.isEnergyExpanded,
                                    isProcessing: false,
                                    theme: theme
                                ) {
                                    EnergyView()
                                }
                            }

                            if health.sleepSnaps.count > 0 {
                                InsightCard(
                                    icon: "bed.double",
                                    title: "Sleep".localize(),
                                    isExpanded: $data.uxState.isSleepExpanded,
                                    isProcessing: false,
                                    theme: theme
                                ) {
                                    SleepView()
                                }
                            }

                            if health.menstrualSnaps.count > 0 {
                                InsightCard(
                                    icon: "calendar",
                                    title: "Menstrual_cycle".localize(),
                                    isExpanded: $data.uxState.isMenstrualExpanded,
                                    isProcessing: false,
                                    theme: theme
                                ) {
                                    MenstrualView()
                                }
                            }
                        }
                        .padding(.horizontal, theme.spacing4)
                    }
                }
                .padding(.top, theme.spacing3)
                .padding(.bottom, theme.spacing6)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("insights".localize())
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done".localize()) {
                        dismiss()
                    }
                    .foregroundColor(theme.iconColor)
                }
            }
        }
    }
}

// MARK: - Hero Stats Section

/**
 Quick overview stats at the top of dashboard
 */
struct HeroStatsSection: View {
    @EnvironmentObject var data: DataStoreClass
    let timescale: Int
    let theme: ThemeStruct

    var body: some View {
        if data.moodSnaps.count > 0 {
            VStack(spacing: theme.spacing3) {
                // Stats grid
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: theme.spacing3) {
                    HeroStatCard(
                        icon: "chart.bar.fill",
                        label: "Entries".localize(),
                        value: "\(data.moodSnaps.filter { $0.snapType == .mood }.count)",
                        color: theme.iconColor,
                        theme: theme
                    )

                    HeroStatCard(
                        icon: "calendar.badge.clock",
                        label: "Days Tracked".localize(),
                        value: "\(data.processedData.dates.count)",
                        color: theme.iconColor,
                        theme: theme
                    )
                }
            }
        }
    }
}

/**
 Individual hero stat card
 */
struct HeroStatCard: View {
    let icon: String
    let label: String
    let value: String
    let color: Color
    let theme: ThemeStruct

    var body: some View {
        VStack(spacing: theme.spacing2) {
            Image(systemName: icon)
                .font(.system(size: theme.iconSizeMedium))
                .foregroundColor(color)

            Text(value)
                .font(theme.fontTitle)
                .foregroundColor(.primary)

            Text(label)
                .font(theme.fontCaption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(theme.spacing4)
        .background(Color(.systemBackground))
        .cornerRadius(theme.cornerRadiusMedium)
        .shadow(color: theme.shadowColor, radius: theme.shadowRadius * 0.5, x: 0, y: theme.shadowY)
    }
}

// MARK: - Modern Segmented Picker

/**
 Modern time range picker with better styling
 */
struct ModernSegmentedPicker: View {
    @Binding var selection: Int
    let theme: ThemeStruct

    var body: some View {
        Picker("", selection: $selection) {
            Text("1mo".localize()).tag(TimeScaleEnum.month.rawValue)
            Text("3mo".localize()).tag(TimeScaleEnum.threeMonths.rawValue)
            Text("6mo".localize()).tag(TimeScaleEnum.sixMonths.rawValue)
            Text("1yr".localize()).tag(TimeScaleEnum.year.rawValue)
            Text("All".localize()).tag(TimeScaleEnum.all.rawValue)
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding(theme.spacing1)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(theme.cornerRadiusSmall)
    }
}

// MARK: - Section Header

/**
 Section header for dashboard
 */
struct SectionHeader: View {
    let title: String
    let theme: ThemeStruct

    var body: some View {
        HStack {
            Text(title)
                .font(theme.fontCallout)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
            Spacer()
        }
        .padding(.top, theme.spacing2)
    }
}

// MARK: - Insight Card

/**
 Reusable insight card with expand/collapse
 */
struct InsightCard<Content: View>: View {
    let icon: String
    let title: String
    @Binding var isExpanded: Bool
    let isProcessing: Bool
    let theme: ThemeStruct
    let content: () -> Content

    var body: some View {
        VStack(spacing: 0) {
            // Header button
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    isExpanded.toggle()
                }
                hapticResponseLight()
            } label: {
                HStack(spacing: theme.spacing3) {
                    // Icon
                    Image(systemName: icon)
                        .font(.system(size: theme.iconSizeMedium))
                        .foregroundColor(theme.iconColor)
                        .frame(width: theme.iconSizeLarge)

                    // Title
                    Text(title)
                        .font(theme.fontHeadline)
                        .foregroundColor(.primary)

                    Spacer()

                    // Processing indicator
                    if isProcessing {
                        ProgressView()
                            .scaleEffect(0.8)
                    }

                    // Chevron
                    Image(systemName: isExpanded ? "chevron.up.circle.fill" : "chevron.down.circle.fill")
                        .font(.system(size: theme.iconSizeMedium))
                        .foregroundColor(theme.iconColor.opacity(0.6))
                }
                .padding(theme.spacing4)
                .background(Color(.systemBackground))
                .cornerRadius(theme.cornerRadiusMedium)
            }

            // Content
            if isExpanded {
                content()
                    .padding(theme.spacing4)
                    .background(Color(.systemBackground))
                    .cornerRadius(theme.cornerRadiusMedium)
                    .padding(.top, theme.spacing2)
                    .transition(.asymmetric(
                        insertion: .opacity.combined(with: .move(edge: .top)),
                        removal: .opacity
                    ))
            }
        }
        .shadow(color: theme.shadowColor, radius: theme.shadowRadius, x: 0, y: theme.shadowY)
    }
}

// Constants
private let iconWidth: CGFloat = 22
