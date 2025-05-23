import 'package:madares_app_teacher/core/utils/uiUtils.dart';
import 'package:flutter/material.dart';

import '../labelKeys.dart';

class DismissibleSecondaryBackgroundContainer extends StatelessWidget {
  const DismissibleSecondaryBackgroundContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.error,),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(
            Icons.delete,
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            UiUtils.getTranslatedLabel(context, deleteKey),
            style: TextStyle(color: Theme.of(context).scaffoldBackgroundColor),
          ),
        ],
      ),
    );
  }
}
