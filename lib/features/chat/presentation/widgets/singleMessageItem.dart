import 'package:any_link_preview/any_link_preview.dart';
import 'package:madares_app_teacher/app/routes.dart';
import 'package:madares_app_teacher/core/models/studyMaterial.dart';
import 'package:madares_app_teacher/core/utils/labelKeys.dart';
import 'package:madares_app_teacher/core/utils/sharedWidgets/commonImageWidget.dart';
import 'package:madares_app_teacher/core/utils/sharedWidgets/customCircularProgressIndicator.dart';
import 'package:madares_app_teacher/core/utils/uiUtils.dart';
import 'package:madares_app_teacher/features/chat/data/models/chatMessage.dart';
import 'package:madares_app_teacher/features/chat/presentation/widgets/messageItemComponents.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/utils/styles/colors.dart';

class SingleChatMessageItem extends StatefulWidget {
  final ChatMessage chatMessage;
  final bool isLoading;
  final bool isError;
  final int currentUserId;
  final Function(ChatMessage chatMessage) onRetry;
  final bool showTime;

  const SingleChatMessageItem(
      {super.key,
      required this.chatMessage,
      required this.isLoading,
      required this.isError,
      required this.onRetry,
      required this.currentUserId,
      this.showTime = true});

  @override
  State<SingleChatMessageItem> createState() => _SingleChatMessageItemState();
}

class _SingleChatMessageItemState extends State<SingleChatMessageItem> {
  final double _messageItemBorderRadius = 12;


  final ValueNotifier _linkAddNotifier = ValueNotifier("");

  @override
  void dispose() {
    _linkAddNotifier.dispose();
    super.dispose();
  }

