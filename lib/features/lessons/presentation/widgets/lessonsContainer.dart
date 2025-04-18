import 'package:madares_app_teacher/app/routes.dart';
import 'package:madares_app_teacher/core/utils/labelKeys.dart';
import 'package:madares_app_teacher/core/utils/sharedWidgets/attachmentsBottomsheetContainer.dart';
import 'package:madares_app_teacher/core/utils/sharedWidgets/confirmDeleteDialog.dart';
import 'package:madares_app_teacher/core/utils/sharedWidgets/customShimmerContainer.dart';
import 'package:madares_app_teacher/core/utils/sharedWidgets/deleteButton.dart';
import 'package:madares_app_teacher/core/utils/sharedWidgets/editButton.dart';
import 'package:madares_app_teacher/core/utils/sharedWidgets/shimmerLoadingContainer.dart';
import 'package:madares_app_teacher/core/utils/uiUtils.dart';
import 'package:madares_app_teacher/features/class/data/models/classSectionDetails.dart';
import 'package:madares_app_teacher/features/lessons/data/models/lesson.dart';
import 'package:madares_app_teacher/features/lessons/data/repositories/lessonRepository.dart';
import 'package:madares_app_teacher/features/lessons/presentation/manager/lessonDeleteCubit.dart';
import 'package:madares_app_teacher/features/lessons/presentation/manager/lessonsCubit.dart';
import 'package:madares_app_teacher/features/subject/data/models/subject.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/animationConfiguration.dart';
import '../../../../core/utils/sharedWidgets/errorContainer.dart';
import '../../../../core/utils/sharedWidgets/noDataContainer.dart';
import '../../../../core/utils/styles/colors.dart';

class LessonsContainer extends StatelessWidget {
  final ClassSectionDetails classSectionDetails;
  final Subject subject;

  const LessonsContainer({
    Key? key,
    required this.classSectionDetails,
    required this.subject,
  }) : super(key: key);

  Widget _buildLessonDetailsShimmerContainer(BuildContext context) {
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

  Widget _buildLessonDetailsContainer({
    required Lesson lesson,
    required BuildContext context,
  }) {
    return BlocProvider<LessonDeleteCubit>(
      create: (context) => LessonDeleteCubit(LessonRepository()),
      child: Builder(
        builder: (context) {
          return BlocConsumer<LessonDeleteCubit, LessonDeleteState>(
            listener: (context, state) {
              if (state is LessonDeleteSuccess) {
                context.read<LessonsCubit>().deleteLesson(lesson.id);
              } else if (state is LessonDeleteFailure) {
                UiUtils.showBottomToastOverlay(
                  context: context,
                  errorMessage:
                      "${UiUtils.getTranslatedLabel(context, unableToDeleteLessonKey)} ${lesson.name}",
                  backgroundColor: Theme.of(context).colorScheme.error,
                );
              }
            },
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Opacity(
                  opacity: state is LessonDeleteInProgress ? 0.5 : 1.0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 15.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    width: MediaQuery.of(context).size.width * (0.85),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              UiUtils.getTranslatedLabel(
                                context,
                                chapterNameKey,
                              ),
                              style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                                fontWeight: FontWeight.w400,
                                fontSize: 12.0,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            const Spacer(),
                            EditButton(
                              onTap: () {
                                if (state is LessonDeleteInProgress) {
                                  return;
                                }
                                Navigator.of(context).pushNamed<bool?>(
                                  Routes.addOrEditLesson,
                                  arguments: {
                                    "lesson": lesson,
                                    "subject": subject,
                                    "classSectionDetails": classSectionDetails
                                  },
                                ).then((value) {
                                  if (value != null && value) {
                                    context.read<LessonsCubit>().fetchLessons(
                                          classSectionId:
                                              classSectionDetails.id,
                                          subjectId: subject.id,
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
                                if (state is LessonDeleteInProgress) {
                                  return;
                                }
                                showDialog<bool>(
                                  context: context,
                                  builder: (_) => const ConfirmDeleteDialog(),
                                ).then((value) {
                                  if (value != null && value) {
                                    context
                                        .read<LessonDeleteCubit>()
                                        .deleteLesson(lesson.id);
                                  }
                                });
                              },
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 2.5,
                        ),
                        Text(
                          lesson.name,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.w600,
                            fontSize: 14.0,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          UiUtils.getTranslatedLabel(
                            context,
                            chapterDescriptionKey,
                          ),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontWeight: FontWeight.w400,
                            fontSize: 12.0,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(
                          height: 2.5,
                        ),
                        Text(
                          lesson.description,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.w600,
                            fontSize: 14.0,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        lesson.studyMaterials.isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: GestureDetector(
                                  onTap: () {
                                    UiUtils.showBottomSheet(
                                      child: AttachmentBottomsheetContainer(
                                        fromAnnouncementsContainer: false,
                                        studyMaterials: lesson.studyMaterials,
                                      ),
                                      context: context,
                                    );
                                  },
                                  child: Text(
                                    "${lesson.studyMaterials.length} ${UiUtils.getTranslatedLabel(context, attachmentsKey)}",
                                    style:  TextStyle(
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox(),
                        lesson.topicsCount != 0
                            ? Padding(
                                padding: const EdgeInsets.only(top: 2.50),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushNamed<bool?>(
                                      Routes.topicsByLesson,
                                      arguments: {
                                        "classSectionDetails":
                                            classSectionDetails,
                                        "subject": subject,
                                        "lesson": lesson
                                      },
                                    ).then((value) {
                                      if (value != null && value) {
                                        context
                                            .read<LessonsCubit>()
                                            .fetchLessons(
                                              classSectionId:
                                                  classSectionDetails.id,
                                              subjectId: subject.id,
                                            );
                                      }
                                    });
                                  },
                                  child: Text(
                                    "${lesson.topicsCount} ${UiUtils.getTranslatedLabel(context, lesson.topicsCount == 1 ? topicKey : topicsKey)}",
                                    style:  TextStyle(
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox(),
                      ],
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LessonsCubit, LessonsState>(
      builder: (context, state) {
        if (state is LessonsFetchSuccess) {
          return state.lessons.isEmpty
              ? const NoDataContainer(titleKey: noLessonsKey)
              : Column(
                  children: state.lessons
                      .map(
                        (lesson) => Animate(
                          effects: customItemFadeAppearanceEffects(),
                          child: _buildLessonDetailsContainer(
                            lesson: lesson,
                            context: context,
                          ),
                        ),
                      )
                      .toList(),
                );
        }
        if (state is LessonsFetchFailure) {
          return Center(
            child: ErrorContainer(
              errorMessageCode: state.errorMessage,
              onTapRetry: () {
                context.read<LessonsCubit>().fetchLessons(
                      classSectionId: classSectionDetails.id,
                      subjectId: subject.id,
                    );
              },
            ),
          );
        }
        return Column(
          children: List.generate(
            UiUtils.defaultShimmerLoadingContentCount,
            (index) => index,
          ).map((e) => _buildLessonDetailsShimmerContainer(context)).toList(),
        );
      },
    );
  }
}
