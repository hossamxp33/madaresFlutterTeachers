
import 'package:madares_app_teacher/core/utils/sharedWidgets/customDropDownMenu.dart';
import 'package:madares_app_teacher/features/class/presentation/manager/myClassesCubit.dart';
import 'package:madares_app_teacher/features/subject/presentation/manager/subjectsOfClassSectionCubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyClassesDropDownMenu extends StatelessWidget {
  final CustomDropDownItem currentSelectedItem;
  final Function(CustomDropDownItem) changeSelectedItem;
  final double width;

  const MyClassesDropDownMenu({
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
      menu: context.read<MyClassesCubit>().getClassSectionName(),
      currentSelectedItem: currentSelectedItem,
    );
  }
}
