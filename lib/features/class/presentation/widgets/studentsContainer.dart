
import 'package:madares_app_teacher/core/utils/sharedWidgets/customShimmerContainer.dart';
import 'package:madares_app_teacher/core/utils/sharedWidgets/shimmerLoadingContainer.dart';
import 'package:madares_app_teacher/features/class/data/models/classSectionDetails.dart';
import 'package:madares_app_teacher/features/studentDetails/presentation/manager/studentsByClassSectionCubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/animationConfiguration.dart';
import '../../../../core/utils/labelKeys.dart';
import '../../../../core/utils/sharedWidgets/errorContainer.dart';
import '../../../../core/utils/sharedWidgets/noDataContainer.dart';
import '../../../../core/utils/sharedWidgets/studentTileContainer.dart';
import '../../../../core/utils/uiUtils.dart';

class StudentsContainer extends StatelessWidget {
  final ClassSectionDetails classSectionDetails;

  const StudentsContainer({Key? key, required this.classSectionDetails})
      : super(key: key);

  Widget _buildStudentShimmerLoadContainer() {
    return LayoutBuilder(
      builder: (context, boxConstraints) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Row(
            children: [
              ShimmerLoadingContainer(
                child: CustomShimmerContainer(
                  height: 50,
                  width: boxConstraints.maxWidth * (0.2),
                  borderRadius: 10,
                ),
              ),
              SizedBox(
                width: boxConstraints.maxWidth * (0.05),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerLoadingContainer(
                    child: CustomShimmerContainer(
                      width: boxConstraints.maxWidth * (0.5),
                      borderRadius: 10,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ShimmerLoadingContainer(
                    child: CustomShimmerContainer(
                      width: boxConstraints.maxWidth * (0.35),
                      borderRadius: 10,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentsByClassSectionCubit,
        StudentsByClassSectionState>(
      builder: (context, state) {
        if (state is StudentsByClassSectionFetchSuccess) {
          return state.students.isEmpty
              ? const NoDataContainer(titleKey: noStudentsInClassKey)
              : Column(
                  children: List.generate(
                    state.students.length,
                    (index) => Animate(
                      effects: listItemAppearanceEffects(
                          itemIndex: index,
                          totalLoadedItems: state.students.length),
                      child: StudentTileContainer(
                        student: state.students[index],
                      ),
                    ),
                  ),
                );
        }
        if (state is StudentsByClassSectionFetchFailure) {
          return ErrorContainer(
            errorMessageCode: state.errorMessage,
            onTapRetry: () {
              context.read<StudentsByClassSectionCubit>().fetchStudents(
                  classSectionId: classSectionDetails.id, subjectId: null);
            },
          );
        }

        return Column(
          children: List.generate(
            UiUtils.defaultShimmerLoadingContentCount,
            (index) => _buildStudentShimmerLoadContainer(),
          ).toList(),
        );
      },
    );
  }
}
