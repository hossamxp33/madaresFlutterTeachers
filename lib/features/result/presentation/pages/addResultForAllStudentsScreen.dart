import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/labelKeys.dart';
import '../../../../core/utils/sharedWidgets/customAppbar.dart';
import '../../../../core/utils/sharedWidgets/customCircularProgressIndicator.dart';
import '../../../../core/utils/sharedWidgets/customDropDownMenu.dart';
import '../../../../core/utils/sharedWidgets/customRoundedButton.dart';
import '../../../../core/utils/sharedWidgets/customShimmerContainer.dart';
import '../../../../core/utils/sharedWidgets/defaultDropDownLabelContainer.dart';
import '../../../../core/utils/sharedWidgets/errorContainer.dart';
import '../../../../core/utils/sharedWidgets/noDataContainer.dart';
import '../../../../core/utils/sharedWidgets/shimmerLoadingContainer.dart';
import '../../../../core/utils/uiUtils.dart';
import '../../../class/presentation/manager/myClassesCubit.dart';
import '../../../exam/presentation/manager/examCubit.dart';
import '../../../exam/presentation/manager/examTimeTableCubit.dart';
import '../../../studentDetails/data/models/student.dart';
import '../../../studentDetails/data/repositories/studentRepository.dart';
import '../../../studentDetails/presentation/manager/studentsByClassSectionCubit.dart';
import '../../../subject/data/models/subject.dart';
import '../../../subject/presentation/manager/submitSubjectMarksBySubjectIdCubit.dart';
import '../widgets/addMarksContainer.dart';

class AddResultForAllStudents extends StatefulWidget {
  const AddResultForAllStudents({
    Key? key,
  }) : super(key: key);

  @override
  State<AddResultForAllStudents> createState() =>
      _AddResultForAllStudentsState();

  static Route route(RouteSettings routeSettings) {
    return CupertinoPageRoute(
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider<ExamDetailsCubit>(
            create: (context) => ExamDetailsCubit(StudentRepository()),
          ),
          BlocProvider<ExamTimeTableCubit>(
            create: (context) => ExamTimeTableCubit(StudentRepository()),
          ),
          BlocProvider(
            create: (context) =>
                StudentsByClassSectionCubit(StudentRepository()),
          ),
          BlocProvider(
            create: (context) => SubjectMarksBySubjectIdCubit(
              studentRepository: StudentRepository(),
            ),
          ),
        ],
        child: const AddResultForAllStudents(),
      ),
    );
  }
}

class _AddResultForAllStudentsState extends State<AddResultForAllStudents> {
  late final allPrimaryClasses = context.read<MyClassesCubit>().primaryClass()!;

  late CustomDropDownItem currentSelectedExamName = CustomDropDownItem(
      index: 0, title: context.read<ExamDetailsCubit>().getExamName().first);

  late CustomDropDownItem currentSelectedPrimaryClassSection =
      CustomDropDownItem(
          index: 0, title: allPrimaryClasses.first.getFullClassSectionName());

  late CustomDropDownItem currentSelectedSubject = CustomDropDownItem(
      index: 0,
      title: UiUtils.getTranslatedLabel(context, fetchingSubjectsKey));

  late String totalMarksOfSelectedSubject = '';

  Subject? selectedSubjectDetails;

