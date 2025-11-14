import SwiftUI

/**
 Modern symptom list with pill-style tags.

 Features:
 - Pill-shaped tags instead of plain text
 - Accent color from theme
 - Better spacing and layout
 - Modern rounded corners
 */
struct HistorySymptomsView: View {
    let moodSnap: MoodSnapStruct
    @EnvironmentObject var data: DataStoreClass

    var body: some View {
        let theme = themes[data.settings.theme]

        // FlowLayout using flexible grid
        let columns = [
            GridItem(.adaptive(minimum: 80, maximum: 150), spacing: theme.spacing2)
        ]

        LazyVGrid(columns: columns, alignment: .leading, spacing: theme.spacing2) {
            ForEach(0 ..< symptomList.count, id: \.self) { i in
                if moodSnap.symptoms[i] && data.settings.symptomVisibility[i] {
                    Text(.init(symptomList[i]))
                        .font(theme.fontCaption)
                        .foregroundColor(.white)
                        .padding(.horizontal, theme.spacing3)
                        .padding(.vertical, theme.spacing1 + 2)
                        .background(
                            theme.buttonColor.opacity(0.85)
                        )
                        .cornerRadius(theme.cornerRadiusSmall)
                }
            }
        }
    }
}
