// ignore_for_file: public_member_api_docs, sort_constructors_first

<<<<<<< HEAD
import 'package:eschool_teacher/core/utils/labelKeys.dart';
import 'package:eschool_teacher/core/utils/uiUtils.dart';
=======
import 'package:madares_app_teacher/core/utils/labelKeys.dart';
import 'package:madares_app_teacher/core/utils/uiUtils.dart';
>>>>>>> f8116bb26ff7cdb9462a79241b86162b4f4e9bdc
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
<<<<<<< HEAD
          const Icon(
            Icons.refresh,
            color: primaryColor,
=======
           Icon(
            Icons.refresh,
            color: Theme.of(context).colorScheme.primary,
>>>>>>> f8116bb26ff7cdb9462a79241b86162b4f4e9bdc
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
<<<<<<< HEAD
              style: const TextStyle(
                color: primaryColor,
=======
              style:  TextStyle(
                color: Theme.of(context).colorScheme.primary,
>>>>>>> f8116bb26ff7cdb9462a79241b86162b4f4e9bdc
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
