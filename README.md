# TaskMaster

A lightweight Flutter app for tracking personal tasks and expenses, with local, offline-first storage.

## Features

**Tasks**
- Add tasks with a title, detail, and due date
- Mark tasks as complete or pending
- View all tasks in a list

**Expenses**
- Log expenses with a cost, category, date, description, and confirmation number
- View all logged expenses

Tasks and expenses are managed on separate tabs via a bottom navigation bar.

## Tech Stack

- **Framework**: Flutter (Dart)
- **Local Storage**: SQLite (via sqflite)
- **Feedback**: Fluttertoast for user-facing success/error messages

## Getting Started

1. Clone the repository.
2. Run `flutter pub get`.
3. Run `flutter run`.

No backend or account setup is required. All data is stored locally on the device.

## Project Structure

- `lib/models/` — Task and Expense data models
- `lib/database/` — SQLite database access for tasks and expenses
- `lib/screens/` — add/view screens for tasks and expenses
- `lib/reusable_widgets/` — shared UI components
