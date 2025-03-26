import 'package:madares_app_teacher/app/routes.dart';
import 'package:madares_app_teacher/features/topics/presentation/widgets/topicsContainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/repositories/teacherRepository.dart';
import '../../../../core/utils/labelKeys.dart';
import '../../../../core/utils/sharedWidgets/classSubjectsDropDownMenu.dart';
import '../../../../core/utils/sharedWidgets/customAppbar.dart';
import '../../../../core/utils/sharedWidgets/customDropDownMenu.dart';
import '../../../../core/utils/sharedWidgets/customFloatingActionButton.dart';
import '../../../../core/utils/sharedWidgets/customRefreshIndicator.dart';
import '../../../../core/utils/sharedWidgets/defaultDropDownLabelContainer.dart';
import '../../../../core/utils/sharedWidgets/noDataContainer.dart';
import '../../../../core/utils/uiUtils.dart';
import '../../../class/presentation/manager/myClassesCubit.dart';
import '../../../class/presentation/widgets/myClassesDropDownMenu.dart';
import '../../../lessons/data/repositories/lessonRepository.dart';
import '../../../lessons/presentation/manager/lessonsCubit.dart';
import '../../../subject/presentation/manager/subjectsOfClassSectionCubit.dart';
import '../../data/repositories/topicRepository.dart';
import '../manager/topicsCubit.dart';

class TopicsScreen extends StatefulWidget {
  const TopicsScreen({
    Key? key,
  }) : super(key: key);

  static Route<dynamic> route(RouteSettings routeSettings) {
    return CupertinoPageRoute(
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => LessonsCubit(LessonRepository()),
          ),
          BlocProvider(
            create: (context) =>
                SubjectsOfClassSectionCubit(TeacherRepository()),
          ),
          BlocProvider(
            create: (context) => TopicsCubit(TopicRepository()),
          ),
        ],
        child: const TopicsScreen(),
      ),
    );
  }

  @override
  State<TopicsScreen> createState() => _TopicsScreenState();
}

class _TopicsScreenState extends State<TopicsScreen> {
  late CustomDropDownItem currentSelectedClassSection = CustomDropDownItem(
      index: 0,
      title: context.read<MyClassesCubit>().getClassSectionName().first);

  late CustomDropDownItem currentSelectedSubject = CustomDropDownItem(
      index: 0,
      title: UiUtils.getTranslatedLabel(context, fetchingSubjectsKey));

  late CustomDropDownItem currentSelectedLesson = CustomDropDownItem(
      index: 0, title: UiUtils.getTranslatedLabel(context, fetchingLessonsKey));

  @override
  void initState() {
    context.read<SubjectsOfClassSectionCubit>().fetchSubjects(
          context
              .read<MyClassesCubit>()
              .getClassSectionDetails(index: currentSelectedClassSection.index)
              .id,
        );
    super.initState();
  }

