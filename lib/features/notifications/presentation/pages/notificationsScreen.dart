// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import 'package:readmore/readmore.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../core/repositories/settingsRepository.dart';
import '../../../../core/repositories/teacherRepository.dart';
import '../../../../core/utils/animationConfiguration.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/labelKeys.dart';
import '../../../../core/utils/sharedWidgets/customBackButton.dart';
import '../../../../core/utils/sharedWidgets/customRefreshIndicator.dart';
import '../../../../core/utils/sharedWidgets/customShimmerContainer.dart';
import '../../../../core/utils/sharedWidgets/errorContainer.dart';
import '../../../../core/utils/sharedWidgets/loadMoreErrorWidget.dart';
import '../../../../core/utils/sharedWidgets/noDataContainer.dart';
import '../../../../core/utils/sharedWidgets/screenTopBackgroundContainer.dart';
import '../../../../core/utils/sharedWidgets/shimmerLoadingContainer.dart';
import '../../../../core/utils/styles/colors.dart';
import '../../../../core/utils/uiUtils.dart';
import '../../../home/presentation/pages/homeScreen.dart';
import '../../data/models/customNotification.dart';
import '../manager/notificationCubit.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  static Route route(RouteSettings routeSettings) {
    return CupertinoPageRoute(
      builder: (_) => BlocProvider(
        create: (context) => NotificationsCubit(TeacherRepository()),
        child: const NotificationScreen(),
      ),
    );
  }

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late final ScrollController _scrollController = ScrollController()
    ..addListener(_notificationsScrollListener);

  void _notificationsScrollListener() {
    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent) {
      if (context.read<NotificationsCubit>().hasMore()) {
        context.read<NotificationsCubit>().fetchMoreNotifications();
      }
    }
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      fetchnotifications();
      notificationCountValueNotifier.value = 0;
      await SettingsRepository().setNotificationCount(0);
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_notificationsScrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void fetchnotifications() {
    context.read<NotificationsCubit>().fetchNotifications(
          page: 1,
        );
  }

  Widget _buildAppBar(BuildContext context) {
    return ScreenTopBackgroundContainer(
      heightPercentage: UiUtils.appBarSmallerHeightPercentage,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const CustomBackButton(),
          Align(
            alignment: Alignment.topCenter,
            child: Text(
              UiUtils.getTranslatedLabel(context, notificationsKey),
              style: TextStyle(
                color: Theme.of(context).scaffoldBackgroundColor,
                fontSize: UiUtils.screenTitleFontSize,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerLoader() {
    return ShimmerLoadingContainer(
      child: LayoutBuilder(
        builder: (context, boxConstraints) {
          return SizedBox(
            height: double.maxFinite,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: UiUtils.defaultShimmerLoadingContentCount,
              itemBuilder: (context, index) {
                return _buildOnenotificationShimmerLoader();
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildOnenotificationShimmerLoader() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: MediaQuery.of(context).size.width * (0.075),
      ),
      child: const ShimmerLoadingContainer(
        child: CustomShimmerContainer(
          height: 100,
          borderRadius: 10,
        ),
      ),
    );
  }

  Widget _buildSinglenotificationItem({
    required CustomNotification notification,
  }) {
    return GestureDetector(
       onTap: () async {
        print("====================");
        print(notification.title);
        print(notification.typeId);
        if (notification.type == "assignment") {
          // if (notification.typeId != null) {
          //   final assignment = await context
          //       .read<AssignmentsCubit>()
          //       .fetchAssignmentById(int.tryParse(notification.typeId!));
          //   print("assignment == $assignment");
          //   Navigator.of(context)
          //       .pushNamed<Assignment>(Routes.assignment, arguments: assignment)
          //       .then((assignment) {
          //     if (assignment != null) {
          //       context.read<AssignmentsCubit>().updateAssignments(assignment);
          //     }
          //   });
          // } else {}
        } else {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                contentPadding: EdgeInsets.zero,
                title: ListTile(
                  contentPadding: EdgeInsets.zero,
                  subtitle: Center(
                    child: Text(
                        "${DateFormat('yyyy-MM-dd hh:mm a').format(notification.date)}"),
                  ),
                  title: Center(child: Text("${notification.title}")),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                    ),
                    Text("${notification.message}"),
                       notification.image == null
                      ? SvgPicture.asset(
                          width: 50,
                          height: 50,
                          UiUtils.getImagePath("appLogo.svg"),
                        )
                      : CachedNetworkImage(
                          errorWidget: (context, image, _) =>
                              const SizedBox.shrink(),
                          imageBuilder: (context, imageProvider) {
                            return Container(
                              alignment: Alignment.topCenter,
                              child: Container(
                                width: 300,
                                height: 300,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            );
                          },
                          imageUrl: storageUrl + notification.image!,
                          placeholder: (context, url) =>
                              const SizedBox.shrink(),
                        ),
                  ],
                ),
                actions: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_forward_ios_rounded)),
                ],
              );
            },
          );
        }
        // notification.type == "assignment"
        //     ? Navigator.of(context)
        //         .pushNamed<Assignment>(Routes.assignment, arguments: assignment)
        //         .then((assignment) {
        //         if (assignment != null) {
        //           context
        //               .read<AssignmentsCubit>()
        //               .updateAssignments(assignment);
        //         }
        //       })
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(10.0),
        ),
        width: MediaQuery.of(context).size.width * (0.85),
        child: LayoutBuilder(
          builder: (context, boxConstraints) {
            return Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          notification.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            height: 1.2,
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 15.0,
                          ),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        ReadMoreText(
                          notification.message,
                          trimLines: 2,
                          colorClickableText: Theme.of(context).colorScheme.primary,
                          trimMode: TrimMode.Line,
                          trimCollapsedText:
                              UiUtils.getTranslatedLabel(context, showMoreKey),
                          trimExpandedText:
                              " ${UiUtils.getTranslatedLabel(context, showLessKey)}",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          timeago.format(notification.date),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onBackground
                                .withOpacity(0.75),
                            fontWeight: FontWeight.w400,
                            fontSize: 11,
                          ),
                          textAlign: TextAlign.start,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  notification.image == null
                      ? const SizedBox.shrink()
                      : CachedNetworkImage(
                          errorWidget: (context, image, _) =>
                              const SizedBox.shrink(),
                          imageBuilder: (context, imageProvider) {
                            return Container(
                              alignment: Alignment.topCenter,
                              child: Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            );
                          },
                          imageUrl: storageUrl + notification.image!,
                          placeholder: (context, url) => const SizedBox.shrink(),
                        ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BlocBuilder<NotificationsCubit, NotificationState>(
            builder: (context, state) {
              if (state is NotificationFetchSuccess) {
                return state.notifications.isEmpty
                    ? Padding(
                        padding: EdgeInsets.only(
                          top: UiUtils.getScrollViewTopPadding(
                            context: context,
                            appBarHeightPercentage:
                                UiUtils.appBarSmallerHeightPercentage,
                          ),
                        ),
                        child: const NoDataContainer(
                          titleKey: noNotificationsKey,
                        ),
                      )
                    : CustomRefreshIndicator(
                        displacment: UiUtils.getScrollViewTopPadding(
                          context: context,
                          appBarHeightPercentage:
                              UiUtils.appBarSmallerHeightPercentage,
                        ),
                        onRefreshCallback: () {
                          if (!context.read<NotificationsCubit>().isLoading()) {
                            fetchnotifications();
                          }
                        },
                        child: SizedBox(
                          height: double.maxFinite,
                          width: double.maxFinite,
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: EdgeInsets.only(
                              top: UiUtils.getScrollViewTopPadding(
                                context: context,
                                appBarHeightPercentage:
                                    UiUtils.appBarSmallerHeightPercentage,
                              ),
                              bottom:
                                  UiUtils.getScrollViewBottomPadding(context),
                            ),
                            child: Column(
                              children: List.generate(
                                state.notifications.length,
                                (index) {
                                  {
                                    return Animate(
                                      effects: listItemAppearanceEffects(
                                        itemIndex: index,
                                      ),
                                      child: _buildSinglenotificationItem(
                                        notification:
                                            state.notifications[index],
                                      ),
                                    );
                                  }
                                },
                              )..addAll([
                                  if (state.moreNotificationsFetchInProgress)
                                    _buildOnenotificationShimmerLoader(),
                                  if (state.moreNotificationsFetchError &&
                                      !state.moreNotificationsFetchInProgress)
                                    LoadMoreErrorWidget(onTapRetry: () {
                                      context
                                          .read<NotificationsCubit>()
                                          .fetchMoreNotifications();
                                    })
                                ]),
                            ),
                          ),
                        ),
                      );
              }
              if (state is NotificationFetchFailure) {
                return Center(
                  child: ErrorContainer(
                    errorMessageCode: state.errorMessage,
                    onTapRetry: () {
                      context.read<NotificationsCubit>().fetchNotifications(
                            page: 1,
                          );
                    },
                  ),
                );
              }
              return Padding(
                padding: EdgeInsets.only(
                  top: UiUtils.getScrollViewTopPadding(
                    context: context,
                    appBarHeightPercentage:
                        UiUtils.appBarSmallerHeightPercentage,
                  ),
                ),
                child: _buildShimmerLoader(),
              );
            },
          ),
          Align(
            alignment: Alignment.topCenter,
            child: _buildAppBar(context),
          ),
        ],
      ),
    );
  }
}
