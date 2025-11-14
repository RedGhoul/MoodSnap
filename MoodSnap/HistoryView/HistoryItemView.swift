import SwiftUI

/**
 Modern history item card with visual timeline and accent border.

 Features:
 - Clean card design with shadow
 - Left accent border matching primary mood color
 - Modern header with icon and timestamp
 - Contextual menu for edit/delete
 - Smooth animations
 */
struct HistoryItemView: View {
    var moodSnap: MoodSnapStruct
    @Binding var filter: SnapTypeEnum
    @Binding var searchText: String
    @EnvironmentObject var data: DataStoreClass
    @EnvironmentObject var health: HealthManager
    @State private var showingDeleteAlert: Bool = false
    @State private var showingMoodSnapSheet: Bool = false

    var body: some View {
        let theme = themes[data.settings.theme]

        if snapFilter(moodSnap: moodSnap, filter: filter, searchText: searchText) && !(moodSnap.snapType == .quote && !data.settings.quoteVisibility) {
            HStack(spacing: 0) {
                // Timeline dot indicator
                VStack {
                    Circle()
                        .fill(getAccentColor(for: moodSnap, theme: theme))
                        .frame(width: 12, height: 12)
                        .overlay(
                            Circle()
                                .stroke(Color(.systemBackground), lineWidth: 2)
                        )

                    Rectangle()
                        .fill(theme.gridColor)
                        .frame(width: 2)
                }
                .frame(width: 20)
                .padding(.trailing, theme.spacing3)

                // Card content
                VStack(alignment: .leading, spacing: 0) {
                    // Modern card with shadow and accent border
                    VStack(alignment: .leading, spacing: theme.spacing3) {
                        // Header with icon, timestamp, and menu
                        HStack(alignment: .center, spacing: theme.spacing2) {
                            // Icon + Timestamp
                            HStack(spacing: theme.spacing2) {
                                Image(systemName: getIcon(for: moodSnap.snapType))
                                    .font(.system(size: theme.iconSizeSmall))
                                    .foregroundColor(getAccentColor(for: moodSnap, theme: theme))
                                    .frame(width: theme.iconSizeMedium)

                                Text(moodSnap.timestamp.dateTimeString())
                                    .font(theme.fontCaption)
                                    .foregroundColor(.secondary)
                            }

                            Spacer()

                            // Quick mood indicators (for mood type)
                            if moodSnap.snapType == .mood {
                                MoodIndicatorDots(moodSnap: moodSnap, theme: theme)
                            }

                            // Menu button
                            Menu {
                                if moodSnap.snapType == .mood || moodSnap.snapType == .note || moodSnap.snapType == .event {
                                    Button(action: {
                                        hapticResponseLight()
                                        showingMoodSnapSheet.toggle()
                                    }, label: {
                                        Label("edit".localize(), systemImage: "pencil")
                                    })
                                }

                                Button(role: .destructive, action: {
                                    hapticResponseLight()
                                    showingDeleteAlert = true
                                }, label: {
                                    Label("delete".localize(), systemImage: "trash")
                                })
                            } label: {
                                Image(systemName: "ellipsis.circle")
                                    .font(.system(size: theme.iconSizeSmall))
                                    .foregroundColor(.secondary)
                                    .frame(width: theme.iconSizeMedium, height: theme.iconSizeMedium)
                            }
                        }

                        // Content
                        if moodSnap.snapType == .event {
                            HistoryEventView(moodSnap: moodSnap)
                        }
                        if moodSnap.snapType == .mood {
                            HistoryMoodView(moodSnap: moodSnap)
                        }
                        if moodSnap.snapType == .note {
                            HistoryNoteView(moodSnap: moodSnap)
                        }
                        if moodSnap.snapType == .media {
                            HistoryMediaView(moodSnap: moodSnap)
                        }
                        if moodSnap.snapType == .custom {
                            HistoryCustomView(which: moodSnap.customView)
                        }
                        if moodSnap.snapType == .quote && data.settings.quoteVisibility {
                            HistoryQuoteView(moodSnap: moodSnap)
                        }
                    }
                    .padding(theme.spacing4)
                    .background(Color(.systemBackground))
                    .cornerRadius(theme.cornerRadiusMedium)
                    .overlay(
                        // Accent border on left
                        HStack {
                            RoundedRectangle(cornerRadius: theme.cornerRadiusMedium)
                                .fill(getAccentColor(for: moodSnap, theme: theme))
                                .frame(width: 4)
                            Spacer()
                        }
                    )
                    .shadow(
                        color: theme.shadowColor,
                        radius: theme.shadowRadius * 0.5,
                        x: 0,
                        y: theme.shadowY
                    )
                }
                .padding(.bottom, theme.spacing3)
            }
            .padding(.horizontal, theme.spacing4)
            .sheet(isPresented: $showingMoodSnapSheet) {
                switch moodSnap.snapType {
                case .mood:
                    MoodSnapView(moodSnap: moodSnap)
                case .event:
                    EventView(moodSnap: moodSnap)
                case .note:
                    NoteView(moodSnap: moodSnap)
                case .media:
                    MediaView(moodSnap: moodSnap)
                default:
                    EmptyView()
                }
            }
            .alert(isPresented: $showingDeleteAlert) {
                Alert(
                    title: Text("delete_this_moodsnap".localize()),
                    message: Text("sure_to_delete".localize()),
                    primaryButton: .cancel(),
                    secondaryButton: .destructive(
                        Text("delete".localize()),
                        action: {
                            DispatchQueue.main.async {
                                withAnimation {
                                    data.stopProcessing()
                                    health.stopProcessing(data: data)
                                    data.moodSnaps = deleteHistoryItem(moodSnaps: data.moodSnaps, moodSnap: moodSnap)
                                    data.startProcessing()
                                    health.startProcessing(data: data)
                                }
                            }
                        }
                    )
                )
            }
        }
    }

