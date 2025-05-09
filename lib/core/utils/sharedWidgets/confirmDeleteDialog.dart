
import 'package:madares_app_teacher/core/utils/labelKeys.dart';
import 'package:madares_app_teacher/core/utils/uiUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConfirmDeleteDialog extends StatelessWidget {
  const ConfirmDeleteDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        CupertinoButton(
          child: Text(
            UiUtils.getTranslatedLabel(context, yesKey),
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
        CupertinoButton(
          child: Text(
            UiUtils.getTranslatedLabel(context, noKey),
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
      backgroundColor: Colors.white,
      content:
          Text(UiUtils.getTranslatedLabel(context, deleteDialogMessageKey)),
      title: Text(UiUtils.getTranslatedLabel(context, deleteDialogTitleKey)),
    );
  }
}
