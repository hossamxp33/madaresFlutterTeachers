import 'package:madares_app_teacher/app/routes.dart';
import 'package:madares_app_teacher/core/repositories/teacherRepository.dart';
import 'package:madares_app_teacher/core/utils/sharedWidgets/appBarTitleContainer.dart';
import 'package:madares_app_teacher/core/utils/sharedWidgets/customAppbar.dart';
import 'package:madares_app_teacher/core/utils/sharedWidgets/customBackButton.dart';
import 'package:madares_app_teacher/core/utils/sharedWidgets/customTabBarContainer.dart';
import 'package:madares_app_teacher/core/utils/sharedWidgets/screenTopBackgroundContainer.dart';
import 'package:madares_app_teacher/core/utils/sharedWidgets/searchButton.dart';
import 'package:madares_app_teacher/core/utils/sharedWidgets/tabBarBackgroundContainer.dart';
import 'package:madares_app_teacher/core/utils/uiUtils.dart';
import 'package:madares_app_teacher/features/class/data/models/classSectionDetails.dart';
import 'package:madares_app_teacher/features/class/presentation/widgets/studentsContainer.dart';
import 'package:madares_app_teacher/features/class/presentation/widgets/subjectsContainer.dart';
import 'package:madares_app_teacher/features/studentDetails/data/repositories/studentRepository.dart';
import 'package:madares_app_teacher/features/studentDetails/presentation/manager/studentsByClassSectionCubit.dart';
import 'package:madares_app_teacher/features/subject/presentation/manager/subjectsOfClassSectionCubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/utils/labelKeys.dart';

class ClassScreen extends StatefulWidget {
  final bool isClassTeacher;
  final ClassSectionDetails classSection;

  const ClassScreen(
      {Key? key, required this.isClassTeacher, required this.classSection})
      : super(key: key);

  @override
  State<ClassScreen> createState() => _ClassScreenState();

  static Route route(RouteSettings routeSettings) {
    final arguments = routeSettings.arguments as Map<String, dynamic>;
    return CupertinoPageRoute(
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                SubjectsOfClassSectionCubit(TeacherRepository()),
          ),
          BlocProvider(
            create: (context) =>
                StudentsByClassSectionCubit(StudentRepository()),
          ),
        ],
        child: ClassScreen(
          classSection: arguments['classSection'],
          isClassTeacher: arguments['isClassTeacher'],
        ),
      ),
    );
  }
}

class _ClassScreenState extends State<ClassScreen> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      context
          .read<SubjectsOfClassSectionCubit>()
          .fetchSubjects(widget.classSection.id);
      if (widget.isClassTeacher) {
        context.read<StudentsByClassSectionCubit>().fetchStudents(
            classSectionId: widget.classSection.id, subjectId: null);
      }
    });
    super.initState();
  }

  late String _selectedTabTitle = studentsKey;

  Widget _buildAppbar() {
    return widget.isClassTeacher
        ? Align(
            alignment: Alignment.topCenter,
            child: ScreenTopBackgroundContainer(
              child: LayoutBuilder(
                builder: (context, boxConstraints) {
                  return Stack(
                    children: [
                      const CustomBackButton(),
                      _selectedTabTitle == subjectsKey
                          ? const SizedBox()
                          : Align(
                              alignment: AlignmentDirectional.topEnd,
                              child: BlocBuilder<StudentsByClassSectionCubit,
                                  StudentsByClassSectionState>(
                                builder: (context, state) {
                                  if (state
                                          is StudentsByClassSectionFetchSuccess &&
                                      state.students.isNotEmpty) {
                                    return SearchButton(
                                      onTap: () {
                                        Navigator.of(context).pushNamed(
                                            Routes.searchStudent,
                                            arguments: {
                                              "students": context
                                                  .read<
                                                      StudentsByClassSectionCubit>()
                                                  .getStudents(),
                                              "fromAttendanceScreen": false
                                            });
                                      },
                                    );
                                  }
                                  return const SizedBox();
                                },
                              ),
                            ),
                      AppBarTitleContainer(
                        boxConstraints: boxConstraints,
                        title:
                            "${UiUtils.getTranslatedLabel(context, classKey)} ${widget.classSection.getFullClassSectionName()}",
                      ),
                      AnimatedAlign(
                        curve: UiUtils.tabBackgroundContainerAnimationCurve,
                        duration:
                            UiUtils.tabBackgroundContainerAnimationDuration,
                        alignment: _selectedTabTitle == studentsKey
                            ? AlignmentDirectional.centerStart
                            : AlignmentDirectional.centerEnd,
                        child: TabBackgroundContainer(
                            boxConstraints: boxConstraints),
                      ),
                      CustomTabBarContainer(
                        boxConstraints: boxConstraints,
                        alignment: AlignmentDirectional.centerStart,
                        isSelected: _selectedTabTitle == studentsKey,
                        onTap: () {
                          setState(() {
                            _selectedTabTitle = studentsKey;
                          });
                        },
                        titleKey: studentsKey,
                      ),
                      CustomTabBarContainer(
                        boxConstraints: boxConstraints,
                        alignment: AlignmentDirectional.centerEnd,
                        isSelected: _selectedTabTitle == subjectsKey,
                        onTap: () {
                          setState(() {
                            _selectedTabTitle = subjectsKey;
                          });
                        },
                        titleKey: subjectsKey,
                      ),
                    ],
                  );
                },
              ),
            ),
          )
        : Align(
            alignment: Alignment.topCenter,
            child: CustomAppBar(
              subTitle: UiUtils.getTranslatedLabel(context, subjectsKey),
              title:
                  "${UiUtils.getTranslatedLabel(context, classKey)} ${widget.classSection.classDetails.name} - ${widget.classSection.sectionDetails.name}",
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:
          widget.isClassTeacher && _selectedTabTitle == studentsKey
              ? BlocBuilder<StudentsByClassSectionCubit,
                  StudentsByClassSectionState>(
                  builder: (context, state) {
                    if (state is StudentsByClassSectionFetchSuccess &&
                        state.students.isNotEmpty) {
                      return FloatingActionButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(Routes.attendance,
                              arguments: state.students);
                        },
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SvgPicture.asset(
                            UiUtils.getImagePath("take_attendance.svg"),
                            colorFilter: ColorFilter.mode(
                              Theme.of(context).scaffoldBackgroundColor,
                              BlendMode.srcIn,
                            ),
                            // color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                        ),
                      );
                    }

                    return const SizedBox();
                  },
                )
              : const SizedBox(),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * (0.075),
                right: MediaQuery.of(context).size.width * (0.075),
                top: UiUtils.getScrollViewTopPadding(
                    context: context,
                    appBarHeightPercentage: widget.isClassTeacher
                        ? UiUtils.appBarBiggerHeightPercentage
                        : UiUtils.appBarSmallerHeightPercentage),
              ),
              child: widget.isClassTeacher
                  ? _selectedTabTitle == subjectsKey
                      ? SubjectsContainer(
                          classSectionDetails: widget.classSection,
                        )
                      : StudentsContainer(
                          classSectionDetails: widget.classSection,
                        )
                  : SubjectsContainer(
                      classSectionDetails: widget.classSection,
                    ),
            ),
          ),
          _buildAppbar(),
        ],
      ),
    );
  }
}
