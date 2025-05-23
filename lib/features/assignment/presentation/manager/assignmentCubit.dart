import 'package:madares_app_teacher/features/assignment/data/models/assignment.dart';
import 'package:madares_app_teacher/features/assignment/data/repositories/assignmentRepository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


abstract class AssignmentState {}

class AssignmentInitial extends AssignmentState {}

class AssignmentFetchInProgress extends AssignmentState {}

class AssignmentsFetchSuccess extends AssignmentState {
  final List<Assignment> assignment;
  final int totalPage;
  final int currentPage;
  final bool moreAssignmentsFetchError;
  final bool fetchMoreAssignmentsInProgress;
  AssignmentsFetchSuccess({
    required this.assignment,
    required this.totalPage,
    required this.currentPage,
    required this.moreAssignmentsFetchError,
    required this.fetchMoreAssignmentsInProgress,
  });
  AssignmentsFetchSuccess copywith({
    final List<Assignment>? newAssignment,
    final int? newTotalPage,
    final int? newCurrentPage,
    final bool? newMoreAssignmentsFetchError,
    final bool? newFetchMoreAssignmentsInProgress,
  }) {
    return AssignmentsFetchSuccess(
      assignment: newAssignment ?? assignment,
      totalPage: newTotalPage ?? totalPage,
      currentPage: newCurrentPage ?? currentPage,
      moreAssignmentsFetchError:
          newMoreAssignmentsFetchError ?? moreAssignmentsFetchError,
      fetchMoreAssignmentsInProgress:
          newFetchMoreAssignmentsInProgress ?? fetchMoreAssignmentsInProgress,
    );
  }
}

class AssignmentFetchFailure extends AssignmentState {
  final String errorMessage;
  AssignmentFetchFailure(this.errorMessage);
}

class AssignmentCubit extends Cubit<AssignmentState> {
  final AssignmentRepository _assignmentRepository;

  AssignmentCubit(this._assignmentRepository) : super(AssignmentInitial());

  Future<void> fetchassignment({
    required int classSectionId,
    required int subjectId,
    int? page,
  }) async {
    try {
      if (kDebugMode) {
        print("asssignemtclassandsubjectid  $classSectionId  $subjectId");
      }
      emit(AssignmentFetchInProgress());
      await _assignmentRepository
          .fetchassignment(
            classSectionId: classSectionId,
            subjectId: subjectId,
            page: page,
          )
          .then(
            (result) => emit(
              AssignmentsFetchSuccess(
                assignment: result['assignment'],
                currentPage: result["currentPage"],
                totalPage: result["lastPage"],
                moreAssignmentsFetchError: false,
                fetchMoreAssignmentsInProgress: false,
              ),
            ),
          )
          .catchError((e) {});
    } catch (e) {
      return emit(
        AssignmentFetchFailure(e.toString()),
      );
    }
  }

  void updateState(AssignmentState updatedState) {
    emit(updatedState);
  }

  bool hasMore() {
    if (state is AssignmentsFetchSuccess) {
      return (state as AssignmentsFetchSuccess).currentPage <
          (state as AssignmentsFetchSuccess).totalPage;
    }
    return false;
  }

  Future<void> fetchMoreAssignment({
    required int classSectionId,
    required int subjectId,
  }) async {
    try {
      emit(
        (state as AssignmentsFetchSuccess)
            .copywith(newFetchMoreAssignmentsInProgress: true),
      );

      final fetchMoreAssignment = await _assignmentRepository.fetchassignment(
        classSectionId: classSectionId,
        subjectId: subjectId,
        page: (state as AssignmentsFetchSuccess).currentPage + 1,
      );

      final currentState = state as AssignmentsFetchSuccess;

      List<Assignment> assignments = currentState.assignment;

      assignments.addAll(fetchMoreAssignment['assignment']);

      emit(
        AssignmentsFetchSuccess(
          assignment: assignments,
          totalPage: fetchMoreAssignment['lastPage'],
          currentPage: fetchMoreAssignment["currentPage"],
          moreAssignmentsFetchError: false,
          fetchMoreAssignmentsInProgress: false,
        ),
      );
    } catch (e) {
      emit(
        (state as AssignmentsFetchSuccess).copywith(
          newMoreAssignmentsFetchError: true,
          newFetchMoreAssignmentsInProgress: false,
        ),
      );
      // throw ApiException(e.toString());
    }
  }

  Future<void> deleteAssignment(
    int assignmentId,
  ) async {
    if (state is AssignmentsFetchSuccess) {
      List<Assignment> listOfAssignments =
          (state as AssignmentsFetchSuccess).assignment;
      if (kDebugMode) {
        print("listOfAssignments${listOfAssignments.length}");
      }
      listOfAssignments.removeWhere((element) => element.id == assignmentId);
      if (kDebugMode) {
        print("afte remove assignmwnt ${listOfAssignments.length}");
      }
      emit(
        AssignmentsFetchSuccess(
          assignment: listOfAssignments,
          currentPage: (state as AssignmentsFetchSuccess).currentPage,
          fetchMoreAssignmentsInProgress:
              (state as AssignmentsFetchSuccess).fetchMoreAssignmentsInProgress,
          moreAssignmentsFetchError:
              (state as AssignmentsFetchSuccess).moreAssignmentsFetchError,
          totalPage: (state as AssignmentsFetchSuccess).totalPage,
        ),
      );
    }
  }
}
