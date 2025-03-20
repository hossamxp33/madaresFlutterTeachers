<<<<<<< HEAD
import 'package:eschool_teacher/features/lessons/data/repositories/lessonRepository.dart';
=======
import 'package:madares_app_teacher/features/lessons/data/repositories/lessonRepository.dart';
>>>>>>> f8116bb26ff7cdb9462a79241b86162b4f4e9bdc
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class LessonDeleteState {}

class LessonDeleteInitial extends LessonDeleteState {}

class LessonDeleteInProgress extends LessonDeleteState {}

class LessonDeleteSuccess extends LessonDeleteState {}

class LessonDeleteFailure extends LessonDeleteState {
  final String errorMessage;

  LessonDeleteFailure(this.errorMessage);
}

class LessonDeleteCubit extends Cubit<LessonDeleteState> {
  final LessonRepository _lessonRepository;

  LessonDeleteCubit(this._lessonRepository) : super(LessonDeleteInitial());

  Future<void> deleteLesson(int lessonId) async {
    emit(LessonDeleteInProgress());
    try {
      await _lessonRepository.deleteLesson(lessonId: lessonId);
      emit(LessonDeleteSuccess());
    } catch (e) {
      emit(LessonDeleteFailure(e.toString()));
    }
  }
}
