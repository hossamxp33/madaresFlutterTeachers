
import 'package:madares_app_teacher/core/utils/sharedWidgets/customDropDownMenu.dart';
import 'package:madares_app_teacher/features/class/presentation/manager/myClassesCubit.dart';
import 'package:madares_app_teacher/features/exam/presentation/manager/examCubit.dart';
import 'package:madares_app_teacher/features/subject/presentation/manager/subjectsOfClassSectionCubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyExamsDropDownMenu extends StatelessWidget {
  final CustomDropDownItem currentSelectedItem;
  final Function(CustomDropDownItem) changeSelectedItem;
  final double width;

  const MyExamsDropDownMenu({
    Key? key,
    required this.currentSelectedItem,
    required this.width,
    required this.changeSelectedItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomDropDownMenu(
      width: width,
      onChanged: (result) {
        if (result != null && result != currentSelectedItem) {
          changeSelectedItem(result);
          //
          context.read<SubjectsOfClassSectionCubit>().fetchSubjects(
                context
                    .read<MyClassesCubit>()
                    .getClassSectionDetails(index: result.index)
                    .id,
              );
        }
      },
      menu: context.read<ExamDetailsCubit>().getExamName(),
      currentSelectedItem: currentSelectedItem,
    );
  }
}
