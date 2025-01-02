import 'dart:developer';

import 'package:madares_app_teacher/app/routes.dart';
import 'package:madares_app_teacher/core/utils/styles/colors.dart';
import 'package:madares_app_teacher/features/home/presentation/pages/homeScreen.dart';
import 'package:madares_app_teacher/features/notifications/presentation/manager/notificationCubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationIconWidget extends StatelessWidget {
  final Size? size;
  const NotificationIconWidget({super.key, this.size});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationsCubit, NotificationState>(
        listener: (context, state) {
      if (state is NotificationFetchSuccess) {
        log("length ${state.notifications.length}");
        log("value ${notificationCountValueNotifier.value}");
      }
    }, builder: (context, state) {
      return ValueListenableBuilder(
        valueListenable: notificationCountValueNotifier,
        builder: (context, value, child) => Container(
          height: size?.height ?? 40,
          width: size?.width ?? 30,
          alignment: Alignment.centerRight,
          child: state is NotificationFetchSuccess
              ? Stack(
                  fit: StackFit.expand,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(Routes.notifications);
                      },
                      child: const Icon(
                        Icons.notifications,
                        color: Colors.white,
                      ),
                    ),
                    Positioned(
                      top: size == null ? 0 : -5,
                      right: 0,
                      child: Container(
                        decoration:  BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        padding: const EdgeInsets.all(4),
                        child: Text(
                          state.notifications.length.toString() ==
                                  value.toString()
                              ? '0'
                              : "${value}",
                          //  "${state.notifications.length - int.parse(value.toString())}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                          ),
                        ),
                      ),
                    )
                  ],
                )
              : CircularProgressIndicator(
                  color: Colors.white,
                ),
        ),
      );
    });
  }
}