  _buildTextMessageWidget(
      {required BuildContext context,
      required BoxConstraints constraints,
      required ChatMessage textMessage}) {

    return Row(
      mainAxisAlignment: textMessage.senderId != widget.currentUserId
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (textMessage.senderId == widget.currentUserId)
          TriangleContainer(
            isFlipped: Directionality.of(context) == TextDirection.rtl,
            size: const Size(10, 10),
            color: Theme.of(context).colorScheme.primary,
          ),
        Flexible(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: constraints.maxWidth * 0.8,
            ),
            clipBehavior: Clip.antiAlias,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: textMessage.senderId != widget.currentUserId
                  ? Theme.of(context).colorScheme.tertiary.withOpacity(0.05)
                  : Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadiusDirectional.only(
                topEnd: textMessage.senderId != widget.currentUserId
                    ? Radius.zero
                    : Radius.circular(_messageItemBorderRadius),
                topStart: textMessage.senderId != widget.currentUserId
                    ? Radius.circular(_messageItemBorderRadius)
                    : Radius.zero,
                bottomEnd: Radius.circular(_messageItemBorderRadius),
                bottomStart: Radius.circular(_messageItemBorderRadius),
              ),
            ),
            child: Column(
              crossAxisAlignment: textMessage.senderId != widget.currentUserId
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                ValueListenableBuilder(
                    valueListenable: _linkAddNotifier,
                    builder: (context, dynamic value, c) {
                      if (value == null) {
                        return const SizedBox.shrink();
                      }
                      return FutureBuilder(
                        future: AnyLinkPreview.getMetadata(link: value),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.data == null) {
                              return const SizedBox.shrink();
                            }
                            return LinkPreviw(
                              snapshot: snapshot,
                              link: value,
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      );
                    }),
                SelectableText.rich(
                  TextSpan(
                    style: TextStyle(
                      color: textMessage.senderId != widget.currentUserId
                          ? Colors.black
                          : Colors.white,
                    ),
                    children:
                        replaceLink(text: textMessage.message).map((data) {
                      // This handles link recognition and message formatting
                      if (isLink(data)) {
                        _linkAddNotifier.value = data;

                        return TextSpan(
                          text: data,
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              if (await canLaunchUrl(Uri.parse(data))) {
                                await launchUrl(Uri.parse(data));
                              }
                            },
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: textMessage.senderId != widget.currentUserId
                                ? Theme.of(context).colorScheme.primary
                                : Colors.black,
                          ),
                        );
                      }
                      return TextSpan(
                        text: "",
                        children: matchAstric(data).map((text) {
                          if (text.toString().startsWith("*") &&
                              text.toString().endsWith("*")) {
                            return TextSpan(
                                text: text.replaceAll("*", ""),
                                style: TextStyle(
                                  color: textMessage.senderId !=
                                          widget.currentUserId
                                      ? Colors.black
                                      : Colors.white,
                                  fontWeight: FontWeight.bold,
                                ));
                          }
                          return TextSpan(
                            text: text,
                            style: TextStyle(
                              color:
                                  textMessage.senderId != widget.currentUserId
                                      ? Colors.black
                                      : Colors.white,
                            ),
                          );
                        }).toList(),
                        style: TextStyle(
                          color: textMessage.senderId != widget.currentUserId
                              ? Colors.black
                              : Colors.white,
                        ),
                      );
                    }).toList(),
                  ),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
        ),
        if (textMessage.senderId != widget.currentUserId)
          TriangleContainer(
            isFlipped: !(Directionality.of(context) == TextDirection.rtl),
            size: const Size(10, 10),
            color: Theme.of(context).colorScheme.tertiary.withOpacity(0.05),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: widget.showTime ? 10 : 5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.showTime)
            Align(
              alignment: widget.chatMessage.senderId != widget.currentUserId
                  ? AlignmentDirectional.centerEnd
                  : AlignmentDirectional.centerStart,
              child: Text(
                UiUtils.formatTimeWithDateTime(
                  widget.chatMessage.sendOrReceiveDateTime,
                  is24: false,
                ),
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.secondary.withOpacity(0.4),
                ),
              ),
            ),
          LayoutBuilder(
            builder: (context, constraints) {
              return Align(
                alignment: widget.chatMessage.senderId != widget.currentUserId
                    ? AlignmentDirectional.centerEnd
                    : AlignmentDirectional.centerStart,
                child: widget.chatMessage.messageType ==
                        ChatMessageType.textMessage
                    ? _buildTextMessageWidget(
                        context: context,
                        constraints: constraints,
                        textMessage: widget.chatMessage)
                    : widget.chatMessage.messageType ==
                            ChatMessageType.imageMessage
                        ? _buildImageMessageWidget(
                            context: context,
                            constraints: constraints,
                            imageMessage: widget.chatMessage)
                        : widget.chatMessage.messageType ==
                                ChatMessageType.fileMessage
                            ? _buildFileMessageWidget(
                                context: context,
                                constraints: constraints,
                                fileMessage: widget.chatMessage)
                            : const SizedBox.shrink(),
              );
            },
          ),
          Align(
            alignment: widget.chatMessage.senderId != widget.currentUserId
                ? AlignmentDirectional.centerEnd
                : AlignmentDirectional.centerStart,
            child: widget.isLoading
                ?  Padding(
                    padding: EdgeInsets.all(5),
                    child: SizedBox(
                      height: 12,
                      width: 12,
                      child: CustomCircularProgressIndicator(
                        indicatorColor: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  )
                : widget.isError
                    ? GestureDetector(
                        onTap: () {
                          widget.onRetry(widget.chatMessage);
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                             Icon(
                              Icons.refresh,
                              size: 10,
                              color: Theme.of(context).colorScheme.error,
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            Flexible(
                              child: Text(
                                UiUtils.getTranslatedLabel(
                                    context, errorSendingMessageRetrykey),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style:  TextStyle(
                                  fontSize: 10,
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  _buildImageMessageWidget(
      {required BuildContext context,
      required BoxConstraints constraints,
      required ChatMessage imageMessage}) {
    return SizedBox(
      width: constraints.maxWidth * 0.8,
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        // Invert sender/receiver logic
        alignment: imageMessage.senderId != widget.currentUserId
            ? WrapAlignment.end
            : WrapAlignment.start,
        children: List.generate(
          imageMessage.files.length,
          (index) {
            final imagePath = imageMessage.files[index];
            return GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(
                  Routes.imageFileView,
                  arguments: {
                    "studyMaterial": StudyMaterial.fromURL(imagePath),
                    "isFile": imageMessage.isLocallyStored,
                    "multiStudyMaterial": imageMessage.files.length > 1
                        ? imageMessage.files
                            .map<StudyMaterial>((e) => StudyMaterial.fromURL(e))
                            .toList()
                        : <StudyMaterial>[],
                    "initialPage": index == 0 ? null : index,
                  },
                );
              },
              child: Container(
                width: (constraints.maxWidth * 0.8) / 2 - 10,
                height: (constraints.maxWidth * 0.8) / 2 - 10,
                decoration: BoxDecoration(
                  borderRadius: BorderRadiusDirectional.only(
                    // Invert the border-radius logic
                    topEnd: imageMessage.senderId != widget.currentUserId
                        ? Radius.zero
                        : Radius.circular(_messageItemBorderRadius),
                    topStart: imageMessage.senderId != widget.currentUserId
                        ? Radius.circular(_messageItemBorderRadius)
                        : Radius.zero,
                    bottomEnd: Radius.circular(_messageItemBorderRadius),
                    bottomStart: Radius.circular(_messageItemBorderRadius),
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: CommonImageWidget(
                    isFile: imageMessage.isLocallyStored, imagePath: imagePath),
              ),
            );
          },
        ),
      ),
    );
  }

  _buildFileMessageWidget(
      {required BuildContext context,
      required BoxConstraints constraints,
      required ChatMessage fileMessage}) {
    return SizedBox(
      width: constraints.maxWidth * 0.7,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          fileMessage.files.length,
          (index) {
            final filePath = fileMessage.files[index];
            bool isPdf = filePath.split(".").last.toLowerCase() == "pdf";
            return GestureDetector(
              onTap: () {
                if (widget.chatMessage.isLocallyStored) {
                  if (isPdf) {
                    Navigator.of(context).pushNamed(
                      Routes.pdfFileView,
                      arguments: {
                        "studyMaterial": StudyMaterial.fromURL(filePath),
                        "isFile": true,
                      },
                    );
                  } else {
                    UiUtils.openDownloadBottomsheet(
                      context: context,
                      studyMaterial: StudyMaterial.fromURL(filePath),
                    );
                  }
                } else {
                  if (isPdf) {
                    Navigator.of(context).pushNamed(
                      Routes.pdfFileView,
                      arguments: {
                        "studyMaterial": StudyMaterial.fromURL(filePath),
                      },
                    );
                  } else {
                    UiUtils.openDownloadBottomsheet(
                      context: context,
                      studyMaterial: StudyMaterial.fromURL(filePath),
                    );
                  }
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadiusDirectional.only(
                    // Invert the border-radius logic
                    topEnd: fileMessage.senderId != widget.currentUserId
                        ? Radius.zero
                        : Radius.circular(_messageItemBorderRadius),
                    topStart: fileMessage.senderId != widget.currentUserId
                        ? Radius.circular(_messageItemBorderRadius)
                        : Radius.zero,
                    bottomEnd: Radius.circular(_messageItemBorderRadius),
                    bottomStart: Radius.circular(_messageItemBorderRadius),
                  ),
                  color: Theme.of(context).colorScheme.primary,
                ),
                clipBehavior: Clip.antiAlias,
                child: SizedBox(
                  height: 60,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: SizedBox(
                          height: 40,
                          width: 40,
                          child: SvgPicture.asset(
                            UiUtils.getImagePath(isPdf
                                ? "pdf_file_message.svg"
                                : "any_file_message.svg"),
                            fit: BoxFit.contain,
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          height: double.maxFinite,
                          color: UiUtils.getColorScheme(context).background,
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            filePath.split("/").last.toString(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
