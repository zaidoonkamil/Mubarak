import 'dart:convert';
import 'dart:io';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:muslim_app/cubit/blocobserver.dart';
import 'package:muslim_app/cubit/cubit.dart';
import 'package:muslim_app/models/azkar&Tsabeeh.dart';
import 'package:muslim_app/screens/bottom_nav_bar.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'components/components.dart';
import 'components/constants.dart';
import 'package:flutter/services.dart';

import 'screens/splash_screen.dart';
import 'shared/cache_helper.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  Map<String, dynamic> json1 = jsonDecode(azkar);
  AzkarAndTsabeeh.fromJson(json1);
  HttpOverrides.global = MyHttpOverrides(); //new
  await CacheHelper.init();
  await CacheHelper.initt();
  CacheHelper.getDataFirstRun(key: 'firstRun');
  surahNameFromSharedPref = CacheHelper.getData(key: "surahName");
  surahNumFromSharedPref = CacheHelper.getData(key: "surahNumber");
  pageNumberFromSharedPref = CacheHelper.getData(key: "pageNumber");

  runApp(BlocProvider(create: (context) => AppCubit(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    checkInternetConnection(AppCubit.get(context));
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ResponsiveSizer(
      builder: (p0, p1, p2) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor:const Color(0xFF232B31),
            primaryColor:const Color(0xFFBC9975),
            appBarTheme:  const AppBarTheme(
                color: Color(0xFFBC9975),
                centerTitle: true,
                iconTheme: IconThemeData(color: Colors.white),
                titleTextStyle: TextStyle(fontSize: 30, color: Colors.white)
            ),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: Color(0xFF232B31),
              selectedItemColor: Colors.white70,
              unselectedItemColor: Colors.grey,
            ),
            fontFamily: 'QuranFont',
          ),
          home: (
              AnimatedSplashScreen(
            splash: const SplashScreen(),
            centered: true,
            splashIconSize: 900,
            nextScreen: const BottomNavBar(),
          )),
        );
      },
    );
  }
}
