# Daily Routine (iOS)

A small SwiftUI iPhone app for keeping track of a daily routine. You add the things you want to do every day, tick them off as you go, and the ticks clear automatically the next day.

This is a simple iOS version of my Daily Routine App idea, built while learning Swift and SwiftUI.

## Features
- Add, tick off, reorder and delete routine tasks
- Progress count for today (for example "3 of 5 done")
- Tasks are saved on the device with UserDefaults (Codable JSON)
- Ticks reset at the start of each new day

## Files
| File | What it does |
| --- | --- |
| `DailyRoutineApp.swift` | App entry point |
| `RoutineTask.swift` | The task model (Codable) |
| `RoutineStore.swift` | Loads, saves and updates tasks, handles the daily reset |
| `ContentView.swift` | The main list screen |

## How to run it in Xcode
Requires Xcode 15 or later and iOS 17 or later.

1. Open Xcode and choose **File > New > Project > iOS > App**.
2. Name it `DailyRoutine`, set Interface to **SwiftUI** and Language to **Swift**.
3. Delete the `ContentView.swift` and `DailyRoutineApp.swift` files Xcode created.
4. Drag the four files from the `DailyRoutine` folder of this repo into the project (tick "Copy items if needed").
5. Pick an iPhone simulator and press **Run** (Cmd+R).

## Screenshots
Screenshots will be added once the app has been run on a simulator.

## Author
Daniel

## License
MIT, see [LICENSE](LICENSE).
