# Maram Milk - Manager App

Flutter application for Maram Milk dairy managers.

## Environment Configuration

This app uses `flutter_dotenv` to manage environments. API Base URLs should never be hardcoded in the source.

### Running Locally (Development)
By default, the app reads from the `.env` file at the root. 
To connect to your local backend:
1. Ensure `.env` contains `API_BASE_URL=http://10.0.2.2:3000/api/v1` (for Android emulator) or `http://localhost:3000/api/v1` (for iOS/Web).
2. Run normally: `flutter run`

### Production (Render)
To test against the production Render backend (once deployed):
1. Open `lib/main.dart`.
2. Change `await dotenv.load(fileName: ".env");` to `await dotenv.load(fileName: ".env.production");`.
3. Make sure `.env.production` has the correct `API_BASE_URL`.
*(Note: Eventually, this will be handled via compile-time arguments like `--dart-define`, but this file swap is the pattern for Phase F2).* 

