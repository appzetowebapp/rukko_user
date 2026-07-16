# Firebase Configuration Instructions

The error `FIS_AUTH_ERROR` indicates that your app's signing certificate is not authorized to use the Firebase project. This is common during development when using a debug keystore.

## Step 1: Add SHA-1 to Firebase Console

1. Go to the [Firebase Console](https://console.firebase.google.com/).
2. Select your project: **rukkooin-39480**.
3. Click on the ⚙️ (Settings icon) > **Project Settings**.
4. Scroll down to the **Your apps** section.
5. Select the Android app with package name: `com.rukkoin.user`.
6. Click **Add fingerprint**.
7. Paste this SHA-1 fingerprint:
   ```
   72:03:75:A5:0F:AC:56:B6:FB:A4:6C:4D:82:AA:8F:2E:55:7D:BA:EA
   ```
8. Click **Save**.

## Step 2: Update google-services.json

1. After adding the fingerprint, download the latest `google-services.json` file from the same page.
2. Replace the existing file at:
   `/Users/appzetoapp/Downloads/rukkoo_user_app/android/app/google-services.json`

## Step 3: Clean and Rebuild

Run the following commands in your terminal:

```bash
flutter clean
flutter pub get
flutter run
```
