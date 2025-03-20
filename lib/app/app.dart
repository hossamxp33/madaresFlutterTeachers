import 'dart:io';
<<<<<<< HEAD
import 'package:eschool_teacher/app/appLocalization.dart';
import 'package:eschool_teacher/app/routes.dart';
import 'package:eschool_teacher/core/cubits/internetConnectivityCubit.dart';
import 'package:eschool_teacher/core/repositories/settingsRepository.dart';
import 'package:eschool_teacher/core/repositories/systemInfoRepository.dart';
import 'package:eschool_teacher/core/repositories/teacherRepository.dart';
import 'package:eschool_teacher/core/utils/appLanguages.dart';
import 'package:eschool_teacher/core/utils/bloc_observer.dart';
import 'package:eschool_teacher/core/utils/hiveBoxKeys.dart';
import 'package:eschool_teacher/core/utils/notificationUtils/generalNotificationUtility.dart';
import 'package:eschool_teacher/core/utils/styles/colors.dart';
import 'package:eschool_teacher/core/utils/uiUtils.dart';
import 'package:eschool_teacher/features/notifications/data/models/customNotification.dart';
=======

>>>>>>> f8116bb26ff7cdb9462a79241b86162b4f4e9bdc
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
<<<<<<< HEAD
=======
import 'package:madares_app_teacher/app/appLocalization.dart';
import 'package:madares_app_teacher/app/routes.dart';
import '../core/cubits/internetConnectivityCubit.dart';
import '../core/repositories/settingsRepository.dart';
import '../core/repositories/systemInfoRepository.dart';
import '../core/repositories/teacherRepository.dart';
import '../core/utils/appLanguages.dart';
import '../core/utils/bloc_observer.dart';
import '../core/utils/flavor_config.dart';
import '../core/utils/hiveBoxKeys.dart';
import '../core/utils/notificationUtils/generalNotificationUtility.dart';
import '../core/utils/uiUtils.dart';
>>>>>>> f8116bb26ff7cdb9462a79241b86162b4f4e9bdc
import '../features/chat/data/repositories/chatRepository.dart';
import '../features/chat/presentation/manager/chatUsersCubit.dart';
import '../features/class/presentation/manager/myClassesCubit.dart';
import '../features/login/data/repositories/authRepository.dart';
import '../features/login/presentation/manager/authCubit.dart';

<<<<<<< HEAD
=======
import '../features/notifications/data/models/customNotification.dart';
>>>>>>> f8116bb26ff7cdb9462a79241b86162b4f4e9bdc
import 'manager/appConfigurationCubit.dart';
import 'manager/appLocalizationCubit.dart';

//to avoide handshake error on some devices
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
<<<<<<< HEAD
=======


>>>>>>> f8116bb26ff7cdb9462a79241b86162b4f4e9bdc
  HttpOverrides.global = MyHttpOverrides();
  Bloc.observer = MyBlocObserver();
  //Register the licence of font
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );

  await Firebase.initializeApp();
  await NotificationUtility.initializeAwesomeNotification();
  final fcmToken = await FirebaseMessaging.instance.getToken();
  if (kDebugMode) {
    print("FCM Token: $fcmToken");
  }
<<<<<<< HEAD
=======

>>>>>>> f8116bb26ff7cdb9462a79241b86162b4f4e9bdc
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Hive.initFlutter();
  await Hive.openBox(authBoxKey);
  await Hive.openBox(settingsBoxKey);
  Hive.registerAdapter(CustomNotificationAdapter()); // Register adapter

  await Hive.openBox<CustomNotification>('notifications');
  runApp(const MyApp());
}

class GlobalScrollBehavior extends ScrollBehavior {
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics();
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    //preloading some of the imaegs
    precacheImage(
      AssetImage(UiUtils.getImagePath("upper_pattern.png")),
      context,
    );

    precacheImage(
      AssetImage(UiUtils.getImagePath("lower_pattern.png")),
      context,
    );
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppConfigurationCubit>(
          create: (_) => AppConfigurationCubit(SystemRepository()),
        ),
        BlocProvider<AppLocalizationCubit>(
          create: (_) => AppLocalizationCubit(SettingsRepository()),
        ),
        BlocProvider<AuthCubit>(create: (_) => AuthCubit(AuthRepository())),
        BlocProvider<MyClassesCubit>(
          create: (_) => MyClassesCubit(TeacherRepository()),
        ),
        BlocProvider<InternetConnectivityCubit>(
          create: (_) => InternetConnectivityCubit(),
        ),
        BlocProvider<StudentChatUsersCubit>(
          create: (_) => StudentChatUsersCubit(ChatRepository()),
        ),
        BlocProvider<ParentChatUserCubit>(
          create: (_) => ParentChatUserCubit(ChatRepository()),
        ),
      ],
      child: Builder(
        builder: (context) {
          final currentLanguage =
              context.watch<AppLocalizationCubit>().state.language;
          return MaterialApp(
            navigatorKey: UiUtils.rootNavigatorKey,
<<<<<<< HEAD
            theme: Theme.of(context).copyWith(
              textTheme:
                  GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
              scaffoldBackgroundColor: pageBackgroundColor,
              colorScheme: Theme.of(context).colorScheme.copyWith(
                    primary: primaryColor,
                    onPrimary: onPrimaryColor,
                    secondary: secondaryColor,
                    background: backgroundColor,
                    error: errorColor,
                    onSecondary: onSecondaryColor,
                    onBackground: onBackgroundColor,
                  ),
            ),
=======
            theme: FlavorConfig.getLightTheme(context),
>>>>>>> f8116bb26ff7cdb9462a79241b86162b4f4e9bdc
            builder: (context, widget) {
              return ScrollConfiguration(
                behavior: GlobalScrollBehavior(),
                child: widget!,
              );
            },
            locale: currentLanguage,
            localizationsDelegates: const [
              AppLocalization.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: appLanguages.map((language) {
              return UiUtils.getLocaleFromLanguageCode(language.languageCode);
            }).toList(),
            debugShowCheckedModeBanner: false,
            initialRoute: Routes.splash,
            onGenerateRoute: Routes.onGenerateRouted,
          );
        },
      ),
    );
  }
}
