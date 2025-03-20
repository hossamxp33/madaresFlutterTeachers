import 'dart:io';

import 'package:dio/dio.dart';
<<<<<<< HEAD
import 'package:eschool_teacher/core/utils/errorMessageKeysAndCodes.dart';
import 'package:eschool_teacher/core/utils/flavor_config.dart';
=======
import 'package:madares_app_teacher/core/utils/errorMessageKeysAndCodes.dart';
import 'package:madares_app_teacher/core/utils/flavor_config.dart';
>>>>>>> f8116bb26ff7cdb9462a79241b86162b4f4e9bdc

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'constants.dart';
import 'hiveBoxKeys.dart';

class ApiException implements Exception {
  String errorMessage;

  ApiException(this.errorMessage);

  @override
  String toString() {
    return errorMessage;
  }
}

// ignore: avoid_classes_with_only_static_members
class Api {
  static Map<String, String> headers() {
<<<<<<< HEAD

=======
>>>>>>> f8116bb26ff7cdb9462a79241b86162b4f4e9bdc
    final String jwtToken = Hive.box(authBoxKey).get(jwtTokenKey) ?? "";

    print({
      "Authorization": "Bearer $jwtToken",
      "Schoolid": FlavorConfig.getSchoolId().toString(),
      'Content-Type': 'application/json',
    });
    return {
      "Authorization": "Bearer $jwtToken",
<<<<<<< HEAD
      "Schoolid": "125",
      'Content-Type': 'application/json',
      "Accept":"application/json"
=======
      "Schoolid": FlavorConfig.getSchoolId().toString(),
      'Content-Type': 'application/json',
      "Accept": "application/json"
>>>>>>> f8116bb26ff7cdb9462a79241b86162b4f4e9bdc
    };
  }

  //
  //Teacher app apis
  //
  static String login = "${databaseUrl}teacher/login";
  static String profile = "${databaseUrl}teacher/get-profile-details";
  static String forgotPassword = "${databaseUrl}forgot-password";
  static String logout = "${databaseUrl}logout";
  static String changePassword = "${databaseUrl}change-password";
  static String getClasses = "${databaseUrl}teacher/classes";
  static String getSubjectByClassSection = "${databaseUrl}teacher/subjects";

  static String getassignment = "${databaseUrl}teacher/get-assignment";
  static String uploadassignment = "${databaseUrl}teacher/update-assignment";
  static String deleteassignment = "${databaseUrl}teacher/delete-assignment";
  static String createassignment = "${databaseUrl}teacher/create-assignment";
  static String createLesson = "${databaseUrl}teacher/create-lesson";
  static String getLessons = "${databaseUrl}teacher/get-lesson";
  static String deleteLesson = "${databaseUrl}teacher/delete-lesson";
  static String updateLesson = "${databaseUrl}teacher/update-lesson";

  static String getTopics = "${databaseUrl}teacher/get-topic";
  static String deleteStudyMaterial = "${databaseUrl}teacher/delete-file";
  static String deleteTopic = "${databaseUrl}teacher/delete-topic";
  static String updateStudyMaterial = "${databaseUrl}teacher/update-file";
  static String createTopic = "${databaseUrl}teacher/create-topic";
  static String updateTopic = "${databaseUrl}teacher/update-topic";
  static String getAnnouncement = "${databaseUrl}teacher/get-announcement";
  static String createAnnouncement = "${databaseUrl}teacher/send-announcement";
  static String deleteAnnouncement =
      "${databaseUrl}teacher/delete-announcement";
  static String updateAnnouncement =
      "${databaseUrl}teacher/update-announcement";
  static String getStudentsByClassSection =
      "${databaseUrl}teacher/student-list";

  static String getStudentsMoreDetails =
      "${databaseUrl}teacher/student-details";

  static String getAttendance = "${databaseUrl}teacher/get-attendance";
  static String submitAttendance = "${databaseUrl}teacher/submit-attendance";
  static String timeTable = "${databaseUrl}teacher/teacher_timetable";
  static String examList = "${databaseUrl}teacher/get-exam-list";
  static String examTimeTable = "${databaseUrl}teacher/get-exam-details";
  static String examResults = "${databaseUrl}teacher/exam-marks";
  static String submitExamMarksBySubjectId =
      "${databaseUrl}teacher/submit-exam-marks/subject";
  static String submitExamMarksByStudentId =
      "${databaseUrl}teacher/submit-exam-marks/student";
  static String getStudentResultList =
      "${databaseUrl}teacher/get-student-result";

  static String getReviewAssignment =
      "${databaseUrl}teacher/get-assignment-submission";

  static String updateReviewAssignmet =
      "${databaseUrl}teacher/update-assignment-submission";

  static String settings = "${databaseUrl}settings";

  static String holidays = "${databaseUrl}holidays";

  static String getNotifications = "${databaseUrl}teacher/get-notification";

  //chat related APIs
  static String getChatUsers = "${databaseUrl}teacher/get-user-list";
  static String getChatMessages = "${databaseUrl}teacher/get-user-message";
  static String sendChatMessage = "${databaseUrl}teacher/send-message";
  static String readAllMessages = "${databaseUrl}teacher/read-all-message";

