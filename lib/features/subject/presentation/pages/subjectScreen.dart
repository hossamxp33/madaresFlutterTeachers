<<<<<<< HEAD
import 'package:eschool_teacher/app/routes.dart';
=======
import 'package:madares_app_teacher/app/routes.dart';
>>>>>>> f8116bb26ff7cdb9462a79241b86162b4f4e9bdc
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/labelKeys.dart';
import '../../../../core/utils/sharedWidgets/appBarSubTitleContainer.dart';
import '../../../../core/utils/sharedWidgets/appBarTitleContainer.dart';
import '../../../../core/utils/sharedWidgets/customFloatingActionButton.dart';
import '../../../../core/utils/sharedWidgets/customRefreshIndicator.dart';
import '../../../../core/utils/sharedWidgets/customTabBarContainer.dart';
import '../../../../core/utils/sharedWidgets/screenTopBackgroundContainer.dart';
import '../../../../core/utils/sharedWidgets/svgButton.dart';
import '../../../../core/utils/sharedWidgets/tabBarBackgroundContainer.dart';
import '../../../../core/utils/uiUtils.dart';
import '../../../announcements/data/repositories/announcementRepository.dart';
import '../../../announcements/presentation/manager/announcementsCubit.dart';
import '../../../announcements/presentation/widgets/announcementsContainer.dart';
import '../../../class/data/models/classSectionDetails.dart';
import '../../../lessons/data/repositories/lessonRepository.dart';
import '../../../lessons/presentation/manager/lessonsCubit.dart';
import '../../../lessons/presentation/widgets/lessonsContainer.dart';
import '../../data/models/subject.dart';

class SubjectScreen extends StatefulWidget {
  final Subject subject;
  final ClassSectionDetails classSectionDetails;

  const SubjectScreen({
    Key? key,
    required this.subject,
    required this.classSectionDetails,
  }) : super(key: key);

  @override
  State<SubjectScreen> createState() => _SubjectScreenState();

  static Route<dynamic> route(RouteSettings routeSettings) {
    final arguments = routeSettings.arguments as Map<String, dynamic>;
    return CupertinoPageRoute(
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => LessonsCubit(LessonRepository()),
          ),
          BlocProvider(
            create: (context) => AnnouncementsCubit(AnnouncementRepository()),
          ),
        ],
        child: SubjectScreen(
          classSectionDetails: arguments['classSectionDetails'],
          subject: arguments['subject'],
        ),
      ),
    );
  }
}

class _SubjectScreenState extends State<SubjectScreen> {
  late String _selectedTabTitle = chaptersKey;

