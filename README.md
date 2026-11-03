# Flutter Experiment 5: Application State Management (Personal Budget Calculator)

## Objective
Build a budget dashboard that tracks income and expenses and recalculates the balance and status using state management.

## Technologies Used
- Flutter 3.47 / Dart 3.13
- Material Design 3
- `provider` package (`ChangeNotifier`)

## Main Features
- Set monthly income
- Add and remove multiple expenses, with validation
- Total expenses, remaining balance and a spent-percentage progress bar
- Status: no income / healthy / tight (80%+ spent) / overspent
- Reset with a confirmation dialog

## Flutter Widgets and Concepts Implemented
- `ChangeNotifier`, `ChangeNotifierProvider`, `context.watch` / `context.read`
- `Form` validation, `AlertDialog`, `LinearProgressIndicator`
- Reusable `SummaryCard` and `ExpenseTile` widgets

## Project Structure
```text
lib/
├── main.dart
├── models/expense.dart
├── providers/budget_provider.dart
├── screens/dashboard_screen.dart
└── widgets/
    ├── summary_card.dart
    └── expense_tile.dart
test/widget_test.dart
```

## Required Dependencies
- `provider`

## How to Run
```bash
flutter pub get
flutter analyze
flutter test
flutter run            # choose an Android emulator/device (or: flutter run -d chrome)
```

## Screenshots
_No screenshots have been added yet. Place images in a `screenshots/` folder and link them here._
