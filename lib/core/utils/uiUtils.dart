import 'dart:math';

import 'package:madares_app_teacher/app/appLocalization.dart';
import 'package:madares_app_teacher/app/manager/appConfigurationCubit.dart';
import 'package:madares_app_teacher/app/routes.dart';
import 'package:madares_app_teacher/core/cubits/downloadfileCubit.dart';
import 'package:madares_app_teacher/core/models/studyMaterial.dart';
import 'package:madares_app_teacher/core/repositories/studyMaterialRepositoy.dart';
import 'package:madares_app_teacher/core/utils/constants.dart';
import 'package:madares_app_teacher/core/utils/errorMessageKeysAndCodes.dart';
import 'package:madares_app_teacher/core/utils/labelKeys.dart';
import 'package:madares_app_teacher/core/utils/sharedWidgets/bottomToastOverlayContainer.dart';
import 'package:madares_app_teacher/core/utils/sharedWidgets/downloadFileBottomsheetContainer.dart';
import 'package:madares_app_teacher/core/utils/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart' as intl;
import 'package:url_launcher/url_launcher.dart';

import 'open_file.dart';

// ignore: avoid_classes_with_only_static_members
class UiUtils {
  //This extra padding will add to MediaQuery.of(context).padding.top in orderto give same top padding in every screen

  static double screenContentTopPadding = 15.0;
  static double screenContentHorizontalPadding = 25.0;
  static double screenTitleFontSize = 18.0;
  static double screenSubTitleFontSize = 14.0;
  static double textFieldFontSize = 15.0;

  static double screenContentHorizontalPaddingPercentage = 0.075;

  static double bottomSheetButtonHeight = 45.0;
  static double bottomSheetButtonWidthPercentage = 0.625;

  static double extraScreenContentTopPaddingForScrolling = 0.0275;
  static double appBarSmallerHeightPercentage = 0.15;

  static double appBarMediumtHeightPercentage = 0.175;

  static double appBarBiggerHeightPercentage = 0.25;

  static double bottomNavigationHeightPercentage = 0.075;
  static double bottomNavigationBottomMargin = 25;

  static double bottomSheetHorizontalContentPadding = 20;

  static double subjectFirstLetterFontSize = 20;

  static double shimmerLoadingContainerDefaultHeight = 7;

  static int defaultShimmerLoadingContentCount = 5;
  static int defaultChatShimmerLoaders = 15;

  static double appBarContentTopPadding = 25.0;
  static double bottomSheetTopRadius = 20.0;
  static Duration tabBackgroundContainerAnimationDuration =
      const Duration(milliseconds: 300);
  static Curve tabBackgroundContainerAnimationCurve = Curves.easeInOut;

  //key for globle navigation
  static GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();


  static Future<void> showCustomSnackBar({
    required BuildContext context,
    required String errorMessage,
    required Color backgroundColor,
    Duration delayDuration = errorMessageDisplayDuration,
  }) async {
    OverlayState? overlayState = Overlay.of(context);
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => ErrorMessageOverlayContainer(
        backgroundColor: backgroundColor,
        errorMessage: errorMessage,
      ),
    );

