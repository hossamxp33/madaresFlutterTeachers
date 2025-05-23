import 'package:madares_app_teacher/features/assignment/data/models/assignment.dart';
import 'package:madares_app_teacher/features/assignment/data/repositories/reviewAssignmentRepository.dart';
import 'package:madares_app_teacher/features/assignment/presentation/manager/editreviewassignmetcubit.dart';
import 'package:madares_app_teacher/features/assignment/presentation/manager/reviewassignmentcubit.dart';
import 'package:madares_app_teacher/features/assignment/presentation/widgets/acceptAssignmentBottomsheetContainer.dart';
import 'package:madares_app_teacher/features/assignment/presentation/widgets/rejectAssignmentBottomsheetContainer.dart';
import 'package:madares_app_teacher/features/assignments/data/models/reviewAssignmentssubmition.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/animationConfiguration.dart';
import '../../../../core/utils/labelKeys.dart';
import '../../../../core/utils/sharedWidgets/attachmentsBottomsheetContainer.dart';
import '../../../../core/utils/sharedWidgets/customAppbar.dart';
import '../../../../core/utils/sharedWidgets/customRefreshIndicator.dart';
import '../../../../core/utils/sharedWidgets/customShimmerContainer.dart';
import '../../../../core/utils/sharedWidgets/customUserProfileImageWidget.dart';
import '../../../../core/utils/sharedWidgets/errorContainer.dart';
import '../../../../core/utils/sharedWidgets/shimmerLoadingContainer.dart';
import '../../../../core/utils/styles/colors.dart';
import '../../../../core/utils/uiUtils.dart';

class AssignmentScreen extends StatefulWidget {
  final Assignment assignment;

  const AssignmentScreen({
    super.key,
    required this.assignment,
  });

