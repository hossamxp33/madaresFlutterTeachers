import 'package:madares_app_teacher/core/utils/labelKeys.dart';
import 'package:madares_app_teacher/features/chat/presentation/manager/chatUsersCubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessageNumber extends StatefulWidget {
  const MessageNumber({
    super.key,
  });

  static route(RouteSettings routeSettings) {
    return CupertinoPageRoute(
      builder: (_) => const MessageNumber(),
    );
  }

  @override
  State<MessageNumber> createState() => _MessageNumberState();
}

class _MessageNumberState extends State<MessageNumber> {
  final ValueNotifier<String> _selectedTabTitle = ValueNotifier(studentsKey);

  late final ScrollController _studentScrollController = ScrollController()
    ..addListener(_studentScrollListener);

  late final ScrollController _parentScrollController = ScrollController()
    ..addListener(_parentScrollListener);

  void _parentScrollListener() {
    if (_parentScrollController.hasClients) {
      if (_parentScrollController.offset >=
          _parentScrollController.position.maxScrollExtent) {
        if (context.read<ParentChatUserCubit>().hasMore()) {
          context.read<ParentChatUserCubit>().fetchMoreChatUsers();
        }
      }
    }
  }

  void _studentScrollListener() {
    if (_studentScrollController.hasClients) {
      if (_studentScrollController.offset >=
          _studentScrollController.position.maxScrollExtent) {
        if (context.read<StudentChatUsersCubit>().hasMore()) {
          context.read<StudentChatUsersCubit>().fetchMoreChatUsers();
        }
      }
    }
  }

  @override
  void dispose() {
    _studentScrollController.removeListener(_studentScrollListener);
    _parentScrollController.removeListener(_parentScrollListener);
    _parentScrollController.dispose();
    _studentScrollController.dispose();

    super.dispose();
  }

  void fetchChatUsers() {
    if (_selectedTabTitle.value == parentsKey) {
      context.read<ParentChatUserCubit>().fetchChatUsers();
    } else {
      context.read<StudentChatUsersCubit>().fetchChatUsers();
    }
  }

  _buildUnreadCounter({required int count}) {
    return count == 0
        ? const SizedBox.shrink()
        : Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).colorScheme.primary.withOpacity(.8),
            ),
            margin: const EdgeInsetsDirectional.only(start: 5),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              (count > 999) ? "999+" : count.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        BlocBuilder<StudentChatUsersCubit, ChatUsersState>(
          builder: (context, studentState) {
            return BlocBuilder<ParentChatUserCubit, ChatUsersState>(
              builder: (context, parentState) {
                int totalUnreadCount = 0;

                if (studentState is ChatUsersFetchSuccess) {
                  totalUnreadCount += studentState.totalUnreadUsers;
                }

                if (parentState is ChatUsersFetchSuccess) {
                  totalUnreadCount += parentState.totalUnreadUsers;
                }

                return _buildUnreadCounter(count: totalUnreadCount);
              },
            );
          },
        ),
      ],
    );
  }
}
