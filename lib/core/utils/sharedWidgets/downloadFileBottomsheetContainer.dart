
import 'package:madares_app_teacher/core/cubits/downloadfileCubit.dart';
import 'package:madares_app_teacher/core/models/studyMaterial.dart';
import 'package:madares_app_teacher/core/utils/sharedWidgets/bottomSheetTopBarMenu.dart';
import 'package:madares_app_teacher/core/utils/sharedWidgets/customRoundedButton.dart';
import 'package:madares_app_teacher/core/utils/uiUtils.dart';
import 'package:flutter/material.dart';


import 'package:flutter_bloc/flutter_bloc.dart';

import '../labelKeys.dart';

class DownloadFileBottomsheetContainer extends StatefulWidget {
  final StudyMaterial studyMaterial;
  const DownloadFileBottomsheetContainer({
    Key? key,
    required this.studyMaterial,
  }) : super(key: key);

  @override
  State<DownloadFileBottomsheetContainer> createState() =>
      _DownloadFileBottomsheetContainerState();
}

class _DownloadFileBottomsheetContainerState
    extends State<DownloadFileBottomsheetContainer> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      context.read<DownloadFileCubit>().downloadFile(
            studyMaterial: widget.studyMaterial,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (_) {
        if (context.read<DownloadFileCubit>().state is DownloadFileInProgress) {
          context.read<DownloadFileCubit>().cancelDownloadProcess();
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BottomSheetTopBarMenu(
            onTapCloseButton: () {
              if (context.read<DownloadFileCubit>().state
                  is DownloadFileInProgress) {
                context.read<DownloadFileCubit>().cancelDownloadProcess();
              }
              Navigator.of(context).pop();
            },
            title: UiUtils.getTranslatedLabel(context, fileDownloadingKey),
          ),

          //
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: UiUtils.bottomSheetHorizontalContentPadding,
            ),
            child: Column(
              children: [
                Text(
                  widget.studyMaterial.fileName,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * (0.0125),
                ),
                BlocConsumer<DownloadFileCubit, DownloadFileState>(
                  listener: (context, state) {
                    if (state is DownloadFileSuccess) {
                      Navigator.of(context).pop({
                        "error": false,
                        "filePath": state.downloadedFileUrl
                      });
                    } else if (state is DownloadFileFailure) {
                      Navigator.of(context).pop({
                        "error": true,
                        "message": state.isMessageKey
                            ? UiUtils.getTranslatedLabel(
                                context, state.errorMessage)
                            : state.errorMessage
                      });
                    }
                  },
                  builder: (context, state) {
                    if (state is DownloadFileInProgress) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 6,
                            child: LayoutBuilder(
                              builder: (context, boxConstraints) {
                                return Stack(
                                  children: [
                                    UiUtils.buildProgressContainer(
                                      width: boxConstraints.maxWidth,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground
                                          .withOpacity(0.5),
                                    ),
                                    UiUtils.buildProgressContainer(
                                      width: boxConstraints.maxWidth *
                                          state.uploadedPercentage *
                                          0.01,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "${state.uploadedPercentage.toStringAsFixed(2)} %",
                          )
                        ],
                      );
                    }
                    return const SizedBox();
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * (0.025),
                ),
                CustomRoundedButton(
                  onTap: () {
                    context.read<DownloadFileCubit>().cancelDownloadProcess();
                    Navigator.of(context).pop();
                  },
                  height: 40,
                  textSize: 16.0,
                  widthPercentage: 0.35,
                  titleColor: Theme.of(context).scaffoldBackgroundColor,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  buttonTitle: UiUtils.getTranslatedLabel(context, cancelKey),
                  showBorder: false,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * (0.025),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
