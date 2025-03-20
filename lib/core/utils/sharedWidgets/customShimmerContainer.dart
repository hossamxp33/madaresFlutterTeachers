
<<<<<<< HEAD
import 'package:eschool_teacher/core/utils/styles/colors.dart';
import 'package:eschool_teacher/core/utils/uiUtils.dart';
=======
import 'package:madares_app_teacher/core/utils/styles/colors.dart';
import 'package:madares_app_teacher/core/utils/uiUtils.dart';
>>>>>>> f8116bb26ff7cdb9462a79241b86162b4f4e9bdc
import 'package:flutter/material.dart';

class CustomShimmerContainer extends StatelessWidget {
  final double? height;
  final double? width;
  final double? borderRadius;
  final BorderRadiusGeometry? customBorderRadius;
  final EdgeInsetsGeometry? margin;
  const CustomShimmerContainer({
    Key? key,
    this.height,
    this.width,
    this.borderRadius,
    this.margin,
    this.customBorderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: margin,
      height: height ?? UiUtils.shimmerLoadingContainerDefaultHeight,
      decoration: BoxDecoration(
        color: shimmerContentColor,
        borderRadius:
            customBorderRadius ?? BorderRadius.circular(borderRadius ?? 10),
      ),
    );
  }
}