  late final ScrollController _scrollController = ScrollController()
    ..addListener(_announcementsScrollListener);

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      context.read<LessonsCubit>().fetchLessons(
            classSectionId: widget.classSectionDetails.id,
            subjectId: widget.subject.id,
          );
      context.read<AnnouncementsCubit>().fetchAnnouncements(
            classSectionId: widget.classSectionDetails.id,
            subjectId: widget.subject.id,
          );
    });
  }

  void _announcementsScrollListener() {
    if (_scrollController.offset ==
        _scrollController.position.maxScrollExtent) {
      if (context.read<AnnouncementsCubit>().hasMore()) {
        context.read<AnnouncementsCubit>().fetchMoreAnnouncements(
              subjectId: widget.subject.id,
              classSectionId: widget.classSectionDetails
                  .id, //widget.classSectionDetails.classTeacherId
            );
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_announcementsScrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _onTapFloatingActionAddButton() {
    Navigator.of(context)
        .pushNamed(
      _selectedTabTitle == chaptersKey
          ? Routes.addOrEditLesson
          : Routes.addOrEditAnnouncement,
      arguments: _selectedTabTitle == chaptersKey
          ? {
              "subject": widget.subject,
              "classSectionDetails": widget.classSectionDetails
            }
          : {
              "subject": widget.subject,
              "classSectionDetails": widget.classSectionDetails
            },
    )
        .then((value) {
      if (value != null && value is bool && value) {
        //reload after adding new lesson or announcement
        if (_selectedTabTitle == chaptersKey) {
          context.read<LessonsCubit>().fetchLessons(
                classSectionId: widget.classSectionDetails.id,
                subjectId: widget.subject.id,
              );
        } else {
          context.read<AnnouncementsCubit>().fetchAnnouncements(
                classSectionId: widget.classSectionDetails.id,
                subjectId: widget.subject.id,
              );
        }
      }
    });
  }

  Widget _buildAppBar() {
    return Align(
      alignment: Alignment.topCenter,
      child: ScreenTopBackgroundContainer(
        child: LayoutBuilder(
          builder: (context, boxConstraints) {
            return Stack(
              children: [
                Align(
                  alignment: AlignmentDirectional.topStart,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: UiUtils.screenContentHorizontalPadding,
                    ),
                    child: SvgButton(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      svgIconUrl: UiUtils.getImagePath("back_icon.svg"),
                    ),
                  ),
                ),
                AppBarTitleContainer(
                  boxConstraints: boxConstraints,
                  title: widget.subject.showType
                      ? widget.subject.subjectNameWithType
                      : widget.subject.name,
                ),
                AppBarSubTitleContainer(
                  boxConstraints: boxConstraints,
                  subTitle:
                      "${UiUtils.getTranslatedLabel(context, classKey)} ${widget.classSectionDetails.getFullClassSectionName()}",
                ),
                AnimatedAlign(
                  curve: UiUtils.tabBackgroundContainerAnimationCurve,
                  duration: UiUtils.tabBackgroundContainerAnimationDuration,
                  alignment: _selectedTabTitle == chaptersKey
                      ? AlignmentDirectional.centerStart
                      : AlignmentDirectional.centerEnd,
                  child: TabBackgroundContainer(boxConstraints: boxConstraints),
                ),
                CustomTabBarContainer(
                  boxConstraints: boxConstraints,
                  alignment: AlignmentDirectional.centerStart,
                  isSelected: _selectedTabTitle == chaptersKey,
                  onTap: () {
                    setState(() {
                      _selectedTabTitle = chaptersKey;
                    });
                  },
                  titleKey: chaptersKey,
                ),
                CustomTabBarContainer(
                  boxConstraints: boxConstraints,
                  alignment: AlignmentDirectional.centerEnd,
                  isSelected: _selectedTabTitle == announcementKey,
                  onTap: () {
                    setState(() {
                      _selectedTabTitle = announcementKey;
                    });
                  },
                  titleKey: announcementKey,
                )
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:
          FloatingActionAddButton(onTap: _onTapFloatingActionAddButton),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: CustomRefreshIndicator(
              onRefreshCallback: () {
                if (_selectedTabTitle == chaptersKey) {
                  context.read<LessonsCubit>().fetchLessons(
                        classSectionId: widget.classSectionDetails.id,
                        subjectId: widget.subject.id,
                      );
                } else {
                  context.read<AnnouncementsCubit>().fetchAnnouncements(
                        classSectionId: widget.classSectionDetails.id,
                        subjectId: widget.subject.id,
                      );
                }
              },
              displacment: UiUtils.getScrollViewTopPadding(
                context: context,
                appBarHeightPercentage: UiUtils.appBarBiggerHeightPercentage,
              ),
              child: ListView(
                padding: EdgeInsets.only(
                  bottom: UiUtils.getScrollViewBottomPadding(context),
                  top: UiUtils.getScrollViewTopPadding(
                    context: context,
                    appBarHeightPercentage:
                        UiUtils.appBarBiggerHeightPercentage,
                  ),
                ),
                children: [
                  _selectedTabTitle == chaptersKey
                      ? LessonsContainer(
                          classSectionDetails: widget.classSectionDetails,
                          subject: widget.subject,
                        )
                      : AnnouncementsContainer(
                          classSectionDetails: widget.classSectionDetails,
                          subject: widget.subject,
                        )
                ],
              ),
            ),
          ),
          _buildAppBar(),
        ],
      ),
    );
  }
}
