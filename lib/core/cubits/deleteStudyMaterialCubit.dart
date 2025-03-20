<<<<<<< HEAD
import 'package:eschool_teacher/core/repositories/studyMaterialRepositoy.dart';
=======
import 'package:madares_app_teacher/core/repositories/studyMaterialRepositoy.dart';
>>>>>>> f8116bb26ff7cdb9462a79241b86162b4f4e9bdc
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class DeleteStudyMaterialState {}

class DeleteStudyMaterialInitial extends DeleteStudyMaterialState {}

class DeleteStudyMaterialInProgress extends DeleteStudyMaterialState {}

class DeleteStudyMaterialSuccess extends DeleteStudyMaterialState {}

class DeleteStudyMaterialFailure extends DeleteStudyMaterialState {
  final String errorMessage;

  DeleteStudyMaterialFailure(this.errorMessage);
}

class DeleteStudyMaterialCubit extends Cubit<DeleteStudyMaterialState> {
  final StudyMaterialRepository _studyMaterialRepository;

  DeleteStudyMaterialCubit(this._studyMaterialRepository)
      : super(DeleteStudyMaterialInitial());

  Future<void> deleteStudyMaterial({required int fileId}) async {
    emit(DeleteStudyMaterialInProgress());
    try {
      await _studyMaterialRepository.deleteStudyMaterial(fileId: fileId);
      emit(DeleteStudyMaterialSuccess());
    } catch (e) {
      emit(DeleteStudyMaterialFailure(e.toString()));
    }
  }
}
