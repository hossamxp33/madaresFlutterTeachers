import 'package:dio/dio.dart';
<<<<<<< HEAD
import 'package:eschool_teacher/core/models/studyMaterial.dart';
import 'package:eschool_teacher/core/utils/api.dart';
=======
import 'package:madares_app_teacher/core/models/studyMaterial.dart';
import 'package:madares_app_teacher/core/utils/api.dart';
>>>>>>> f8116bb26ff7cdb9462a79241b86162b4f4e9bdc

class StudyMaterialRepository {
  Future<void> deleteStudyMaterial({required int fileId}) async {
    try {
      await Api.post(body: {
        "file_id": fileId,
      }, url: Api.deleteStudyMaterial, useAuthToken: true,);
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<StudyMaterial> updateStudyMaterial(
      {required int fileId, required Map<String, dynamic> fileDetails,}) async {
    try {
      Map<String, dynamic> body = {
        "file_id": fileId,
      };
      body.addAll(fileDetails);

      final result = await Api.post(
          body: body, url: Api.updateStudyMaterial, useAuthToken: true,);

      return StudyMaterial.fromJson(Map.from(result['data']));
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<void> downloadStudyMaterialFile(
      {required String url,
      required String savePath,
      required CancelToken cancelToken,
      required Function updateDownloadedPercentage,}) async {
    try {
      await Api.download(
          cancelToken: cancelToken,
          url: url,
          savePath: savePath,
          updateDownloadedPercentage: updateDownloadedPercentage,);
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
