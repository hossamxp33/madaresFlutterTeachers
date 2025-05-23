import 'package:madares_app_teacher/app/routes.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/labelKeys.dart';
import '../../../../core/utils/sharedWidgets/customAppbar.dart';
import '../../../../core/utils/sharedWidgets/customFloatingActionButton.dart';
import '../../../../core/utils/sharedWidgets/customRefreshIndicator.dart';
import '../../../../core/utils/uiUtils.dart';
import '../../../class/data/models/classSectionDetails.dart';
import '../../../lessons/data/models/lesson.dart';
import '../../../subject/data/models/subject.dart';
import '../../../topics/data/repositories/topicRepository.dart';
import '../../../topics/presentation/manager/topicsCubit.dart';
import '../../../topics/presentation/widgets/topicsContainer.dart';

class TopcisByLessonScreen extends StatefulWidget {
  final Lesson lesson;
  final Subject subject;
  final ClassSectionDetails classSectionDetails;

  const TopcisByLessonScreen({
    Key? key,
    required this.lesson,
    required this.classSectionDetails,
    required this.subject,
  }) : super(key: key);

  @override
  State<TopcisByLessonScreen> createState() => _TopcisByLessonScreenState();

  static Route<bool?> route(RouteSettings routeSettings) {
    final arguments = routeSettings.arguments as Map<String, dynamic>;
    return CupertinoPageRoute(
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider<TopicsCubit>(
            create: (_) => TopicsCubit(TopicRepository()),
          )
        ],
        child: TopcisByLessonScreen(
          classSectionDetails: arguments['classSectionDetails'],
          lesson: arguments['lesson'],
          subject: arguments['subject'],
        ),
      ),
    );
  }
}

class _TopcisByLessonScreenState extends State<TopcisByLessonScreen> {
  bool addedOrEditedAnyTopics = false;
  @override
  void initState() {
    fetchTopics();
    super.initState();
  }

  void fetchTopics() {
    Future.delayed(Duration.zero, () {
      context.read<TopicsCubit>().fetchTopics(lessonId: widget.lesson.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        Navigator.of(context).pop(addedOrEditedAnyTopics);
      },
      child: Scaffold(
        floatingActionButton: FloatingActionAddButton(
          onTap: () {
            Navigator.of(context).pushNamed<bool?>(
              Routes.addOrEditTopic,
              arguments: {
                "classSectionDetails": widget.classSectionDetails,
                "subject": widget.subject,
                "lesson": widget.lesson
              },
            ).then((value) {
              if (value != null && value) {
                addedOrEditedAnyTopics = true;
                fetchTopics();
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
                  fetchTopics();
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
                    TopicsContainer(
                      classSectionDetails: widget.classSectionDetails,
                      lesson: widget.lesson,
                      subject: widget.subject,
                    )
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: CustomAppBar(
                title: UiUtils.getTranslatedLabel(context, topicsKey),
                subTitle: widget.lesson.name,
                onPressBackButton: () {
                  Navigator.of(context).pop(addedOrEditedAnyTopics);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
