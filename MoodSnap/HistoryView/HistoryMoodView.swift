import SwiftUI

/**
 Modern mood history entry with improved spacing and layout.

 Features:
 - Clean section separators
 - Better visual hierarchy
 - Improved spacing using theme system
 - Modern label styling
 */
struct HistoryMoodView: View {
    let moodSnap: MoodSnapStruct
    @EnvironmentObject var data: DataStoreClass

    var body: some View {
        let theme = themes[data.settings.theme]

        VStack(alignment: .leading, spacing: theme.spacing3) {
            // Mood levels with subtle divider
            Divider()
                .background(theme.gridColor.opacity(0.5))

            MoodLevelsView(
                moodSnapFlat: moodSnap,
                moodSnapAll: moodSnap,
                theme: theme
            )

            // Symptoms section
            if totalSymptoms(moodSnap: moodSnap, settings: data.settings) != 0 {
                Divider()
                    .background(theme.gridColor.opacity(0.5))
                    .padding(.top, theme.spacing2)

                Label("symptoms".localize(), systemImage: "heart.text.square")
                    .font(theme.fontCallout)
                    .foregroundColor(theme.iconColor.opacity(0.8))
                    .padding(.bottom, theme.spacing1)

                HistorySymptomsView(moodSnap: moodSnap)
            }

            // Activities section
            if totalActivities(moodSnap: moodSnap, settings: data.settings) != 0 {
                Divider()
                    .background(theme.gridColor.opacity(0.5))
                    .padding(.top, theme.spacing2)

                Label("activity".localize(), systemImage: "figure.walk")
                    .font(theme.fontCallout)
                    .foregroundColor(theme.iconColor.opacity(0.8))
                    .padding(.bottom, theme.spacing1)

                HistoryActivityView(moodSnap: moodSnap)
            }

            // Social section
            if totalSocial(moodSnap: moodSnap, settings: data.settings) != 0 {
                Divider()
                    .background(theme.gridColor.opacity(0.5))
                    .padding(.top, theme.spacing2)

                Label("social".localize(), systemImage: "person.2")
                    .font(theme.fontCallout)
                    .foregroundColor(theme.iconColor.opacity(0.8))
                    .padding(.bottom, theme.spacing1)

                HistorySocialView(moodSnap: moodSnap)
            }

            // Notes section
            if !String(moodSnap.notes).isEmpty {
                Divider()
                    .background(theme.gridColor.opacity(0.5))
                    .padding(.top, theme.spacing2)

                Text(String(moodSnap.notes))
                    .font(theme.fontCallout)
                    .foregroundColor(.primary)
                    .lineSpacing(2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(theme.spacing3)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(theme.cornerRadiusSmall)
            }
        }
    }
}
