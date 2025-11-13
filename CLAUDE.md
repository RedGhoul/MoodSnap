# CLAUDE.md - AI Assistant Guide for MoodSnap

**Last Updated:** 2025-11-13
**Project:** MoodSnap - iOS Mood Tracking & Analytics App
**Platform:** iOS (SwiftUI, Swift)
**Architecture:** MVVM-like with Reactive State Management

---

## Table of Contents

1. [Quick Start for AI Assistants](#quick-start-for-ai-assistants)
2. [Project Philosophy & Core Principles](#project-philosophy--core-principles)
3. [Essential Context](#essential-context)
4. [Coding Conventions & Patterns](#coding-conventions--patterns)
5. [Common Tasks - Quick Reference](#common-tasks---quick-reference)
6. [Development Workflow](#development-workflow)
7. [Critical Files Reference](#critical-files-reference)
8. [Common Pitfalls & How to Avoid Them](#common-pitfalls--how-to-avoid-them)
9. [Testing & Debugging Guidelines](#testing--debugging-guidelines)
10. [Making Changes Safely](#making-changes-safely)
11. [Git Workflow & Branching](#git-workflow--branching)
12. [Performance Considerations](#performance-considerations)
13. [Localization Requirements](#localization-requirements)
14. [Data Migration & Versioning](#data-migration--versioning)

---

## Quick Start for AI Assistants

### First Things to Know

1. **Read ARCHITECTURE.md first** - This document complements it with AI-specific guidance
2. **Privacy is paramount** - All data stays local, no backend, no analytics
3. **This is production code** - Real users with mental health needs depend on this app
4. **Backwards compatibility matters** - Users have months/years of mood data
5. **Localization is required** - Changes must support all 5 languages

### Essential File Locations

```
DataStore/DataStore.swift      # Central state management (START HERE)
Base/Constants.swift           # App-wide configuration
UX/UX.swift                    # All theming and styling
DataStore/JSON.swift           # All data structures
Statistics/                    # Analytics engine (10 files)
MainViews/                     # Primary user interface
```

### Before Making Any Changes

✅ **ALWAYS:**
- Read the file you're modifying completely
- Check if changes affect data structures (breaking changes!)
- Consider impact on existing user data
- Update all 5 localizations if adding UI text
- Test with existing data, not just empty state
- Verify theme compatibility (all 6 themes)

❌ **NEVER:**
- Break backwards compatibility with saved data
- Add network calls or analytics
- Modify data structures without migration plan
- Hard-code colors (use theme system)
- Add dependencies without discussion
- Remove or rename saved data fields

---

## Project Philosophy & Core Principles

### 1. Privacy First
**Philosophy:** Users' mental health data is extremely sensitive. It must never leave their device.

**Implementation:**
- No backend, no API calls, no analytics
- Local-only JSON storage via Disk library
- HealthKit data never exported
- All processing happens on-device

**For AI Assistants:**
- Reject any requests for telemetry, crash reporting, or cloud sync
- No third-party SDKs that phone home
- No user tracking of any kind

### 2. Mental Health Focus
**Philosophy:** This app is used by people managing serious mood disorders (bipolar, depression, anxiety, BPD, PTSD).

**Implementation:**
- Features designed with clinical input
- 24 medically-relevant symptoms
- Validation without toxic positivity
- Emergency contact support

**For AI Assistants:**
- Take feature requests seriously - they may be clinically motivated
- Avoid trivializing mental health language
- Consider accessibility implications

### 3. Open Source & Free Forever
**Philosophy:** Mental health tools should be accessible to everyone.

**Implementation:**
- MIT license (check LICENSE file)
- No paid features, no ads, no IAP
- Community-driven development

**For AI Assistants:**
- No suggestions for monetization
- No paywalls or feature gating
- Keep dependencies open source

### 4. Accessibility & Inclusivity
**Philosophy:** Everyone should be able to use this app effectively.

**Implementation:**
- 6 themes including ColorBlind mode (IBM accessibility palette)
- 5 languages (en, de, es, fr, nl)
- Face ID/Touch ID support
- Haptic feedback
- Clear typography

**For AI Assistants:**
- Test changes with ColorBlind theme
- Maintain localization coverage
- Consider VoiceOver compatibility

---

## Essential Context

### What is MoodSnap?

MoodSnap is a **4-dimensional mood tracker** that uses the **EDAI scale**:
- **E**levation (green) - Elevated mood, energy, mania
- **D**epression (red) - Low mood, sadness
- **A**nxiety (orange) - Worry, panic, fear
- **I**rritability (yellow) - Anger, frustration

Each dimension is rated 0-4:
- 0 = None
- 1 = Mild
- 2 = Moderate
- 3 = Severe
- 4 = Extreme

### Key Features

1. **Mood Tracking** - 4D EDAI scale with 24 symptoms, 9 activities, 6 social categories
2. **Analytics** - Correlations, volatility, trends, butterfly effects
3. **HealthKit Integration** - Weight, sleep, exercise, menstrual cycle
4. **Timeline** - Chronological feed of moods, notes, photos, events
5. **PDF Reports** - Exportable clinical reports
6. **Widgets** - iOS home screen widgets
7. **Themes** - 6 themes including accessibility mode

### Data Architecture Quick Summary

```swift
DataStoreClass (ObservableObject)
├── @Published var moodSnaps: [MoodSnapStruct]        // Raw entries
├── @Published var processedData: ProcessedDataStruct // Analytics
├── @Published var settings: SettingsStruct           // User preferences
└── @Published var healthSnaps: [HealthSnapStruct]    // HealthKit data

// Persistence: JSON files via Disk library
// Location: .documents/data.json + shared container for widgets
```

### The Processing Pipeline

When data changes, `startProcessing()` runs **8 parallel async tasks**:

1. `processStats()` - Count occurrences, date ranges
2. `processHistory()` - Daily sequences, correlations, trends
3. `processAverages()` - 30/90/180 day sliding windows
4. `processEvents()` - Butterfly effect analysis
5. `processHashtags()` - Extract #tags from notes
6. `processActivities()` - Activity impact on mood
7. `processSocial()` - Social event impact
8. `processSymptoms()` - Symptom correlations

**Critical:** All tasks must complete before UI updates.

---

## Coding Conventions & Patterns

### Swift Style Guide

#### 1. Naming Conventions

```swift
// ✅ CORRECT
var moodSnaps: [MoodSnapStruct]          // camelCase for variables
let buttonColor: Color                    // camelCase for constants
func processHistory() async { }           // camelCase for functions
struct ThemeStruct { }                    // PascalCase for types
enum SnapType { }                         // PascalCase for enums

// ❌ AVOID
var MoodSnaps: [MoodSnapStruct]          // Don't use PascalCase for vars
let button_color: Color                   // Don't use snake_case
func ProcessHistory() async { }           // Don't use PascalCase for funcs
```

#### 2. Type Naming Pattern

**Convention:** Most structs use `Struct` suffix, most enums don't.

```swift
// ✅ Established pattern
struct MoodSnapStruct: Codable { }
struct ThemeStruct { }
struct SettingsStruct: Codable { }
enum SnapType: String, Codable { }
enum TimeScale: String { }
```

**Rationale:** Distinguishes data structures from UI views (which use `View` suffix).

#### 3. File Organization

**One type per file:**
```
✅ MoodSnapView.swift contains struct MoodSnapView: View
✅ HistoryView.swift contains struct HistoryView: View
✅ DataStore.swift contains class DataStoreClass
```

**Exception:** Helper extensions can be in same file.

#### 4. Documentation

```swift
// ✅ GOOD - Document complex functions
/**
 Process correlations between mood dimensions.

 Calculates Pearson correlation coefficients for all pairs of E/D/A/I.
 Updates the @Published correlations property.
 */
func processCorrelations() async -> CorrelationsStruct {
    // ...
}

// ✅ GOOD - Inline comments for clarity
let butterflyWindowShort = 7  // Days before/after event
let quoteFrequency = 11       // Insert quote every N entries

// ❌ AVOID - Over-commenting obvious code
let count = moodSnaps.count   // Get the count of mood snaps
```

### SwiftUI Patterns

#### 1. Environment Objects

**Convention:** Use `@EnvironmentObject` for DataStoreClass and HealthManager.

```swift
// ✅ CORRECT
struct MyView: View {
    @EnvironmentObject var data: DataStoreClass
    @EnvironmentObject var health: HealthManager

    var body: some View {
        Text("\(data.moodSnaps.count)")
    }
}

// ❌ AVOID - Don't pass as parameters
struct MyView: View {
    let data: DataStoreClass  // Don't do this
}
```

#### 2. State Management

**Convention:** UI state (sheet visibility, selection) uses `@State`. Persistent data uses `DataStoreClass`.

```swift
// ✅ CORRECT
struct SettingsView: View {
    @EnvironmentObject var data: DataStoreClass
    @State private var showingDeleteAlert = false  // Transient UI state

    var body: some View {
        Toggle("Use Face ID", isOn: $data.settings.faceIDEnabled)  // Persistent
        .alert(isPresented: $showingDeleteAlert) { }               // Transient
    }
}
```

#### 3. Theme Access Pattern

**Convention:** Access theme via array index: `themes[data.settings.theme]`

```swift
// ✅ CORRECT
Circle()
    .fill(themes[data.settings.theme].elevationColor)
    .frame(width: themes[data.settings.theme].controlIconSize)

// ❌ AVOID - Don't hard-code colors
Circle()
    .fill(Color.green)  // Don't do this
```

#### 4. Localization Pattern

**Convention:** All user-facing strings use `.localize()` extension.

```swift
// ✅ CORRECT
Text("Elevation".localize())
Text("Depression".localize())
Label("Settings".localize(), systemImage: "gear")

// ❌ AVOID - Hard-coded English
Text("Elevation")  // Don't do this
```

**Implementation:**
```swift
// String extension (somewhere in codebase)
extension String {
    func localize() -> String {
        return NSLocalizedString(self, comment: "")
    }
}
```

### Data Structure Patterns

#### 1. Codable for Persistence

**Convention:** All structs that persist to disk must be `Codable`.

```swift
// ✅ CORRECT
struct SettingsStruct: Codable, Hashable {
    var theme: Int = 0
    var faceIDEnabled: Bool = false
    // ...
}

// ❌ AVOID - Missing Codable
struct SettingsStruct: Hashable {  // Won't save to disk!
    var theme: Int = 0
}
```

#### 2. Default Values

**Convention:** All struct properties have default values (enables easy initialization).

```swift
// ✅ CORRECT
struct ThemeStruct {
    var elevationColor: Color = Color.green
    var depressionColor: Color = Color.red
    var hBarHeight: CGFloat = 15
}

// Usage
var theme = ThemeStruct()  // All defaults applied

// ❌ AVOID - Non-optional without defaults
struct ThemeStruct {
    var elevationColor: Color  // Compile error
}
```

#### 3. Array Sizing Convention

**Convention:** Bool arrays match constant list sizes.

```swift
// In Constants.swift
let symptomList = ["Anhedonia", "Fatigue", ...]  // 24 items
let activityList = ["Alcohol", "Caffeine", ...]  // 9 items
let socialList = ["Affection", "Conflict", ...]  // 6 items

// In MoodSnapStruct
var symptoms: [Bool] = Array(repeating: false, count: 24)
var activities: [Bool] = Array(repeating: false, count: 9)
var social: [Bool] = Array(repeating: false, count: 6)
```

**Critical:** If you add to `symptomList`, update the count!

---

## Common Tasks - Quick Reference

### Task 1: Add a New Symptom/Activity/Social Category

**Files to modify:**
1. `Base/Constants.swift` - Add to appropriate list
2. `MoodSnapStruct` - Update array size if needed
3. All 5 `.lproj/Localizable.strings` files - Add translations

**Example: Add "Brain_fog" symptom**

```swift
// 1. Base/Constants.swift (line 32-56)
let symptomList = [
    "Anhedonia",
    // ... existing symptoms ...
    "Suicidal_thoughts",
    "Brain_fog"  // Add here (now 25 items)
]

// 2. Update MoodSnapStruct if you changed array size
// (Usually not needed - arrays are dynamic)

// 3. Add to localizations
// en.lproj/Localizable.strings:
"Brain_fog" = "Brain Fog";

// de.lproj/Localizable.strings:
"Brain_fog" = "Gehirnnebel";

// es.lproj/Localizable.strings:
"Brain_fog" = "Niebla Mental";

// fr.lproj/Localizable.strings:
"Brain_fog" = "Brouillard Cérébral";

// nl.lproj/Localizable.strings:
"Brain_fog" = "Hersenmist";
```

**Important:** The symptom will automatically appear in:
- MoodSnapView toggles (dynamically generated)
- Analytics (automatically included)
- PDF reports (automatically included)

### Task 2: Modify Theme Colors

**File:** `UX/UX.swift`

**Option A: Edit existing theme**
```swift
func AquaTheme() -> ThemeStruct {
    var theme = ThemeStruct()
    theme.name = "Aqua"
    theme.elevationColor = Color(0x75CDD8)  // Change this
    theme.depressionColor = Color(0xFF8296)
    // ...
    return theme
}
```

**Option B: Add new theme**
```swift
// Step 1: Create theme function
func MyNewTheme() -> ThemeStruct {
    var theme = ThemeStruct()
    theme.name = "MyNew"
    theme.elevationColor = Color(0x00FF00)
    theme.depressionColor = Color(0xFF0000)
    theme.buttonColor = Color.purple
    // ... set all colors ...
    return theme
}

// Step 2: Add to themes array (line ~151)
let themes = [
    AquaTheme(),
    ColorBlindTheme(),
    OrangeTheme(),
    PrimaryTheme(),
    PastelTheme(),
    SummerTheme(),
    MyNewTheme()  // Index 6
]

// Step 3: Update SettingsView.swift theme picker UI
```

### Task 3: Add New Statistic/Analytic

**Files to modify:**
1. Create new file in `Statistics/` directory
2. Call from `DataStore.swift` in processing pipeline
3. Add result field to `ProcessedDataStruct`
4. Create visualization in `InsightsView/`

**Example: Add "Mood Range" metric**

```swift
// 1. Statistics/MoodRange.swift
import Foundation

func calculateMoodRange(data: [CGFloat?]) -> CGFloat? {
    let validData = data.compactMap { $0 }
    guard !validData.isEmpty else { return nil }

    let max = validData.max() ?? 0
    let min = validData.min() ?? 0
    return max - min
}

// 2. DataStore.swift - Add to processing
func processHistory() async {
    // ... existing processing ...

    // Add mood range calculation
    let rangeE = calculateMoodRange(data: processedData.levelE)
    processedData.moodRangeElevation = rangeE
}

// 3. DataStore/JSON.swift - Add to ProcessedDataStruct
struct ProcessedDataStruct: Codable, Hashable {
    // ... existing fields ...
    var moodRangeElevation: CGFloat? = nil
    var moodRangeDepression: CGFloat? = nil
    var moodRangeAnxiety: CGFloat? = nil
    var moodRangeIrritability: CGFloat? = nil
}

// 4. InsightsView/MoodRangeView.swift - Create visualization
struct MoodRangeView: View {
    @EnvironmentObject var data: DataStoreClass

    var body: some View {
        VStack {
            Text("Mood Range".localize())
            if let range = data.processedData.moodRangeElevation {
                Text(String(format: "%.1f", range))
            }
        }
    }
}
```

### Task 4: Modify Data Structure (DANGEROUS!)

**⚠️ WARNING:** Changing data structures can break existing user data!

**Safe Approach:**
```swift
// ❌ DON'T - Remove or rename fields
struct SettingsStruct: Codable {
    var theme: Int = 0
    // var oldField: String = ""  // DELETED - breaks old data!
}

// ✅ DO - Add optional fields with defaults
struct SettingsStruct: Codable {
    var theme: Int = 0
    var oldField: String = ""      // Keep old field
    var newField: String? = nil    // Add as optional
}

// ✅ DO - Deprecate instead of remove
struct SettingsStruct: Codable {
    @available(*, deprecated, message: "Use newField instead")
    var oldField: String = ""
    var newField: String = ""
}
```

**Migration Pattern:**
```swift
// If you MUST change structure, increment version
struct DataStoreStruct: Codable {
    var version: Int = 2  // Increment from 1 to 2
    // ...
}

// Add migration logic in init()
init() {
    // Load data
    let retrieved = try Disk.retrieve(...)

    // Migrate if old version
    if retrieved.version < 2 {
        // Perform migration
        migrateFromV1ToV2(data: retrieved)
    }
}
```

### Task 5: Add New View/Screen

**Pattern:** Create in `MainViews/` or `InsightsView/` depending on purpose.

```swift
// MainViews/MyNewView.swift
import SwiftUI

struct MyNewView: View {
    @EnvironmentObject var data: DataStoreClass
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            VStack {
                Text("My New Feature".localize())
                // ... content ...
            }
            .navigationTitle("Title".localize())
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done".localize()) {
                        dismiss()
                    }
                }
            }
        }
    }
}

// Add to parent view as sheet
@State private var showMyNewView = false

Button("Open") {
    showMyNewView = true
}
.sheet(isPresented: $showMyNewView) {
    MyNewView()
        .environmentObject(data)
}
```

---

## Development Workflow

### 1. Building & Running

**Platform:** Xcode (macOS required for iOS development)

```bash
# Open project
open MoodSnap.xcodeproj

# Or use xcodebuild (command line)
xcodebuild -project MoodSnap.xcodeproj -scheme MoodSnap -destination 'platform=iOS Simulator,name=iPhone 15' build

# Run tests (if available)
xcodebuild test -project MoodSnap.xcodeproj -scheme MoodSnap -destination 'platform=iOS Simulator,name=iPhone 15'
```

**Targets:**
- **MoodSnap** - Main app target
- **Widget** - Widget extension target

### 2. Dependency Management

**Current Dependencies:**
- **Disk** - JSON persistence library
- **TPPDF** - PDF generation library

**Installing:** Dependencies are included in project (likely via SPM or manual inclusion).

**Adding New Dependencies:**
1. Discuss with maintainers first (privacy implications!)
2. Prefer Swift Package Manager (SPM)
3. Must be open source
4. Must not phone home or collect telemetry

### 3. File System Structure

```
MoodSnap/
├── MoodSnap.xcodeproj/           # Xcode project
├── MoodSnap/                      # Main app code
│   ├── MoodSnapApp.swift         # Entry point
│   ├── MainViews/                # UI screens
│   ├── HistoryView/              # Timeline views
│   ├── InsightsView/             # Analytics views
│   ├── DataStore/                # State management
│   ├── Statistics/               # Analytics engine
│   ├── Base/                     # Utilities
│   ├── UX/                       # Theming
│   ├── Plotting/                 # Charts
│   ├── HealthKit/                # Health integration
│   ├── PDF/                      # Report generation
│   ├── Widget/                   # Widget extension
│   ├── Assets.xcassets/          # Images
│   └── *.lproj/                  # Localizations
├── Widget/                        # Widget extension code
├── README.md                      # Project overview
├── ARCHITECTURE.md                # Technical docs
├── CLAUDE.md                      # This file
└── LICENSE                        # MIT license
```

### 4. Code Review Checklist

Before submitting changes:

- [ ] Code compiles without warnings
- [ ] Tested on iOS simulator
- [ ] All 6 themes display correctly
- [ ] Localization strings added for all 5 languages
- [ ] No hard-coded colors (use theme system)
- [ ] No network calls or analytics
- [ ] Backwards compatible with existing data
- [ ] Comments added for complex logic
- [ ] No force unwraps (`!`) - use safe unwrapping
- [ ] Memory leaks checked (especially in closures)
- [ ] Haptic feedback added where appropriate

---

## Critical Files Reference

### Files You'll Modify Frequently

| File | Purpose | When to Modify |
|------|---------|----------------|
| `Base/Constants.swift` | App-wide constants | Adding symptoms, activities, changing windows |
| `UX/UX.swift` | Theme definitions | Changing colors, dimensions, adding themes |
| `DataStore/JSON.swift` | Data structures | Adding new data fields (careful!) |
| `*.lproj/Localizable.strings` | Translations | Adding any new UI text |
| `MainViews/*.swift` | UI screens | Changing user interface |
| `InsightsView/*.swift` | Analytics UI | Adding new visualizations |

### Files You Should Rarely/Never Modify

| File | Purpose | Risk Level |
|------|---------|------------|
| `DataStore/DataStore.swift` | State management | 🔴 HIGH - Central to app |
| `Statistics/*.swift` | Analytics algorithms | 🟡 MEDIUM - Affects accuracy |
| `Plotting/LineChart.swift` | Charting | 🟡 MEDIUM - Complex geometry |
| `HealthKit/HealthManager.swift` | HealthKit integration | 🟡 MEDIUM - Privacy-sensitive |
| `MoodSnapApp.swift` | Entry point | 🔴 HIGH - Breaks app if wrong |

### File Dependency Map

```
MoodSnapApp.swift
    ↓ initializes
DataStoreClass (DataStore/DataStore.swift)
    ↓ loads/saves
DataStoreStruct (DataStore/JSON.swift)
    ↓ contains
MoodSnapStruct, SettingsStruct, ProcessedDataStruct
    ↓ references
Constants (Base/Constants.swift)
    ↓ used by
All Views (MainViews/, InsightsView/)
    ↓ styled by
ThemeStruct (UX/UX.swift)
```

---

## Common Pitfalls & How to Avoid Them

### Pitfall 1: Breaking Data Persistence

**Problem:** Renaming or removing Codable fields breaks existing user data.

**Example:**
```swift
// ❌ BREAKS EXISTING DATA
struct SettingsStruct: Codable {
    // var oldName: String = ""  // Removed - users' data won't load!
    var newName: String = ""
}
```

**Solution:**
```swift
// ✅ SAFE - Keep old field, add new
struct SettingsStruct: Codable {
    var oldName: String = ""      // Keep for backwards compatibility
    var newName: String = ""      // Add new field

    // Optionally deprecate
    @available(*, deprecated)
    var oldName: String = ""
}
```

### Pitfall 2: Force Unwrapping Optionals

**Problem:** App crashes if value is nil.

**Example:**
```swift
// ❌ CRASHES if no moods
let firstMood = data.moodSnaps.first!
let elevation = firstMood.elevation

// ❌ CRASHES if processing incomplete
let avgE = data.processedData.averageE.first!
```

**Solution:**
```swift
// ✅ SAFE - Guard statement
guard let firstMood = data.moodSnaps.first else { return }
let elevation = firstMood.elevation

// ✅ SAFE - Optional chaining
if let avgE = data.processedData.averageE.first {
    // Use avgE safely
}

// ✅ SAFE - Nil coalescing
let avgE = data.processedData.averageE.first ?? 0.0
```

### Pitfall 3: Hard-Coding Colors

**Problem:** Breaks theme system and accessibility.

**Example:**
```swift
// ❌ BREAKS THEMES
Circle()
    .fill(Color.green)  // Always green, ignores theme

Text("Mood")
    .foregroundColor(Color.red)  // Always red
```

**Solution:**
```swift
// ✅ RESPECTS THEMES
Circle()
    .fill(themes[data.settings.theme].elevationColor)

Text("Mood")
    .foregroundColor(themes[data.settings.theme].depressionColor)
```

### Pitfall 4: Forgetting Localization

**Problem:** App shows English text for non-English users.

**Example:**
```swift
// ❌ ENGLISH ONLY
Text("Elevation")
Button("Save") { }
.navigationTitle("Settings")
```

**Solution:**
```swift
// ✅ LOCALIZED
Text("Elevation".localize())
Button("Save".localize()) { }
.navigationTitle("Settings".localize())

// Add to all 5 .lproj/Localizable.strings files:
// "Elevation" = "Elevation";     // English
// "Elevation" = "Erhöhung";      // German
// "Elevation" = "Elevación";     // Spanish
// "Elevation" = "Élévation";     // French
// "Elevation" = "Verhoging";     // Dutch
```

### Pitfall 5: Async/Await Misuse

**Problem:** UI updates on background thread cause crashes.

**Example:**
```swift
// ❌ CRASHES - UI update on background thread
Task {
    await processData()
    data.processedData = newData  // ⚠️ Not on main thread!
}
```

**Solution:**
```swift
// ✅ SAFE - Dispatch to main thread
Task {
    let newData = await processData()
    await MainActor.run {
        data.processedData = newData
    }
}

// ✅ SAFE - Use @MainActor
@MainActor
func updateData() async {
    let newData = await processData()
    data.processedData = newData  // Safe, on main thread
}
```

### Pitfall 6: Array Index Out of Bounds

**Problem:** Accessing invalid array indices crashes app.

**Example:**
```swift
// ❌ CRASHES if theme > 5
let currentTheme = themes[data.settings.theme]

// ❌ CRASHES if empty
let firstSnap = data.moodSnaps[0]
```

**Solution:**
```swift
// ✅ SAFE - Validate bounds
let themeIndex = min(data.settings.theme, themes.count - 1)
let currentTheme = themes[themeIndex]

// ✅ SAFE - Use .first or guard
guard !data.moodSnaps.isEmpty else { return }
let firstSnap = data.moodSnaps[0]

// ✅ SAFE - Optional access
if data.moodSnaps.indices.contains(index) {
    let snap = data.moodSnaps[index]
}
```

### Pitfall 7: Memory Leaks in Closures

**Problem:** Strong reference cycles prevent memory cleanup.

**Example:**
```swift
// ❌ MEMORY LEAK - Strong reference to self
Task {
    await self.processData()
    self.updateUI()  // Retains self strongly
}

// ❌ MEMORY LEAK - Closure captures self
Button("Process") {
    self.data.startProcessing()  // Retains self
}
```

**Solution:**
```swift
// ✅ SAFE - Weak self in async
Task { [weak self] in
    await self?.processData()
    self?.updateUI()
}

// ✅ SAFE - SwiftUI handles closures
Button("Process") {
    data.startProcessing()  // No explicit self needed
}
```

---

## Testing & Debugging Guidelines

### Testing Approach

**Current State:** No formal unit test suite exists.

**Testing Strategy:**
1. **Manual testing** in Xcode simulator
2. **Test data** via `Test/TestData.swift`
3. **Real data testing** with imported JSON

### How to Test Your Changes

#### 1. Load Test Data

```swift
// Test/TestData.swift provides makeIntroSnap()
// This creates sample mood entries

// In DataStoreClass init():
self.moodSnaps = makeIntroSnap()  // Creates 10+ sample entries
```

#### 2. Test with Empty State

```swift
// Clear all data in SettingsView
data.moodSnaps = []
data.healthSnaps = []
data.processedData = ProcessedDataStruct()
data.save()

// Now test how your feature handles empty state
```

#### 3. Test All Themes

```swift
// In SettingsView, cycle through all 6 themes:
// 0: Aqua
// 1: ColorBlind (critical for accessibility!)
// 2: Orange
// 3: Primary
// 4: Pastel
// 5: Summer

// Verify your changes look correct in all themes
```

#### 4. Test All Languages

```swift
// Change device language in iOS Settings
// Or use Xcode scheme editor to test specific language

// Verify all your new strings are localized
```

#### 5. Test Statistics Processing

```swift
// Add print statements to debug processing
func processHistory() async {
    print("📊 Starting history processing")
    // ... processing ...
    print("📊 Completed history processing: \(sequencedMoodSnaps.count) days")
}

// Check Xcode console for output
```

### Debugging Tools

#### 1. Processing Status

```swift
// DataStoreClass has @Published processingStatus
@Published var processingStatus: ProcessingStatus

// Check if processing complete
if data.processingStatus.allDone {
    print("✅ All processing complete")
} else {
    print("⏳ Still processing...")
}
```

#### 2. Print Data Structures

```swift
// Debug data contents
print("Mood snaps count: \(data.moodSnaps.count)")
print("First mood: \(data.moodSnaps.first)")
print("Processed data dates: \(data.processedData.dates)")
```

#### 3. Breakpoints

Set breakpoints in:
- `DataStore.swift:startProcessing()` - Debug processing pipeline
- `DataStore.swift:save()` - Debug persistence
- `MoodSnapView.swift` - Debug user input
- `HistoryView.swift` - Debug rendering

#### 4. View Hierarchy Inspector

Use Xcode's View Hierarchy Inspector (Debug → View Debugging → Capture View Hierarchy) to debug layout issues.

### Common Debugging Scenarios

#### Scenario 1: Charts Not Showing Data

**Check:**
1. Is `data.processedData` populated?
2. Are arrays the correct length?
3. Are values nil or zero?
4. Is processing complete? (`data.processingStatus.allDone`)

**Debug:**
```swift
print("Level E: \(data.processedData.levelE)")
print("Average E: \(data.processedData.averageE)")
print("Count: \(data.processedData.levelE.count)")
```

#### Scenario 2: Data Not Persisting

**Check:**
1. Is `data.save()` being called?
2. Is Disk library throwing errors?
3. Is data structure `Codable`?

**Debug:**
```swift
func save() {
    do {
        try Disk.save(self.toStruct(), to: .documents, as: "data.json")
        print("✅ Saved successfully")
    } catch {
        print("❌ Save error: \(error)")
    }
}
```

#### Scenario 3: Localization Not Working

**Check:**
1. Is `.localize()` being called?
2. Are all 5 `.lproj/Localizable.strings` updated?
3. Is string key exactly matching?

**Debug:**
```swift
// Check what's being returned
let localized = "Elevation".localize()
print("Localized 'Elevation': \(localized)")
```

---

## Making Changes Safely

### Change Impact Assessment

Before modifying code, ask:

1. **Does this change data structures?**
   - YES → Need migration plan
   - NO → Proceed with caution

2. **Does this affect existing user data?**
   - YES → Must be backwards compatible
   - NO → Lower risk

3. **Does this change UI?**
   - YES → Test all themes, localize all text
   - NO → Proceed

4. **Does this affect analytics?**
   - YES → Verify math, test with real data
   - NO → Proceed

5. **Does this add dependencies?**
   - YES → Discuss with maintainers first
   - NO → Proceed

### Risk Levels

| Change Type | Risk | Precautions |
|-------------|------|-------------|
| **Add UI element** | 🟢 LOW | Localize, test themes |
| **Modify theme colors** | 🟢 LOW | Test all 6 themes |
| **Add symptom/activity** | 🟢 LOW | Localize, update constants |
| **Add analytics view** | 🟡 MEDIUM | Test with empty/full data |
| **Modify statistics** | 🟡 MEDIUM | Verify math, test edge cases |
| **Change data structure** | 🔴 HIGH | Migration plan required |
| **Modify DataStore** | 🔴 HIGH | Extensive testing needed |
| **Change persistence** | 🔴 HIGH | Data loss risk |

### Safe Change Workflow

```
1. Read & Understand
   ↓
2. Plan Changes
   ├── Identify affected files
   ├── Check backwards compatibility
   └── Plan testing approach
   ↓
3. Implement
   ├── Make changes
   ├── Add localization
   ├── Update documentation
   └── Add comments
   ↓
4. Test Locally
   ├── Empty state
   ├── Full data
   ├── All themes
   ├── All languages
   └── Edge cases
   ↓
5. Review
   ├── Check checklist (see Code Review Checklist)
   ├── Verify no warnings
   └── Confirm backwards compatibility
   ↓
6. Commit
   └── Clear commit message
```

---

## Git Workflow & Branching

### Branch Naming Convention

```
claude/feature-name-sessionID
claude/bug-fix-sessionID
claude/docs-update-sessionID
```

**Examples:**
```
claude/create-codebase-documentation-01LKbdhFDjRnqG79kRu4kYiY
claude/add-new-theme-sessionID
claude/fix-correlation-bug-sessionID
```

### Commit Message Guidelines

**Format:**
```
<type>: <short description>

<optional detailed description>

<optional breaking changes note>
```

**Types:**
- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation
- `style:` Formatting, no code change
- `refactor:` Code restructuring
- `test:` Adding tests
- `chore:` Maintenance

**Examples:**

```
feat: Add brain fog symptom to symptom list

- Added "Brain_fog" to symptomList in Constants.swift
- Added localizations for all 5 languages
- Symptom automatically appears in analytics

No breaking changes.
```

```
fix: Prevent crash when mood snaps array is empty

- Added guard statement in HistoryView
- Use .first instead of [0] for array access
- Fixes #123

No breaking changes.
```

```
refactor: Extract mood calculation into separate function

- Created calculateAverageMood() in Statistics/
- Reduces code duplication in DataStore.swift
- No functional changes

No breaking changes.
```

### Pull Request Guidelines

**Title Format:**
```
[Type] Short description
```

**Examples:**
```
[Feature] Add brain fog symptom tracking
[Fix] Prevent crash on empty mood array
[Docs] Update CLAUDE.md with testing guidelines
```

**PR Description Template:**

```markdown
## Summary
Brief description of changes.

## Changes
- File 1: What changed
- File 2: What changed

## Testing
- [ ] Tested on iOS simulator
- [ ] Tested all 6 themes
- [ ] Tested all 5 languages
- [ ] Tested with empty data
- [ ] Tested with full data
- [ ] No warnings in Xcode

## Backwards Compatibility
- [ ] No data structure changes
- [ ] No breaking changes
OR
- [ ] Migration plan implemented

## Localization
- [ ] All new strings localized in 5 languages

## Screenshots
(If UI changes)
```

### Pushing Changes

**Important:** Always push to `claude/*` branches.

```bash
# Push to remote (with retry logic for network issues)
git push -u origin claude/feature-name-sessionID
```

---

## Performance Considerations

### Current Performance Profile

- **Processing time:** 8 async tasks run in parallel (~1-2 seconds for 1000 entries)
- **UI rendering:** LazyVStack for history (efficient scrolling)
- **Data persistence:** JSON file I/O (fast for typical data sizes)

### Optimization Guidelines

#### 1. Avoid Blocking Main Thread

```swift
// ❌ BAD - Blocks UI
func processData() {
    // Long-running calculation
    let result = heavyCalculation()  // UI freezes!
    data.processedData = result
}

// ✅ GOOD - Async processing
func processData() async {
    let result = await heavyCalculation()
    await MainActor.run {
        data.processedData = result
    }
}
```

#### 2. Use Lazy Loading

```swift
// ❌ BAD - Loads all views immediately
VStack {
    ForEach(data.moodSnaps) { snap in
        HistoryMoodView(snap: snap)  // All 1000+ views created!
    }
}

// ✅ GOOD - Lazy loading
LazyVStack {
    ForEach(data.moodSnaps) { snap in
        HistoryMoodView(snap: snap)  // Only visible views created
    }
}
```

#### 3. Cache Expensive Calculations

```swift
// ❌ BAD - Recalculates every frame
var body: some View {
    let average = calculateAverage(data.moodSnaps)  // Recalculates!
    Text("\(average)")
}

// ✅ GOOD - Cache in @Published var
// Calculate once in processing, store in processedData
var body: some View {
    Text("\(data.processedData.averageE.last ?? 0)")
}
```

#### 4. Minimize Array Copies

```swift
// ❌ BAD - Creates copy
let sortedSnaps = data.moodSnaps.sorted { $0.timestamp < $1.timestamp }

// ✅ GOOD - Use indices
ForEach(data.moodSnaps.indices, id: \.self) { index in
    HistoryView(snap: data.moodSnaps[index])
}
```

### Performance Testing

**Scenarios to test:**

1. **Large datasets:**
   - 1000+ mood entries
   - 365+ days of data
   - Multiple years of history

2. **Processing pipeline:**
   - Time each async task
   - Identify bottlenecks
   - Optimize slowest tasks first

3. **UI rendering:**
   - Scroll performance in HistoryView
   - Chart rendering time
   - Theme switching speed

**Profiling:**
```swift
// Add timing logs
let start = Date()
await processHistory()
let elapsed = Date().timeIntervalSince(start)
print("⏱️ processHistory took \(elapsed)s")
```

---

## Localization Requirements

### Supported Languages

1. **English** (`en.lproj/`)
2. **German** (`de.lproj/`)
3. **Spanish** (`es.lproj/`)
4. **French** (`fr.lproj/`)
5. **Dutch** (`nl.lproj/`)

### Adding Localized Strings

**Every user-facing string must be localized in all 5 languages.**

**Process:**

1. **Add to English** (`en.lproj/Localizable.strings`):
```
"My_New_String" = "My New String";
```

2. **Translate for German** (`de.lproj/Localizable.strings`):
```
"My_New_String" = "Meine Neue Zeichenfolge";
```

3. **Translate for Spanish** (`es.lproj/Localizable.strings`):
```
"My_New_String" = "Mi Nueva Cadena";
```

4. **Translate for French** (`fr.lproj/Localizable.strings`):
```
"My_New_String" = "Ma Nouvelle Chaîne";
```

5. **Translate for Dutch** (`nl.lproj/Localizable.strings`):
```
"My_New_String" = "Mijn Nieuwe String";
```

### Translation Resources

**For AI Assistants:**
- Use professional translation (DeepL, Google Translate as starting point)
- Prefer formal tone for mental health terminology
- Maintain technical accuracy
- Consider cultural sensitivity

**Key Terms Reference:**

| English | German | Spanish | French | Dutch |
|---------|--------|---------|--------|-------|
| Mood | Stimmung | Estado de ánimo | Humeur | Stemming |
| Elevation | Erhöhung | Elevación | Élévation | Verhoging |
| Depression | Depression | Depresión | Dépression | Depressie |
| Anxiety | Angst | Ansiedad | Anxiété | Angst |
| Irritability | Reizbarkeit | Irritabilidad | Irritabilité | Prikkelbaarheid |
| Symptom | Symptom | Síntoma | Symptôme | Symptoom |
| Activity | Aktivität | Actividad | Activité | Activiteit |

### Testing Localization

```swift
// Test in Xcode:
// 1. Edit Scheme → Run → Options → App Language
// 2. Select language to test
// 3. Run app and verify translations

// Or change device language in iOS Settings
```

---

## Data Migration & Versioning

### Version Tracking

```swift
// DataStoreStruct has version field
struct DataStoreStruct: Codable {
    var version: Int = 1  // Current version
    // ...
}
```

**Increment version when:**
- Changing data structure (adding/removing fields)
- Changing data format (e.g., Date → String)
- Changing data meaning (e.g., scale 0-5 → 0-10)

### Migration Pattern

```swift
init() {
    do {
        let retrieved = try Disk.retrieve("data.json", from: .documents, as: DataStoreStruct.self)

        // Check version
        if retrieved.version < 2 {
            // Migrate from v1 to v2
            let migrated = migrateV1ToV2(data: retrieved)
            self.moodSnaps = migrated.moodSnaps
            self.version = 2
            save()  // Save migrated data
        } else {
            // Already current version
            self.moodSnaps = retrieved.moodSnaps
            self.version = retrieved.version
        }
    } catch {
        // No existing data or error - use defaults
        self.moodSnaps = makeIntroSnap()
        self.version = 1
    }
}

func migrateV1ToV2(data: DataStoreStruct) -> DataStoreStruct {
    var migrated = data

    // Example: Add default values for new fields
    for i in 0..<migrated.moodSnaps.count {
        if migrated.moodSnaps[i].newField == nil {
            migrated.moodSnaps[i].newField = defaultValue
        }
    }

    migrated.version = 2
    return migrated
}
```

### Breaking Changes Checklist

Before making breaking changes:

- [ ] Increment version number
- [ ] Write migration function
- [ ] Test migration with real data
- [ ] Test migration with old version data
- [ ] Document migration in commit message
- [ ] Consider user communication (if needed)

---

## Final Notes for AI Assistants

### Key Principles to Remember

1. **Privacy is non-negotiable** - No network, no tracking, ever
2. **Users depend on their data** - Never risk data loss
3. **Accessibility matters** - Test ColorBlind theme always
4. **Localization is required** - All 5 languages, every time
5. **Mental health is serious** - Treat this code with care

### When in Doubt

1. **Read the code** - Don't guess, read the actual implementation
2. **Test thoroughly** - Empty state, full state, edge cases
3. **Ask questions** - Better to clarify than break things
4. **Be conservative** - Backwards compatibility over clever tricks
5. **Document changes** - Future you (and others) will thank you

### Resources

- **ARCHITECTURE.md** - Technical architecture details
- **README.md** - Project overview and features
- **Constants.swift** - All configurable values
- **DataStore.swift** - Central state management
- **UX.swift** - All theming and styling

### Getting Help

- **GitHub Issues:** Report bugs or request features
- **Code Comments:** Many files have helpful inline documentation
- **Xcode Quick Help:** Option+Click on any symbol for documentation

---

**Remember:** This app helps people manage serious mental health conditions. Your code quality directly impacts their wellbeing. Take the time to do it right.

**Happy coding!** 🧠💙

---

*This document is maintained alongside ARCHITECTURE.md. When making significant changes to the codebase, update both documents.*

**Document Version:** 1.0
**Last Updated:** 2025-11-13
**Maintained By:** AI Assistants working on MoodSnap