  Widget _buildClassSubjectAndLessonDropDowns() {
    return LayoutBuilder(
      builder: (context, boxConstraints) {
        return Column(
          children: [
            MyClassesDropDownMenu(
              currentSelectedItem: currentSelectedClassSection,
              width: boxConstraints.maxWidth,
              changeSelectedItem: (value) {
                currentSelectedClassSection = value;
                context.read<LessonsCubit>().updateState(LessonsInitial());
                context.read<TopicsCubit>().updateState(TopicsInitial());
                setState(() {});
              },
            ),
            ClassSubjectsDropDownMenu(
              changeSelectedItem: (result) {
                setState(() {
                  currentSelectedSubject = result;
                });
                final subjectId = context
                    .read<SubjectsOfClassSectionCubit>()
                    .getSubjectId(currentSelectedSubject.index);
                if (subjectId != -1) {
                  context.read<LessonsCubit>().fetchLessons(
                        classSectionId: context
                            .read<MyClassesCubit>()
                            .getClassSectionDetails(
                              index: currentSelectedClassSection.index,
                            )
                            .id,
                        subjectId: subjectId,
                      );

                  context.read<TopicsCubit>().updateState(TopicsInitial());
                }
              },
              currentSelectedItem: currentSelectedSubject,
              width: boxConstraints.maxWidth,
            ),
            //

            BlocListener<SubjectsOfClassSectionCubit,
                SubjectsOfClassSectionState>(
              listener: (context, state) {
                if (state is SubjectsOfClassSectionFetchSuccess) {
                  if (state.subjects.isEmpty) {
                    context
                        .read<LessonsCubit>()
                        .updateState(LessonsFetchSuccess([]));
                    context
                        .read<TopicsCubit>()
                        .updateState(TopicsFetchSuccess([]));
                  }
                }
              },
              child: BlocConsumer<LessonsCubit, LessonsState>(
                builder: (context, state) {
                  return state is LessonsFetchSuccess
                      ? state.lessons.isEmpty
                          ? DefaultDropDownLabelContainer(
                              titleLabelKey: noLessonsKey,
                              width: boxConstraints.maxWidth,
                            )
                          : CustomDropDownMenu(
                              width: boxConstraints.maxWidth,
                              onChanged: (value) {
                                if (value != null &&
                                    value != currentSelectedLesson) {
                                  currentSelectedLesson = value;
                                  setState(() {});
                                  context.read<TopicsCubit>().fetchTopics(
                                        lessonId: context
                                            .read<LessonsCubit>()
                                            .getLesson(
                                                currentSelectedLesson.index)
                                            .id,
                                      );
                                }
                              },
                              menu: state.lessons.map((e) => e.name).toList(),
                              currentSelectedItem: currentSelectedLesson,
                            )
                      : DefaultDropDownLabelContainer(
                          titleLabelKey: fetchingLessonsKey,
                          width: boxConstraints.maxWidth,
                        );
                },
                listener: (context, state) {
                  if (state is LessonsFetchSuccess) {
                    if (state.lessons.isNotEmpty) {
                      setState(() {
                        currentSelectedLesson = CustomDropDownItem(
                            index: 0, title: state.lessons.first.name);
                      });
                      context.read<TopicsCubit>().fetchTopics(
                            lessonId: context
                                .read<LessonsCubit>()
                                .getLesson(currentSelectedLesson.index)
                                .id,
                          );
                    }
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionAddButton(
        onTap: () {
          Navigator.of(context)
              .pushNamed<bool?>(Routes.addOrEditTopic)
              .then((value) {
            if (value != null && value) {
              final lessonsState = context.read<LessonsCubit>().state;
              if (lessonsState is LessonsFetchSuccess &&
                  lessonsState.lessons.isNotEmpty) {
                context.read<TopicsCubit>().fetchTopics(
                      lessonId: context
                          .read<LessonsCubit>()
                          .getLesson(currentSelectedLesson.index)
                          .id,
                    );
              }
            }
          });
        },
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: CustomRefreshIndicator(
              onRefreshCallback: () {
                context.read<TopicsCubit>().fetchTopics(
                      lessonId: context
                          .read<LessonsCubit>()
                          .getLesson(currentSelectedLesson.index)
                          .id,
                    );
              },
              displacment: UiUtils.getScrollViewTopPadding(
                context: context,
                appBarHeightPercentage: UiUtils.appBarSmallerHeightPercentage,
              ),
              child: ListView(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width *
                      UiUtils.screenContentHorizontalPaddingPercentage,
                  right: MediaQuery.of(context).size.width *
                      UiUtils.screenContentHorizontalPaddingPercentage,
                  top: UiUtils.getScrollViewTopPadding(
                    context: context,
                    appBarHeightPercentage:
                        UiUtils.appBarSmallerHeightPercentage,
                  ),
                ),
                children: [
                  //
                  _buildClassSubjectAndLessonDropDowns(),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * (0.0125),
                  ),

                  BlocBuilder<LessonsCubit, LessonsState>(
                    builder: (context, state) {
                      if (state is LessonsFetchSuccess &&
                          state.lessons.isEmpty) {
                        return const NoDataContainer(titleKey: noTopicsKey);
                      }
                      return TopicsContainer(
                        classSectionDetails: context
                            .read<MyClassesCubit>()
                            .getClassSectionDetails(
                              index: currentSelectedClassSection.index,
                            ),
                        subject: context
                            .read<SubjectsOfClassSectionCubit>()
                            .getSubjectDetails(currentSelectedSubject.index),
                        lesson: context.read<LessonsCubit>().getLesson(
                              currentSelectedLesson.index,
                            ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: CustomAppBar(
              title: UiUtils.getTranslatedLabel(context, topicsKey),
            ),
          ),
        ],
      ),
    );
  }
}
