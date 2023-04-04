import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:muslim_app/components/components.dart';
import 'package:muslim_app/components/time_util.dart';
import 'package:muslim_app/cubit/controller.dart';
import 'package:muslim_app/models/models.dart';
import 'package:muslim_app/shared/cache_helper.dart';
import 'package:restart_app/restart_app.dart';

var firstTime = true;
PermissionStatus? permissionGranted;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Timer timer;

  late Prayer nextPrayer = Prayer("s", "تقبل الله طاعتكم", false);
  late Prayer? currentPrayer = Prayer("s", "s", false);

  late String reminderTime = "";

  bool visiblityLoader = true;
  var handlerError = false;

  Future getLocationPermission() async {

    Location location = Location();

    bool serviceEnabled;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getLocationPermission();

    if(CacheHelper.getDataFirstRun(key: 'firstRun') !='first') {
      Future.delayed( const Duration(milliseconds: 1), () {
        awesomeDialog(
            context,
            'لن يتم مشاركة الموقع الجغرافي الخاص بك لاي سبب كان',
            'الموقع',
            'الرجاء قم بتفعيل الموقع الجغرافي الخاص بك لكي نتمكن من ارسال اوقات الصلاة المناسبة لك'
        );    });
    }
      CacheHelper.saveDataFirstRun(key: 'firstRun', value: 'first');
    print('-----------------------');
    print(CacheHelper.getDataFirstRun(key: 'firstRun'));

    updatePrayers(() {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: const Text(
                  "Change location",
                  style: TextStyle(fontSize: 18),
                ),
                content: const Text(
                    "Your location has been changed \npress refresh to reset data",
                    style: TextStyle(fontSize: 12)),
                actions: [
                  TextButton(
                      onPressed: () {
                        Restart.restartApp(webOrigin: '[your main route]');
                      },
                      child: Text(
                        "Refresh",
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ))
                ],
                elevation: 22,
              ),
          barrierDismissible: false);
    }).then((value) {
      List<Prayer> newPrayers = [];
      for (var element in value) {
        if (element.title == "Imsak" || element.title == "Sunset") {
        } else {
          if (element.title == "Fajr") element.title = "الفجر";
          if (element.title == "Sunrise") element.title = "الشروق";
          if (element.title == "Dhuhr") element.title = "الظهر";
          if (element.title == "Asr") element.title = "العصر";
          if (element.title == "Maghrib") element.title = "المغرب";
          if (element.title == "Isha") element.title = "العشاء";
          element.time = element.time.substring(0, 5);
          newPrayers.add(element);
        }
      }

      prayers = newPrayers;

      nextPrayer = getNextPrayer()!;
      if (nextPrayer.status == "now") currentPrayer = nextPrayer;

      for (var element in prayers) {
        if (element.selected) currentPrayer = element;
      }
      reminderTime = calculateRemindTime(nextPrayer);

      setState(() => visiblityLoader = false);

      //Update state every mint
      timer =
          Timer.periodic(const Duration(minutes: 30), (Timer t) => update());
   }).catchError((e) {
      print("Eeeeeeeeeeeeeeeeeee $e");
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
                title: Text(
                  "Bad internet",
                  style: TextStyle(fontSize: 18),
                ),
                content: Text(
                    "No Internet connect \ncheck your internet and try again",
                    style: TextStyle(fontSize: 12)),
                elevation: 22,
              ),
          barrierDismissible: false);
    });
  }

  var firstUpdate = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: double.maxFinite,
                    height: MediaQuery.of(context).size.height * 0.28,
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20)),
                        gradient: const LinearGradient(
                            begin: Alignment.bottomCenter,
                            tileMode: TileMode.mirror,
                            end: Alignment.center,
                            colors: [
                              Color(0xFFBC9975),
                              Color(0xFFBC9975),
                            ]),
                        border: Border.all(
                          color: Colors.white,
                          width: .3,
                        ),
                        boxShadow: const [
                          BoxShadow(
                              color: Color(0xFF232B31),
                              offset: Offset(3, 3),
                              blurRadius: 7)
                        ]),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20)),
                            child: Image.asset(
                              'assets/images/m.png',
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(10),
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(30),
                            topLeft: Radius.circular(30)),
                        gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            tileMode: TileMode.mirror,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFFBC9975),
                              Color(0xFFBEA184),
                            ]),
                        border: Border.all(
                          color: Colors.white,
                          width: .3,
                        ),
                        boxShadow: const [
                          BoxShadow(
                              color: Color(0xFF232B31),
                              offset: Offset(3, 3),
                              blurRadius: 7)
                        ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          reminderTime,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(nextPrayer.title,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                        Text(
                          "${CacheHelper.getString('country') ?? ""}  ${CacheHelper.getString('city') ?? ""}",
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
                    child: SizedBox(
                      width: double.maxFinite,
                      child: cardWidget(context),
                    ),
                  ),
                ],
              ),
              Visibility(
                  visible: visiblityLoader,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          color: Colors.white54,
                          height: MediaQuery.of(context).size.height * 1,
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            color: Theme.of(context).primaryColor,
                          )),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void update() {
    setState(() {
      firstTime = false;
      nextPrayer = getNextPrayer()!;
      if (nextPrayer.status == "now") currentPrayer = nextPrayer;
      for (var element in prayers) {
        if (element.selected) currentPrayer = element;
      }
      reminderTime = calculateRemindTime(nextPrayer);
      print(
          "Update now with next prayer${nextPrayer.title} current prayer ${currentPrayer?.title} reminded time $reminderTime");
    });
  }

  Widget cardWidget(BuildContext context) => Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(30),
              bottomLeft: Radius.circular(30)),
          gradient: const LinearGradient(
              begin: Alignment.topCenter,
              tileMode: TileMode.mirror,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFBC9975),
                Color(0xFFE5D0B8),
              ]),
          border: Border.all(
            color: Colors.white,
            width: .3,
          ),
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
            children: [
          prayers[0],
          prayers[1],
          prayers[2],
          prayers[3],
          prayers[4],
          prayers[5]
        ]
                .map((e) => Column(
                      children: [
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //Time widget
                            Container(
                              alignment: Alignment.centerLeft,
                              width: 65,
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: amPm(e.time),
                              ),
                            ),
                            const SizedBox(width: 4),
                            //Title widget
                            Container(
                                alignment: Alignment.centerRight,
                                width: 55,
                                child: FittedBox(
                                    child: Text(e.title,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 24)))),
                          ],
                        ),
                        const SizedBox(height: 10),
                        if (e.selected)
                          Container(
                            width: double.maxFinite,
                            height: 2.3,
                            color: Colors.white70,
                          ),
                        const Divider(
                          height: 1,
                          color: Color(0xFF232B31),
                        )
                      ],
                    ))
                .toList()),
      );

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
