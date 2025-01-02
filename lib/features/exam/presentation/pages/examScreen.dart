
import 'package:madares_app_teacher/core/utils/sharedWidgets/customAppbar.dart';
import 'package:madares_app_teacher/core/utils/uiUtils.dart';
import 'package:madares_app_teacher/features/exam/presentation/manager/examCubit.dart';
import 'package:madares_app_teacher/features/exam/presentation/widgets/examListContainer.dart';
import 'package:madares_app_teacher/features/studentDetails/data/repositories/studentRepository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/labelKeys.dart';

class ExamScreen extends StatelessWidget {
  const ExamScreen({
    Key? key,
  }) : super(key: key);

  static Route route(RouteSettings routeSettings) {
    return CupertinoPageRoute(
      builder: (_) => BlocProvider<ExamDetailsCubit>(
        create: (context) => ExamDetailsCubit(StudentRepository()),
        child: const ExamScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const ExamListContainer(),
          Align(
            alignment: Alignment.topCenter,
            child: CustomAppBar(
              title: UiUtils.getTranslatedLabel(context, examsKey),
              showBackButton: true,
              onPressBackButton: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