  late List<TextEditingController> obtainedMarksTextEditingController = [];

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      fetchExamList();
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    for (int i = 0; i < obtainedMarksTextEditingController.length; i++) {
      obtainedMarksTextEditingController[i].dispose();
    }
  }

  void fetchExamList() {
    context.read<ExamDetailsCubit>().fetchStudentExamsList(
        examStatus: 3,
        publishStatus: 0,
        classSectionId:
            allPrimaryClasses[currentSelectedPrimaryClassSection.index].id);
  }

  //
  void fetchStudentList({required int classSectionId, required int subjectId}) {
    context.read<StudentsByClassSectionCubit>().fetchStudents(
          classSectionId: classSectionId,
          subjectId: subjectId,
        );
  }

  //
  void fetchStudentExamTimeTableOfExam({required int index}) {
    context.read<ExamTimeTableCubit>().fetchStudentExamTimeTable(
          examID: context
              .read<ExamDetailsCubit>()
              .getExamDetails(index: index)
              .examID!,
          classId: allPrimaryClasses[currentSelectedPrimaryClassSection.index]
              .classDetails
              .id,
        );
  }

  //
  Widget _buildClassTeacherClasSListDropDown({required double width}) {
    return CustomDropDownMenu(
      width: width,
      onChanged: (result) {
        if (result != null && result != currentSelectedPrimaryClassSection) {
          setState(() {
            currentSelectedPrimaryClassSection = result;

            // we will change currentSelectedSubject value to fetchingSubjectsKey label,
            // because we are using this value to validate subject currentSelectedItem value
            currentSelectedExamName = CustomDropDownItem(
                index: 0,
                title: UiUtils.getTranslatedLabel(
                  context,
                  fetchingExamsKey,
                ));
            currentSelectedSubject = CustomDropDownItem(
                index: 0,
                title: UiUtils.getTranslatedLabel(
                  context,
                  fetchingSubjectsKey,
                ));
          });

          context
              .read<StudentsByClassSectionCubit>()
              .updateState(StudentsByClassSectionFetchInProgress());
          fetchExamList();
        }
      },
      menu: context
          .read<MyClassesCubit>()
          .primaryClass()!
          .map((e) => e.getFullClassSectionName())
          .toList(),
      currentSelectedItem: currentSelectedPrimaryClassSection,
    );
  }

  //
  Widget _buildExamListDropdown({required double width}) {
    return BlocConsumer<ExamDetailsCubit, ExamDetailsState>(
      builder: (context, state) {
        return state is ExamDetailsFetchSuccess
            ? state.examList.isEmpty
                ? DefaultDropDownLabelContainer(
                    titleLabelKey: noExamsKey,
                    width: width,
                  )
                : CustomDropDownMenu(
                    width: width,
                    onChanged: (result) {
                      if (result != null && result != currentSelectedExamName) {
                        setState(() {
                          currentSelectedExamName = result;

                          // we will change currentSelectedSubject value to fetchingSubjectsKey label,
                          // because we are using this value to validate subject currentSelectedItem value
                          currentSelectedSubject = CustomDropDownItem(
                              index: 0,
                              title: UiUtils.getTranslatedLabel(
                                context,
                                fetchingSubjectsKey,
                              ));
                        });

                        //
                        context.read<StudentsByClassSectionCubit>().updateState(
                            StudentsByClassSectionFetchInProgress());

                        //
                        fetchStudentExamTimeTableOfExam(index: result.index);
                      }
                    },
                    menu: context.read<ExamDetailsCubit>().getExamName(),
                    currentSelectedItem: currentSelectedExamName,
                  )
            : DefaultDropDownLabelContainer(
                titleLabelKey: fetchingExamsKey,
                width: width,
              );
      },
      listener: (context, state) {
        if (state is ExamDetailsFetchSuccess) {
          if (state.examList.isNotEmpty) {
            setState(() {
              currentSelectedExamName = CustomDropDownItem(
                  index: 0,
                  title: context.read<ExamDetailsCubit>().getExamName().first);
            });

            fetchStudentExamTimeTableOfExam(
                index: currentSelectedExamName.index);
          } else {
            context
                .read<ExamTimeTableCubit>()
                .updateState(ExamTimeTableFetchSuccess(examTimeTableList: []));
            context
                .read<StudentsByClassSectionCubit>()
                .updateState(StudentsByClassSectionFetchSuccess(students: []));
          }
        }
      },
    );
  }

  //
  Widget _buildSubjectListDropdown({required double width}) {
    return BlocConsumer<ExamTimeTableCubit, ExamTimeTableState>(
      builder: (context, state) {
        return state is ExamTimeTableFetchSuccess
            ? state.examTimeTableList.isEmpty
                ? DefaultDropDownLabelContainer(
                    titleLabelKey: noSubjectsKey,
                    width: width,
                  )
                : CustomDropDownMenu(
                    width: width,
                    onChanged: (result) {
                      if (result != null && result != currentSelectedSubject) {
                        //fetch selected subject details
                        selectedSubjectDetails = context
                            .read<ExamTimeTableCubit>()
                            .getSubjectDetails(index: result.index);

                        fetchStudentList(
                            classSectionId: allPrimaryClasses[
                                    currentSelectedPrimaryClassSection.index]
                                .id,
                            subjectId: selectedSubjectDetails!.id);
                        //
                        setState(() {
                          currentSelectedSubject = result;
                        });
                      }
                    },
                    menu: context.read<ExamTimeTableCubit>().getSubjectName(),
                    currentSelectedItem: currentSelectedSubject.index == -1
                        ? CustomDropDownItem(
                            index: 0,
                            title: context
                                .read<ExamTimeTableCubit>()
                                .getSubjectName()
                                .first)
                        : currentSelectedSubject,
                  )
            : DefaultDropDownLabelContainer(
                titleLabelKey: fetchingSubjectsKey,
                width: width,
              );
      },
      listener: (context, state) {
        if (state is ExamTimeTableFetchSuccess) {
          if (state.examTimeTableList.isNotEmpty) {
            selectedSubjectDetails =
                context.read<ExamTimeTableCubit>().getSubjectDetails(
                      index: 0,
                    );
            fetchStudentList(
                classSectionId:
                    allPrimaryClasses[currentSelectedPrimaryClassSection.index]
                        .id,
                subjectId: selectedSubjectDetails!.id);
          } else {
            context
                .read<StudentsByClassSectionCubit>()
                .updateState(StudentsByClassSectionFetchSuccess(students: []));
          }
        } else if (state is ExamTimeTableFetchFailure) {
          UiUtils.showBottomToastOverlay(
            context: context,
            backgroundColor: Theme.of(context).colorScheme.error,
            errorMessage: UiUtils.getErrorMessageFromErrorCode(
                context, state.errorMessage),
          );
        }
      },
    );
  }

  Widget _buildResultFilters() {
    return LayoutBuilder(
      builder: (context, boxConstraints) {
        return Column(
          children: [
            //Classes where teacher is class teacher
            _buildClassTeacherClasSListDropDown(width: boxConstraints.maxWidth),

            //Exam List
            _buildExamListDropdown(width: boxConstraints.maxWidth),

            //Subject List
            _buildSubjectListDropdown(width: boxConstraints.maxWidth),
          ],
        );
      },
    );
  }

  TextStyle _getResultTitleTextStyle() {
    return TextStyle(
      color: Theme.of(context).colorScheme.secondary,
      fontWeight: FontWeight.w600,
      fontSize: 12.0,
    );
  }

  Widget _buildResultTitleDetails() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.075),
            offset: const Offset(2.5, 2.5),
            blurRadius: 5,
            spreadRadius: 1,
          )
        ],
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      width: MediaQuery.of(context).size.width,
      child: LayoutBuilder(
        builder: (context, boxConstraints) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: AlignmentDirectional.centerStart,
                width: boxConstraints.maxWidth * (0.1),
                child: Text(
                  UiUtils.getTranslatedLabel(context, rollNoKey),
                  style: _getResultTitleTextStyle(),
                ),
              ),
              Container(
                alignment: AlignmentDirectional.centerStart,
                width: boxConstraints.maxWidth * (0.4),
                child: Text(
                  UiUtils.getTranslatedLabel(context, studentsKey),
                  style: _getResultTitleTextStyle(),
                ),
              ),
              Container(
                alignment: Alignment.center,
                width: boxConstraints.maxWidth * (0.2),
                child: Text(
                  UiUtils.getTranslatedLabel(context, obtainedKey),
                  style: _getResultTitleTextStyle(),
                ),
              ),
              Container(
                alignment: AlignmentDirectional.centerEnd,
                width: boxConstraints.maxWidth * (0.2),
                child: Text(
                  UiUtils.getTranslatedLabel(context, totalKey),
                  style: _getResultTitleTextStyle(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSubmitButton({
    required String totalMarks,
    required List<Student> studentList,
  }) {
    return BlocConsumer<SubjectMarksBySubjectIdCubit,
        SubjectMarksBySubjectIdState>(
      listener: (context, state) {
        if (state is SubjectMarksBySubjectIdSubmitSuccess) {
          if (state.isMarksUpdated) {
            UiUtils.showBottomToastOverlay(
              context: context,
              errorMessage: UiUtils.getTranslatedLabel(
                context,
                marksAddedSuccessfullyKey,
              ),
              backgroundColor: Theme.of(context).colorScheme.primary,
            );
          } else {
            UiUtils.showBottomToastOverlay(
              context: context,
              errorMessage: UiUtils.getErrorMessageFromErrorCode(
                context,
                state.successMessage,
              ),
              backgroundColor: Theme.of(context).colorScheme.error,
            );
          }

          for (var element in obtainedMarksTextEditingController) {
            element.clear();
          }
          //Navigator.of(context).pop();
        } else if (state is SubjectMarksBySubjectIdSubmitFailure) {
          UiUtils.showBottomToastOverlay(
            context: context,
            errorMessage: UiUtils.getErrorMessageFromErrorCode(
              context,
              state.errorMessage,
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
          );
        }
      },
      builder: (context, state) {
        return CustomRoundedButton(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
            bool hasError = false;
            List<Map<String, dynamic>> studentsMarksList = [];
            for (int index = 0;
                index < obtainedMarksTextEditingController.length;
                index++) {
              //
              String inputMarks =
                  obtainedMarksTextEditingController[index].text;
              //
              if (inputMarks != '') {
                if (double.parse(inputMarks) > double.parse(totalMarks)) {
                  UiUtils.showBottomToastOverlay(
                    context: context,
                    errorMessage: UiUtils.getTranslatedLabel(
                      context,
                      marksMoreThanTotalMarksKey,
                    ),
                    backgroundColor: Theme.of(context).colorScheme.error,
                  );

                  hasError = true;
                  break;
                }
                studentsMarksList.add({
                  'obtained_marks': inputMarks,
                  'student_id': "${studentList[index].id}",
                });
              }
            }

            if (studentsMarksList.length !=
                obtainedMarksTextEditingController.length) {
              //if marks of all students are not inserted then error message will be shown

              UiUtils.showBottomToastOverlay(
                context: context,
                errorMessage: UiUtils.getTranslatedLabel(
                  context,
                  pleaseEnterAllMarksKey,
                ),
                backgroundColor: Theme.of(context).colorScheme.error,
              );
              return;
            }
            //if marks list is empty and doesn't show any error message before then this will be shown
            if (studentsMarksList.isEmpty && !hasError) {
              UiUtils.showBottomToastOverlay(
                context: context,
                backgroundColor: Theme.of(context).colorScheme.error,
                errorMessage: UiUtils.getTranslatedLabel(
                  context,
                  pleaseEnterSomeDataKey,
                ),
              );

              return;
            }

            if (hasError) return;
print({"examId":context
    .read<ExamDetailsCubit>()
    .getExamDetails(
  index: currentSelectedExamName.index,
)
    .examID!,"subjectId": selectedSubjectDetails!.id,"bodyParameter":studentsMarksList,"classSectionId":allPrimaryClasses[
currentSelectedPrimaryClassSection.index]
    .id});
            context
                .read<SubjectMarksBySubjectIdCubit>()
                .submitSubjectMarksBySubjectId(
                  examId: context.read<ExamDetailsCubit>().getExamDetails(index: currentSelectedExamName.index,).examID!,
                  subjectId: selectedSubjectDetails!.id,
                  bodyParameter: studentsMarksList,
                  classSectionId: allPrimaryClasses[currentSelectedPrimaryClassSection.index].id,
                );
          },
          height: UiUtils.bottomSheetButtonHeight,
          widthPercentage: UiUtils.bottomSheetButtonWidthPercentage,
          backgroundColor: Theme.of(context).colorScheme.primary,
          buttonTitle: UiUtils.getTranslatedLabel(context, submitResultKey),
          showBorder: false,
          child: state is SubjectMarksBySubjectIdSubmitInProgress
              ? const CustomCircularProgressIndicator(
                  strokeWidth: 2,
                  widthAndHeight: 20,
                )
              : null,
        );
      },
    );
  }

  Widget _buildStudentContainer() {
    return BlocConsumer<StudentsByClassSectionCubit,
        StudentsByClassSectionState>(
      listener: (context, state) {
        if (state is StudentsByClassSectionFetchSuccess) {
          //clear old list
          for (var element in obtainedMarksTextEditingController) {
            element.dispose();
          }
          obtainedMarksTextEditingController.clear();

          //create textController
          for (var i = 0; i < state.students.length; i++) {
            obtainedMarksTextEditingController.add(TextEditingController());
          }
          if (selectedSubjectDetails != null) {
            totalMarksOfSelectedSubject = context
                .read<ExamTimeTableCubit>()
                .getTotalMarksOfSubject(subjectId: selectedSubjectDetails!.id);
          }
        }
      },
      builder: (context, state) {
        //
        if (state is StudentsByClassSectionFetchSuccess) {
          //
          if (state.students.isEmpty) {
            return NoDataContainer(
              titleKey: UiUtils.getTranslatedLabel(context, noDataFoundKey),
            );
          }
          //
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildResultTitleDetails(),
              SizedBox(
                height: MediaQuery.of(context).size.height * (0.04),
              ),
              Column(
                children: List.generate(state.students.length, (index) {
                  //
                  return AddMarksContainer(
                    alias: state.students[index].rollNumber.toString(),
                    obtainedMarksTextEditingController:
                        obtainedMarksTextEditingController[index],
                    title:
                        '${state.students[index].firstName} ${state.students[index].lastName}',
                    totalMarks: totalMarksOfSelectedSubject,
                  );
                  //
                }),
              ),
              //
              SizedBox(
                height: MediaQuery.of(context).size.height * (0.09),
              ),
            ],
          );
        }
        if (state is StudentsByClassSectionFetchFailure) {
          return ErrorContainer(
            errorMessageCode: state.errorMessage,
            onTapRetry: () => fetchStudentList(
                classSectionId:
                    allPrimaryClasses[currentSelectedPrimaryClassSection.index]
                        .id,
                subjectId: selectedSubjectDetails != null
                    ? selectedSubjectDetails!.id
                    : context
                        .read<ExamTimeTableCubit>()
                        .getAllSubjects()[currentSelectedSubject.index]
                        .id),
          );
        }
        return _buildStudentListShimmerContainer();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            //  controller: _scrollController,
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
              _buildResultFilters(),
              const SizedBox(
                height: 10,
              ),
              _buildStudentContainer()
            ],
          ),
          _buildSubmitButtonContainer(),
          Align(
            alignment: Alignment.topCenter,
            child: CustomAppBar(
              title: UiUtils.getTranslatedLabel(context, addResultKey),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSubmitButtonContainer() {
    return BlocBuilder<StudentsByClassSectionCubit,
        StudentsByClassSectionState>(
      builder: (context, state) {
        if (state is StudentsByClassSectionFetchSuccess) {
          return state.students.isEmpty
              ? const SizedBox()
              : Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height * 0.02,
                    ),
                    child: _buildSubmitButton(
                      totalMarks: context
                          .read<ExamTimeTableCubit>()
                          .getTotalMarksOfSubject(
                            subjectId: selectedSubjectDetails!.id,
                          ),
                      studentList: (context
                              .read<StudentsByClassSectionCubit>()
                              .state as StudentsByClassSectionFetchSuccess)
                          .students,
                    ),
                  ),
                );
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildStudentListShimmerContainer() {
    return Column(
      children:
          List.generate(UiUtils.defaultShimmerLoadingContentCount, (index) {
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
                          end: boxConstraints.maxWidth * (0.3),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                );
              },
            ),
          ),
        );
      }),
    );
  }
}
