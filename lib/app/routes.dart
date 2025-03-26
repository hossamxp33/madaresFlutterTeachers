import 'package:madares_app_teacher/features/notifications/presentation/pages/notificationsScreen.dart';
import 'package:madares_app_teacher/features/splash/presentation/pages/splashScreen.dart';
import 'package:madares_app_teacher/features/termsAndCondition/presentation/pages/termsAndConditionScreen.dart';
import 'package:madares_app_teacher/features/topcisByLesson/presentation/pages/topcisByLessonScreen.dart';
import 'package:madares_app_teacher/fileViews/imageFileScreen.dart';
import 'package:madares_app_teacher/fileViews/pdfFileScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../features/aboutUs/presentation/pages/aboutUsScreen.dart';
import '../features/add&editAssignment/presentation/pages/add&editAssignmentScreen.dart';
import '../features/addOrEditAnnouncement/presentation/pages/addOrEditAnnouncementScreen.dart';
import '../features/addOrEditLesson/presentation/pages/addOrEditLessonScreen.dart';
import '../features/addOrEditTopic/presentation/pages/addOrEditTopicScreen.dart';
import '../features/announcements/presentation/pages/announcementsScreen.dart';
import '../features/assignment/presentation/pages/assignmentScreen.dart';
import '../features/assignments/presentation/pages/assignmentsScreen.dart';
import '../features/attendance/presentation/pages/attendanceScreen.dart';
import '../features/chat/presentation/pages/chatMessagesScreen.dart';
import '../features/chat/presentation/pages/chatUserProfileScreen.dart';
import '../features/chat/presentation/pages/chatUserSearchScreen.dart';
import '../features/chat/presentation/pages/chatUsersScreen.dart';
import '../features/class/presentation/pages/classScreen.dart';
import '../features/contactUs/presentation/pages/contactUsScreen.dart';
import '../features/exam/presentation/pages/examScreen.dart';
import '../features/exam/presentation/pages/examTimeTableScreen.dart';
import '../features/holidays/presentation/pages/holidaysScreen.dart';
import '../features/home/presentation/pages/homeScreen.dart';
import '../features/lessons/presentation/pages/lessonsScreen.dart';
import '../features/login/presentation/pages/loginScreen.dart';
import '../features/privacyPolicy/presentation/pages/privacyPolicyScreen.dart';
import '../features/result/presentation/pages/addResultForAllStudentsScreen.dart';
import '../features/result/presentation/pages/addResultOfStudentScreen.dart';
import '../features/result/presentation/pages/resultScreen.dart';
import '../features/searchStudent/presentation/pages/searchStudentScreen.dart';
import '../features/studentDetails/presentation/pages/studentDetailsScreen.dart';
import '../features/subject/presentation/pages/subjectScreen.dart';
import '../features/topics/presentation/pages/topicsScreen.dart';


// ignore: avoid_classes_with_only_static_members
class Routes {
  static const String splash = "splash";
  static const String home = "/";
  static const String login = "login";
  static const String classScreen = "/class";
  static const String subject = "/subject";

  static const String assignments = "/assignments";

  static const String announcements = "/announcements";

  static const String topics = "/topics";

  static const String assignment = "/assignment";

  static const String addAssignment = "/addAssignment";

  static const String attendance = "/attendance";

  static const String searchStudent = "/searchStudent";

  static const String studentDetails = "/studentDetails";

  static const String resultList = "/resultList";

  static const String addResult = "/addResult";
  static const String addResultForAllStudents = "/addResultForAllStudents";

  static const String lessons = "/lessons";

  static const String addOrEditLesson = "/addOrEditLesson";

  static const String addOrEditTopic = "/addOrEditTopic";

  static const String addOrEditAnnouncement = "/addOrEditAnnouncement";

  static const String monthWiseAttendance = "/monthWiseAttendance";

  static const String termsAndCondition = "/termsAndCondition";

  static const String aboutUs = "/aboutUs";
  static const String privacyPolicy = "/privacyPolicy";

