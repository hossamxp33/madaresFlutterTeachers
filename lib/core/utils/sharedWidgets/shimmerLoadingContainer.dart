import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../styles/colors.dart';

class ShimmerLoadingContainer extends StatelessWidget {
  final Widget child;
  const ShimmerLoadingContainer({Key? key, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: shimmerBaseColor,
      highlightColor: shimmerhighlightColor,
      child: child,
    );
  }
}