    overlayState.insert(overlayEntry);
    await Future.delayed(delayDuration);
    overlayEntry.remove();
  }
  //to give bottom scroll padding in screen where
  //bottom navigation bar is displayed
  static double getScrollViewBottomPadding(BuildContext context) {
    return MediaQuery.of(context).size.height *
            (UiUtils.bottomNavigationHeightPercentage) +
        UiUtils.bottomNavigationBottomMargin * (1.5);
  }

  static Future<dynamic> showBottomSheet({
    required Widget child,
    required BuildContext context,
    bool? enableDrag,
  }) async {
    final result = await showModalBottomSheet(
      enableDrag: enableDrag ?? false,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(bottomSheetTopRadius),
          topRight: Radius.circular(bottomSheetTopRadius),
        ),
      ),
      context: context,
      builder: (_) => child,
    );

    return result;
  }

  static Future<void> showBottomToastOverlay({
    required BuildContext context,
    required String errorMessage,
    required Color backgroundColor,

  }) async {
    OverlayState? overlayState = Overlay.of(context);
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => BottomToastOverlayContainer(
        backgroundColor: backgroundColor == Theme.of(context).colorScheme.onPrimary?Theme.of(context).colorScheme.primary: backgroundColor,
        errorMessage: errorMessage,
      ),
    );

    overlayState.insert(overlayEntry);
    await Future.delayed(errorMessageDisplayDuration);
    overlayEntry.remove();
  }

  static String getErrorMessageFromErrorCode(
    BuildContext context,
    String errorCode,
  ) {
    return UiUtils.getTranslatedLabel(
      context,
      ErrorMessageKeysAndCode.getErrorMessageKeyFromCode(errorCode),
    );
  }

  static Widget buildProgressContainer({
    required double width,
    required Color color,
  }) {
    return Container(
      width: width,
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(3.0)),
    );
  }

  //to give top scroll padding to screen content
  static double getScrollViewTopPadding(
      {required BuildContext context,
      required double appBarHeightPercentage,
      bool keepExtraSpace = true}) {
    return MediaQuery.of(context).size.height *
        (appBarHeightPercentage +
            (keepExtraSpace ? extraScreenContentTopPaddingForScrolling : 0));
  }

  static String getImagePath(String imageName) {
    return "assets/images/$imageName";
  }

  static String getLottieAnimationPath(String animationName) {
    return "assets/animations/$animationName";
  }

  static ColorScheme getColorScheme(BuildContext context) {
    return Theme.of(context).colorScheme;
  }

  static Color getColorFromHexValue(String hexValue) {
    int color = int.parse(hexValue.replaceAll("#", "0xff").toString());
    return Color(color);
  }

  static Locale getLocaleFromLanguageCode(String languageCode) {
    List<String> result = languageCode.split("-");
    return result.length == 1
        ? Locale(result.first)
        : Locale(result.first, result.last);
  }

  static String getTranslatedLabel(BuildContext context, String labelKey) {
    return (AppLocalization.of(context)!.getTranslatedValues(labelKey) ??
            labelKey)
        .trim();
  }

  static String getMonthName(int monthNumber) {
    List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[monthNumber - 1];
  }

  static List<String> buildMonthYearsBetweenTwoDates(
    DateTime startDate,
    DateTime endDate,
  ) {
    List<String> dateTimes = [];
    DateTime current = startDate;
    while (current.difference(endDate).isNegative) {
      current = current.add(const Duration(days: 24));
      dateTimes.add("${getMonthName(current.month)}, ${current.year}");
    }
    dateTimes = dateTimes.toSet().toList();

    return dateTimes;
  }

  static Color getClassColor(int index) {
    int colorIndex = index < myClassesColors.length
        ? index
        : (index % myClassesColors.length);

    return myClassesColors[colorIndex];
  }

  static void showFeatureDisableInDemoVersion(BuildContext context) {
    showBottomToastOverlay(
      context: context,
      errorMessage:
          UiUtils.getTranslatedLabel(context, featureDisableInDemoVersionKey),
      backgroundColor: Theme.of(context).colorScheme.error,
    );
  }

  static bool isDemoVersionEnable({required BuildContext context}) {
    return context.read<AppConfigurationCubit>().isDemoModeOn();
  }

  static int getStudyMaterialId(
    String studyMaterialLabel,
    BuildContext context,
  ) {
    if (studyMaterialLabel == getTranslatedLabel(context, fileUploadKey)) {
      return 1;
    }
    if (studyMaterialLabel == getTranslatedLabel(context, youtubeLinkKey)) {
      return 2;
    }
    if (studyMaterialLabel == getTranslatedLabel(context, videoUploadKey)) {
      return 3;
    }
    return 0;
  }

  static int getStudyMaterialIdByEnum(
    StudyMaterialType studyMaterialType,
    BuildContext context,
  ) {
    if (studyMaterialType == StudyMaterialType.file) {
      return 1;
    }
    if (studyMaterialType == StudyMaterialType.youtubeVideo) {
      return 2;
    }
    if (studyMaterialType == StudyMaterialType.uploadedVideoUrl) {
      return 3;
    }
    return 0;
  }

  static String getBackButtonPath(BuildContext context) {
    return Directionality.of(context).name == TextDirection.rtl.name
        ? getImagePath("rtl_back_icon.svg")
        : getImagePath("back_icon.svg");
  }

  static String getStudyMaterialTypeLabelByEnum(
    StudyMaterialType studyMaterialType,
    BuildContext context,
  ) {
    if (studyMaterialType == StudyMaterialType.file) {
      return UiUtils.getTranslatedLabel(context, fileUploadKey);
    }
    if (studyMaterialType == StudyMaterialType.youtubeVideo) {
      return UiUtils.getTranslatedLabel(context, youtubeLinkKey);
    }
    if (studyMaterialType == StudyMaterialType.uploadedVideoUrl) {
      return UiUtils.getTranslatedLabel(context, videoUploadKey);
    }

    return "Other";
  }

  static void viewOrDownloadStudyMaterial({
    required BuildContext context,
    required bool storeInExternalStorage,
    required StudyMaterial studyMaterial,
  }) {
    try {
      if (studyMaterial.fileExtension.toLowerCase() == "pdf") {
        Navigator.pushNamed(context, Routes.pdfFileView,
            arguments: {"studyMaterial": studyMaterial});
      } else if (studyMaterial.fileExtension.isImage()) {
        Navigator.pushNamed(context, Routes.imageFileView,
            arguments: {"studyMaterial": studyMaterial});
      } else {
        if (studyMaterial.studyMaterialType ==
                StudyMaterialType.uploadedVideoUrl ||
            studyMaterial.studyMaterialType == StudyMaterialType.youtubeVideo) {
          launchUrl(Uri.parse(studyMaterial.fileUrl));
        } else {
          UiUtils.openDownloadBottomsheet(
            context: context,
            studyMaterial: studyMaterial,
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        UiUtils.showBottomToastOverlay(
          context: context,
          errorMessage:
              UiUtils.getTranslatedLabel(context, unableToOpenFileKey),
          backgroundColor: Theme.of(context).colorScheme.error,
        );
      }
    }
  }

  static void openDownloadBottomsheet({
    required BuildContext context,
    required StudyMaterial studyMaterial,
  }) {
    showBottomSheet(
      child: BlocProvider<DownloadFileCubit>(
        create: (context) => DownloadFileCubit(StudyMaterialRepository()),
        child: DownloadFileBottomsheetContainer(
          studyMaterial: studyMaterial,
        ),
      ),
      context: context,
    ).then((result) {
      if (result != null) {
        if (result['error']) {
          showBottomToastOverlay(
            context: context,
            errorMessage: getErrorMessageFromErrorCode(
              context,
              result['message'].toString(),
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
          );
        } else {
          try {
            openMyFile(result['filePath'].toString(), context);

          } catch (e) {
            showBottomToastOverlay(
              context: context,
              errorMessage: getTranslatedLabel(
                context,
                unableToOpenKey,
              ),
              backgroundColor: Theme.of(context).colorScheme.error,
            );
          }
        }
      }
    });
  }

  static Future<bool> forceUpdate(String updatedVersion) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String currentVersion = "${packageInfo.version}+${packageInfo.buildNumber}";
    if (updatedVersion.isEmpty) {
      return false;
    }

    bool updateBasedOnVersion = _shouldUpdateBasedOnVersion(
      currentVersion.split("+").first,
      updatedVersion.split("+").first,
    );

    if (updatedVersion.split("+").length == 1 ||
        currentVersion.split("+").length == 1) {
      return updateBasedOnVersion;
    }

    bool updateBasedOnBuildNumber = _shouldUpdateBasedOnBuildNumber(
      currentVersion.split("+").last,
      updatedVersion.split("+").last,
    );

    return updateBasedOnVersion || updateBasedOnBuildNumber;
  }

  static bool _shouldUpdateBasedOnVersion(
    String currentVersion,
    String updatedVersion,
  ) {
    List<int> currentVersionList =
        currentVersion.split(".").map((e) => int.parse(e)).toList();
    List<int> updatedVersionList =
        updatedVersion.split(".").map((e) => int.parse(e)).toList();

    if (updatedVersionList[0] > currentVersionList[0]) {
      return true;
    }
    if (updatedVersionList[1] > currentVersionList[1]) {
      return true;
    }
    if (updatedVersionList[2] > currentVersionList[2]) {
      return true;
    }

    return false;
  }

  static final List<String> weekDays = [
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
    "Sun"
  ];

  static String formatTime(String time) {
    final hourMinuteSecond = time.split(":");
    final hour = int.parse(hourMinuteSecond.first) < 13
        ? int.parse(hourMinuteSecond.first)
        : int.parse(hourMinuteSecond.first) - 12;
    final amOrPm = int.parse(hourMinuteSecond.first) > 12 ? "PM" : "AM";
    return "${hour.toString().padLeft(2, '0')}:${hourMinuteSecond[1]} $amOrPm";
  }

  static bool _shouldUpdateBasedOnBuildNumber(
    String currentBuildNumber,
    String updatedBuildNumber,
  ) {
    return int.parse(updatedBuildNumber) > int.parse(currentBuildNumber);
  }

  static String formatTimeWithDateTime(DateTime dateTime, {bool is24 = true}) {
    if (is24) {
      return intl.DateFormat("kk:mm").format(dateTime);
    } else {
      return intl.DateFormat("hh:mm a").format(dateTime);
    }
  }

  //Date format is DD-MM-YYYY
  static String formatStringDate(String date) {
    final DateTime dateTime = DateTime.parse(date);
    return "${dateTime.day.toString().padLeft(2, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.year}";
  }

  static String formatDate(DateTime dateTime) {
    return "${dateTime.day.toString().padLeft(2, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.year}";
  }

  static String formatDateAndTime(DateTime dateTime) {
    return intl.DateFormat("dd-MM-yyyy,  kk:mm").format(dateTime);
  }

  static bool isToadyIsInSessionYear(DateTime firstDate, DateTime lastDate) {
    final currentDate = DateTime.now();

    return (currentDate.isAfter(firstDate) && currentDate.isBefore(lastDate)) ||
        isSameDay(firstDate) ||
        isSameDay(lastDate);
  }

  static bool isSameDay(DateTime dateTime) {
    final currentDate = DateTime.now();
    return (currentDate.day == dateTime.day) &&
        (currentDate.month == dateTime.month) &&
        (currentDate.year == dateTime.year);
  }

  //It will return - if given value is empty
  static String formatEmptyValue(String value) {
    return value.isEmpty ? "-" : value;
  }

  static String getFileSizeString({required int bytes, int decimals = 0}) {
    const suffixes = ["b", "kb", "mb", "gb", "tb"];
    if (bytes == 0) return '0${suffixes[0]}';
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + suffixes[i];
  }
}

extension StringExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');

  String commaSeperatedListToString() => substring(1, length - 1)
      .split(', ')
      .map((part) => part.toCapitalized())
      .join(', ');

  bool isFile() => [
        'jpg', 'jpeg', 'png', 'gif', 'bmp', // Image formats
        'mp3', 'wav', 'ogg', 'flac', // Audio formats
        'mp4', 'avi', 'mkv', 'mov', // Video formats
        'pdf', // PDF documents
        'doc', 'docx', 'ppt', 'pptx', 'xls',
        'xlsx', // Microsoft Office documents
        'txt', // Text documents
        'html', 'htm', 'css', 'js', // Web formats
        'zip', 'rar', '7z', 'tar', // Archive formats
      ].contains(toLowerCase().split('.').lastOrNull ?? "");

  bool isImage() => [
        'png',
        'jpg',
        'jpeg',
        'gif',
        'webp',
        'bmp',
        'wbmp',
        'pbm',
        'pgm',
        'ppm',
        'tga',
        'ico',
        'cur',
      ].contains(toLowerCase().split('.').lastOrNull ?? "");
}

