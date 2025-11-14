import SwiftUI

/**
 Modern mood entry form with gradient sliders and expandable sections.

 Features:
 - Beautiful gradient sliders for EDAI dimensions
 - Expandable sections for better organization
 - Modern pill-style toggles
 - Enhanced notes section
 - Gradient save button
 - Clean navigation bar
 */
struct MoodSnapView: View {
    @Environment(\.dismiss) var dismiss
    @State var moodSnap: MoodSnapStruct
    @EnvironmentObject var data: DataStoreClass
    @EnvironmentObject var health: HealthManager
    @State private var showingDatePickerSheet = false

    // Expandable sections
    @State private var symptomsExpanded = false
    @State private var activitiesExpanded = false
    @State private var socialExpanded = false
    @State private var notesExpanded = true

    var body: some View {
        let theme = themes[data.settings.theme]

        NavigationView {
            ScrollView {
                VStack(spacing: theme.spacing5) {
                    // EDAI Sliders Section
                    VStack(spacing: theme.spacing4) {
                        // Section header
                        HStack {
                            Image(systemName: "brain.head.profile")
                                .font(.system(size: theme.iconSizeMedium))
                                .foregroundColor(theme.iconColor)

                            Text("mood".localize())
                                .font(theme.fontTitle2)
                                .foregroundColor(theme.iconColor)

                            Spacer()
                        }
                        .padding(.horizontal, theme.spacing4)

                        // Elevation slider
                        GradientMoodSlider(
                            label: "elevation".localize(),
                            value: $moodSnap.elevation,
                            gradientColors: theme.elevationGradient,
                            color: theme.elevationColor,
                            theme: theme,
                            data: data
                        )

                        // Depression slider
                        GradientMoodSlider(
                            label: "depression".localize(),
                            value: $moodSnap.depression,
                            gradientColors: theme.depressionGradient,
                            color: theme.depressionColor,
                            theme: theme,
                            data: data
                        )

                        // Anxiety slider
                        GradientMoodSlider(
                            label: "anxiety".localize(),
                            value: $moodSnap.anxiety,
                            gradientColors: theme.anxietyGradient,
                            color: theme.anxietyColor,
                            theme: theme,
                            data: data
                        )

                        // Irritability slider
                        GradientMoodSlider(
                            label: "irritability".localize(),
                            value: $moodSnap.irritability,
                            gradientColors: theme.irritabilityGradient,
                            color: theme.irritabilityColor,
                            theme: theme,
                            data: data
                        )
                    }
                    .padding(theme.spacing4)
                    .background(Color(.systemBackground))
                    .cornerRadius(theme.cornerRadiusLarge)
                    .shadow(color: theme.shadowColor, radius: theme.shadowRadius, x: 0, y: theme.shadowY)
                    .padding(.horizontal, theme.spacing4)

                    // Symptoms Section
                    if visibleSymptomsCount(settings: data.settings) > 0 {
                        ExpandableToggleSection(
                            title: "symptoms".localize(),
                            icon: "heart.text.square",
                            isExpanded: $symptomsExpanded,
                            count: moodSnap.symptoms.filter { $0 }.count,
                            theme: theme
                        ) {
                            ToggleGrid(
                                items: symptomList,
                                bindings: $moodSnap.symptoms,
                                visibility: data.settings.symptomVisibility,
                                theme: theme,
                                data: data
                            )
                        }
                        .padding(.horizontal, theme.spacing4)
                    }

                    // Activities Section
                    if visibleActivitiesCount(settings: data.settings) > 0 {
                        ExpandableToggleSection(
                            title: "activity".localize(),
                            icon: "figure.walk",
                            isExpanded: $activitiesExpanded,
                            count: moodSnap.activities.filter { $0 }.count,
                            theme: theme
                        ) {
                            ToggleGrid(
                                items: activityList,
                                bindings: $moodSnap.activities,
                                visibility: data.settings.activityVisibility,
                                theme: theme,
                                data: data
                            )
                        }
                        .padding(.horizontal, theme.spacing4)
                    }

                    // Social Section
                    if visibleSocialCount(settings: data.settings) > 0 {
                        ExpandableToggleSection(
                            title: "social".localize(),
                            icon: "person.2",
                            isExpanded: $socialExpanded,
                            count: moodSnap.social.filter { $0 }.count,
                            theme: theme
                        ) {
                            ToggleGrid(
                                items: socialList,
                                bindings: $moodSnap.social,
                                visibility: data.settings.socialVisibility,
                                theme: theme,
                                data: data
                            )
                        }
                        .padding(.horizontal, theme.spacing4)
                    }

                    // Notes Section
                    ExpandableNotesSection(
                        isExpanded: $notesExpanded,
                        notes: $moodSnap.notes,
                        theme: theme
                    )
                    .padding(.horizontal, theme.spacing4)

                    // Save Button
                    Button {
                        saveMoodSnap()
                    } label: {
                        HStack(spacing: theme.spacing3) {
                            Text("Save Mood".localize())
                                .font(theme.fontHeadline)

                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: theme.iconSizeMedium))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, theme.spacing4)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: theme.accentGradient),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(theme.cornerRadiusLarge)
                        .shadow(color: theme.shadowColor.opacity(0.3), radius: theme.shadowRadius * 2, x: 0, y: theme.shadowY * 2)
                    }
                    .padding(.horizontal, theme.spacing4)
                    .padding(.bottom, theme.spacing5)
                }
                .padding(.top, theme.spacing3)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("take_moodsnap".localize())
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingDatePickerSheet = true
                    } label: {
                        Label(moodSnap.timestamp.dateTimeString(), systemImage: "calendar.badge.clock")
                            .font(theme.fontCaption)
                    }
                    .sheet(isPresented: $showingDatePickerSheet) {
                        DatePickerView(moodSnap: $moodSnap, settings: data.settings)
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel".localize()) {
                        hapticResponseLight(data: data)
                        dismiss()
                    }
                    .foregroundColor(theme.iconColor)
                }
            }
        }
    }

    // MARK: - Helper Functions

    private func saveMoodSnap() {
        hapticResponseMedium(data: data)
        DispatchQueue.main.async {
            withAnimation {
                data.stopProcessing()
                health.stopProcessing(data: data)
                moodSnap.snapType = .mood
                data.moodSnaps = deleteHistoryItem(moodSnaps: data.moodSnaps, moodSnap: moodSnap)
                data.moodSnaps.append(moodSnap)
                data.settings.addedSnaps += 1
                let quoteSnap = getQuoteSnap(count: data.settings.addedSnaps)
                if quoteSnap != nil {
                    data.moodSnaps.append(quoteSnap!)
                }
                data.startProcessing()
                health.startProcessing(data: data)
            }
        }
        dismiss()
    }
}

