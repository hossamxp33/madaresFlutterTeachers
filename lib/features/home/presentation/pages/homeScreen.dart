import 'package:madares_app_teacher/core/repositories/settingsRepository.dart';
import 'package:madares_app_teacher/core/repositories/teacherRepository.dart';
import 'package:madares_app_teacher/core/utils/notificationUtils/generalNotificationUtility.dart';
import 'package:madares_app_teacher/features/chat/presentation/pages/chatUsersScreen.dart';
import 'package:madares_app_teacher/features/exam/presentation/manager/timeTableCubit.dart';
import 'package:madares_app_teacher/features/home/presentation/widgets/bottomNavigationItemContainer.dart';
import 'package:madares_app_teacher/features/home/presentation/widgets/forceUpdateDialogContainer.dart';
import 'package:madares_app_teacher/features/home/presentation/widgets/profileContainer.dart';
import 'package:madares_app_teacher/features/home/presentation/widgets/settingsContainer.dart';
import 'package:madares_app_teacher/features/home/presentation/widgets/timeTableContainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/manager/appConfigurationCubit.dart';
import '../../../../core/utils/labelKeys.dart';
import '../../../../core/utils/uiUtils.dart';
import '../../../chat/presentation/manager/chatUsersCubit.dart';
import '../../../chat/presentation/pages/message_number.dart';
import '../widgets/appUnderMaintenanceContainer.dart';
import '../widgets/homeContainer.dart';

