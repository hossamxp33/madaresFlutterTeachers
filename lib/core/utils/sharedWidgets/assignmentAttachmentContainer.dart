
import 'package:madares_app_teacher/core/cubits/deleteStudyMaterialCubit.dart';
import 'package:madares_app_teacher/core/models/studyMaterial.dart';
import 'package:madares_app_teacher/core/repositories/studyMaterialRepositoy.dart';
import 'package:madares_app_teacher/core/utils/labelKeys.dart';
import 'package:madares_app_teacher/core/utils/sharedWidgets/confirmDeleteDialog.dart';
import 'package:madares_app_teacher/core/utils/sharedWidgets/deleteButton.dart';
import 'package:madares_app_teacher/core/utils/styles/colors.dart';
import 'package:madares_app_teacher/core/utils/uiUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AssignmentAttachmentContainer extends StatelessWidget {
  final bool showDeleteButton;
  final StudyMaterial studyMaterial;
  final Function(int)? onDeleteCallback;
  const AssignmentAttachmentContainer({
    Key? key,
    required this.showDeleteButton,
    required this.studyMaterial,
    this.onDeleteCallback,
  }) : super(key: key);

  Widget _buildFileName(BuildContext context) {
    return GestureDetector(
      onTap: () {
        UiUtils.viewOrDownloadStudyMaterial(
            context: context,
            storeInExternalStorage: true,
            studyMaterial: studyMaterial);
      },
      child: Text(
        studyMaterial.fileName,
        style:  TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w500,
          height: 1.25,
          fontSize: 13.5,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DeleteStudyMaterialCubit(StudyMaterialRepository()),
      child: Builder(
        builder: (context) {
          return BlocConsumer<DeleteStudyMaterialCubit,
              DeleteStudyMaterialState>(
            listener: (context, state) {
              //
              if (state is DeleteStudyMaterialSuccess) {
                onDeleteCallback?.call(studyMaterial.id);
              } else if (state is DeleteStudyMaterialFailure) {
                UiUtils.showBottomToastOverlay(
                  context: context,
                  //
                  errorMessage:
                      UiUtils.getTranslatedLabel(context, unableToDeleteKey),
                  backgroundColor: Theme.of(context).colorScheme.error,
                );
              }
            },
            builder: (context, state) {
              return Opacity(
                opacity: state is DeleteStudyMaterialInProgress ? 0.5 : 1.0,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  width: MediaQuery.of(context).size.width * (0.85),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 15),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: LayoutBuilder(
                    builder: (context, boxConstraints) {
                      return showDeleteButton
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: _buildFileName(context)),
                                DeleteButton(
                                  onTap: () {
                                    if (state
                                        is DeleteStudyMaterialInProgress) {
                                      return;
                                    }
                                    showDialog<bool>(
                                      context: context,
                                      builder: (_) =>
                                          const ConfirmDeleteDialog(),
                                    ).then((value) {
                                      if (value != null && value) {
                                        context
                                            .read<DeleteStudyMaterialCubit>()
                                            .deleteStudyMaterial(
                                              fileId: studyMaterial.id,
                                            );
                                      }
                                    });
                                  },
                                )
                              ],
                            )
                          : _buildFileName(context);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
