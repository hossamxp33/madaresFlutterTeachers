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

  static int getSchoolId() {
    switch (flavor) {
      case 'school1':
        return 125;
      default:
        return 125;
    }
  }
}
