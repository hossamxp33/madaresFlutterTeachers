<<<<<<< HEAD
import 'package:eschool_teacher/core/utils/labelKeys.dart';
import 'package:eschool_teacher/core/utils/uiUtils.dart';
=======
import 'package:madares_app_teacher/core/utils/labelKeys.dart';
import 'package:madares_app_teacher/core/utils/uiUtils.dart';
>>>>>>> f8116bb26ff7cdb9462a79241b86162b4f4e9bdc
import 'package:flutter/material.dart';

class DismissibleBackgroundContainer extends StatelessWidget {
  const DismissibleBackgroundContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.onPrimary,),
      child: Row(
        children: [
          Icon(
            Icons.edit,
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            UiUtils.getTranslatedLabel(context, editKey),
            style: TextStyle(color: Theme.of(context).scaffoldBackgroundColor),
          ),
        ],
      ),
    );
  }
}
