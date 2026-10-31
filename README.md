# Daily Routine (iOS)

A small SwiftUI iPhone app for keeping track of a daily routine and personal life goals. You add the things you want to do every day, tick them off as you go, and the ticks clear automatically the next day. A second tab lets you keep a list of life goals with a category, priority and progress.

This is a simple iOS version of my Daily Routine App idea, built while learning Swift and SwiftUI. The goals screen and finance models were moved here from the earlier `daily-routine-app` repository.

## Features
- Add, tick off, reorder and delete routine tasks
- Progress count for today (for example "3 of 5 done")
- Tasks are saved on the device with UserDefaults (Codable JSON)
- Ticks reset at the start of each new day
- Goals tab: add, edit and delete life goals, filter by category, set a priority, an optional target date and a progress percentage
- Goals are sorted by priority (critical, high, medium, low) and saved on the device with UserDefaults (Codable JSON)

## Not built yet
- Finance: `FinanceModels.swift` contains data models for transactions, savings accounts, holiday pots, financial targets and budgets, but there is no finance screen yet and nothing saves finance data. These models will be reviewed and reworked before a finance UI is added.
- There are no automated tests yet.

## Files
| File | What it does |
| --- | --- |
| `DailyRoutineApp.swift` | App entry point, with a Routine tab and a Goals tab |
| `RoutineTask.swift` | The task model (Codable) |
| `RoutineStore.swift` | Loads, saves and updates tasks, handles the daily reset |
| `ContentView.swift` | The routine list screen |
| `LifeGoal.swift` | The life goal model (Codable) |
| `GoalStore.swift` | Loads, saves and updates goals, sorts them by priority |
| `GoalsView.swift` | The goals screen, plus the add and edit goal forms |
| `FinanceModels.swift` | Finance data models only, not used by any screen yet |

## How to run it in Xcode
Requires Xcode 15 or later and iOS 17 or later.

1. Clone this repository.
2. Open `DailyRoutine.xcodeproj`.
3. Pick an iPhone simulator and press **Run** (Cmd+R).

The project is already connected to this GitHub repository, so commits can be pushed from Xcode or from the command line.

## Screenshots
Screenshots will be added once the app has been run on a simulator.

## Author
Daniel

## License
MIT, see [LICENSE](LICENSE).
