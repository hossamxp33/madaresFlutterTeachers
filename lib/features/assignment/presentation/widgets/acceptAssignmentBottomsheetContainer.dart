import 'package:madares_app_teacher/features/assignment/data/models/assignment.dart';
import 'package:madares_app_teacher/features/assignment/presentation/manager/editreviewassignmetcubit.dart';
import 'package:madares_app_teacher/features/assignments/data/models/reviewAssignmentssubmition.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/labelKeys.dart';
import '../../../../core/utils/sharedWidgets/bottomSheetTextFiledContainer.dart';
import '../../../../core/utils/sharedWidgets/bottomSheetTopBarMenu.dart';
import '../../../../core/utils/sharedWidgets/customCircularProgressIndicator.dart';
import '../../../../core/utils/sharedWidgets/customRoundedButton.dart';
import '../../../../core/utils/uiUtils.dart';



class AcceptAssignmentBottomsheetContainer extends StatefulWidget {
  final Assignment assignment;
  final ReviewAssignmentssubmition reviewAssignment;
  const AcceptAssignmentBottomsheetContainer({
    Key? key,
    required this.assignment,
    required this.reviewAssignment,
  }) : super(key: key);

  @override
  State<AcceptAssignmentBottomsheetContainer> createState() =>
      _AcceptAssignmentBottomsheetContainerState();
}

class _AcceptAssignmentBottomsheetContainerState
    extends State<AcceptAssignmentBottomsheetContainer> {
  late final TextEditingController _remarkTextEditingController = TextEditingController();

  late final TextEditingController _pointsTextEditingController =   TextEditingController();

  void showErrorMessage(String errorMessage) {
    UiUtils.showBottomToastOverlay(
      context: context,
      errorMessage: errorMessage,
      backgroundColor: Theme.of(context).colorScheme.error,
    );
  }

  void updateAssignment() {
    if (_remarkTextEditingController.text.trim().isEmpty) {
      showErrorMessage(
        UiUtils.getTranslatedLabel(context, pleaseEnterRemarkkey),
      );
    }
    if (_pointsTextEditingController.text.trim().isEmpty) {
      showErrorMessage(
        UiUtils.getTranslatedLabel(context, pleaseEnterPointskey),
      );
    }
    if (int.parse(_pointsTextEditingController.text) <=
        widget.assignment.points) {
      context.read<EditReviewAssignmetCubit>().updateReviewAssignmet(
            reviewAssignmetId: widget.reviewAssignment.id,
            reviewAssignmentStatus: 1,
            reviewAssignmentPoints: (widget.assignment.points == 0 &&
                    widget.assignment.points == -1)
                ? "0"
                : _pointsTextEditingController.text.trim(),
            reviewAssignmentFeedBack: _remarkTextEditingController.text.trim(),
          );
    } else {
      UiUtils.showBottomToastOverlay(
        context: context,
        errorMessage:
            UiUtils.getTranslatedLabel(context, pleaseEnterlessPointskey),
        backgroundColor: Theme.of(context).colorScheme.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BottomSheetTopBarMenu(
            onTapCloseButton: () {
              Navigator.of(context).pop();
            },
            title: UiUtils.getTranslatedLabel(context, acceptKey),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: UiUtils.bottomSheetHorizontalContentPadding,
            ),
            child: Column(
              children: [
                Text(
                  "${UiUtils.getTranslatedLabel(context, pointsKey)} : ${widget.assignment.points}",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.w600,),
                ),
                // BottomSheetTextFieldContainer(
                //   hintText: UiUtils.getTranslatedLabel(context, pleaseEnterPointskey),
                //   maxLines: 2,
                //   textEditingController: _pointsTextEditingController,
                //   keyboardType: TextInputType.number,
                // ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * (0.0125),
                ),
                BottomSheetTextFieldContainer(
                  hintText: UiUtils.getTranslatedLabel(context, addRemarkKey),
                  maxLines: 2,
                  textEditingController: _remarkTextEditingController,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * (0.025),
                ),
                // if (widget.assignment.points != 0 &&
                //     widget.assignment.points != -1)
                  BottomSheetTextFieldContainer(
                    hintText: UiUtils.getTranslatedLabel(context, pleaseEnterPointskey),
                    maxLines: 1,
                    textEditingController: _pointsTextEditingController,
                    keyboardType: TextInputType.number,
                  ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * (0.025),
                ),
                BlocConsumer<EditReviewAssignmetCubit,
                    EditReviewAssignmetState>(
                  bloc: context.read<EditReviewAssignmetCubit>(),
                  listener: (context, state) {
                    if (state is EditReviewAssignmetSuccess) {
                      UiUtils.showBottomToastOverlay(
                        context: context,
                        errorMessage: UiUtils.getTranslatedLabel(
                          context,
                          reviewAssignmentsucessfullukey,
                        ),
                        backgroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                      );
                      //TOTO
                      Navigator.of(context).pop(
                        widget.reviewAssignment.copywith(
                          id: widget.reviewAssignment.id,
                          feedback: _remarkTextEditingController.text.trim(),
                          points: int.parse(_pointsTextEditingController.text.trim(),),
                          status: 1,
                        ),
                      );
                    }
                    if (state is EditReviewAssignmetFailure) {
                      UiUtils.showBottomToastOverlay(
                        context: context,
                        errorMessage: UiUtils.getTranslatedLabel(
                          context,
                          failureAssignmentReviewkey,
                        ),
                        backgroundColor: Theme.of(context).colorScheme.error,
                      );
                      Navigator.of(context).pop();
                    }
                  },
                  builder: (context, state) {
                    return CustomRoundedButton(
                      height: UiUtils.bottomSheetButtonHeight,
                      widthPercentage: UiUtils.bottomSheetButtonWidthPercentage,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      buttonTitle: UiUtils.getTranslatedLabel(
                        context,
                        submitKey,
                      ),
                      showBorder: false,
                      child: state is EditReviewAssignmetInProgress
                          ? const CustomCircularProgressIndicator(
                              strokeWidth: 2,
                              widthAndHeight: 20,
                            )
                          : null,
                      onTap: () {
                        FocusScope.of(context).unfocus();

                        updateAssignment();
                      },
                    );
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * (0.05),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
