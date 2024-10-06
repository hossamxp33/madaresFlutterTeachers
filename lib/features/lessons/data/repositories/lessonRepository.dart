import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

import '../../../../core/utils/api.dart';
import '../../../../core/utils/flavor_config.dart';
import '../../../../core/utils/hiveBoxKeys.dart';
import '../models/lesson.dart';

class LessonRepository {
  Future<void> createLesson({
    required String lessonName,
    required int classSectionId,
    required int subjectId,
    required String lessonDescription,
    required List<Map<String, dynamic>> files,
  }) async {
    try {
      Map<String, dynamic> body = {
        "class_section_id": classSectionId,
        "subject_id": subjectId,
        "name": lessonName,
        "description": lessonDescription
      };

      if (files.isNotEmpty) {
        body['file'] = files;
      }

      await Api.post(body: body, url: Api.createLesson, useAuthToken: true);
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<List<Lesson>> getLessons({
    required int classSectionId,
    required int subjectId,
  }) async {
    try {
      var headers = {
        "Authorization": "Bearer ${Hive.box(authBoxKey).get(jwtTokenKey)}",
        "Schoolid": FlavorConfig.getSchoolId(),
        'token': '${Hive.box(authBoxKey).get(jwtTokenKey)}',
      };

      var dio = Dio();
      Response result = await dio.request(
        'https://madaresapp.codesroots.com/api/teacher/get-lesson',
        options: Options(
          method: 'GET',
          headers: headers,
        ),
      );
      return (result.data['data'] as List)
          .map((lesson) => Lesson.fromJson(Map.from(lesson)))
          .toList();
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<void> deleteLesson({required int lessonId}) async {
    try {
      await Api.post(
        body: {"lesson_id": lessonId},
        url: Api.deleteLesson,
        useAuthToken: true,
      );
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<void> updateLesson({
    required String lessonName,
    required int lessonId,
    required int classSectionId,
    required int subjectId,
    required String lessonDescription,
    required List<Map<String, dynamic>> files,
  }) async {
    try {
      Map<String, dynamic> body = {
        "class_section_id": classSectionId,
        "subject_id": subjectId,
        "name": lessonName,
        "description": lessonDescription,
        "lesson_id": lessonId
      };

      if (files.isNotEmpty) {
        body['file'] = files;
      }

      await Api.post(
        body: body,
        url: Api.updateLesson,
        useAuthToken: true,
      );
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
