<<<<<<< HEAD
import 'package:eschool_teacher/features/class/presentation/widgets/subjectImageContainer.dart';
=======
import 'package:madares_app_teacher/features/class/presentation/widgets/subjectImageContainer.dart';
>>>>>>> f8116bb26ff7cdb9462a79241b86162b4f4e9bdc
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/animationConfiguration.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/labelKeys.dart';
import '../../../../core/utils/sharedWidgets/customShimmerContainer.dart';
import '../../../../core/utils/sharedWidgets/errorContainer.dart';
import '../../../../core/utils/sharedWidgets/noDataContainer.dart';
import '../../../../core/utils/sharedWidgets/screenTopBackgroundContainer.dart';
import '../../../../core/utils/sharedWidgets/shimmerLoadingContainer.dart';
import '../../../../core/utils/uiUtils.dart';
import '../../../exam/data/models/timeTableSlot.dart';
import '../../../exam/presentation/manager/timeTableCubit.dart';

class TimeTableContainer extends StatefulWidget {
  const TimeTableContainer({Key? key}) : super(key: key);

  @override
  State<TimeTableContainer> createState() => _TimeTableContainerState();
}

class _TimeTableContainerState extends State<TimeTableContainer> {
  late int _currentSelectedDayIndex = DateTime.now().weekday - 1;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      context.read<TimeTableCubit>().fetchTimeTable();
    });
  }

  Widget _buildAppBar() {
    return ScreenTopBackgroundContainer(
      heightPercentage: UiUtils.appBarSmallerHeightPercentage,
      padding: EdgeInsets.zero,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Align(
            child: Text(
              UiUtils.getTranslatedLabel(context, scheduleKey),
              style: TextStyle(
                color: Theme.of(context).scaffoldBackgroundColor,
                fontSize: UiUtils.screenTitleFontSize,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayContainer(int index) {
    return InkWell(
      onTap: () {
        setState(() {
          _currentSelectedDayIndex = index;
        });
      },
      borderRadius: BorderRadius.circular(5.0),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: index == _currentSelectedDayIndex
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
        ),
        padding: const EdgeInsets.all(7.5),
        child: Text(
          UiUtils.weekDays[index],
          style: TextStyle(
            fontSize: 13.0,
            fontWeight: FontWeight.w600,
            color: index == _currentSelectedDayIndex
                ? Theme.of(context).scaffoldBackgroundColor
                : Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildDays() {
    final List<Widget> children = [];

    for (var i = 0; i < UiUtils.weekDays.length; i++) {
      children.add(_buildDayContainer(i));
    }

    return SizedBox(
      width: MediaQuery.of(context).size.width * (0.85),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: children,
      ),
    );
  }

  Widget _buildTimeTableSlotDetainsContainer(TimeTableSlot timeTableSlot) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
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
      height: 80,
      width: MediaQuery.of(context).size.width * (0.85),
      padding: const EdgeInsets.symmetric(horizontal: 12.5, vertical: 10.0),
      child: LayoutBuilder(
        builder: (context, boxConstraints) {
          return Row(
            children: [
              // SubjectImageContainer(
              //   showShadow: false,
              //   height: 60,
              //   width: boxConstraints.maxWidth * (0.2),
              //   radius: 7.5,
              //   subject: timeTableSlot.subject,
              // ),
              SizedBox(
                width: boxConstraints.maxWidth * (0.05),
              ),
              SizedBox(
                  width: boxConstraints.maxWidth * (0.75),
                  child: ListTile(
                    title: Text(
                      timeTableSlot.subject.showType
                          ? timeTableSlot.subject.subjectNameWithType
                          : timeTableSlot.subject.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontWeight: FontWeight.w400,
                        fontSize: 12.0,
                      ),
                    ),

                    subtitle: Column(
                      children: [
                        Text(
                          timeTableSlot.classSectionDetails
                              .getFullClassSectionName(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontWeight: FontWeight.w400,
                            fontSize: 12.0,
                          ),
                        ),
                        Text(
                          "${UiUtils.formatTime(timeTableSlot.startTime)} - ${UiUtils.formatTime(timeTableSlot.endTime)}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.w700,
                            fontSize: 12.0,
                          ),
                        )
                      ],
                    ),
                  )),
            ],
          );
        },
      ),
    );
  }

  List<TimeTableSlot> _buildTimeTableSlots(List<TimeTableSlot> timeTableSlot) {
    final dayWiseTimeTableSlots = timeTableSlot
        .where((element) => element.day == _currentSelectedDayIndex + 1)
        .toList();
    return dayWiseTimeTableSlots;
  }

  Widget _buildTimeTableShimmerLoadingContainer() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(
        horizontal: UiUtils.screenContentHorizontalPaddingPercentage *
            MediaQuery.of(context).size.width,
      ),
      child: ShimmerLoadingContainer(
        child: LayoutBuilder(
          builder: (context, boxConstraints) {
            return Row(
              children: [
                CustomShimmerContainer(
                  height: 60,
                  width: boxConstraints.maxWidth * (0.25),
                ),
                SizedBox(
                  width: boxConstraints.maxWidth * (0.05),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomShimmerContainer(
                      height: 9,
                      width: boxConstraints.maxWidth * (0.6),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomShimmerContainer(
                      height: 8,
                      width: boxConstraints.maxWidth * (0.5),
                    ),
                  ],
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTimeTable() {
    return BlocBuilder<TimeTableCubit, TimeTableState>(
      builder: (context, state) {
        if (state is TimeTableFetchSuccess) {
          final timetableSlots = _buildTimeTableSlots(state.timetableSlots);
          return timetableSlots.isEmpty
              ? NoDataContainer(
                  key: isApplicationItemAnimationOn ? UniqueKey() : null,
                  titleKey: noLecturesKey)
              : SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: List.generate(
                      timetableSlots.length,
                      (index) => Animate(
                        key: isApplicationItemAnimationOn ? UniqueKey() : null,
                        effects: listItemAppearanceEffects(
                          itemIndex: index,
                          totalLoadedItems: timetableSlots.length,
                        ),
                        child: _buildTimeTableSlotDetainsContainer(
                          timetableSlots[index],
                        ),
                      ),
                    ),
                  ),
                );
        }

        if (state is TimeTableFetchFailure) {
          return ErrorContainer(
            key: isApplicationItemAnimationOn ? UniqueKey() : null,
            errorMessageCode: state.errorMessage,
            onTapRetry: () {
              context.read<TimeTableCubit>().fetchTimeTable();
            },
          );
        }

        return Column(
          children: List.generate(
            UiUtils.defaultShimmerLoadingContentCount,
            (index) => index,
          ).map((e) => _buildTimeTableShimmerLoadingContainer()).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: UiUtils.getScrollViewBottomPadding(context),
              top: UiUtils.getScrollViewTopPadding(
                context: context,
                appBarHeightPercentage: UiUtils.appBarSmallerHeightPercentage,
              ),
            ),
            child: Column(
              children: [
                _buildDays(),
                SizedBox(
                  height: MediaQuery.of(context).size.height * (0.025),
                ),
                _buildTimeTable(),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: _buildAppBar(),
        ),
      ],
    );
  }
}