// MARK: - Gradient Mood Slider Component

/**
 Beautiful gradient slider for EDAI dimensions with visual feedback
 */
struct GradientMoodSlider: View {
    let label: String
    @Binding var value: CGFloat
    let gradientColors: [Color]
    let color: Color
    let theme: ThemeStruct
    let data: DataStoreClass

    private let levels = ["None", "Mild", "Moderate", "Severe", "Extreme"]

    var body: some View {
        VStack(alignment: .leading, spacing: theme.spacing2) {
            // Label and value badge
            HStack {
                Text(label)
                    .font(theme.fontCallout.weight(.semibold))
                    .foregroundColor(color)

                Spacer()

                // Value badge
                Text(levels[Int(value)])
                    .font(theme.fontCaption)
                    .foregroundColor(.white)
                    .padding(.horizontal, theme.spacing3)
                    .padding(.vertical, theme.spacing1)
                    .background(color)
                    .cornerRadius(theme.cornerRadiusSmall)
            }

            // Slider
            Slider(value: $value, in: 0...4, step: 1)
                .tint(color)
                .onChange(of: value) { _ in
                    hapticResponseLight(data: data)
                }

            // Visual progress indicator
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background track
                    RoundedRectangle(cornerRadius: theme.cornerRadiusSmall / 2)
                        .fill(Color(.systemGray5))
                        .frame(height: 6)

                    // Gradient fill
                    if theme.useGradients {
                        RoundedRectangle(cornerRadius: theme.cornerRadiusSmall / 2)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: gradientColors),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geometry.size.width * (value / 4.0), height: 6)
                    } else {
                        RoundedRectangle(cornerRadius: theme.cornerRadiusSmall / 2)
                            .fill(color)
                            .frame(width: geometry.size.width * (value / 4.0), height: 6)
                    }
                }
            }
            .frame(height: 6)
        }
        .padding(.horizontal, theme.spacing4)
        .padding(.vertical, theme.spacing3)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(theme.cornerRadiusMedium)
    }
}

