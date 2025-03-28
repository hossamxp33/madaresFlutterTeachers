import 'package:madares_app_teacher/app/routes.dart';
import 'package:madares_app_teacher/core/utils/animationConfiguration.dart';
import 'package:madares_app_teacher/core/utils/sharedWidgets/errorContainer.dart';
import 'package:madares_app_teacher/features/class/data/models/classSectionDetails.dart';
import 'package:madares_app_teacher/features/class/presentation/widgets/subjectImageContainer.dart';
import 'package:madares_app_teacher/features/subject/data/models/subject.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/labelKeys.dart';
import '../../../../core/utils/sharedWidgets/customShimmerContainer.dart';
import '../../../../core/utils/sharedWidgets/internetListenerWidget.dart';
import '../../../../core/utils/sharedWidgets/noDataContainer.dart';
import '../../../../core/utils/sharedWidgets/shimmerLoadingContainer.dart';
import '../../../../core/utils/uiUtils.dart';
import '../../../subject/presentation/manager/subjectsOfClassSectionCubit.dart';

class SubjectsContainer extends StatelessWidget {
  final ClassSectionDetails classSectionDetails;

  const SubjectsContainer({Key? key, required this.classSectionDetails})
      : super(key: key);

  Widget _buildSubjectContainer({
    required Subject subject,
    required BuildContext context,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          Navigator.of(context).pushNamed(
            Routes.subject,
            arguments: {
              "subject": subject,
              "classSectionDetails": classSectionDetails
            },
          );
        },
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color:
                    Theme.of(context).colorScheme.secondary.withOpacity(0.05),
                offset: const Offset(2.5, 2.5),
                blurRadius: 10,
              )
            ],
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(10),
          ),
          height: 80,
          width: MediaQuery.of(context).size.width * (0.85),
          padding: const EdgeInsets.symmetric(horizontal: 12.5, vertical: 10.0),
          child: LayoutBuilder(
            builder: (context, boxConstraints) {
              return Row(
                children: [
                  SubjectImageContainer(
                    showShadow: false,
                    height: 60,
                    radius: 7.5,
                    subject: subject,
                    width: boxConstraints.maxWidth * (0.2),
                  ),
                  SizedBox(
                    width: boxConstraints.maxWidth * (0.05),
                  ),
                  Expanded(
                    child: Text(
                      subject.showType
                          ? subject.subjectNameWithType
                          : subject.name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.0,
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSubjectShimmerLoading(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      width: MediaQuery.of(context).size.width * (0.85),
      child: LayoutBuilder(
        builder: (context, boxConstraints) {
          return Row(
            children: [
              ShimmerLoadingContainer(
                child: CustomShimmerContainer(
                  margin: const EdgeInsetsDirectional.only(start: 10),
                  height: 60,
                  width: boxConstraints.maxWidth * (0.2),
                ),
              ),
              ShimmerLoadingContainer(
                child: CustomShimmerContainer(
                  margin: const EdgeInsetsDirectional.only(start: 20),
                  width: boxConstraints.maxWidth * (0.3),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InternetListenerWidget(
      onInternetConnectionBack: () {
        if (context.read<SubjectsOfClassSectionCubit>().state
            is SubjectsOfClassSectionFetchFailure) {
          context
              .read<SubjectsOfClassSectionCubit>()
              .fetchSubjects(classSectionDetails.id);
        }
      },
      child:
          BlocBuilder<SubjectsOfClassSectionCubit, SubjectsOfClassSectionState>(
        builder: (context, state) {
          if (state is SubjectsOfClassSectionFetchSuccess) {
            return state.subjects.isEmpty
                ? const NoDataContainer(titleKey: noSubjectsInClassKey)
                : Column(
                    children: List.generate(
                      state.subjects.length,
                      (index) => Animate(
                        effects: listItemAppearanceEffects(
                            itemIndex: index,
                            totalLoadedItems: state.subjects.length),
                        child: _buildSubjectContainer(
                          subject: state.subjects[index],
                          context: context,
                        ),
                      ),
                    ),
                  );
          }
          if (state is SubjectsOfClassSectionFetchFailure) {
            return Center(
              child: ErrorContainer(
                errorMessageCode: state.errorMessage,
                onTapRetry: () {
                  context
                      .read<SubjectsOfClassSectionCubit>()
                      .fetchSubjects(classSectionDetails.id);
                },
              ),
            );
          }

          return Column(
            children: List.generate(
              UiUtils.defaultShimmerLoadingContentCount,
              (index) => index,
            ).map((e) => _buildSubjectShimmerLoading(context)).toList(),
          );
        },
      ),
    );
  }
}
