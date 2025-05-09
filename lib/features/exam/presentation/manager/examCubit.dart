// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:madares_app_teacher/features/exam/data/models/exam.dart';
import 'package:madares_app_teacher/features/studentDetails/data/repositories/studentRepository.dart';


abstract class ExamDetailsState {}

class ExamDetailsInitial extends ExamDetailsState {}

class ExamDetailsFetchSuccess extends ExamDetailsState {
  final List<Exam> examList;

  ExamDetailsFetchSuccess({required this.examList});
}

class ExamDetailsFetchFailure extends ExamDetailsState {
  final String errorMessage;

  ExamDetailsFetchFailure(this.errorMessage);
}

class ExamDetailsFetchInProgress extends ExamDetailsState {}

class ExamDetailsCubit extends Cubit<ExamDetailsState> {
  final StudentRepository _studentRepository;

  ExamDetailsCubit(this._studentRepository) : super(ExamDetailsInitial());

  void fetchStudentExamsList({
    required int examStatus,
    int? classSectionId,
    int? studentId,
    int? publishStatus,
  }) {
    emit(ExamDetailsFetchInProgress());
    _studentRepository
        .fetchExamsList(
          examStatus: examStatus,
          studentID: studentId,
          publishStatus: publishStatus,
          classSectionId: classSectionId,
        )
        .then((value) => emit(ExamDetailsFetchSuccess(examList: value)))
        .catchError((e) => emit(ExamDetailsFetchFailure(e.toString())));
  }

  List<Exam> getAllExams() {
    if (state is ExamDetailsFetchSuccess) {
      return (state as ExamDetailsFetchSuccess).examList;
    }
    return [];
  }

  List<String> getExamName() {
    return getAllExams().map((exams) => exams.getExamName()).toList();
  }

  Exam getExamDetails({required int index}) {
    return getAllExams()[index];
  }
}
