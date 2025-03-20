import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart' as internet_connection;

abstract class InternetConnectivityState {}

class InternetConnectivityInitial extends InternetConnectivityState {}

class InternetConnectivityEstablished extends InternetConnectivityState {
  final bool isUserOnline;

  InternetConnectivityEstablished({required this.isUserOnline});
}

class InternetConnectivityCubit extends Cubit<InternetConnectivityState> {
  InternetConnectivityCubit() : super(InternetConnectivityInitial()) {
    _setUpInternetConnectionChecker();
  }

  StreamSubscription<ConnectivityResult>? _streamSubscription;

  Future<void> _setUpInternetConnectionChecker() async {
    try {
      _streamSubscription =Connectivity().onConnectivityChanged.listen(
<<<<<<< HEAD
        _internetConnectionListenerCallback,
=======
        _internetConnectionListenerCallback as void Function(List<ConnectivityResult> event)?,
>>>>>>> f8116bb26ff7cdb9462a79241b86162b4f4e9bdc
        onError: (error) {
          // Handle subscription error
          print('Error setting up internet connection checker: $error');
        },
<<<<<<< HEAD
      );
=======
      ) as StreamSubscription<ConnectivityResult>?;
>>>>>>> f8116bb26ff7cdb9462a79241b86162b4f4e9bdc
    } catch (error) {
      // Handle general error
      print('Error setting up internet connection checker: $error');
    }
  }

  Future<void> _internetConnectionListenerCallback(
    ConnectivityResult result,
  ) async {
    //
    if (result != ConnectivityResult.none) {
      final bool hasConnection =
          await internet_connection.InternetConnectionChecker().hasConnection;

      if (state is InternetConnectivityInitial) {
        emit(InternetConnectivityEstablished(isUserOnline: hasConnection));
      } else {
        //do not emit state with same data
        if ((state as InternetConnectivityEstablished).isUserOnline !=
            hasConnection) {
          emit(InternetConnectivityEstablished(isUserOnline: hasConnection));
        }
      }
    } else {
      emit(InternetConnectivityEstablished(isUserOnline: false));
    }
  }

  @override
  Future<void> close() async {
    _streamSubscription?.cancel();
    return super.close();
  }
}
