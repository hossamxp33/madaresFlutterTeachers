<<<<<<< HEAD
import 'package:eschool_teacher/core/utils/sharedWidgets/svgButton.dart';
import 'package:eschool_teacher/core/utils/uiUtils.dart';
=======
import 'package:madares_app_teacher/core/utils/sharedWidgets/svgButton.dart';
import 'package:madares_app_teacher/core/utils/uiUtils.dart';
>>>>>>> f8116bb26ff7cdb9462a79241b86162b4f4e9bdc
import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  final Function? onTap;
  final double? topPadding;
  final AlignmentDirectional? alignmentDirectional;
  const CustomBackButton(
      {Key? key, this.onTap, this.topPadding, this.alignmentDirectional,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignmentDirectional ?? AlignmentDirectional.topStart,
      child: Padding(
        padding: EdgeInsetsDirectional.only(
          top: topPadding ?? 0,
          start: UiUtils.screenContentHorizontalPadding,
        ),
        child: SvgButton(
            onTap: () {
              if (onTap != null) {
                onTap?.call();
              } else {
                Navigator.of(context).pop();
              }
            },
            svgIconUrl: UiUtils.getBackButtonPath(context),),
      ),
    );
  }
}
