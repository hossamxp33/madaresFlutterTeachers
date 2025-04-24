import 'package:madares_app_teacher/app/routes.dart';
import 'package:madares_app_teacher/core/utils/animationConfiguration.dart';
import 'package:madares_app_teacher/core/utils/sharedWidgets/noDataContainer.dart';
import 'package:madares_app_teacher/features/assignment/data/models/assignment.dart';
import 'package:madares_app_teacher/features/assignment/data/repositories/assignmentRepository.dart';
import 'package:madares_app_teacher/features/assignment/presentation/manager/assignmentCubit.dart';
import 'package:madares_app_teacher/features/assignment/presentation/manager/deleteassignmentcubit.dart';
import 'package:madares_app_teacher/features/assignments/presentation/widgets/assignmentDetailsBottomsheetContainer.dart';
import 'package:madares_app_teacher/features/class/data/models/classSectionDetails.dart';
import 'package:madares_app_teacher/features/subject/data/models/subject.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
// ignore: depend_on_referenced_packages

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/labelKeys.dart';
import '../../../../core/utils/sharedWidgets/confirmDeleteDialog.dart';
import '../../../../core/utils/sharedWidgets/customShimmerContainer.dart';
import '../../../../core/utils/sharedWidgets/deleteButton.dart';
import '../../../../core/utils/sharedWidgets/editButton.dart';
import '../../../../core/utils/sharedWidgets/errorContainer.dart';
import '../../../../core/utils/sharedWidgets/shimmerLoadingContainer.dart';
import '../../../../core/utils/uiUtils.dart';

class AssignmentsContainer extends StatelessWidget {
  final ClassSectionDetails classSectionDetails;
  final Subject subject;

  const AssignmentsContainer({
    Key? key,
    required this.classSectionDetails,
    required this.subject,
  }) : super(key: key);

  void showAssignmentBottomSheet({
    required BuildContext context,
    required Assignment assignment,
  }) {
    UiUtils.showBottomSheet(
      enableDrag: true,
      child: AssignmentDetailsBottomsheetContainer(assignment: assignment),
      context: context,
    );
  }

  Widget asignmentListtile(Assignment assignment) {
    return BlocProvider<DeleteAssignmentCubit>(
      create: (context) => DeleteAssignmentCubit(AssignmentRepository(),),
      child: Builder(
        builder: (context) {
          return BlocConsumer<DeleteAssignmentCubit, DeleteAssignmentState>(
            listener: (context, state) {
              if (state is DeleteAssignmentFetchSuccess) {
                context.read<AssignmentCubit>().deleteAssignment(assignment.id);
              } else if (state is DeleteAssignmentFetchFailure) {
                UiUtils.showBottomToastOverlay(
                  context: context,
                  errorMessage: UiUtils.getTranslatedLabel(
                      context, unableToDeleteAssignmentKey),
                  backgroundColor: Theme.of(context).colorScheme.error,
                );
              }
            },
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: GestureDetector(
                  onTap: () {
                    if (state is DeleteAssignmentFetchInProgress) {
                      return;
                    }
                    showAssignmentBottomSheet(
                      context: context,
                      assignment: assignment,
                    );
                  },
                  child: Opacity(
                    opacity:
                        state is DeleteAssignmentFetchInProgress ? 0.5 : 1.0,
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.secondary.withOpacity(0.05),
                            offset: const Offset(2.5, 2.5),
                            blurRadius: 10,
                          )
                        ],
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: MediaQuery.of(context).size.width * (0.85),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 17.5,
                        vertical: 17.5,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  assignment.subject.name.toString(),
                                  maxLines: 5,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),
                              EditButton(
                                onTap: () {
                                  Navigator.of(context).pushNamed<bool?>(
                                    Routes.addAssignment,
                                    arguments: {
                                      "editAssignment": true,
                                      "assignment": assignment,
                                    },
                                  ).then((value) {
                                    if (value != null && value) {
                                      context
                                          .read<AssignmentCubit>()
                                          .fetchassignment(
                                            classSectionId:
                                                assignment.classSectionId,
                                            subjectId: assignment.subjectId,
                                          );
                                    }
                                  });
                                },
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              DeleteButton(
                                onTap: () {
                                  if (state
                                      is DeleteAssignmentFetchInProgress) {
                                    return;
                                  }
                                  showDialog<bool>(
                                    context: context,
                                    builder: (_) => const ConfirmDeleteDialog(),
                                  ).then((value) {
                                    if (value != null && value) {
                                      context
                                          .read<DeleteAssignmentCubit>()
                                          .deleteAssignment(
                                            assignmentId: assignment.id,
                                          );
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            "${UiUtils.getTranslatedLabel(context, dueDateKey)}: ${UiUtils.formatDateAndTime(assignment.dueDate)}",
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onBackground
                                  .withOpacity(0.6),
                              fontWeight: FontWeight.w400,
                              fontSize: 11.0,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                Routes.assignment,
                                arguments: {"assignment": assignment},
                              );
                            },
                            child: Text(
                              "${UiUtils.getTranslatedLabel(context, viewKey)}  واجبات الطالب ",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildInformationShimmerLoadingContainer({
    required BuildContext context,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        width: MediaQuery.of(context).size.width * (0.85),
        child: LayoutBuilder(
          builder: (context, boxConstraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerLoadingContainer(
                  child: CustomShimmerContainer(
                    margin: EdgeInsetsDirectional.only(
                      end: boxConstraints.maxWidth * (0.7),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                ShimmerLoadingContainer(
                  child: CustomShimmerContainer(
                    margin: EdgeInsetsDirectional.only(
                      end: boxConstraints.maxWidth * (0.5),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                ShimmerLoadingContainer(
                  child: CustomShimmerContainer(
                    margin: EdgeInsetsDirectional.only(
                      end: boxConstraints.maxWidth * (0.7),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                ShimmerLoadingContainer(
                  child: CustomShimmerContainer(
                    margin: EdgeInsetsDirectional.only(
                      end: boxConstraints.maxWidth * (0.5),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AssignmentCubit, AssignmentState>(
      bloc: context.read<AssignmentCubit>(),
      builder: (context, state) {
        if (state is AssignmentsFetchSuccess) {
          return state.assignment.isEmpty
              ? const NoDataContainer(titleKey: noAssignmentsKey)
              : Column(
                  children: state.assignment
                      .map(
                        (assignment) => Animate(
                          effects: customItemFadeAppearanceEffects(),
                          child: asignmentListtile(assignment),
                        ),
                      )
                      .toList(),
                );
        }
        if (state is AssignmentFetchFailure) {
          return Center(
            child: ErrorContainer(
              errorMessageCode: state.errorMessage,
              onTapRetry: () {
                context.read<AssignmentCubit>().fetchassignment(
                      classSectionId: classSectionDetails.id,
                      subjectId: subject.id,
                    );
              },
            ),
          );
        }
        return Column(
          children: List.generate(5, (index) {
            return _buildInformationShimmerLoadingContainer(context: context);
          }),
        );
      },
    );
  }
}
