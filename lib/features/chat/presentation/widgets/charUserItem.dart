import 'package:madares_app_teacher/app/routes.dart';
import 'package:madares_app_teacher/core/utils/styles/colors.dart';
import 'package:madares_app_teacher/core/utils/uiUtils.dart';
import 'package:madares_app_teacher/features/chat/data/models/chatUser.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

import '../../../../core/utils/labelKeys.dart';
import '../../../../core/utils/sharedWidgets/customUserProfileImageWidget.dart';

class ChatUserItemWidget extends StatelessWidget {
  final ChatUser chatUser;
  final bool showCount;
   const ChatUserItemWidget(
      {super.key, required this.chatUser, this.showCount = true});

  final double _chatUserContainerHeight = 80;
//note: opacity is used in UI with this color

  _profileImageBuilder({required String imageUrl}) {
    return Container(
      clipBehavior: Clip.antiAlias,
      height: 50,
      width: 50,
      decoration: BoxDecoration(
          shape: BoxShape.circle, border: Border.all(color: Colors.black45)),
      child: CustomUserProfileImageWidget(
        profileUrl: imageUrl,
        color: Colors.black,
      ),
    );
  }

  String _getDateTimeTextForLastMessage(
      {required BuildContext context, required DateTime dateTime}) {
    if (dateTime.isToday()) {
      return UiUtils.formatTimeWithDateTime(dateTime, is24: false);
    } else if (dateTime.isYesterday()) {
      return UiUtils.getTranslatedLabel(context, yesterdayKey);
    } else if (dateTime.isCurrentYear()) {
      return DateFormat("dd MMM").format(dateTime);
    } else {
      return DateFormat("dd MMM yyyy").format(dateTime);
    }
  }

  _buildUnreadCounter({required int count,required BuildContext context} ) {
    final Color _unreadCountBackgroundColor =
        Theme.of(context).colorScheme.primary;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: _unreadCountBackgroundColor.withOpacity(.8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        (count > 999) ? "999+" : count.toString(),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color _containerActiveColor = Theme.of(context).colorScheme.primaryContainer;
    final Color _containerInactiveColor =
        Theme.of(context).colorScheme.secondary; //note: opacity is used in UI with this color

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: MediaQuery.of(context).size.width *
            UiUtils.screenContentHorizontalPaddingPercentage,
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, Routes.chatMessages, arguments: {
            "chatUser": chatUser,
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: _chatUserContainerHeight,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            boxShadow: !chatUser.hasUnreadMessages
                ? null
                : [
                    const BoxShadow(
                      color: Colors.black12,
                      spreadRadius: 0.5,
                      blurRadius: 10,
                    )
                  ],
            color: !chatUser.hasUnreadMessages
                ? _containerInactiveColor.withOpacity(0.05)
                : _containerActiveColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _profileImageBuilder(
                imageUrl: chatUser.profileUrl,
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            chatUser.userName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        if (chatUser.lastMessage != null)
                          Text(
                            _getDateTimeTextForLastMessage(
                              context: context,
                              dateTime:
                                  chatUser.lastMessage!.sendOrReceiveDateTime,
                            ),
                            style: const TextStyle(fontSize: 12),
                          ),
                      ],
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Container(
                      constraints: const BoxConstraints(
                          minHeight:
                              25), //min height to not look bad when there is no notification count
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              chatUser.hasUnreadMessages && showCount
                                  ? ((chatUser.lastMessage?.message.isEmpty ??
                                              true) &&
                                          (chatUser.lastMessage?.files
                                                  .isNotEmpty ??
                                              false))
                                      ? "${chatUser.lastMessage?.files.length.toString()} ${UiUtils.getTranslatedLabel(context, filesReceivedKey)}"
                                      : chatUser.lastMessage?.message ?? ""
                                  : chatUser.isParent
                                      ? "${UiUtils.getTranslatedLabel(context, childrenKey)} : ${chatUser.childrenNames}"
                                      : "${UiUtils.getTranslatedLabel(context, classKey)} : ${chatUser.className}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          if (chatUser.hasUnreadMessages && showCount)
                            _buildUnreadCounter(
                                count: chatUser.unreadNotificationsCount,context: context),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
