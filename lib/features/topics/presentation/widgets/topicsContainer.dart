import 'package:madares_app_teacher/app/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/animationConfiguration.dart';
import '../../../../core/utils/labelKeys.dart';
import '../../../../core/utils/sharedWidgets/attachmentsBottomsheetContainer.dart';
import '../../../../core/utils/sharedWidgets/confirmDeleteDialog.dart';
import '../../../../core/utils/sharedWidgets/customShimmerContainer.dart';
import '../../../../core/utils/sharedWidgets/deleteButton.dart';
import '../../../../core/utils/sharedWidgets/editButton.dart';
import '../../../../core/utils/sharedWidgets/errorContainer.dart';
import '../../../../core/utils/sharedWidgets/noDataContainer.dart';
import '../../../../core/utils/sharedWidgets/shimmerLoadingContainer.dart';
import '../../../../core/utils/styles/colors.dart';
import '../../../../core/utils/uiUtils.dart';
import '../../../class/data/models/classSectionDetails.dart';
import '../../../lessons/data/models/lesson.dart';
import '../../../subject/data/models/subject.dart';
import '../../data/models/topic.dart';
import '../../data/repositories/topicRepository.dart';
import '../manager/deleteTopicCubit.dart';
import '../manager/topicsCubit.dart';

class TopicsContainer extends StatelessWidget {
  final Subject subject;
  final Lesson lesson;
  final ClassSectionDetails classSectionDetails;
  const TopicsContainer({
    Key? key,
    required this.classSectionDetails,
    required this.lesson,
    required this.subject,
  }) : super(key: key);

  Widget _buildTopicDetailsShimmerContainer(BuildContext context) {
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

  Widget _buildTopicDetailsContainer({
    required Topic topic,
    required BuildContext context,
  }) {
    return BlocProvider<DeleteTopicCubit>(
      create: (context) => DeleteTopicCubit(TopicRepository()),
      child: Builder(
        builder: (context) {
          return BlocConsumer<DeleteTopicCubit, DeleteTopicState>(
            listener: (context, state) {
              if (state is DeleteTopicSuccess) {
                context.read<TopicsCubit>().deleteTopic(topic.id);
              } else if (state is DeleteTopicFailure) {
                UiUtils.showBottomToastOverlay(
                  context: context,
                  errorMessage:
                      "${UiUtils.getTranslatedLabel(context, unableToDeleteTopicKey)} ${topic.name}",
                  backgroundColor: Theme.of(context).colorScheme.error,
                );
              }
            },
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Opacity(
                  opacity: state is DeleteTopicInProgress ? 0.5 : 1.0,
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
                              UiUtils.getTranslatedLabel(context, topicNameKey),
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
                                if (state is DeleteTopicInProgress) {
                                  return;
                                }
                                Navigator.of(context).pushNamed<bool?>(
                                  Routes.addOrEditTopic,
                                  arguments: {
                                    "classSectionDetails": classSectionDetails,
                                    "subject": subject,
                                    "lesson": lesson,
                                    "topic": topic
                                  },
                                ).then((value) {
                                  if (value != null && value) {
                                    context
                                        .read<TopicsCubit>()
                                        .fetchTopics(lessonId: lesson.id);
                                  }
                                });
                              },
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            DeleteButton(
                              onTap: () {
                                if (state is DeleteTopicInProgress) {
                                  return;
                                }
                                showDialog<bool>(
                                  context: context,
                                  builder: (_) => const ConfirmDeleteDialog(),
                                ).then((value) {
                                  if (value != null && value) {
                                    context
                                        .read<DeleteTopicCubit>()
                                        .deleteTopic(topicId: topic.id);
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
                          topic.name,
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
                            topicDescriptionKey,
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
                          topic.description,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.w600,
                            fontSize: 14.0,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        topic.studyMaterials.isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: GestureDetector(
                                  onTap: () {
                                    UiUtils.showBottomSheet(
                                      child: AttachmentBottomsheetContainer(
                                        fromAnnouncementsContainer: false,
                                        studyMaterials: topic.studyMaterials,
                                      ),
                                      context: context,
                                    );
                                  },
                                  child: Text(
                                    "${topic.studyMaterials.length} ${UiUtils.getTranslatedLabel(context, attachmentsKey)}",
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
    return BlocBuilder<TopicsCubit, TopicsState>(
      builder: (context, state) {
        if (state is TopicsFetchSuccess) {
          return state.topics.isEmpty
              ? const NoDataContainer(titleKey: noTopicsKey)
              : Column(
                  children: state.topics
                      .map(
                        (topic) => Animate(
                          effects: customItemFadeAppearanceEffects(),
                          child: _buildTopicDetailsContainer(
                            topic: topic,
                            context: context,
                          ),
                        ),
                      )
                      .toList(),
                );
        }
        if (state is TopicsFetchFailure) {
          return Center(
            child: ErrorContainer(
              errorMessageCode: state.errorMessage,
              onTapRetry: () {
                context.read<TopicsCubit>().fetchTopics(lessonId: lesson.id);
              },
            ),
          );
        }
        return Column(
          children: List.generate(
            UiUtils.defaultShimmerLoadingContentCount,
            (index) => index,
          ).map((e) => _buildTopicDetailsShimmerContainer(context)).toList(),
        );
      },
    );
  }
}