//value notifier to show notification icon active/deavtive
ValueNotifier<int> notificationCountValueNotifier = ValueNotifier(0);

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();

  static Route<dynamic> route(RouteSettings routeSettings) {
    return CupertinoPageRoute(
      builder: (_) => BlocProvider(
        create: (context) => TimeTableCubit(TeacherRepository()),
        child: const HomeScreen(),
      ),
    );
  }
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  );

  late final Animation<double> _bottomNavAndTopProfileAnimation =
      Tween<double>(begin: 0.0, end: 1.0).animate(
    CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ),
  );

  late final List<AnimationController> _bottomNavItemTitlesAnimationController =
      [];

  late int _currentSelectedBottomNavIndex = 0;

  final List<BottomNavItem> _bottomNavItems = [
    BottomNavItem(
      activeImageUrl: UiUtils.getImagePath("home_active_icon.svg"),
      disableImageUrl: UiUtils.getImagePath("home_icon.svg"),
      title: homeKey,
    ),
    BottomNavItem(
      activeImageUrl: UiUtils.getImagePath("schedule_active.svg"),
      disableImageUrl: UiUtils.getImagePath("schedule.svg"),
      title: scheduleKey,
    ),
    BottomNavItem(
      activeImageUrl: UiUtils.getImagePath("chat.svg"),
      disableImageUrl: UiUtils.getImagePath("chat_icon.svg"),
      title: chatKey,
    ),
    BottomNavItem(
      activeImageUrl: UiUtils.getImagePath("profile_active.svg"),
      disableImageUrl: UiUtils.getImagePath("profile.svg"),
      title: profileKey,
    ),
    BottomNavItem(
      activeImageUrl: UiUtils.getImagePath("setting_active.svg"),
      disableImageUrl: UiUtils.getImagePath("setting.svg"),
      title: settingKey,
    ),
  ];

  @override
  void initState() {
    initAnimations();
    _animationController.forward();
    _animationController.forward();
    WidgetsBinding.instance.addObserver(this);
    Future.delayed(Duration.zero, () {
      //setup notification callback here
      NotificationUtility.setUpNotificationService(context);
      //fetch chat users for chat count
      context.read<StudentChatUsersCubit>().fetchChatUsers();
      context.read<ParentChatUserCubit>().fetchChatUsers();
    });
    super.initState();
  }

  void initAnimations() {
    for (var i = 0; i < _bottomNavItems.length; i++) {
      _bottomNavItemTitlesAnimationController.add(
        AnimationController(
          value: i == _currentSelectedBottomNavIndex ? 0.0 : 1.0,
          vsync: this,
          duration: const Duration(milliseconds: 400),
        ),
      );
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    //Refereshing the shared preferences to get the latest notification count, it there were any notifications in the background
    if (state == AppLifecycleState.resumed) {
      notificationCountValueNotifier.value =
          await SettingsRepository().getNotificationCount();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    for (var animationController in _bottomNavItemTitlesAnimationController) {
      animationController.dispose();
    }
    super.dispose();
  }

  Future<void> _changeBottomNavItem(int index) async {
    _bottomNavItemTitlesAnimationController[_currentSelectedBottomNavIndex]
        .forward();
    //change current selected bottom index
    setState(() {
      _currentSelectedBottomNavIndex = index;
    });
    _bottomNavItemTitlesAnimationController[_currentSelectedBottomNavIndex]
        .reverse();
  }

  Widget _buildBottomNavigationContainer() {
    return FadeTransition(
      opacity: _bottomNavAndTopProfileAnimation,
      child: SlideTransition(
        position: _bottomNavAndTopProfileAnimation.drive(
            Tween<Offset>(begin: const Offset(0.0, 1.0), end: Offset.zero)),
        child: Container(
          alignment: Alignment.center,
          // padding: EdgeInsets.only(
          //   bottom: MediaQuery.of(context).size.height * (0.075) * (0.075),
          // ),
          margin: EdgeInsets.only(
            bottom: UiUtils.bottomNavigationBottomMargin,
          ),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color:
                    UiUtils.getColorScheme(context).secondary.withOpacity(0.15),
                offset: const Offset(2.5, 2.5),
                blurRadius: 20,
              )
            ],
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(10.0),
          ),
          width: MediaQuery.of(context).size.width * (0.8),
          height: MediaQuery.of(context).size.height *
              UiUtils.bottomNavigationHeightPercentage,
          child: LayoutBuilder(
            builder: (context, boxConstraints) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _bottomNavItems.map((bottomNavItem) {
                  int index = _bottomNavItems
                      .indexWhere((e) => e.title == bottomNavItem.title);
                  return index == 2
                      ? Stack(children: [
                          BottomNavItemContainer(
                            onTap: _changeBottomNavItem,
                            boxConstraints: boxConstraints,
                            currentIndex: _currentSelectedBottomNavIndex,
                            bottomNavItem: _bottomNavItems[index],
                            animationController:
                                _bottomNavItemTitlesAnimationController[index],
                            index: index,
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: MessageNumber(),
                          )
                        ])
                      : BottomNavItemContainer(
                          onTap: _changeBottomNavItem,
                          boxConstraints: boxConstraints,
                          currentIndex: _currentSelectedBottomNavIndex,
                          bottomNavItem: _bottomNavItems[index],
                          animationController:
                              _bottomNavItemTitlesAnimationController[index],
                          index: index,
                        );
                }).toList(),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _currentSelectedBottomNavIndex == 0,
      onPopInvoked: (didPop) {
        if (!didPop) {
          _changeBottomNavItem(0);
        }
      },
      child: Scaffold(
        body: context.read<AppConfigurationCubit>().appUnderMaintenance()
            ? const AppUnderMaintenanceContainer()
            : Stack(
                children: [
                  IndexedStack(
                    index: _currentSelectedBottomNavIndex,
                    children: const [
                      HomeContainer(),
                      TimeTableContainer(),
                      ChatUsersScreen(),
                      ProfileContainer(),
                      SettingsContainer(),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: _buildBottomNavigationContainer(),
                  ),
                  context.read<AppConfigurationCubit>().forceUpdate()
                      ? FutureBuilder<bool>(
                          future: UiUtils.forceUpdate(
                            context
                                .read<AppConfigurationCubit>()
                                .getAppVersion(),
                          ),
                          builder: (context, snaphsot) {
                            if (snaphsot.hasData) {
                              return (snaphsot.data ?? false)
                                  ? const ForceUpdateDialogContainer()
                                  : const SizedBox();
                            }

                            return const SizedBox();
                          },
                        )
                      : const SizedBox(),
                ],
              ),
      ),
    );
  }
}