extension DateTimeExtensions on DateTime {
  bool isSameAs(DateTime date) {
    return year == date.year && month == date.month && day == date.day;
  }

  bool isToday() {
    return isSameAs(DateTime.now());
  }

  bool isYesterday() {
    return isSameAs(DateTime.now().subtract(const Duration(days: 1)));
  }

  bool isCurrentYear() {
    return year == DateTime.now().year;
  }
}



class ErrorMessageOverlayContainer extends StatefulWidget {
  final String errorMessage;
  final Color backgroundColor;
  const ErrorMessageOverlayContainer({
    Key? key,
    required this.errorMessage,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  State<ErrorMessageOverlayContainer> createState() =>
      _ErrorMessageOverlayContainerState();
}

class _ErrorMessageOverlayContainerState
    extends State<ErrorMessageOverlayContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 500))
    ..forward();

  late Animation<double> slideAnimation =
  Tween<double>(begin: -0.5, end: 1.0).animate(
    CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOutCirc,
    ),
  );

  @override
  void initState() {
    super.initState();
    Future.delayed(
        Duration(
          milliseconds: errorMessageDisplayDuration.inMilliseconds - 500,
        ), () {
      animationController.reverse();
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: slideAnimation,
      builder: (context, child) {
        return PositionedDirectional(
          start: MediaQuery.of(context).size.width * (0.1),
          bottom: MediaQuery.of(context).size.height *
              (0.075) *
              (slideAnimation.value),
          child: Opacity(
            opacity: slideAnimation.value < 0.0 ? 0.0 : slideAnimation.value,
            child: Material(
              type: MaterialType.transparency,
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * (0.8),
                padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                decoration: BoxDecoration(
                  color: widget.backgroundColor,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(
                  widget.errorMessage,
                  style: TextStyle(
                    fontSize: 13.5,
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
