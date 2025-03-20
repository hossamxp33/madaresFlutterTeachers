<<<<<<< HEAD
# eschool_teacher

//to run the application
```shell
flutter run
```

//To update iOS pods
```shell
cd ios
pod init
pod update
pod install
cd ..
```

//To clean the pub cache
```shell
flutter clean
flutter pub cache clean
flutter pub get
```

//To repair the pub cache
```shell
flutter clean
flutter pub cache repair
flutter pub get
```

//to generate android application
```shell
flutter build apk --split-per-abi
open  build/app/outputs/flutter-apk/
```

// to solve most common iOS errors
```shell
flutter clean
rm -Rf ios/Pods
rm -Rf ios/.symlinks
rm -Rf ios/Flutter/Flutter.framework
rm -Rf Flutter/Flutter.podspec
rm ios/podfile.lock
cd ios 
pod deintegrate
sudo rm -rf ~/Library/Developer/Xcode/DerivedData
flutter pub cache repair
flutter pub get 
pod install 
pod update 
```
=======
# madares_app_teacher

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
>>>>>>> f8116bb26ff7cdb9462a79241b86162b4f4e9bdc
