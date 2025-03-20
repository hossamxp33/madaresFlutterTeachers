<<<<<<< HEAD
import 'package:eschool_teacher/core/utils/uiUtils.dart';
=======
import 'package:madares_app_teacher/core/utils/uiUtils.dart';
>>>>>>> f8116bb26ff7cdb9462a79241b86162b4f4e9bdc
import 'package:flutter/material.dart';

//It will be in use when using appbar with bigger height percentage
class AppBarSubTitleContainer extends StatelessWidget {
  final String subTitle;
  final BoxConstraints boxConstraints;
  final double? topPaddingPercentage;
  const AppBarSubTitleContainer(
      {Key? key,
      required this.boxConstraints,
      required this.subTitle,
      this.topPaddingPercentage,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(
            top: boxConstraints.maxHeight * ((topPaddingPercentage ?? 0.085)) +
                UiUtils.screenSubTitleFontSize,),
        child: Text(
          subTitle,
          style: TextStyle(
              fontSize: UiUtils.screenSubTitleFontSize,
              color: Theme.of(context).scaffoldBackgroundColor,),
        ),
      ),
    );
  }
}
