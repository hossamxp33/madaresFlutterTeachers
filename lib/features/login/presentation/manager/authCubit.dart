
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/models/teacher.dart';
import '../../data/repositories/authRepository.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class Unauthenticated extends AuthState {}

class Authenticated extends AuthState {
  final String jwtToken;
  final Teacher teacher;

  Authenticated({required this.jwtToken, required this.teacher});
}

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;

  AuthCubit(this.authRepository) : super(AuthInitial()) {
    _checkIsAuthenticated();
  }

  void _checkIsAuthenticated() {
    if (authRepository.getIsLogIn()) {
      emit(
        Authenticated(
          teacher: authRepository.getTeacherDetails(),
          jwtToken: authRepository.getJwtToken(),
        ),
      );
    } else {
      emit(Unauthenticated());
    }
  }

  void authenticateUser({required String jwtToken, required Teacher teacher}) {
    //
    authRepository.setJwtToken(jwtToken);
    authRepository.setIsLogIn(true);
    authRepository.setTeacherDetails(teacher);

    //emit new state
    emit(Authenticated(
      teacher: teacher,
      jwtToken: jwtToken,
    ),);
  }

  Teacher getTeacherDetails() {
    if (state is Authenticated) {
      return (state as Authenticated).teacher;
    }
    return Teacher.fromJson({});
  }

  void signOut() {
    authRepository.signOutUser();
    emit(Unauthenticated());
  }
}