    // MARK: - Helper Functions

    /**
     Get icon for snap type
     */
    private func getIcon(for snapType: SnapType) -> String {
        switch snapType {
        case .mood:
            return "brain.head.profile"
        case .note:
            return "note.text"
        case .event:
            return "star.fill"
        case .media:
            return "photo.on.rectangle.angled"
        case .custom:
            return "eye"
        case .quote:
            return "quote.opening"
        }
    }

    /**
     Get accent color based on snap type and primary mood
     */
    private func getAccentColor(for moodSnap: MoodSnapStruct, theme: ThemeStruct) -> Color {
        if moodSnap.snapType == .mood {
            // Use dominant mood color
            let levels = [
                (moodSnap.elevation, theme.elevationColor),
                (moodSnap.depression, theme.depressionColor),
                (moodSnap.anxiety, theme.anxietyColor),
                (moodSnap.irritability, theme.irritabilityColor)
            ]

            if let dominant = levels.max(by: { $0.0 < $1.0 }) {
                return dominant.1
            }
        }

        // Default colors for other types
        switch moodSnap.snapType {
        case .event:
            return theme.emergencyColor
        case .note:
            return theme.iconColor
        case .media:
            return theme.iconColor
        default:
            return theme.gridColor
        }
    }
}

/**
 Quick mood indicator dots showing EDAI levels
 */
struct MoodIndicatorDots: View {
    let moodSnap: MoodSnapStruct
    let theme: ThemeStruct

    var body: some View {
        HStack(spacing: 3) {
            if moodSnap.elevation > 0 {
                Circle()
                    .fill(theme.elevationColor)
                    .frame(width: getDotSize(level: moodSnap.elevation), height: getDotSize(level: moodSnap.elevation))
            }
            if moodSnap.depression > 0 {
                Circle()
                    .fill(theme.depressionColor)
                    .frame(width: getDotSize(level: moodSnap.depression), height: getDotSize(level: moodSnap.depression))
            }
            if moodSnap.anxiety > 0 {
                Circle()
                    .fill(theme.anxietyColor)
                    .frame(width: getDotSize(level: moodSnap.anxiety), height: getDotSize(level: moodSnap.anxiety))
            }
            if moodSnap.irritability > 0 {
                Circle()
                    .fill(theme.irritabilityColor)
                    .frame(width: getDotSize(level: moodSnap.irritability), height: getDotSize(level: moodSnap.irritability))
            }
        }
    }

    private func getDotSize(level: CGFloat) -> CGFloat {
        return 6 + (level * 1.5) // 6pt at level 0, up to 12pt at level 4
    }
}
