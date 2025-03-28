
import 'package:madares_app_teacher/core/models/pickedStudyMaterial.dart';
import 'package:madares_app_teacher/features/lessons/data/repositories/lessonRepository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class EditLessonState {}

class EditLessonInitial extends EditLessonState {}

class EditLessonInProgress extends EditLessonState {}

class EditLessonSuccess extends EditLessonState {}

class EditLessonFailure extends EditLessonState {
  final String errorMessage;

  EditLessonFailure(this.errorMessage);
}

class EditLessonCubit extends Cubit<EditLessonState> {
  final LessonRepository _lessonRepository;

  EditLessonCubit(this._lessonRepository) : super(EditLessonInitial());

  Future<void> editLesson({
    required String lessonName,
    required int lessonId,
    required int classSectionId,
    required int subjectId,
    required String lessonDescription,
    required List<PickedStudyMaterial> files,
  }) async {
    emit(EditLessonInProgress());
    try {
      List<Map<String, dynamic>> filesJosn = [];
      for (var file in files) {
        filesJosn.add(await file.toJson());
      }

      await _lessonRepository.updateLesson(
        lessonId: lessonId,
        lessonName: lessonName,
        classSectionId: classSectionId,
        subjectId: subjectId,
        lessonDescription: lessonDescription,
        files: filesJosn,
      );
      emit(EditLessonSuccess());
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      emit(EditLessonFailure(e.toString()));
    }
  }
}
