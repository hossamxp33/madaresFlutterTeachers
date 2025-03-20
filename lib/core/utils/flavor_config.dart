<<<<<<< HEAD
class FlavorConfig {
  static const String flavor = String.fromEnvironment('FLUTTER_APP_FLAVOR');

  static String getAssetPath(String assetName) {
    switch (flavor) {
      case 'school1':
        return 'assets/school1/$assetName';
      default:
        return 'assets/images/$assetName';
=======
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FlavorConfig {
  static const String flavor = String.fromEnvironment('FLUTTER_APP_FLAVOR');

  static String getAssetPath() {
    print(flavor);
    switch (flavor) {
      case 'school2':
        return 'assets/new_school.jpeg';
      case 'school1':
        return "assets/palms_school.jpeg";
      case 'school3':
        return "assets/altuwaysh.jpeg";
      default :
        return 'assets/palms_school.jpeg';
    }
  }

  static ThemeData getLightTheme(BuildContext context) {
    print(flavor);
    switch (flavor) {
      case 'school2':
        return FlexThemeData.light(scheme: FlexScheme.amber).copyWith(
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        );
      case 'school1':
        return FlexThemeData.light(scheme: FlexScheme.cyanM3).copyWith(
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        );
      case 'school3':
        return FlexThemeData.light(scheme: FlexScheme.tealM3).copyWith(
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        )  ;
      default:
        return FlexThemeData.light(scheme: FlexScheme.cyanM3).copyWith(
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        );
    }
  }

  static ThemeData getDarkTheme(BuildContext context) {
    print(flavor);
    switch (flavor) {
      case 'school2':
        return FlexThemeData.dark(scheme: FlexScheme.amber).copyWith(
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        );
      case 'school1':
        return FlexThemeData.dark(scheme: FlexScheme.cyanM3).copyWith(
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        );
      case 'school3':
        return FlexThemeData.dark(scheme: FlexScheme.tealM3).copyWith(
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        )  ;
      default:
        return FlexThemeData.dark(scheme: FlexScheme.cyanM3).copyWith(
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        );
>>>>>>> f8116bb26ff7cdb9462a79241b86162b4f4e9bdc
    }
  }

  static int getSchoolId() {
    switch (flavor) {
<<<<<<< HEAD
      case 'school1':
        return 125;
      default:
        return 125;
=======
      case 'school2':
        return 125;
      case 'school1':
        return 126;
      case 'school3':
        return 127;
      default:
        return 126;
    }
  }

  static String getSchoolName() {
    switch (flavor) {
      case 'school1':
        return "مدرسة النخيل الاهليه";
      case 'school2':
        return "مدرسة زهور الحياة للبنات";
      case 'school3':
        return "مدرسه الطويسه";
      default:
        return "مدرسة النخيل الاهليه";
>>>>>>> f8116bb26ff7cdb9462a79241b86162b4f4e9bdc
    }
  }
}
