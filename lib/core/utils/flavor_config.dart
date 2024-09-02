class FlavorConfig {
  static const String flavor = String.fromEnvironment('FLUTTER_APP_FLAVOR');

  static String getAssetPath(String assetName) {
    switch (flavor) {
      case 'school1':
        return 'assets/school1/$assetName';
      default:
        return 'assets/images/$assetName';
    }
  }

  static String getSchoolId() {
    switch (flavor) {
      case 'school1':
        return '123';
      default:
        return '123';
    }
  }
}
