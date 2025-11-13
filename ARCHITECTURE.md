# MoodSnap Architecture Documentation

## Table of Contents
1. [Overview](#overview)
2. [Technology Stack](#technology-stack)
3. [Project Structure](#project-structure)
4. [Application Flow](#application-flow)
5. [Data Architecture](#data-architecture)
6. [Styling & Theming System](#styling--theming-system)
7. [How to Modify Different Aspects](#how-to-modify-different-aspects)
8. [Key Components Guide](#key-components-guide)
9. [Adding New Features](#adding-new-features)
10. [Common Development Tasks](#common-development-tasks)

---

## Overview

**MoodSnap** is a sophisticated native iOS mood tracking and analytics application built with SwiftUI. It allows users to track their mental health by recording mood levels (Elevation, Depression, Anxiety, Irritability), symptoms, activities, social events, and integrates with Apple HealthKit for holistic health insights.

**Key Features:**
- 4-dimensional mood tracking (E/D/A/I scale)
- 24 symptom categories
- 9 activity types
- 6 social event types
- Statistical analysis (correlations, volatility, trends)
- Butterfly effect analysis (mood changes around events)
- HealthKit integration (weight, sleep, exercise, menstrual cycle)
- PDF report generation
- iOS Widget support
- Multi-language support (5 languages)
- Face ID/Touch ID protection
- Local-only data storage (privacy-first)

---

## Technology Stack

| Component | Technology |
|-----------|-----------|
| **Platform** | iOS (Native) |
| **Framework** | SwiftUI |
| **Language** | Swift |
| **Build System** | Xcode (.xcodeproj) |
| **Architecture Pattern** | MVVM-like (SwiftUI + ObservableObject) |
| **Concurrency** | Swift Async/Await, Combine |
| **Data Persistence** | Disk library (JSON files) |
| **Chart Library** | Custom-built |
| **PDF Generation** | TPPDF |
| **Health Integration** | HealthKit |
| **Widget Support** | WidgetKit |
| **Authentication** | LocalAuthentication (Face ID/Touch ID) |

---

## Project Structure

```
MoodSnap/
├── MoodSnapApp.swift                 # App entry point
├── MainViews/                        # Primary screens
│   ├── ContentView.swift            # Root view container
│   ├── MoodSnapView.swift           # Main mood entry interface
│   ├── ControlView.swift            # Bottom navigation bar
│   ├── EventView.swift              # Life events entry
│   ├── NoteView.swift               # Diary notes
│   ├── MediaView.swift              # Photo diary
│   ├── SettingsView.swift           # App settings
│   └── UnlockView.swift             # Face ID screen
│
├── HistoryView/                      # Timeline & history
│   ├── HistoryView.swift            # Main timeline
│   ├── HistoryItemView.swift        # Item renderer (routes to specific views)
│   ├── HistoryMoodView.swift        # Mood entry display
│   ├── HistoryNoteView.swift        # Note display
│   ├── HistoryEventView.swift       # Event display
│   ├── HistoryMediaView.swift       # Photo display
│   ├── HistoryQuoteView.swift       # Quote display
│   └── HistoryCustomView.swift      # Custom entry display
│
├── InsightsView/                     # Analytics & insights
│   ├── InsightsView.swift           # Main analytics container
│   ├── AverageMoodView.swift        # Aggregate mood display
│   ├── MoodHistoryBarView.swift     # Timeline bar chart
│   ├── MovingAverageView.swift      # Sliding window averages
│   ├── VolatilityView.swift         # Mood instability metrics
│   ├── TallyView.swift              # Frequency counts
│   ├── InfluencesActivityView.swift # Activity analysis
│   ├── InfluencesSocialView.swift   # Social analysis
│   ├── InfluencesSymptomView.swift  # Symptom analysis
│   ├── InfluencesEventsView.swift   # Event analysis
│   ├── InfluencesHashtagView.swift  # Hashtag analysis
│   ├── WeightView.swift             # Weight tracking
│   ├── WalkingRunningDistanceView.swift
│   ├── ActiveEnergyView.swift
│   ├── SleepView.swift
│   └── MenstrualView.swift
│
├── DataStore/                        # Data management
│   ├── DataStore.swift              # Main data class & processing logic
│   └── JSON.swift                   # JSON structures
│
├── Base/                             # Core utilities
│   ├── Constants.swift              # App-wide constants
│   ├── DateConverters.swift         # Date formatting
│   ├── Filtering.swift              # Data filtering
│   ├── Sorting.swift                # Data sorting
│   ├── Merging.swift                # Data merging
│   ├── Counting.swift               # Count utilities
│   ├── GraphDataConverters.swift    # Chart data transformation
│   ├── Haptic.swift                 # Haptic feedback
│   ├── Notifications.swift          # Reminder system
│   └── Utilities.swift              # General helpers
│
├── Statistics/                       # Analytics engine
│   ├── GenerateHistory.swift        # Daily sequencing
│   ├── Average.swift                # Mean calculations
│   ├── AverageMoodSnap.swift        # Aggregate snapshots
│   ├── Volatility.swift             # Instability metrics
│   ├── Correlation.swift            # Pearson correlations
│   ├── Transients.swift             # Butterfly analysis
│   ├── Influence.swift              # Impact calculations
│   ├── Trends.swift                 # Trend detection
│   └── GetDates.swift               # Date range utilities
│
├── Plotting/                         # Visualization components
│   ├── LineChart.swift              # Multi-line charts
│   ├── VerticalBarChart.swift       # Bar charts
│   ├── MoodLevelsView.swift         # Mood sliders
│   └── RoundedRectangleDot.swift    # Chart markers
│
├── UX/                               # Styling & theming
│   ├── UX.swift                     # Theme definitions
│   └── Color.swift                  # Color utilities
│
├── HealthKit/                        # Health integration
│   └── HealthManager.swift          # HealthKit interface
│
├── PDF/                              # Report generation
│   ├── GeneratePDF.swift            # PDF builder
│   ├── PDFAverageMoodView.swift
│   ├── PDFMoodHistoryBarView.swift
│   ├── PDFSingleSlidingAverageView.swift
│   └── PDFSingleSlidingVolatilityView.swift
│
├── Widget/                           # iOS Widget extension
│   ├── MoodSnapWidget.swift         # Widget provider
│   └── MoodSnapWidgetEntryView.swift
│
├── Hashtags/                         # Hashtag system
│   ├── HashtagExtractor.swift       # Parse hashtags from notes
│   └── HashtagInfluence.swift
│
├── Quotes/                           # Motivational quotes
│   └── QuotesList.swift
│
├── Media/                            # Photo diary
│   └── MediaManager.swift
│
└── Assets.xcassets/                  # Images & icons
```

---

## Application Flow

### 1. App Launch Flow

```
MoodSnapApp.swift (@main)
    ↓
Initialize @StateObject DataStoreClass
Initialize @StateObject HealthManager
    ↓
Check Face ID setting
    ↓ (if enabled)
UnlockView (Face ID/Touch ID)
    ↓ (on success)
ContentView (main interface)
```

**Key Code:** `MoodSnapApp.swift:14-42`

### 2. Main Interface Structure

```
ContentView
├── VStack
│   ├── HistoryView (scrollable timeline)
│   │   └── LazyVStack
│   │       └── ForEach(moodSnaps)
│   │           └── HistoryItemView (routes by snapType)
│   │
│   └── ControlView (bottom bar with 7 buttons)
│       ├── Settings Sheet
│       ├── Insights Sheet
│       ├── Event Sheet
│       ├── MoodSnap Sheet (center, larger)
│       ├── Note Sheet
│       ├── Media Sheet
│       └── Help Sheet
```

**Key Code:** `MainViews/ContentView.swift`

### 3. Data Flow Pipeline

```
User Input (MoodSnapView, EventView, etc.)
    ↓
Create MoodSnapStruct
    ↓
Append to DataStoreClass.moodSnaps[]
    ↓
Save to Disk (data.json)
    ↓
Trigger DataStoreClass.startProcessing()
    ↓
8 Parallel Async Tasks:
├── processStats() → counts, dates
├── processHistory() → daily sequences, correlations, trends
├── processAverages() → sliding window calculations
├── processEvents() → butterfly analysis
├── processHashtags() → hashtag extraction & influence
├── processActivities() → activity impact
├── processSocial() → social impact
└── processSymptoms() → symptom impact
    ↓
Update @Published processedData
    ↓
SwiftUI auto-refreshes all dependent views
```

**Key Code:** `DataStore/DataStore.swift:242-382`

### 4. Widget Data Sharing

```
Main App (DataStoreClass)
    ↓
Save to shared App Group
Disk.save("data.json", to: .sharedContainer("group.MoodSnap"))
    ↓
Widget Extension reads shared data
    ↓
Display in iOS Widget
    ↓
Timeline refresh every 1 hour
```

**Key Code:** `DataStore/DataStore.swift:416-446`

---

## Data Architecture

### Core Data Structures

#### 1. MoodSnapStruct
The primary unit of data representing a single mood entry.

**Location:** `DataStore/JSON.swift:31-84`

```swift
struct MoodSnapStruct {
    var id: UUID
    var timestamp: Date
    var snapType: SnapType  // .mood, .note, .event, .media, .quote, .custom

    // Mood levels (0-4 scale)
    var elevation: CGFloat
    var depression: CGFloat
    var anxiety: CGFloat
    var irritability: CGFloat

    // Binary toggles
    var symptoms: [Bool]    // 24 symptoms
    var activities: [Bool]  // 9 activities
    var social: [Bool]      // 6 social categories

    // Text fields
    var event: String
    var notes: String

    // Media
    var mediaIDs: [UUID]
}
```

**Mood Scale:**
- 0 = None
- 1 = Mild
- 2 = Moderate
- 3 = Severe
- 4 = Extreme

#### 2. HealthSnapStruct
HealthKit data aggregated by day.

**Location:** `DataStore/JSON.swift:86-105`

```swift
struct HealthSnapStruct {
    var id: UUID
    var timestamp: Date
    var walkingRunningDistance: CGFloat?  // km
    var activeEnergy: CGFloat?            // kcal
    var weight: CGFloat?                  // kg
    var sleepHours: CGFloat?              // hours
    var menstrual: CGFloat?               // flow level 1-4
}
```

#### 3. ProcessedDataStruct
Computed analytics and insights.

**Location:** `DataStore/JSON.swift:149-248`

```swift
struct ProcessedDataStruct {
    // Daily mood levels
    var levelE, levelD, levelA, levelI: [CGFloat?]

    // Daily averages (all symptoms/activities included)
    var averageE, averageD, averageA, averageI: [CGFloat?]

    // Volatility (instability metric)
    var volatilityE, volatilityD, volatilityA, volatilityI: [CGFloat?]

    // Trend indicators
    var elevationTrend: String  // "up", "down", "stable"
    var depressionTrend: String
    var anxietyTrend: String
    var irritabilityTrend: String

    // Sliding averages (30, 90, 180 day windows)
    var averageThirtyE, averageThirtyD, averageThirtyA, averageThirtyI: [CGFloat?]
    var averageNinetyE, averageNinetyD, averageNinetyA, averageNinetyI: [CGFloat?]
    var averageHundredEightyE, averageHundredEightyD, averageHundredEightyA, averageHundredEightyI: [CGFloat?]

    // Volatility sliding averages
    var volatilityThirtyE, volatilityThirtyD, volatilityThirtyA, volatilityThirtyI: [CGFloat?]
    var volatilityNinetyE, volatilityNinetyD, volatilityNinetyA, volatilityNinetyI: [CGFloat?]

    // Butterfly charts (mood changes around events)
    var butterflyCharts: [String: ButterflyChartStruct]
    var butterflyHashtagCharts: [String: ButterflyChartStruct]

    // Influence analysis
    var activityInfluence: [String: InfluenceStruct]
    var socialInfluence: [String: InfluenceStruct]
    var symptomInfluence: [String: InfluenceStruct]
}
```

#### 4. SettingsStruct
User preferences and app configuration.

**Location:** `DataStore/JSON.swift:250-334`

```swift
struct SettingsStruct {
    // Appearance
    var theme: Int  // 0=Aqua, 1=ColorBlind, 2=Orange, 3=Primary, 4=Pastel, 5=Summer

    // Visibility toggles (what to show in UI)
    var showElevation, showDepression, showAnxiety, showIrritability: Bool
    var showSymptoms, showActivities, showSocial: Bool
    var showThirty, showNinety, showHundredEighty: Bool
    var showVolatility: Bool

    // Features
    var faceIDEnabled: Bool
    var remindersEnabled: Bool
    var reminderTime: Date
    var quotesEnabled: Bool

    // HealthKit
    var healthKitEnabled: Bool
    var healthWeight, healthWalkingRunning, healthEnergy, healthSleep, healthMenstrual: Bool

    // PDF settings
    var pdfTimePeriod: Int  // 0=1mo, 1=3mo, 2=6mo, 3=1yr
    var pdfIncludeNotes: Bool
    var pdfBlackAndWhite: Bool
}
```

### Data Persistence

**Library:** Disk (third-party JSON persistence)

**Storage Locations:**
1. **Main App:** `.documents/data.json`
2. **Widget:** `.sharedContainer(appGroupName: "group.MoodSnap")/data.json`

**Save Operations:**
- Auto-save on background (app enters background)
- Manual save after each data modification
- Shared container sync for widgets

**Code Example:**
```swift
// Save to main app storage
try Disk.save(dataStoreStruct, to: .documents, as: "data.json")

// Save to shared container (for widgets)
try Disk.save(dataStoreStruct, to: .sharedContainer(appGroupName: "group.MoodSnap"), as: "data.json")
```

**Key Code:** `DataStore/DataStore.swift:416-467`

---

## Styling & Theming System

### Theme Architecture

**Location:** `UX/UX.swift`

The app uses a **theme struct system** where all colors and dimensions are defined per theme.

### ThemeStruct Definition

```swift
struct ThemeStruct {
    var name: String

    // Mood colors
    var elevationColor: Color
    var depressionColor: Color
    var anxietyColor: Color
    var irritabilityColor: Color

    // UI colors
    var gridColor: Color
    var buttonColor: Color
    var iconColor: Color
    var controlColor: Color
    var emergencyColor: Color
    var logoColor: Color

    // Health colors
    var menstrualColor: Color
    var menstrualLabelColor: Color
    var walkingRunningColor: Color
    var energyColor: Color
    var weightColor: Color
    var sleepColor: Color

    // Dimensions
    var hBarHeight: CGFloat           // History bar height
    var hBarRadius: CGFloat           // History bar corner radius
    var hBarFontSize: CGFloat         // History bar text size
    var controlIconSize: CGFloat      // Control bar icon size
    var controlBigIconSize: CGFloat   // Large icon size
    var closeButtonIconSize: CGFloat  // Close button size
    var sliderSpacing: CGFloat        // Mood slider spacing
    var historyGridSpacing: CGFloat   // History item spacing
    var moodSnapGridSpacing: CGFloat  // MoodSnap view spacing
    var barShadeOffset: CGFloat       // Bar shadow offset
}
```

**Key Code:** `UX/UX.swift:6-46`

### Available Themes

| Index | Name | Description | Key Colors |
|-------|------|-------------|------------|
| **0** | **Aqua** (default) | Blue-based theme | Blue buttons, standard mood colors |
| **1** | **ColorBlind** | IBM accessibility palette | Blue, Purple, Pink, Orange, Yellow (optimized for color blindness) |
| **2** | **Orange** | Orange-accented | Orange buttons, standard mood colors |
| **3** | **Primary** | Standard iOS colors | Green/Red/Orange/Yellow mood colors |
| **4** | **Pastel** | Soft, muted colors | Cyan, Red, Orange, Yellow pastels |
| **5** | **Summer** | Bright, vibrant | Cyan, Red, Yellow vibrant tones |

**Theme Array:**
```swift
let themes = [AquaTheme(), ColorBlindTheme(), OrangeTheme(), PrimaryTheme(), PastelTheme(), SummerTheme()]
```

**Key Code:** `UX/UX.swift:151`

### Accessing Theme Values in Code

The current theme is stored in `data.settings.theme` (Int 0-5).

**Usage Pattern:**
```swift
// Access theme properties
themes[data.settings.theme].elevationColor
themes[data.settings.theme].buttonColor
themes[data.settings.theme].controlIconSize

// Example in a View
Circle()
    .fill(themes[data.settings.theme].elevationColor)
    .frame(width: themes[data.settings.theme].controlIconSize)
```

### Color System

**Hex Color Support:** `UX/Color.swift`

```swift
// Create color from hex
Color(0x2D65AF)  // Blue
Color(0xFF8296)  // Red
Color(0x75CDD8, alpha: 0.5)  // Cyan with transparency
```

**Key Code:** `UX/Color.swift:7-16`

---

## How to Modify Different Aspects

### 1. Change App Colors / Add New Theme

**File:** `UX/UX.swift`

**Step 1:** Create a new theme constructor function

```swift
func MyCustomTheme() -> ThemeStruct {
    var theme = ThemeStruct()
    theme.name = "MyCustom"

    // Set mood colors
    theme.elevationColor = Color(0x00FF00)      // Green
    theme.depressionColor = Color(0xFF0000)     // Red
    theme.anxietyColor = Color(0xFFA500)        // Orange
    theme.irritabilityColor = Color(0xFFFF00)   // Yellow

    // Set UI colors
    theme.buttonColor = Color.purple
    theme.iconColor = Color.purple
    theme.controlColor = Color.purple
    theme.emergencyColor = Color.red

    // Health colors (optional, defaults are fine)
    theme.menstrualColor = Color(0xF47157)
    theme.walkingRunningColor = Color(0xFE6532)
    theme.energyColor = Color(0xFE6532)
    theme.weightColor = Color(0xB15FE9)
    theme.sleepColor = Color(0x86E2E0)

    return theme
}
```

**Step 2:** Add to themes array

```swift
// Line 151
let themes = [
    AquaTheme(),
    ColorBlindTheme(),
    OrangeTheme(),
    PrimaryTheme(),
    PastelTheme(),
    SummerTheme(),
    MyCustomTheme()  // Add your theme here (index 6)
]
```

**Step 3:** Update theme picker in SettingsView

**File:** `MainViews/SettingsView.swift`

Find the theme picker section and add your theme option to the UI.

---

### 2. Change Layout Dimensions

**File:** `UX/UX.swift`

Modify the `ThemeStruct` defaults:

```swift
// Line 34-45
var hBarHeight: CGFloat = 15              // Make history bars taller
var hBarRadius: CGFloat = 10              // More rounded corners
var hBarFontSize: CGFloat = 14            // Larger text
var controlIconSize: CGFloat = 30         // Bigger control icons
var controlBigIconSize: CGFloat = 50      // Bigger center button
var closeButtonIconSize: CGFloat = 30     // Bigger close buttons
var sliderSpacing: CGFloat = 0            // More space between sliders
var historyGridSpacing: CGFloat = 10      // More space between history items
var moodSnapGridSpacing: CGFloat = 5      // Spacing in mood entry view
var barShadeOffset: CGFloat = 2.0         // More pronounced shadows
```

**Note:** These changes will apply to ALL themes. To customize per theme, modify individual theme constructors.

---

### 3. Add New Symptom, Activity, or Social Category

**File:** `Base/Constants.swift`

**Add a Symptom:**
```swift
// Line 32-56
let symptomList = [
    "Anhedonia",
    "Increased_appetite",
    // ... existing symptoms ...
    "Suicidal_thoughts",
    "My_New_Symptom"  // Add here
]
```

**Add an Activity:**
```swift
// Line 59-68
let activityList = [
    "Alcohol",
    "Caffeine",
    // ... existing activities ...
    "Therapy",
    "My_New_Activity"  // Add here
]
```

**Add a Social Event:**
```swift
// Line 71-77
let socialList = [
    "Affection",
    "Conflict",
    // ... existing social ...
    "No_in_person_contact",
    "My_New_Social_Event"  // Add here
]
```

**Important:** After modifying these arrays, you must also:

1. **Add localization strings** for each language (`en.lproj`, `de.lproj`, etc.)
2. **Update MoodSnapStruct** in `DataStore/JSON.swift` to add a new Bool field if needed
3. **Update MoodSnapView** toggles to include the new option

**Example: Add toggle in MoodSnapView.swift**

Search for the symptoms/activities/social section and add:
```swift
Toggle("My_New_Symptom".localize(), isOn: $moodSnap.myNewSymptom)
```

---

### 4. Change Mood Scale Range

The app currently uses a **0-4 scale** for mood levels.

**To change to 0-10 scale:**

**File:** `MainViews/MoodSnapView.swift`

Find the mood sliders (around line 80-120) and change:

```swift
// Change from:
Slider(value: $moodSnap.elevation, in: 0...4, step: 1)

// To:
Slider(value: $moodSnap.elevation, in: 0...10, step: 1)
```

**Update labels in charting views:**

**Files to update:**
- `InsightsView/AverageMoodView.swift`
- `InsightsView/MoodHistoryBarView.swift`
- `Plotting/LineChart.swift`

Change y-axis max from 4 to 10.

---

### 5. Change Statistical Analysis Windows

**File:** `Base/Constants.swift`

```swift
// Line 10-12
let butterflyWindowShort = 7       // Change to 14 for 2-week window
let butterflyWindowLong = 28       // Change to 56 for 8-week window
let menstrualTransientWindow = 14  // Menstrual analysis window
```

**Sliding Average Windows:**

**File:** `Statistics/Average.swift`

Currently hardcoded to 30, 90, 180 days. Search for these values and modify.

---

### 6. Change Quote Frequency

**File:** `Base/Constants.swift`

```swift
// Line 4
let quoteFrequency = 11  // Change to 5 for more frequent quotes, 20 for less frequent
```

This inserts a motivational quote every N mood entries.

---

### 7. Modify Chart Colors

**For mood line charts:**

**File:** `UX/Color.swift`

```swift
// Line 22
let lineChartOpacity = 1.0  // Change to 0.8 for more transparent lines
```

**For health charts:**

**File:** `UX/UX.swift`

```swift
// Line 26-31
var menstrualColor: Color = Color(0xFF0000)      // Change to red
var walkingRunningColor: Color = Color(0x00FF00) // Change to green
var energyColor: Color = Color(0x0000FF)         // Change to blue
var weightColor: Color = Color(0xFFFF00)         // Change to yellow
var sleepColor: Color = Color(0xFF00FF)          // Change to magenta
```

---

### 8. Change PDF Report Settings

**File:** `Base/Constants.swift`

```swift
// Line 15-20
let marginPDF = 1.0 * 72              // Change margins (72 points = 1 inch)
let titleFontSizePDF = 28.0           // Larger title
let subtitleFontSizePDF = 20.0        // Larger subtitle
let bodyFontSizePDF = 14.0            // Larger body text
let notesFontSizePDF = 12.0           // Larger notes
let headerFontSizePDF = 12.0          // Larger header
```

**PDF generation logic:**

**File:** `PDF/GeneratePDF.swift`

This file controls the PDF layout, sections included, and formatting.

---

### 9. Change Reminder Notification Schedule

**File:** `Base/Notifications.swift`

Modify the reminder time logic and frequency.

---

### 10. Modify Widget Refresh Rate

**File:** `Widget/MoodSnapWidget.swift`

```swift
// Find the timeline reload logic
let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!

// Change to refresh every 30 minutes:
let nextUpdate = Calendar.current.date(byAdding: .minute, value: 30, to: Date())!

// Or every 6 hours:
let nextUpdate = Calendar.current.date(byAdding: .hour, value: 6, to: Date())!
```

---

## Key Components Guide

### 1. DataStoreClass (State Management)

**File:** `DataStore/DataStore.swift`

**Purpose:** Central ObservableObject managing all app state

**Key Properties:**
```swift
@Published var settings: SettingsStruct           // User preferences
@Published var uxState: UXStateStruct             // UI state (sheet visibility, etc.)
@Published var moodSnaps: [MoodSnapStruct]        // All mood entries
@Published var processedData: ProcessedDataStruct // Computed analytics
@Published var processingStatus: ProcessingStatus // Processing state
@Published var correlations: CorrelationsStruct   // Mood correlations
```

**Key Methods:**
- `init()` - Loads data from disk
- `startProcessing()` - Triggers analytics pipeline
- `save()` - Persists to disk
- `processHistory()` - Daily sequencing & correlations
- `processAverages()` - Sliding window calculations
- `processEvents()` - Butterfly analysis
- `processHashtags()` - Hashtag extraction
- `processActivities()` - Activity influence
- `processSocial()` - Social influence
- `processSymptoms()` - Symptom influence

**Usage in Views:**
```swift
@EnvironmentObject var data: DataStoreClass

// Access data
let moods = data.moodSnaps
let avgElevation = data.processedData.averageE

// Modify data
data.moodSnaps.append(newMood)
data.startProcessing()
```

---

### 2. HealthManager (HealthKit Integration)

**File:** `HealthKit/HealthManager.swift`

**Purpose:** Manages HealthKit permissions and data fetching

**Key Methods:**
- `requestAuthorization()` - Request HealthKit access
- `makeHealthSnaps()` - Fetch health data for date range
- `queryWeight()` - Get weight data
- `querySleep()` - Get sleep hours
- `queryWalkingRunning()` - Get exercise distance
- `queryActiveEnergy()` - Get calories burned
- `queryMenstrual()` - Get menstrual cycle data

**Usage:**
```swift
@EnvironmentObject var health: HealthManager

// Request permissions (in settings)
health.requestAuthorization()

// Fetch data
await health.makeHealthSnaps(data: data)
```

---

### 3. LineChart (Custom Charting)

**File:** `Plotting/LineChart.swift`

**Purpose:** Multi-line time series visualization

**Features:**
- Supports up to 4 simultaneous lines
- Dynamic y-axis scaling
- Grid overlay
- Handles nil values (gaps)
- Theme-aware colors
- PDF export mode (black & white)

**Usage:**
```swift
LineChart(
    dataE: data.processedData.levelE,
    dataD: data.processedData.levelD,
    dataA: data.processedData.levelA,
    dataI: data.processedData.levelI,
    minY: 0,
    maxY: 4,
    showGrid: true,
    blackAndWhite: false
)
.environmentObject(data)
```

---

### 4. Statistical Functions

**Location:** `Statistics/`

#### Pearson Correlation
**File:** `Correlation.swift`

```swift
let correlation = pearson(dataX: elevationData, dataY: depressionData)
// Returns: -1.0 to 1.0
```

#### Volatility (Standard Deviation)
**File:** `Volatility.swift`

```swift
let volatility = volatility(data: moodData)
// Returns: 0.0 to 4.0 (or higher)
```

#### Sliding Average
**File:** `Average.swift`

```swift
let avg30 = slidingAverage(data: moodData, window: 30)
// Returns: [CGFloat?] with same length as input
```

#### Butterfly Analysis (Event Transients)
**File:** `Transients.swift`

```swift
let butterfly = makeButterfly(
    data: data,
    eventType: "Therapy",
    windowShort: 7,
    windowLong: 28
)
// Returns: mood changes before/after events
```

---

## Adding New Features

### Example: Add a New Mood Dimension

Let's say you want to add **"Stress"** as a 5th mood dimension.

#### Step 1: Update Data Structure

**File:** `DataStore/JSON.swift`

```swift
struct MoodSnapStruct {
    // ... existing fields ...
    var stress: CGFloat = 0  // Add new field
}
```

#### Step 2: Update Constants

**File:** `Base/Constants.swift`

```swift
let moodLabels = ["Elevation", "Depression", "Anxiety", "Irritability", "Stress"]
```

#### Step 3: Add Theme Color

**File:** `UX/UX.swift`

```swift
struct ThemeStruct {
    // ... existing colors ...
    var stressColor: Color = Color.purple  // Add new color
}

// Update each theme constructor to include stressColor
func AquaTheme() -> ThemeStruct {
    var theme = ThemeStruct()
    // ... existing setup ...
    theme.stressColor = Color.purple
    return theme
}
```

#### Step 4: Update Input View

**File:** `MainViews/MoodSnapView.swift`

Add a slider for stress:

```swift
// After irritability slider
HStack {
    Text("Stress".localize())
    Spacer()
    Text(String(format: "%.0f", moodSnap.stress))
}
Slider(value: $moodSnap.stress, in: 0...4, step: 1)
    .accentColor(themes[data.settings.theme].stressColor)
```

#### Step 5: Update Processing Pipeline

**File:** `Statistics/GenerateHistory.swift`

Add stress to daily sequencing:

```swift
// Add alongside E/D/A/I processing
var levelS: [CGFloat?] = []
var averageS: [CGFloat?] = []
var volatilityS: [CGFloat?] = []
```

#### Step 6: Update ProcessedDataStruct

**File:** `DataStore/JSON.swift`

```swift
struct ProcessedDataStruct {
    // ... existing fields ...
    var levelS: [CGFloat?] = []
    var averageS: [CGFloat?] = []
    var volatilityS: [CGFloat?] = []
    var averageThirtyS: [CGFloat?] = []
    var averageNinetyS: [CGFloat?] = []
    // ... etc
}
```

#### Step 7: Update Visualization

**File:** `Plotting/LineChart.swift`

Extend to support 5 lines instead of 4 (or create a separate chart).

#### Step 8: Update History Display

**File:** `HistoryView/HistoryMoodView.swift`

Add stress bar to mood entry display.

#### Step 9: Add Localization

**Files:** `en.lproj/Localizable.strings`, `de.lproj/Localizable.strings`, etc.

```
"Stress" = "Stress";
// German
"Stress" = "Stress";
// Spanish
"Stress" = "Estrés";
```

---

## Common Development Tasks

### Task 1: Debug Data Processing

**Enable processing status logging:**

**File:** `DataStore/DataStore.swift`

The `ProcessingStatus` struct tracks completion of each processing task:

```swift
@Published var processingStatus: ProcessingStatus

// Check status
if data.processingStatus.allDone {
    print("All processing complete")
}
```

### Task 2: Clear All Data (for Testing)

**In Settings:**

There's typically a "Delete All Data" button that:
1. Clears `data.moodSnaps`
2. Clears `data.healthSnaps`
3. Resets `data.processedData`
4. Saves empty state to disk

**Code:**
```swift
data.moodSnaps = []
data.healthSnaps = []
data.processedData = ProcessedDataStruct()
data.save()
```

### Task 3: Export Data to JSON

**File:** `DataStore/DataStore.swift`

```swift
// Get JSON representation
let encoder = JSONEncoder()
encoder.outputFormatting = .prettyPrinted
let jsonData = try encoder.encode(data.moodSnaps)
let jsonString = String(data: jsonData, encoding: .utf8)

// Save to file or share
```

### Task 4: Import Sample Data

**File:** `DataStore/JSON.swift:471-610`

The `makeIntroSnap()` function creates sample data. You can modify this to add realistic test data.

### Task 5: Change App Icon

**File:** `Assets.xcassets/AppIcon.appiconset/`

Replace PNG files with new icon (requires various sizes: 20px, 29px, 40px, 58px, 60px, 76px, 80px, 87px, 120px, 152px, 167px, 180px, 1024px).

### Task 6: Add New Language

1. **Create new .lproj folder** (e.g., `it.lproj` for Italian)
2. **Copy `en.lproj/Localizable.strings`** to new folder
3. **Translate all strings**
4. **Add to Xcode project** (Project Settings → Info → Localizations)

### Task 7: Performance Optimization

**Current optimization strategies:**

1. **Parallel processing:** 8 async tasks run concurrently
2. **Lazy loading:** `LazyVStack` in history view
3. **Cached calculations:** ProcessedDataStruct stores results
4. **Throttled updates:** Processing only triggers on data changes

**To improve:**
- Add debouncing to rapid user inputs
- Implement pagination for very long histories (1000+ entries)
- Cache chart render images for PDF

---

## File Location Quick Reference

| Task | File(s) |
|------|---------|
| **Change colors** | `UX/UX.swift`, `UX/Color.swift` |
| **Change layout** | `UX/UX.swift` (dimensions) |
| **Add symptom/activity** | `Base/Constants.swift` |
| **Modify data structure** | `DataStore/JSON.swift` |
| **Change statistics** | `Statistics/*.swift` |
| **Update main UI** | `MainViews/*.swift` |
| **Modify charts** | `Plotting/*.swift` |
| **Change PDF** | `PDF/*.swift` |
| **Widget customization** | `Widget/*.swift` |
| **HealthKit changes** | `HealthKit/HealthManager.swift` |
| **Localization** | `*.lproj/Localizable.strings` |
| **Constants** | `Base/Constants.swift` |

---

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                      MoodSnapApp.swift                      │
│                   (@main entry point)                       │
└─────────────────────┬───────────────────────────────────────┘
                      │
                      ├──> DataStoreClass (@StateObject)
                      │    └──> Load from Disk
                      │
                      ├──> HealthManager (@StateObject)
                      │    └──> Request HealthKit permissions
                      │
                      └──> UnlockView (Face ID)
                           └──> ContentView
                                │
                                ├──> HistoryView (Timeline)
                                │    └──> HistoryItemView
                                │         ├──> HistoryMoodView
                                │         ├──> HistoryNoteView
                                │         ├──> HistoryEventView
                                │         ├──> HistoryMediaView
                                │         ├──> HistoryQuoteView
                                │         └──> HistoryCustomView
                                │
                                └──> ControlView (Bottom Nav)
                                     ├──> SettingsView (Sheet)
                                     ├──> InsightsView (Sheet)
                                     ├──> EventView (Sheet)
                                     ├──> MoodSnapView (Sheet)
                                     ├──> NoteView (Sheet)
                                     ├──> MediaView (Sheet)
                                     └──> HelpView (Sheet)

┌─────────────────────────────────────────────────────────────┐
│                    Data Flow Pipeline                        │
└─────────────────────────────────────────────────────────────┘

User Input → MoodSnapStruct → DataStoreClass.moodSnaps[]
                                      ↓
                              Save to Disk.json
                                      ↓
                         startProcessing() [Async]
                                      ↓
              ┌───────────────────────┴───────────────────────┐
              │                                               │
    ┌─────────┴─────────┐                         ┌──────────┴────────┐
    │  processHistory   │                         │ processAverages   │
    │  - Daily sequence │                         │ - 30/90/180 day   │
    │  - Correlations   │                         │ - Volatility      │
    │  - Trends         │                         │                   │
    └─────────┬─────────┘                         └──────────┬────────┘
              │                                               │
    ┌─────────┴─────────┐                         ┌──────────┴────────┐
    │  processEvents    │                         │ processHashtags   │
    │  - Butterfly      │                         │ - Extract #tags   │
    │  - Transients     │                         │ - Influence       │
    └─────────┬─────────┘                         └──────────┬────────┘
              │                                               │
    ┌─────────┴─────────┐                         ┌──────────┴────────┐
    │ processActivities │                         │  processSocial    │
    │  - Influence calc │                         │  - Influence calc │
    └─────────┬─────────┘                         └──────────┬────────┘
              │                                               │
              └───────────────────────┬───────────────────────┘
                                      ↓
                          ProcessedDataStruct (@Published)
                                      ↓
                          SwiftUI Views Auto-Update
```

---

## Summary

**MoodSnap** is a well-architected iOS app with:

- **Clear separation of concerns:** UI, Data, Analytics, Utilities
- **Reactive architecture:** SwiftUI + Combine
- **Efficient data processing:** Async/await with parallel tasks
- **Flexible theming:** Centralized theme system
- **Extensible design:** Easy to add new features
- **Privacy-focused:** Local-only data storage
- **Accessibility:** Color-blind mode, Face ID, multi-language

**Key strengths:**
✅ Modular codebase
✅ Comprehensive analytics engine
✅ Beautiful visualization
✅ Health integration
✅ Widget support
✅ PDF reports

**To modify the app:**
1. **Styling:** Edit `UX/UX.swift` for colors and dimensions
2. **Data:** Edit `DataStore/JSON.swift` for structures
3. **Constants:** Edit `Base/Constants.swift` for lists and settings
4. **Analytics:** Edit `Statistics/*.swift` for calculations
5. **UI:** Edit `MainViews/*.swift` and `InsightsView/*.swift` for interface

**Development workflow:**
1. Read the file you want to modify
2. Make changes according to this guide
3. Test in Xcode simulator
4. Build and run on device
5. Commit changes

For questions, refer back to the specific sections in this document or explore the codebase using the file paths provided.

---

**Last Updated:** 2025-11-13
**App Version:** Inferred from codebase
**Platform:** iOS (SwiftUI)
