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
      case 'abulkhaseeb':
        return "assets/abulkhaseeb.png";
      default:
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
        );
      case 'abulkhaseeb':
        return FlexThemeData.light(scheme: FlexScheme.blue).copyWith(
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        );
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
        );
      case 'abulkhaseeb':
        return FlexThemeData.light(scheme: FlexScheme.blue).copyWith(
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        );
      default:
        return FlexThemeData.dark(scheme: FlexScheme.cyanM3).copyWith(
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        );
    }
  }

  static int getSchoolId() {
    switch (flavor) {
      case 'school2':
        return 125;
      case 'school1':
        return 126;
      case 'school3':
        return 127;
      case 'abulkhaseeb':
        return 129;
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
      case 'abulkhaseeb':
        return "مدارس أبي الخصيب الأهلية";
      default:
        return "مدرسة النخيل الاهليه";
    }
  }
}
