

import 'package:madares_app_teacher/core/models/sessionYear.dart';

class AppConfiguration {
  AppConfiguration({
    required this.appLink,
    required this.iosAppLink,
    required this.appVersion,
    required this.iosAppVersion,
    required this.forceAppUpdate,
    required this.appMaintenance,
    required this.isDemo,
  });
  late final bool isDemo;
  late final String appLink;
  late final String iosAppLink;
  late final String appVersion;
  late final String iosAppVersion;
  late final String forceAppUpdate;
  late final String appMaintenance;
  late final SessionYear sessionYear;
  late final String schoolName;
  late final String schoolTagline;

  AppConfiguration.fromJson(Map<String, dynamic> json) {
    appLink = json['teacher_app_link'] ?? "";
    iosAppLink = json['teacher_ios_app_link'] ?? "";
    appVersion = json['teacher_app_version'] ?? "";
    iosAppVersion = json['teacher_ios_app_version'] ?? "";
    forceAppUpdate = json['teacher_force_app_update'] ?? "0";
    appMaintenance = json['teacher_app_maintenance'] ?? "0";
    schoolName = json['school_name'] ?? "";
    schoolTagline = json['school_tagline'] ?? "";
    sessionYear = SessionYear.fromJson(json['session_year'] ?? {});
    isDemo = json['is_demo'] ?? false;
  }
}