  //Api methods
  static Future<Map<String, dynamic>> post({
    required Map<String, dynamic> body,
    required String url,
    required bool useAuthToken,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Function(int, int)? onSendProgress,
    Function(int, int)? onReceiveProgress,
  }) async {
    try {
<<<<<<< HEAD
      final Dio dio = Dio();
=======
      final Dio dio = Dio(BaseOptions(
        connectTimeout: Duration(seconds: 15), // Default 5 seconds
        receiveTimeout: Duration(seconds: 15), // Default 3 seconds
      ));
>>>>>>> f8116bb26ff7cdb9462a79241b86162b4f4e9bdc
      final FormData formData =
          FormData.fromMap(body, ListFormat.multiCompatible);
      print("======");
      print(url);
      print(formData);
      print("======");
      final response = await dio.post(
        url,
        data: formData,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
        onSendProgress: onSendProgress,
<<<<<<< HEAD
        options: useAuthToken ? Options(headers: headers()) : null,
      );
=======
        options: Options(
          headers: useAuthToken ? headers() : {
            "Schoolid": FlavorConfig.getSchoolId().toString(),
            'Content-Type': 'application/json',
            "Accept": "application/json"
          },
          followRedirects: false,
          validateStatus: (status) => status! < 500, // Allows proper handling of 302
        ),
      );
      print("response");
      print(response);
      print("response");

>>>>>>> f8116bb26ff7cdb9462a79241b86162b4f4e9bdc
      if (kDebugMode) {
        print("Response: ${response.data}");
      }
      if (response.data['error']) {
        if (kDebugMode) {
          print("POST ERROR: ${response.data}");
        }
        throw ApiException(response.data['code'].toString());
      }
      return Map.from(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 503 || e.response?.statusCode == 500) {
        throw ApiException(ErrorMessageKeysAndCode.internetServerErrorCode);
      }
      throw ApiException(
        e.error is SocketException
            ? ErrorMessageKeysAndCode.noInternetCode
            : ErrorMessageKeysAndCode.defaultErrorMessageCode,
      );
    } on ApiException catch (e) {
      throw ApiException(e.errorMessage);
    } catch (e) {
      throw ApiException(ErrorMessageKeysAndCode.defaultErrorMessageKey);
    }
  }

  static Future<Map<String, dynamic>> get({
    required String url,
    required bool useAuthToken,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      //
<<<<<<< HEAD
      final Dio dio = Dio();
=======
      final Dio dio = Dio(BaseOptions(
        connectTimeout: Duration(seconds: 15), // Default 5 seconds
        receiveTimeout: Duration(seconds: 15), // Default 3 seconds
      ));
>>>>>>> f8116bb26ff7cdb9462a79241b86162b4f4e9bdc
      if (kDebugMode) {
        print("API Called GET: $url ");
        print("queryParameters: $queryParameters");
        print("headers: ${headers()}");
      }

<<<<<<< HEAD

=======
>>>>>>> f8116bb26ff7cdb9462a79241b86162b4f4e9bdc
      final response = await dio.get(
        url,
        queryParameters: queryParameters,
        options: useAuthToken ? Options(headers: headers()) : null,
      );
      if (kDebugMode) {
        print("Response: ${response.data}");
      }
      if (response.data['error']) {
        if (kDebugMode) {
          print("GET ERROR: ${response.data}");
        }
        throw ApiException(response.data['code'].toString());
      }
      return Map.from(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 503 || e.response?.statusCode == 500) {
        throw ApiException(ErrorMessageKeysAndCode.internetServerErrorCode);
      }
      throw ApiException(
        e.error is SocketException
            ? ErrorMessageKeysAndCode.noInternetCode
            : ErrorMessageKeysAndCode.defaultErrorMessageCode,
      );
    } on ApiException catch (e) {
      throw ApiException(e.errorMessage);
    } catch (e) {
      throw ApiException(ErrorMessageKeysAndCode.defaultErrorMessageKey);
    }
  }

  static Future<void> download({
    required String url,
    required CancelToken cancelToken,
    required String savePath,
    required Function updateDownloadedPercentage,
  }) async {
    try {
<<<<<<< HEAD
      final Dio dio = Dio();
=======
      final Dio dio = Dio(BaseOptions(
        connectTimeout: Duration(seconds: 15), // Default 5 seconds
        receiveTimeout: Duration(seconds: 15), // Default 3 seconds
      ));
>>>>>>> f8116bb26ff7cdb9462a79241b86162b4f4e9bdc
      await dio.download(
        url,
        savePath,
        cancelToken: cancelToken,
        onReceiveProgress: (count, total) {
          final double percentage = (count / total) * 100;
          updateDownloadedPercentage(percentage < 0.0 ? 99.0 : percentage);
        },
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 503 || e.response?.statusCode == 500) {
        throw ApiException(ErrorMessageKeysAndCode.internetServerErrorCode);
      }
      if (e.response?.statusCode == 404) {
        throw ApiException(ErrorMessageKeysAndCode.fileNotFoundErrorCode);
      }
      throw ApiException(
        e.error is SocketException
            ? ErrorMessageKeysAndCode.noInternetCode
            : ErrorMessageKeysAndCode.defaultErrorMessageCode,
      );
    } on ApiException catch (e) {
      throw ApiException(e.errorMessage);
    } catch (e) {
      throw ApiException(ErrorMessageKeysAndCode.defaultErrorMessageKey);
    }
  }
}
