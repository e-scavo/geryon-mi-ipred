# Phase X — Task 014 — Android 16 / API 36 Google Play Target Upgrade

## Objective

Update the Android release toolchain so Mi IP·RED can publish new Google Play releases under the Android 16 target API requirement, without changing the application's minimum supported Android version or the Flutter release/versioning workflow.

## Repository evidence

The Task 013 baseline used:

- `compileSdk = flutter.compileSdkVersion`
- `targetSdk = flutter.targetSdkVersion`
- Android Gradle Plugin `8.7.0`
- Gradle wrapper `8.10.2`
- release version `1.0.0+91`

The uploaded Google Play Console evidence reports that version code 91 targets API 35 and must target API 36 or higher.

## Implementation

### Explicit Android 16 compile/target contract

`android/app/build.gradle.kts` now declares:

- `compileSdk = 36`
- `targetSdk = 36`

The values are explicit instead of inheriting the Flutter SDK defaults because publication compliance is now a release contract for this application.

`minSdk` remains managed by Flutter and is intentionally unchanged, so this migration does not raise the minimum Android version supported by the app.

### Android Gradle Plugin compatibility

`android/settings.gradle.kts` now uses Android Gradle Plugin `8.9.1`.

API 36 requires AGP 8.9.1 or newer. The former AGP 8.7.0 is below the supported minimum for API 36.

### Gradle wrapper compatibility

`android/gradle/wrapper/gradle-wrapper.properties` now uses Gradle `8.11.1`, matching the minimum Gradle version required by AGP 8.9.x.

## Release workflow

No change was made to `build_and_commit.dart`, `update_version.dart`, signing, versionCode/versionName mapping, or the existing release artifact flow.

Before building on a workstation, Android SDK Platform 36 must be installed. With Android Studio this can be installed from SDK Manager. With `sdkmanager`, the equivalent packages are:

- `platforms;android-36`
- `build-tools;36.0.0`

After the SDK is installed, the project can be rebuilt using the existing release command, for example:

`dart run build_and_commit.dart --aab --bump`

A new versionCode must be uploaded to Google Play; the already-uploaded versionCode 91 cannot be replaced by another bundle with the same versionCode.

## Google Play native-symbol warning

The Play Console warning about native debug symbols is not the API-level publication blocker. It is independent of the API 36 migration and can be handled separately if native crash/ANR symbolication is required.

## Files changed

- `android/app/build.gradle.kts`
- `android/settings.gradle.kts`
- `android/gradle/wrapper/gradle-wrapper.properties`
- `docs/tasks/014_android_16_api36_google_play_target_upgrade.md`
- `docs/tasks/index.md`
- `docs/index.md`

## Validation boundary

The Android/Flutter SDK is not available in the execution environment used for this task, so the release bundle could not be compiled here. The project configuration was validated statically against the API 36 toolchain requirements.

## Result

The repository is now configured to compile and target Android 16 / API 36 using an API-36-compatible Android Gradle Plugin and Gradle wrapper, while preserving the existing application release and signing architecture.
