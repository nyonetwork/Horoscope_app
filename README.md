# Horoscope App

Mobile horoscope app built with Flutter.

## What It Does

- Onboards users by birth date and auto-detects zodiac sign
- Shows daily horoscope cards (yesterday/today/tomorrow)
- Tracks daily streak check-ins
- Calculates compatibility score from two birth dates
- Supports a local premium mode gate for extra details

## Tech Stack

- Flutter / Dart
- `shared_preferences` for local persistence
- Optional HTTP horoscope endpoint (if configured)

## Run Locally

```bash
flutter pub get
flutter run
```

## Optional API Configuration

The app can use a remote daily horoscope endpoint if these compile-time values are provided:

- `HOROSCOPE_API_BASE_URL`
- `HOROSCOPE_API_KEY` (optional, if your endpoint requires auth)

Example:

```bash
flutter run --dart-define=HOROSCOPE_API_BASE_URL=https://your-api.example.com --dart-define=HOROSCOPE_API_KEY=your_key
```

## Screenshot

Add a screenshot here later, for example:

- `docs/home-screen.png`
