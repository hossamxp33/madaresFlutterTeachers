
import 'package:madares_app_teacher/core/utils/labelKeys.dart';
import 'package:madares_app_teacher/core/utils/sharedWidgets/customDropDownMenu.dart';
import 'package:madares_app_teacher/core/utils/sharedWidgets/defaultDropDownLabelContainer.dart';
import 'package:madares_app_teacher/features/subject/presentation/manager/subjectsOfClassSectionCubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClassSubjectsDropDownMenu extends StatelessWidget {
  final CustomDropDownItem currentSelectedItem;
  final Function(CustomDropDownItem) changeSelectedItem;

  final double width;
  const ClassSubjectsDropDownMenu({
    Key? key,
    required this.changeSelectedItem,
    required this.currentSelectedItem,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SubjectsOfClassSectionCubit,
        SubjectsOfClassSectionState>(
      listener: (context, state) {
        if (state is SubjectsOfClassSectionFetchSuccess) {
          if (state.subjects.isNotEmpty) {
            changeSelectedItem(
                CustomDropDownItem(index: 0, title: state.subjects.first.name));
          }
        }
      },
      builder: (context, state) {
        return state is SubjectsOfClassSectionFetchSuccess
            ? state.subjects.isEmpty
                ? DefaultDropDownLabelContainer(
                    titleLabelKey: noSubjectsKey,
                    width: width,
                  )
                : CustomDropDownMenu(
                    width: width,
                    onChanged: (result) {
                      if (result != null && result != currentSelectedItem) {
                        changeSelectedItem(result);
                      }
                    },
                    menu: state.subjects
                        .map((e) => e.subjectNameWithType)
                        .toList(),
                    currentSelectedItem: currentSelectedItem,
                  )
            : DefaultDropDownLabelContainer(
                titleLabelKey: fetchingSubjectsKey,
                width: width,
              );
      },
    );
  }
}
