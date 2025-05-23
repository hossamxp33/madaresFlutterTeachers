import 'package:madares_app_teacher/features/assignment/data/repositories/assignmentRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class DeleteAssignmentState {}

class DeleteAssignmentInitial extends DeleteAssignmentState {}

class DeleteAssignmentFetchInProgress extends DeleteAssignmentState {}

class DeleteAssignmentFetchSuccess extends DeleteAssignmentState {}

class DeleteAssignmentFetchFailure extends DeleteAssignmentState {
  final String errorMessage;
  DeleteAssignmentFetchFailure(this.errorMessage);
}

class DeleteAssignmentCubit extends Cubit<DeleteAssignmentState> {
  final AssignmentRepository _assignmentRepository;

  DeleteAssignmentCubit(this._assignmentRepository)
      : super(DeleteAssignmentInitial());

  Future<void> deleteAssignment({
    required int assignmentId,
  }) async {
    try {
      emit(DeleteAssignmentFetchInProgress());
      await _assignmentRepository
          .deleteAssignment(assignmentId: assignmentId)
          .then((_) => emit(DeleteAssignmentFetchSuccess()));
    } catch (e) {
      emit(DeleteAssignmentFetchFailure(e.toString()));
    }
  }
}
