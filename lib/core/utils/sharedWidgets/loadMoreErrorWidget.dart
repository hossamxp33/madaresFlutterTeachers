// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:madares_app_teacher/core/utils/labelKeys.dart';
import 'package:madares_app_teacher/core/utils/uiUtils.dart';
import 'package:flutter/material.dart';

import '../styles/colors.dart';

class LoadMoreErrorWidget extends StatelessWidget {
  final Function() onTapRetry;
  const LoadMoreErrorWidget({
    Key? key,
    required this.onTapRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapRetry,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
           Icon(
            Icons.refresh,
            color: Theme.of(context).colorScheme.primary,
            size: 16,
          ),
          const SizedBox(
            width: 5,
          ),
          Flexible(
            child: Text(
              UiUtils.getTranslatedLabel(
                context,
                errorLoadingMoreTapToRetryKey,
              ),
              style:  TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 12,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