  static Route<dynamic> route(RouteSettings routeSettings) {
    final arguments = routeSettings.arguments as Map<String, dynamic>;
    return CupertinoPageRoute(
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider<ReviewAssignmentCubit>(
            create: (context) =>
                ReviewAssignmentCubit(ReviewAssignmentRepository()),
          )
        ],
        child: AssignmentScreen(
          assignment: arguments['assignment'],
        ),
      ),
    );
  }

  @override
  State<AssignmentScreen> createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends State<AssignmentScreen> {
  late String _currentlySelectedAssignmentFilter = allKey;

  final List<String> _assignmentFilters = [
    allKey,
    submittedKey,
    reSubmittedKey,
    acceptedKey,
    rejectedKey,
    //  pendingKey
  ];

  @override
  void initState() {
    if (kDebugMode) {
      print("assignmentId ${widget.assignment.id}");
    }
    fetchReviewAssignment();
    super.initState();
  }

  void fetchReviewAssignment() {
    context
        .read<ReviewAssignmentCubit>()
        .fetchReviewAssignment(assignmentId: widget.assignment.id);
  }

  void openRejectAssignmentBottomsheet(
    ReviewAssignmentssubmition reviewAssignment,
  ) {
    UiUtils.showBottomSheet(
      child: BlocProvider<EditReviewAssignmetCubit>(
        create: (context) =>
            EditReviewAssignmetCubit(ReviewAssignmentRepository()),
        child: RejectAssignmentBottomsheetContainer(
          assignment: widget.assignment,
          reviewAssignment: reviewAssignment,
        ),
      ),
      context: context,
    ).then((value) {
      if (value != null) {
        context
            .read<ReviewAssignmentCubit>()
            .updateReviewAssignmet(updatedReviewAssignmentSubmition: value);
      }
    });
  }

  void openAcceptAssignmentBottomsheet(
    ReviewAssignmentssubmition reviewAssignmet,
  ) {
    UiUtils.showBottomSheet(
      child: BlocProvider<EditReviewAssignmetCubit>(
        create: (context) =>
            EditReviewAssignmetCubit(ReviewAssignmentRepository()),
        child: AcceptAssignmentBottomsheetContainer(
          assignment: widget.assignment,
          reviewAssignment: reviewAssignmet,
        ),
      ),
      context: context,
    ).then((value) {
      if (value != null) {
        context
            .read<ReviewAssignmentCubit>()
            .updateReviewAssignmet(updatedReviewAssignmentSubmition: value);
      }
    });
  }

  Widget _buildAppbar() {
    return Align(
      alignment: Alignment.topCenter,
      child: CustomAppBar(title: widget.assignment.subject.name),
    );
  }

  Widget _buildInformationShimmerLoadingContainer() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        width: MediaQuery.of(context).size.width * (0.8),
        child: LayoutBuilder(
          builder: (context, boxConstraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerLoadingContainer(
                  child: CustomShimmerContainer(
                    margin: EdgeInsetsDirectional.only(
                      end: boxConstraints.maxWidth * (0.5),
                    ),
                    width: boxConstraints.maxWidth,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                ShimmerLoadingContainer(
                  child: CustomShimmerContainer(
                    width: boxConstraints.maxWidth,
                    margin: EdgeInsetsDirectional.only(
                      end: boxConstraints.maxWidth * (0.1),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                ShimmerLoadingContainer(
                  child: CustomShimmerContainer(
                    width: boxConstraints.maxWidth,
                    margin: EdgeInsetsDirectional.only(
                      end: boxConstraints.maxWidth * (0.5),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                ShimmerLoadingContainer(
                  child: CustomShimmerContainer(
                    width: boxConstraints.maxWidth,
                    margin: EdgeInsetsDirectional.only(
                      end: boxConstraints.maxWidth * (0.1),
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

  Widget _buildAssignmentFilterContainer(
    String title,
    List<ReviewAssignmentssubmition> reviewAssignment,
  ) {
    final int totalNumberAssignment = title == allKey
        ? reviewAssignment.length
        : title == submittedKey
            ? reviewAssignment.where((element) => element.status == 0).length
            : title == acceptedKey
                ? reviewAssignment
                    .where((element) => element.status == 1)
                    .length
                : title == rejectedKey ? reviewAssignment.where((element) => element.status == 2).length
                    : title == reSubmittedKey
                        ? reviewAssignment
                            .where((element) => element.status == 3)
                            .length
                        : 0;
    return InkWell(
      onTap: () {
        setState(() {
          _currentlySelectedAssignmentFilter = title;
        });
      },
      borderRadius: BorderRadius.circular(5.0),
      child: Container(
        margin: const EdgeInsets.only(right: 5.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: _currentlySelectedAssignmentFilter == title
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              UiUtils.getTranslatedLabel(context, title),
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w600,
                color: _currentlySelectedAssignmentFilter == title
                    ? Theme.of(context).scaffoldBackgroundColor
                    : Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(
              width: 2.5,
            ),
            Text(
              "($totalNumberAssignment)",
              style: TextStyle(
                fontSize: 11.5,
                color: _currentlySelectedAssignmentFilter == title
                    ? Theme.of(context).scaffoldBackgroundColor
                    : Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssignmentSubmissionFilters(
    List<ReviewAssignmentssubmition> reviewAssignment,
  ) {
    return Transform.translate(
      offset: const Offset(0, -5),
      child: SizedBox(
        height: 30,
        child: ListView.builder(
          padding:
              EdgeInsets.only(left: MediaQuery.of(context).size.width * (0.05)),
          itemCount: _assignmentFilters.length,
          itemBuilder: (context, index) {
            return _buildAssignmentFilterContainer(
              _assignmentFilters[index],
              reviewAssignment,
            );
          },
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }

  //to display rejected, accepted,view and download
  Widget _buildStudentAssignmentActionButton({
    required String title,
    required double rightMargin,
    required double width,
    required Function onTap,
    required Color backgroundColor,
  }) {
    return InkWell(
      onTap: () {
        onTap();
      },
      borderRadius: BorderRadius.circular(5.0),
      child: Container(
        margin: EdgeInsets.only(right: rightMargin),
        alignment: Alignment.center,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: backgroundColor,
        ),
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Text(
          UiUtils.getTranslatedLabel(context, title),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 10.75,
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
        ),
      ),
    );
  }

  Widget _buildStudentAssignmentDetailsContainer({
    required String assignmentFilterType,
    required bool isAssignmentFilterTypeAll,
    required ReviewAssignmentssubmition reviewAssignment,
  }) {
    return Animate(
      effects: customItemFadeAppearanceEffects(),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        width: MediaQuery.of(context).size.width * (0.85),
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(15),
        ),
        child: LayoutBuilder(
          builder: (context, boxConstraints) {
            return Column(
              children: [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.75),
                      ),
                      height: boxConstraints.maxWidth * (0.175),
                      width: boxConstraints.maxWidth * (0.175),
                      child: CustomUserProfileImageWidget(
                        profileUrl: reviewAssignment.student.user.image,
                        radius: BorderRadius.circular(15),
                      ),
                    ),
                    SizedBox(
                      width: boxConstraints.maxWidth * (0.05),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: boxConstraints.maxWidth * 0.5,
                              child: Text(
                                "${reviewAssignment.student.user.firstName}${reviewAssignment.student.user.lastName}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13.0,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            isAssignmentFilterTypeAll == true
                                ? reviewAssignment.status == 0
                                    ? Container()
                                    : Container(
                                        alignment: Alignment.center,
                                        width: boxConstraints.maxWidth * (0.27),
                                        decoration: BoxDecoration(
                                          color: reviewAssignment.status == 1 ||
                                                  reviewAssignment.status == 3
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .error,
                                          borderRadius:
                                              BorderRadius.circular(2.5),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2),
                                        child: Text(
                                          UiUtils.getTranslatedLabel(
                                            context,
                                            reviewAssignment.status == 1
                                                ? "accepted"
                                                : reviewAssignment.status == 3
                                                    ? reSubmittedKey
                                                    : "rejected",
                                          ), //
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 10.75,
                                            color: Theme.of(context)
                                                .scaffoldBackgroundColor,
                                          ),
                                        ),
                                      )
                                : const SizedBox(),
                          ],
                        ),
                        const SizedBox(
                          height: 2.5,
                        ),
                        Text(
                          "Submitted on ${reviewAssignment.assignment.dueDate}",
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withOpacity(0.7),
                            fontWeight: FontWeight.w400,
                            fontSize: 11.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                assignmentFilterType == rejectedKey
                    ? Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(
                          left: boxConstraints.maxWidth * (0.225),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              reviewAssignment.feedback,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontWeight: FontWeight.w600,
                                fontSize: 12.0,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            GestureDetector(
                              onTap: () {
                                UiUtils.showBottomSheet(
                                  child: AttachmentBottomsheetContainer(
                                    fromAnnouncementsContainer: false,
                                    studyMaterials: reviewAssignment.file,
                                  ),
                                  context: context,
                                );
                              },
                              child: Text(
                                "${reviewAssignment.file.length} ${UiUtils.getTranslatedLabel(context, attachmentsKey)}",
                                style:  TextStyle(
                                    color: Theme.of(context).colorScheme.secondary),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(),
                assignmentFilterType == submitKey ||
                        assignmentFilterType == reSubmittedKey
                    ? Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(
                          left: boxConstraints.maxWidth * (0.225),
                        ),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                UiUtils.showBottomSheet(
                                  child: AttachmentBottomsheetContainer(
                                    fromAnnouncementsContainer: false,
                                    studyMaterials: reviewAssignment.file,
                                  ),
                                  context: context,
                                );
                              },
                              child: Text(
                                "${reviewAssignment.file.length} ${UiUtils.getTranslatedLabel(context, attachmentsKey)}",
                                style:  TextStyle(
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(),
                assignmentFilterType == acceptedKey
                    ? Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(
                          left: boxConstraints.maxWidth * (0.225),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (reviewAssignment.feedback.isNotEmpty)
                              Text(
                                reviewAssignment.feedback,
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12.0,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            if (reviewAssignment.assignment.points != 0 &&
                                reviewAssignment.assignment.points != -1)
                              const SizedBox(
                                height: 7,
                              ),
                            if (reviewAssignment.assignment.points != 0 &&
                                reviewAssignment.assignment.points != -1)
                              Text(
                                UiUtils.getTranslatedLabel(context, pointsKey),
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondary
                                      .withOpacity(0.7),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.0,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            if (reviewAssignment.assignment.points != 0 &&
                                reviewAssignment.assignment.points != -1)
                              Text(
                                "${reviewAssignment.points} / ${widget.assignment.points}",
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12.0,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            const SizedBox(
                              height: 7,
                            ),
                            GestureDetector(
                              onTap: () {
                                UiUtils.showBottomSheet(
                                  child: AttachmentBottomsheetContainer(
                                    fromAnnouncementsContainer: false,
                                    studyMaterials: reviewAssignment.file,
                                  ),
                                  context: context,
                                );
                              },
                              child: Text(
                                "${reviewAssignment.file.length} ${UiUtils.getTranslatedLabel(context, attachmentsKey)}",
                                style:  TextStyle(
                                    color: Theme.of(context).colorScheme.secondary),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    assignmentFilterType == acceptedKey || assignmentFilterType == rejectedKey
                        ? const SizedBox()
                        : _buildStudentAssignmentActionButton(
                            rightMargin: boxConstraints.maxWidth * (0.05),
                            width: boxConstraints.maxWidth * (0.2),
                            title:
                                UiUtils.getTranslatedLabel(context, acceptKey),
                            onTap: () {
                              openAcceptAssignmentBottomsheet(reviewAssignment);
                            },
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                          ),
                    assignmentFilterType == acceptedKey || assignmentFilterType == rejectedKey ?
                    const SizedBox() : _buildStudentAssignmentActionButton(
                            rightMargin: boxConstraints.maxWidth * (0.05),
                            width: boxConstraints.maxWidth * (0.2),
                            title:
                                UiUtils.getTranslatedLabel(context, rejectKey),
                            onTap: () {
                              openRejectAssignmentBottomsheet(reviewAssignment);
                            },
                            backgroundColor:
                                Theme.of(context).colorScheme.error,
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

  Widget _buildAssignments(List<ReviewAssignmentssubmition> reviewAssignment) {
    // all key  show All Assignment Reject ,Accept & submmit
    //Status 1 - Accepted
    //Status 2 - Rejected
    //Status 3 - Submitted but not reject
    if (_currentlySelectedAssignmentFilter == allKey) {
      final List<ReviewAssignmentssubmition> accept_assignment =
          reviewAssignment.where((e) => e.status == 1).toList();
      final List<ReviewAssignmentssubmition> reject_assignment =
          reviewAssignment.where((e) => e.status == 2).toList();
      final List<ReviewAssignmentssubmition> submited_assignment =
          reviewAssignment.where((e) => e.status == 0).toList();
      final List<ReviewAssignmentssubmition> resubmitted_assignment =
          reviewAssignment.where((e) => e.status == 3).toList();

      return Column(
        children: [
          ...resubmitted_assignment
              .map(
                (reviewAssignment) => _buildStudentAssignmentDetailsContainer(
                  isAssignmentFilterTypeAll: true,
                  assignmentFilterType: submitKey,
                  reviewAssignment: reviewAssignment,
                ),
              )
              .toList(),
          ...submited_assignment
              .map(
                (reviewAssignment) => _buildStudentAssignmentDetailsContainer(
                  isAssignmentFilterTypeAll: true,
                  assignmentFilterType: submitKey,
                  reviewAssignment: reviewAssignment,
                ),
              )
              .toList(),
          ...accept_assignment
              .map(
                (reviewAssignment) => _buildStudentAssignmentDetailsContainer(
                  isAssignmentFilterTypeAll: true,
                  reviewAssignment: reviewAssignment,
                  assignmentFilterType: acceptedKey,
                ),
              )
              .toList(),
          ...reject_assignment
              .map(
                (reviewAssignment) => _buildStudentAssignmentDetailsContainer(
                  isAssignmentFilterTypeAll: true,
                  assignmentFilterType: rejectedKey,
                  reviewAssignment: reviewAssignment,
                ),
              )
              .toList(),
        ],
      );
    }
    if (_currentlySelectedAssignmentFilter == acceptedKey) {
      //status 1 is Accept Assignment
      final List<ReviewAssignmentssubmition> accepted_assignment =
          reviewAssignment.where((e) => e.status == 1).toList();
      //
      return Column(
        children: [
          ...accepted_assignment
              .map(
                (e) => _buildStudentAssignmentDetailsContainer(
                  isAssignmentFilterTypeAll: false,
                  reviewAssignment: e,
                  assignmentFilterType: acceptedKey,
                ),
              )
              .toList()
        ],
      );
    }
    if (_currentlySelectedAssignmentFilter == rejectedKey) {
      //Status 2 is Reject Assigment
      final List<ReviewAssignmentssubmition> reject_assignment =
          reviewAssignment.where((e) => e.status == 2).toList();
      //
      return Column(
        children: [
          ...reject_assignment
              .map(
                (e) => _buildStudentAssignmentDetailsContainer(
                  isAssignmentFilterTypeAll: false,
                  reviewAssignment: e,
                  assignmentFilterType: rejectedKey,
                ),
              )
              .toList()
        ],
      );
    }
    if (_currentlySelectedAssignmentFilter == submittedKey) {
      // Status 0 is show Assignment Which one is not Accepted of Rejected
      final List<ReviewAssignmentssubmition> submited_assignment =
          reviewAssignment.where((e) => e.status == 0).toList();

      //
      return Column(
        children: [
          ...submited_assignment
              .map(
                (e) => _buildStudentAssignmentDetailsContainer(
                  isAssignmentFilterTypeAll: false,
                  reviewAssignment: e,
                  assignmentFilterType: submitKey,
                ),
              )
              .toList()
        ],
      );
    }

    if (_currentlySelectedAssignmentFilter == reSubmittedKey) {
      //Status 2 is Reject Assigment
      final List<ReviewAssignmentssubmition> resubmitted_assignment =
          reviewAssignment.where((e) => e.status == 3).toList();
      //
      return Column(
        children: [
          ...resubmitted_assignment
              .map(
                (e) => _buildStudentAssignmentDetailsContainer(
                  isAssignmentFilterTypeAll: false,
                  reviewAssignment: e,
                  assignmentFilterType: reSubmittedKey,
                ),
              )
              .toList()
        ],
      );
    }

    return const Column();
  }

  Widget _buildAssignmentListWithFiltersContainer(
    List<ReviewAssignmentssubmition> reviewAssignment,
  ) {
    return ListView(
      padding: EdgeInsets.only(
        top: UiUtils.getScrollViewTopPadding(
          context: context,
          appBarHeightPercentage: UiUtils.appBarSmallerHeightPercentage,
        ),
      ),
      children: [
        _buildAssignmentSubmissionFilters(reviewAssignment),
        const SizedBox(
          height: 20,
        ),
        _buildAssignments(reviewAssignment),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomRefreshIndicator(
            displacment: UiUtils.getScrollViewTopPadding(
              context: context,
              appBarHeightPercentage: UiUtils.appBarSmallerHeightPercentage,
            ),
            onRefreshCallback: () {
              fetchReviewAssignment();
            },
            child: BlocBuilder<ReviewAssignmentCubit, ReviewAssignmentState>(
              bloc: context.read<ReviewAssignmentCubit>(),
              builder: (context, state) {
                if (state is ReviewAssignmentSuccess) {
                  return _buildAssignmentListWithFiltersContainer(
                    state.reviewAssignment,
                  );
                }
                if (state is ReviewAssignmentFailure) {
                  return Center(
                    child: ErrorContainer(
                      errorMessageCode: state.errorMessage,
                      onTapRetry: () {
                        fetchReviewAssignment();
                      },
                    ),
                  );
                }
                return ListView(
                  padding: EdgeInsets.only(
                    top: UiUtils.getScrollViewTopPadding(
                      context: context,
                      appBarHeightPercentage:
                          UiUtils.appBarSmallerHeightPercentage,
                    ),
                  ),
                  children: [
                    LayoutBuilder(
                      builder: (context, boxConstraints) {
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ...List.generate(
                                  4,
                                  (index) => ShimmerLoadingContainer(
                                    child: CustomShimmerContainer(
                                      height: 35,
                                      borderRadius: 10,
                                      width: boxConstraints.maxWidth * 0.20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                    ...List.generate(
                      10,
                      (index) => Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: _buildInformationShimmerLoadingContainer(),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          _buildAppbar(),
        ],
      ),
    );
  }
}
