
import 'package:madares_app_teacher/features/lessons/data/models/lesson.dart';
import 'package:madares_app_teacher/features/lessons/data/repositories/lessonRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class LessonsState {}

class LessonsInitial extends LessonsState {}

class LessonsFetchInProgress extends LessonsState {}

class LessonsFetchSuccess extends LessonsState {
  final List<Lesson> lessons;

  LessonsFetchSuccess(this.lessons);
}

class LessonsFetchFailure extends LessonsState {
  final String errorMessage;

  LessonsFetchFailure(this.errorMessage);
}

class LessonsCubit extends Cubit<LessonsState> {
  final LessonRepository _lessonRepository;

  LessonsCubit(this._lessonRepository) : super(LessonsInitial());

  Future<void> fetchLessons({
    required int classSectionId,
    required int subjectId,
  }) async {
    emit(LessonsFetchInProgress());
    try {
      emit(
        LessonsFetchSuccess(
          await _lessonRepository.getLessons(
            classSectionId: classSectionId,
            subjectId: subjectId,
          ),
        ),
      );
    } catch (e) {
      emit(LessonsFetchFailure(e.toString()));
    }
  }

  void updateState(LessonsState updatedState) {
    emit(updatedState);
  }

  void deleteLesson(int lessonId) {
    if (state is LessonsFetchSuccess) {
      List<Lesson> lessons = (state as LessonsFetchSuccess).lessons;
      lessons.removeWhere((element) => element.id == lessonId);
      emit(LessonsFetchSuccess(lessons));
    }
  }

  Lesson getLesson(int index) {
    if (state is LessonsFetchSuccess) {
      return (state as LessonsFetchSuccess).lessons[index];
    }
    return Lesson.fromJson({});
  }
}