  static const String contactUs = "/contactUs";

  static const String topicsByLesson = "/topicsByLesson";

  static const String holidays = "/holidays";

  static const String exams = "/exam";
  static const String examTimeTable = "/examTimeTable";

  static const String notifications = "/notifications";

  static const String pdfFileView = "/pdfFileView";
  static const String imageFileView = "/imageFileView";

  static const String chatMessages = "/chatMessages";
  static const String chatUserPage = "/chatUserPage";
  static const String chatUserProfile = "/chatUserProfile";
  static const String chatUserSearch = "/chatUserSearch";

  static String currentRoute = splash;

  static Route<dynamic> onGenerateRouted(RouteSettings routeSettings) {
    currentRoute = routeSettings.name ?? "";
    if (kDebugMode) {
      print("Route: $currentRoute");
    }
    switch (routeSettings.name) {
      case splash:
        {
          return SplashScreen.route(routeSettings);
        }
      case login:
        {
          return LoginScreen.route(routeSettings);
        }
      case home:
        {
          return HomeScreen.route(routeSettings);
        }
      case classScreen:
        {
          return ClassScreen.route(routeSettings);
        }
      case subject:
        {
          return SubjectScreen.route(routeSettings);
        }
      case assignments:
        {
          return AssignmentsScreen.route(routeSettings);
        }
      case assignment:
        {
          return AssignmentScreen.route(routeSettings);
        }
      case addAssignment:
        {
          return AddAssignmentScreen.routes(routeSettings);
        }

      case attendance:
        {
          return AttendanceScreen.route(routeSettings);
        }
      case searchStudent:
        {
          return SearchStudentScreen.route(routeSettings);
        }
      case studentDetails:
        {
          return StudentDetailsScreen.route(routeSettings);
        }
      case resultList:
        {
          return ResultListScreen.route(routeSettings);
        }
      case addResult:
        {
          return AddResultScreen.route(routeSettings);
        }
      case addResultForAllStudents:
        {
          return AddResultForAllStudents.route(routeSettings);
        }

      case announcements:
        {
          return AnnouncementsScreen.route(routeSettings);
        }
      case lessons:
        {
          return LessonsScreen.route(routeSettings);
        }
      case topics:
        {
          return TopicsScreen.route(routeSettings);
        }
      case addOrEditLesson:
        {
          return AddOrEditLessonScreen.route(routeSettings);
        }
      case addOrEditTopic:
        {
          return AddOrEditTopicScreen.route(routeSettings);
        }
      case aboutUs:
        {
          return AboutUsScreen.route(routeSettings);
        }
      case privacyPolicy:
        {
          return PrivacyPolicyScreen.route(routeSettings);
        }

      case contactUs:
        {
          return ContactUsScreen.route(routeSettings);
        }
      case termsAndCondition:
        {
          return TermsAndConditionScreen.route(routeSettings);
        }
      case addOrEditAnnouncement:
        {
          return AddOrEditAnnouncementScreen.route(routeSettings);
        }
      case topicsByLesson:
        {
          return TopcisByLessonScreen.route(routeSettings);
        }
      case holidays:
        {
          return HolidaysScreen.route(routeSettings);
        }
      case exams:
        {
          return ExamScreen.route(routeSettings);
        }

      case examTimeTable:
        {
          return ExamTimeTableScreen.route(routeSettings);
        }
      case notifications:
        return NotificationScreen.route(routeSettings);
      case pdfFileView:
        return PdfFileScreen.route(routeSettings);
      case imageFileView:
        return ImageFileScreen.route(routeSettings);
      case chatMessages:
        return ChatMessagesScreen.route(routeSettings);
      case chatUserProfile:
        return ChatUserProfileScreen.route(routeSettings);
      case chatUserPage:
        return ChatUsersScreen.route(routeSettings);
      case chatUserSearch:
        return ChatUsersSearchScreen.route(routeSettings);
      default:
        {
          return CupertinoPageRoute(builder: (context) => const Scaffold());
        }
    }
  }
}
