<<<<<<< HEAD
import 'package:eschool_teacher/core/utils/uiUtils.dart';
=======
import 'package:madares_app_teacher/core/utils/uiUtils.dart';
>>>>>>> f8116bb26ff7cdb9462a79241b86162b4f4e9bdc
import 'package:flutter/material.dart';

//It will be in use when using appbar with bigger height percentage
class AppBarTitleContainer extends StatelessWidget {
  final BoxConstraints boxConstraints;
  final String title;
  const AppBarTitleContainer(
      {Key? key, required this.boxConstraints, required this.title,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: boxConstraints.maxWidth * (0.6),
        child: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Theme.of(context).scaffoldBackgroundColor,
              fontSize: UiUtils.screenTitleFontSize,),
        ),
      ),
    );
  }
}
