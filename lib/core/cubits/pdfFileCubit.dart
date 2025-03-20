import 'dart:io';

import 'package:dio/dio.dart';
<<<<<<< HEAD
import 'package:eschool_teacher/core/models/studyMaterial.dart';
import 'package:eschool_teacher/core/repositories/studyMaterialRepositoy.dart';
import 'package:eschool_teacher/core/utils/errorMessageKeysAndCodes.dart';
import 'package:external_path/external_path.dart';
=======
import 'package:madares_app_teacher/core/models/studyMaterial.dart';
import 'package:madares_app_teacher/core/repositories/studyMaterialRepositoy.dart';
import 'package:madares_app_teacher/core/utils/errorMessageKeysAndCodes.dart';
>>>>>>> f8116bb26ff7cdb9462a79241b86162b4f4e9bdc

import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

abstract class PdfFileSaveState {}

class PdfFileSaveInitial extends PdfFileSaveState {}

class PdfFileSaveInProgress extends PdfFileSaveState {
  final double uploadedPercentage;

  PdfFileSaveInProgress(this.uploadedPercentage);
}

class PdfFileSaveSuccess extends PdfFileSaveState {
  final String pdfFilePath;

  PdfFileSaveSuccess(this.pdfFilePath);
}

class PdfFileSaveFailure extends PdfFileSaveState {
  final String errorMessage;

  PdfFileSaveFailure(this.errorMessage);
}

class PdfFileSaveCubit extends Cubit<PdfFileSaveState> {
  final StudyMaterialRepository _subjectRepository;

  PdfFileSaveCubit(this._subjectRepository) : super(PdfFileSaveInitial());

  final CancelToken _cancelToken = CancelToken();

  void _downloadedFilePercentage(double percentage) {
    emit(PdfFileSaveInProgress(percentage));
  }

  Future<void> writeFileFromTempStorage({
    required String sourcePath,
    required String destinationPath,
  }) async {
    final tempFile = File(sourcePath);
    final byteData = await tempFile.readAsBytes();
    final downloadedFile = File(destinationPath);
    //write into downloaded file
    await downloadedFile.writeAsBytes(
      byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
    );
  }

  Future<void> savePdfFile({
    required StudyMaterial studyMaterial,
    required bool storeInExternalStorage,
    bool isFile = false,
  }) async {
    if (isFile) {
      emit(PdfFileSaveSuccess(studyMaterial.fileUrl));
      return;
    }
    emit(PdfFileSaveInProgress(0.0));
    try {
      //if wants to download the file then
      if (storeInExternalStorage) {
        Future<void> thingsToDoAfterPermissionIsGiven(
            bool isPermissionGranted) async {
          //storing the fie temp
          final Directory tempDir = await getTemporaryDirectory();
          final tempFileSavePath =
              "${tempDir.path}/${studyMaterial.fileName}.${studyMaterial.fileExtension}";

          await _subjectRepository.downloadStudyMaterialFile(
            cancelToken: _cancelToken,
            savePath: tempFileSavePath,
            updateDownloadedPercentage: _downloadedFilePercentage,
            url: studyMaterial.fileUrl,
          );

          //download file
          String pdfFilePath = Platform.isAndroid && isPermissionGranted
<<<<<<< HEAD
              ? (await ExternalPath.getExternalStoragePublicDirectory(
                  ExternalPath.DIRECTORY_DOWNLOADS,
                ))
=======
              ? await getDownloadsDirectory().then(
                  (value) => value!.path,)
>>>>>>> f8116bb26ff7cdb9462a79241b86162b4f4e9bdc
              : (await getApplicationDocumentsDirectory()).path;

          pdfFilePath =
              "$pdfFilePath/${studyMaterial.fileName}.${studyMaterial.fileExtension}";

          await writeFileFromTempStorage(
            sourcePath: tempFileSavePath,
            destinationPath: pdfFilePath,
          );

          emit(PdfFileSaveSuccess(pdfFilePath));
        }

        //if user has given permission to download and view file
        final permission = await Permission.storage.request();
        if (permission.isGranted) {
          await thingsToDoAfterPermissionIsGiven(true);
        } else {
          try {
            await thingsToDoAfterPermissionIsGiven(false);
          } catch (e) {
            if (e.toString() != ErrorMessageKeysAndCode.fileNotFoundErrorCode) {
              emit(
                PdfFileSaveFailure(
                  ErrorMessageKeysAndCode.permissionNotGivenCode,
                ),
              );
              openAppSettings();
            } else {
              emit(
                PdfFileSaveFailure(
                  e.toString(),
                ),
              );
            }
          }
        }
      } else {
        //download file for just to see
        final Directory tempDir = await getTemporaryDirectory();
        final savePath =
            "${tempDir.path}/${studyMaterial.fileName}.${studyMaterial.fileExtension}";

        await _subjectRepository.downloadStudyMaterialFile(
          cancelToken: _cancelToken,
          savePath: savePath,
          updateDownloadedPercentage: _downloadedFilePercentage,
          url: studyMaterial.fileUrl,
        );

        emit(PdfFileSaveSuccess(savePath));
      }
    } catch (e) {
      emit(PdfFileSaveFailure(e.toString()));
    }
  }

  void cancelDownloadProcess() {
    _cancelToken.cancel();
  }
}
