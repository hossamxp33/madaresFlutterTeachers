
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/labelKeys.dart';
import '../../../../core/utils/sharedWidgets/customAppbar.dart';
import '../../../../core/utils/uiUtils.dart';
import '../../../exam/presentation/manager/examCubit.dart';
import '../../../studentDetails/data/repositories/studentRepository.dart';
import '../../../studentDetails/presentation/manager/studentCompletedExamWithResultCubit.dart';
import '../widgets/resultsContainer.dart';

class ResultListScreen extends StatelessWidget {
  final int? studentId;
  final String? studentName;
  final String? className;
  final int classSectionId;

  const ResultListScreen(
      {Key? key,
      this.studentId,
      this.studentName,
      this.className,
      required this.classSectionId})
      : super(key: key);

  static Route route(RouteSettings routeSettings) {
    final studentData = routeSettings.arguments as Map<String, dynamic>;
    return CupertinoPageRoute(
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider<ExamDetailsCubit>(
            create: (context) => ExamDetailsCubit(StudentRepository()),
          ),
          BlocProvider<StudentCompletedExamWithResultCubit>(
            create: (context) => StudentCompletedExamWithResultCubit(
              StudentRepository(),
            ),
          ),
        ],
        child: ResultListScreen(
          studentId: studentData['studentId'],
          studentName: studentData['studentName'],
          className: studentData['className'],
          classSectionId: studentData['classSectionId'],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ResultsContainer(
            studentId: studentId,
            studentName: studentName,
            className: className,
            classSectionId: classSectionId,
          ),
          Align(
            alignment: Alignment.topCenter,
            child: CustomAppBar(
              title: UiUtils.getTranslatedLabel(context, resultKey),
              subTitle: studentName,
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