// MARK: - Expandable Toggle Section Component

/**
 Expandable section for symptoms, activities, and social
 */
struct ExpandableToggleSection<Content: View>: View {
    let title: String
    let icon: String
    @Binding var isExpanded: Bool
    let count: Int
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
                        .font(theme.fontTitle2)
                        .foregroundColor(.primary)

                    // Count badge
                    if count > 0 {
                        Text("\(count)")
                            .font(theme.fontCaption2)
                            .foregroundColor(.white)
                            .padding(.horizontal, theme.spacing2)
                            .padding(.vertical, theme.spacing1)
                            .background(theme.iconColor)
                            .cornerRadius(theme.cornerRadiusSmall)
                    }

                    Spacer()

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

// MARK: - Toggle Grid Component

/**
 Grid of pill-style toggles
 */
struct ToggleGrid: View {
    let items: [String]
    @Binding var bindings: [Bool]
    let visibility: [Bool]
    let theme: ThemeStruct
    let data: DataStoreClass

    var body: some View {
        let columns = [
            GridItem(.adaptive(minimum: 100, maximum: 200), spacing: theme.spacing2)
        ]

        LazyVGrid(columns: columns, alignment: .leading, spacing: theme.spacing2) {
            ForEach(0..<items.count, id: \.self) { i in
                if visibility[i] {
                    Toggle(isOn: $bindings[i]) {
                        Text(.init(items[i]))
                    }
                    .toggleStyle(PillToggleStyle(theme: theme, accentColor: theme.buttonColor))
                    .onChange(of: bindings[i]) { _ in
                        hapticResponseLight(data: data)
                    }
                }
            }
        }
    }
}

// MARK: - Expandable Notes Section

/**
 Expandable notes section with modern text editor
 */
struct ExpandableNotesSection: View {
    @Binding var isExpanded: Bool
    @Binding var notes: String
    let theme: ThemeStruct

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
                    Image(systemName: "note.text")
                        .font(.system(size: theme.iconSizeMedium))
                        .foregroundColor(theme.iconColor)
                        .frame(width: theme.iconSizeLarge)

                    // Title
                    Text("notes".localize())
                        .font(theme.fontTitle2)
                        .foregroundColor(.primary)

                    // Preview
                    if !isExpanded && !notes.isEmpty {
                        Text(notes)
                            .font(theme.fontCaption)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }

                    Spacer()

                    // Chevron
                    Image(systemName: isExpanded ? "chevron.up.circle.fill" : "chevron.down.circle.fill")
                        .font(.system(size: theme.iconSizeMedium))
                        .foregroundColor(theme.iconColor.opacity(0.6))
                }
                .padding(theme.spacing4)
                .background(Color(.systemBackground))
                .cornerRadius(theme.cornerRadiusMedium)
            }

            // Text editor
            if isExpanded {
                TextEditor(text: $notes)
                    .font(theme.fontCallout)
                    .frame(minHeight: 120)
                    .padding(theme.spacing3)
                    .background(Color(.secondarySystemGroupedBackground))
                    .cornerRadius(theme.cornerRadiusMedium)
                    .overlay(
                        RoundedRectangle(cornerRadius: theme.cornerRadiusMedium)
                            .stroke(theme.gridColor, lineWidth: 1)
                    )
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
