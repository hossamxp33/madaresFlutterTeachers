import 'package:eschool_teacher/app/routes.dart';
import 'package:eschool_teacher/core/repositories/teacherRepository.dart';
import 'package:eschool_teacher/core/utils/sharedWidgets/customDropDownMenu.dart';
import 'package:eschool_teacher/features/assignment/data/repositories/assignmentRepository.dart';
import 'package:eschool_teacher/features/assignment/presentation/manager/assignmentCubit.dart';
import 'package:eschool_teacher/features/assignments/presentation/widgets/assignmentsContainer.dart';
import 'package:eschool_teacher/features/class/presentation/manager/myClassesCubit.dart';
import 'package:eschool_teacher/features/class/presentation/widgets/myClassesDropDownMenu.dart';
import 'package:eschool_teacher/features/subject/presentation/manager/subjectsOfClassSectionCubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/labelKeys.dart';
import '../../../../core/utils/sharedWidgets/classSubjectsDropDownMenu.dart';
import '../../../../core/utils/sharedWidgets/customAppbar.dart';
import '../../../../core/utils/sharedWidgets/customFloatingActionButton.dart';
import '../../../../core/utils/sharedWidgets/customRefreshIndicator.dart';
import '../../../../core/utils/uiUtils.dart';
import '../../../subject/data/models/subject.dart';

class AssignmentsScreen extends StatefulWidget {
  const AssignmentsScreen({Key? key}) : super(key: key);

  static Route<dynamic> route(RouteSettings routeSettings) {
    return CupertinoPageRoute(
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider<SubjectsOfClassSectionCubit>(
            create: (context) => SubjectsOfClassSectionCubit(
              TeacherRepository(),
            ),
          ),
          BlocProvider<AssignmentCubit>(
            create: (context) => AssignmentCubit(
              AssignmentRepository(),
            ),
          ),
        ],
        child: const AssignmentsScreen(),
      ),
    );
  }

  @override
  State<AssignmentsScreen> createState() => _AssignmentsScreenState();
}

class _AssignmentsScreenState extends State<AssignmentsScreen> {
  late final ScrollController _scrollController = ScrollController()
    ..addListener(_announcementsScrollListener);

  void _announcementsScrollListener() {
    if (_scrollController.offset ==
        _scrollController.position.maxScrollExtent) {
      if (context.read<AssignmentCubit>().hasMore()) {
        context.read<AssignmentCubit>().fetchMoreAssignment(
              subjectId: context
                  .read<SubjectsOfClassSectionCubit>()
                  .getSubjectDetails(currentSelectedSubject.index)
                  .id,
              classSectionId: context
                  .read<MyClassesCubit>()
                  .getClassSectionDetails(
                    index: currentSelectedClassSection.index,
                  )
                  .id,
            );
      }
    }
  }

  void fetchAssignment() {
    final subjectState = context.read<SubjectsOfClassSectionCubit>().state;

    if (subjectState is SubjectsOfClassSectionFetchSuccess &&
        subjectState.subjects.isNotEmpty) {
      final subjectId = context
          .read<SubjectsOfClassSectionCubit>()
          .getSubjectDetails(currentSelectedSubject.index)
          .id;
      if (subjectId != -1) {
        context.read<AssignmentCubit>().fetchassignment(
              classSectionId: context
                  .read<MyClassesCubit>()
                  .getClassSectionDetails(
                    index: currentSelectedClassSection.index,
                  )
                  .id,
              subjectId: subjectId,
            );
      }
    }
  }

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

  late CustomDropDownItem currentSelectedClassSection = CustomDropDownItem(
      index: 0,
      title: context.read<MyClassesCubit>().getClassSectionName().first);

  late CustomDropDownItem currentSelectedSubject = CustomDropDownItem(
      index: 0,
      title: UiUtils.getTranslatedLabel(context, fetchingSubjectsKey));

  Widget _buildAppbar() {
    return Align(
      alignment: Alignment.topCenter,
      child: CustomAppBar(
        title: UiUtils.getTranslatedLabel(context, assignmentsKey),
      ),
    );
  }

  Widget _buildAssignmentFilters() {
    return LayoutBuilder(
      builder: (context, boxConstraints) {
        return Column(
          children: [
            MyClassesDropDownMenu(
              currentSelectedItem: currentSelectedClassSection,
              width: boxConstraints.maxWidth,
              changeSelectedItem: (result) {
                setState(() {
                  currentSelectedClassSection = result;
                });

                context
                    .read<AssignmentCubit>()
                    .updateState(AssignmentInitial());
              },
            ),

            //
            BlocListener<SubjectsOfClassSectionCubit,
                SubjectsOfClassSectionState>(
              listener: (context, state) {
                if (state is SubjectsOfClassSectionFetchSuccess) {
                  if (state.subjects.isEmpty) {
                    context
                        .read<AssignmentCubit>()
                        .updateState(AssignmentsFetchSuccess(
                          assignment: [],
                          fetchMoreAssignmentsInProgress: false,
                          moreAssignmentsFetchError: false,
                          totalPage: 0,
                          currentPage: 0,
                        ));
                  }
                }
              },
              child: ClassSubjectsDropDownMenu(
                changeSelectedItem: (result) {
                  setState(() {
                    currentSelectedSubject = result;
                  });
                  fetchAssignment();
                },
                currentSelectedItem: currentSelectedSubject,
                width: boxConstraints.maxWidth,
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
          Navigator.of(context).pushNamed<bool?>(
            Routes.addAssignment,
            arguments: {"editAssignment": false},
          ).then((value) {
            if (value != null && value) {
              fetchAssignment();
            }
          });
        },
      ),
      body: Stack(
        children: [
          CustomRefreshIndicator(
            displacment: UiUtils.getScrollViewTopPadding(
              context: context,
              appBarHeightPercentage: UiUtils.appBarSmallerHeightPercentage,
            ),
            onRefreshCallback: () {
              fetchAssignment();
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: _scrollController,
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width *
                    UiUtils.screenContentHorizontalPaddingPercentage,
                right: MediaQuery.of(context).size.width *
                    UiUtils.screenContentHorizontalPaddingPercentage,
                top: UiUtils.getScrollViewTopPadding(
                  context: context,
                  appBarHeightPercentage: UiUtils.appBarSmallerHeightPercentage,
                ),
              ),
              children: [
                _buildAssignmentFilters(),
                const SizedBox(
                  height: 10,
                ),
                AssignmentsContainer(
                  classSectionDetails:
                      context.read<MyClassesCubit>().getClassSectionDetails(
                            index: currentSelectedClassSection.index,
                          ),
                  subject: (context.read<SubjectsOfClassSectionCubit>().state
                              is SubjectsOfClassSectionFetchSuccess &&
                          (context.read<SubjectsOfClassSectionCubit>().state
                                  as SubjectsOfClassSectionFetchSuccess)
                              .subjects
                              .isNotEmpty)
                      ? context
                          .read<SubjectsOfClassSectionCubit>()
                          .getSubjectDetails(currentSelectedSubject.index)
                      : Subject.fromJson({}),
                ),
              ],
            ),
          ),
          _buildAppbar()
        ],
      ),
    );
  }
}
