
<<<<<<< HEAD
import 'package:eschool_teacher/core/models/teacher.dart';
import 'package:eschool_teacher/features/login/data/repositories/authRepository.dart';
=======
import 'package:madares_app_teacher/core/models/teacher.dart';
import 'package:madares_app_teacher/features/login/data/repositories/authRepository.dart';
>>>>>>> f8116bb26ff7cdb9462a79241b86162b4f4e9bdc
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class UserProfileState {}

class UserProfileInitial extends UserProfileState {}

class UserProfileFetchInProgress extends UserProfileState {}

class UserProfileFetchSuccess extends UserProfileState {
  final bool wasUserLoggedIn;
  UserProfileFetchSuccess({required this.wasUserLoggedIn});
}

class UserProfileFetchFailure extends UserProfileState {
  final String errorMessage;

  UserProfileFetchFailure(this.errorMessage);
}

class UserProfileCubit extends Cubit<UserProfileState> {
  final AuthRepository _authRepository;

  UserProfileCubit(this._authRepository) : super(UserProfileInitial());

  Future<void> fetchAndSetUserProfile() async {
    emit(UserProfileFetchInProgress());
    if (_authRepository.getIsLogIn()) {
      try {
        final Teacher? teacher = await _authRepository.fetchTeacherProfile();
        if (teacher == null) {
          _authRepository.signOutUser();
        } else {
          _authRepository.setTeacherDetails(teacher);
        }
        emit(
          UserProfileFetchSuccess(wasUserLoggedIn: true),
        );
      } catch (e) {
        emit(UserProfileFetchFailure(e.toString()));
      }
    } else {
      emit(UserProfileFetchSuccess(wasUserLoggedIn: false));
    }
  }
}
