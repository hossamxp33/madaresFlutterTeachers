import 'package:madares_app_teacher/app/manager/appConfigurationCubit.dart';
import 'package:madares_app_teacher/app/routes.dart';
import 'package:madares_app_teacher/core/repositories/teacherRepository.dart';
import 'package:madares_app_teacher/core/utils/labelKeys.dart';
import 'package:madares_app_teacher/core/utils/sharedWidgets/customBackButton.dart';
import 'package:madares_app_teacher/core/utils/sharedWidgets/customCircularProgressIndicator.dart';
import 'package:madares_app_teacher/core/utils/sharedWidgets/customRoundedButton.dart';
import 'package:madares_app_teacher/core/utils/sharedWidgets/errorContainer.dart';
import 'package:madares_app_teacher/core/utils/sharedWidgets/screenTopBackgroundContainer.dart';
import 'package:madares_app_teacher/core/utils/sharedWidgets/searchButton.dart';
import 'package:madares_app_teacher/core/utils/uiUtils.dart';
import 'package:madares_app_teacher/features/attendance/presentation/manager/classAttendanceCubit.dart';
import 'package:madares_app_teacher/features/attendance/presentation/widgets/studentAttendanceTileContainer.dart';
import 'package:madares_app_teacher/features/class/presentation/manager/submitClassAttendanceCubit.dart';
import 'package:madares_app_teacher/features/studentDetails/data/models/student.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AttendanceScreen extends StatefulWidget {
  final List<Student> students;
  const AttendanceScreen({Key? key, required this.students}) : super(key: key);

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();

  static Route route(RouteSettings routeSettings) {
    return CupertinoPageRoute(
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ClassAttendanceCubit(TeacherRepository()),
          ),
          BlocProvider(
            create: (context) =>
                SubmitClassAttendanceCubit(TeacherRepository()),
          ),
        ],
        child: AttendanceScreen(
          students: routeSettings.arguments as List<Student>,
        ),
      ),
    );
  }
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  late List<Map<int, bool>> _listOfAttendance = [];

  late DateTime _selectedAttendanceDate = DateTime.now();
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      fetchClassAttendanceReports();
    });
    print("============");
    print( widget.students.length);
    print("============");
    // widget.students.forEach((e) {
    //   _listOfAttendance.add({e.id: true});
    // });
  }

  void fetchClassAttendanceReports() {
    context.read<ClassAttendanceCubit>().fetchAttendanceReports(
          classSectionId: widget.students.first.classSectionId,
          date: _selectedAttendanceDate,
        );
  }

  void _updateAttendance(int studentId) {
    if (context.read<SubmitClassAttendanceCubit>().state
        is SubmitClassAttendanceInProgress) {
      return;
    }
    final index = _listOfAttendance
        .indexWhere((element) => element.keys.first == studentId);
    _listOfAttendance[index][studentId] = !_listOfAttendance[index][studentId]!;
    setState(() {});
  }

  String _buildAttendanceDate() {
    return "${_selectedAttendanceDate.day.toString().padLeft(2, '0')} - ${_selectedAttendanceDate.month.toString().padLeft(2, '0')} - ${_selectedAttendanceDate.year}";
  }

  Future<void> _changeAttendanceDate() async {
    final pickedDate = await showDatePicker(
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  onPrimary: Theme.of(context).scaffoldBackgroundColor,
                ),
          ),
          child: child!,
        );
      },
      context: context,
      initialDate: _selectedAttendanceDate,
      firstDate: context
          .read<AppConfigurationCubit>()
          .getAppConfiguration()
          .sessionYear
          .startDate,
    );

    if (pickedDate != null) {
      //If teacher change the date then fetch attendance for that day
      setState(() {
        _selectedAttendanceDate = pickedDate;
        _listOfAttendance = [];
      });

      fetchClassAttendanceReports();
    }
  }

  Widget _buildAppbar() {
    return ScreenTopBackgroundContainer(
      padding: const EdgeInsets.all(0),
      heightPercentage: UiUtils.appBarSmallerHeightPercentage,
      child: LayoutBuilder(
        builder: (context, boxConstraints) {
          return Stack(
            children: [
              CustomBackButton(
                onTap: () {
                  if (context.read<SubmitClassAttendanceCubit>().state
                      is SubmitClassAttendanceInProgress) {
                    return;
                  }
                  Navigator.of(context).pop();
                },
                alignmentDirectional: AlignmentDirectional.centerStart,
              ),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: BlocBuilder<ClassAttendanceCubit, ClassAttendanceState>(
                  builder: (context, state) {
                    if (state is ClassAttendanceFetchSuccess) {
                      if (state.isHoliday) {
                        return const SizedBox();
                      }
                      return SearchButton(
                        onTap: () {
                          if (context.read<SubmitClassAttendanceCubit>().state
                              is SubmitClassAttendanceInProgress) {
                            return;
                          }
                          Navigator.of(context)
                              .pushNamed<List<Map<int, bool>>?>(
                            Routes.searchStudent,
                            arguments: {
                              "fromAttendanceScreen": true,
                              "students": widget.students,
                              "listOfAttendanceReport": _listOfAttendance
                            },
                          ).then((value) {
                            if (value != null) {
                              _listOfAttendance = value;
                              setState(() {});
                            }
                          });
                        },
                      );
                    }

                    return const SizedBox();
                  },
                ),
              ),
              Align(
                child: Container(
                  alignment: Alignment.center,
                  width: boxConstraints.maxWidth * (0.6),
                  child: Text(
                    UiUtils.getTranslatedLabel(context, takeAttendanceKey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: UiUtils.screenTitleFontSize,
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                  ),
                ),
              ),
              Align(
                child: Container(
                  alignment: Alignment.center,
                  width: boxConstraints.maxWidth * (0.6),
                  margin: EdgeInsets.only(
                    top: boxConstraints.maxHeight * (0.25) +
                        UiUtils.screenTitleFontSize,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      _changeAttendanceDate();
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Transform.translate(
                          offset: const Offset(0.0, -0.75),
                          child: Icon(
                            Icons.calendar_month,
                            size: 14,
                            color: Theme.of(context).colorScheme.background,
                          ),
                        ),
                        SizedBox(
                          width: boxConstraints.maxWidth * (0.015),
                        ),
                        Text(
                          _buildAttendanceDate(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: UiUtils.screenSubTitleFontSize,
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSubmitAttendanceButton() {
    return BlocBuilder<ClassAttendanceCubit, ClassAttendanceState>(
      builder: (context, state) {
        if (state is ClassAttendanceFetchSuccess) {
          if (state.isHoliday) {
            return const SizedBox();
          }
          return BlocConsumer<SubmitClassAttendanceCubit,
              SubmitClassAttendanceState>(
            listener: (context, submitAttendanceState) {
              if (submitAttendanceState is SubmitClassAttendanceSuccess) {
                UiUtils.showBottomToastOverlay(
                  context: context,
                  errorMessage: UiUtils.getTranslatedLabel(
                    context,
                    attendanceSubmittedSuccessfullyKey,
                  ),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                );
              } else if (submitAttendanceState is SubmitClassAttendanceFailure) {
                UiUtils.showBottomToastOverlay(
                  context: context,
                  errorMessage: UiUtils.getErrorMessageFromErrorCode(
                    context,
                    submitAttendanceState.errorMessage,
                  ),
                  backgroundColor: Theme.of(context).colorScheme.error,
                );
              }
            },
            builder: (context, submitAttendanceState) {
              return Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: CustomRoundedButton(
                    onTap: () {
                      if (submitAttendanceState
                          is SubmitClassAttendanceInProgress) {
                        return;
                      }
                      context
                          .read<SubmitClassAttendanceCubit>()
                          .submitAttendance(
                            dateTime: _selectedAttendanceDate,
                            classSectionId:
                                widget.students.first.classSectionId,
                            attendanceReport: _listOfAttendance,
                          );
                    },
                    elevation: 10.0,
                    height: UiUtils.bottomSheetButtonHeight,
                    widthPercentage: UiUtils.bottomSheetButtonWidthPercentage,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    buttonTitle: UiUtils.getTranslatedLabel(context, submitKey),
                    showBorder: false,
                    child:
                        submitAttendanceState is SubmitClassAttendanceInProgress
                            ? const CustomCircularProgressIndicator(
                                strokeWidth: 2,
                                widthAndHeight: 20,
                              )
                            : null,
                  ),
                ),
              );
            },
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildStudents() {
    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: UiUtils.bottomSheetButtonHeight + 40.0,
          top: UiUtils.getScrollViewTopPadding(
            context: context,
            appBarHeightPercentage: UiUtils.appBarSmallerHeightPercentage,
          ),
        ),
        child: BlocConsumer<ClassAttendanceCubit, ClassAttendanceState>(
          listener: (context, state) {
            if (state is ClassAttendanceFetchSuccess) {
              //
              if (!state.isHoliday) {
                //
                if (state.attendanceReports.isNotEmpty) {
                  //
                  for (var student in widget.students) {
                    //Find the attendance report and update the list of attendace
                    try {
                      final attendanceReport = state.attendanceReports
                          .where((element) => element.studentId == student.id)
                          .first;

                      _listOfAttendance
                          .add({student.id: attendanceReport.isPresent()});
                    } catch (_) {
                      _listOfAttendance.add({student.id: true});
                    }
                  }
                } else {
                  //If passed date is not holiday and also attendance reports is empty
                  //means attendance of that day not taken
                  //So by default attendance status will be present
                  for (var student in widget.students) {
                    _listOfAttendance.add({student.id: true});
                  }
                }
                setState(() {});
              }
            }
          },
          builder: (context, state) {
            if (state is ClassAttendanceFetchSuccess) {
              if (state.isHoliday) {
                return Padding(
                  padding: EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: MediaQuery.of(context).size.height * (0.25),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${UiUtils.getTranslatedLabel(context, holidayKey)} : ${state.holidayDetails.title}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        UiUtils.getTranslatedLabel(
                          context,
                          attendanceNotViewEditKey,
                        ),
                      ),
                    ],
                  ),
                );
              }

              if (_listOfAttendance.isEmpty) {
                return const SizedBox();
              }

              return Column(
                children: widget.students.map((student) {
                  final isPresent = _listOfAttendance
                      .where((element) => element.keys.first == student.id)
                      .toList()
                      .first[student.id]!;
                  return StudentAttendanceTileContainer(
                    isPresent: isPresent,
                    student: student,
                    updateAttendance: _updateAttendance,
                  );
                }).toList(),
              );
            }

            if (state is ClassAttendanceFetchFailure) {
              return ErrorContainer(
                errorMessageCode: state.errorMessage,
                onTapRetry: () {
                  fetchClassAttendanceReports();
                },
              );
            }
            return Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * (0.25),
              ),
              child: CustomCircularProgressIndicator(
                indicatorColor: Theme.of(context).colorScheme.primary,
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (context.read<SubmitClassAttendanceCubit>().state
            is! SubmitClassAttendanceInProgress) {
          if (didPop) {
            return;
          }
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            _buildStudents(),
            _buildAppbar(),
            _buildSubmitAttendanceButton()
          ],
        ),
      ),
    );
  }
}
