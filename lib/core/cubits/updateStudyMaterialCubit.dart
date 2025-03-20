
<<<<<<< HEAD
import 'package:eschool_teacher/core/models/pickedStudyMaterial.dart';
import 'package:eschool_teacher/core/models/studyMaterial.dart';
import 'package:eschool_teacher/core/repositories/studyMaterialRepositoy.dart';
=======
import 'package:madares_app_teacher/core/models/pickedStudyMaterial.dart';
import 'package:madares_app_teacher/core/models/studyMaterial.dart';
import 'package:madares_app_teacher/core/repositories/studyMaterialRepositoy.dart';
>>>>>>> f8116bb26ff7cdb9462a79241b86162b4f4e9bdc
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class UpdateStudyMaterialState {}

class UpdateStudyMaterialInitial extends UpdateStudyMaterialState {}

class UpdateStudyMaterialInProgress extends UpdateStudyMaterialState {}

class UpdateStudyMaterialSuccess extends UpdateStudyMaterialState {
  final StudyMaterial studyMaterial;

  UpdateStudyMaterialSuccess(this.studyMaterial);
}

class UpdateStudyMaterialFailure extends UpdateStudyMaterialState {
  final String errorMessage;

  UpdateStudyMaterialFailure(this.errorMessage);
}

class UpdateStudyMaterialCubit extends Cubit<UpdateStudyMaterialState> {
  final StudyMaterialRepository _studyMaterialRepository;

  UpdateStudyMaterialCubit(this._studyMaterialRepository)
      : super(UpdateStudyMaterialInitial());

  Future<void> updateStudyMaterial(
      {required int fileId,
      required PickedStudyMaterial pickedStudyMaterial,}) async {
    emit(UpdateStudyMaterialInProgress());
    try {
      final fileDetails = await pickedStudyMaterial.toJson();
      final result = await _studyMaterialRepository.updateStudyMaterial(
          fileId: fileId, fileDetails: fileDetails,);

      emit(UpdateStudyMaterialSuccess(result));
    } catch (e) {
      emit(UpdateStudyMaterialFailure(e.toString()));
    }
  }
}
