import 'package:flutter/material.dart';

class CustomRoundedButton extends StatelessWidget {
  final String? buttonTitle;
  final double? height;
  final double widthPercentage;
  final Function? onTap;
  final Color backgroundColor;
  final double? radius;
  final Color? shadowColor;
  final bool showBorder;
  final Color? borderColor;
  final Color? titleColor;
  final double? textSize;
  final FontWeight? fontWeight;
  final double? elevation;
  final int? maxLines;
  final Widget? child;
  final TextAlign? textAlign;

  const CustomRoundedButton({
    Key? key,
    required this.widthPercentage,
    required this.backgroundColor,
    this.child,
    this.maxLines,
    this.borderColor,
    this.elevation,
    required this.buttonTitle,
    this.onTap,
    this.radius,
    this.shadowColor,
    required this.showBorder,
    this.height,
    this.titleColor,
    this.fontWeight,
    this.textSize,
    this.textAlign,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      shadowColor: shadowColor ?? Colors.black54,
      elevation: elevation ?? 0.0,
      color: backgroundColor,
      borderRadius: BorderRadius.circular(radius ?? 10.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(radius ?? 10.0),
        onTap: onTap as void Function()?,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15.0), //
          alignment: Alignment.center,
          height: height ?? 55.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius ?? 10.0),
            border: showBorder
                ? Border.all(
                    color: borderColor ??
                        Theme.of(context).scaffoldBackgroundColor,
                  )
                : null,
          ),
          width: MediaQuery.of(context).size.width * widthPercentage,
          child: child ??
              Text(
                "$buttonTitle",
                maxLines: maxLines ?? 2,
                overflow: TextOverflow.ellipsis,
                textAlign: textAlign ?? TextAlign.center,
                style: TextStyle(
                  fontSize: textSize ?? 17.0,
                  color:
                      titleColor ?? Theme.of(context).scaffoldBackgroundColor,
                  fontWeight: fontWeight ?? FontWeight.normal,
                ),
              ),
        ),
      ),
    );
  }
}
