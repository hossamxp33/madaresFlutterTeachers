import 'package:madares_app_teacher/app/routes.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/styles/colors.dart';
import '../../../home/presentation/pages/homeScreen.dart';

class NotificationIconWidget extends StatelessWidget {
  final Size? size;
  const NotificationIconWidget({super.key, this.size});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: notificationCountValueNotifier,
      builder: (context, value, child) => Container(
        height: size?.height ?? 40,
        width: size?.width ?? 30,
        alignment: Alignment.centerRight,
        child: Stack(
          fit: StackFit.expand,
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(Routes.notifications);
              },
              child: const Icon(
                Icons.notifications,
                color: Colors.white,
                size: 24,
              ),
            ),
            if (value > 0)
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
                    value > 9 ? "9+" : value.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
