import 'dart:async';
import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:muslim_app/cubit/controller.dart';
import 'package:workmanager/workmanager.dart';

import 'constants.dart';


FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

Future showNotificationDoea() async {

  int randomIndex = Random().nextInt(smallDo3a2.length-1);

  AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails(
    '$randomIndex.0',
    'Mubarak',
    importance: Importance.max,
    priority: Priority.high,
    playSound: true,
    enableVibration: true,

  );
  var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
  );

  await flutterLocalNotificationsPlugin!.show(
    randomIndex,
    'فَذَكِّرْ',
    smallDo3a2[randomIndex],
    platformChannelSpecifics,
  );
}

// Future showNotificationPrayers() async {
//
//   AndroidNotificationDetails androidPlatformChannelSpecifics =
//   const AndroidNotificationDetails(
//     'حان الان موعد الصلاة',
//     'Mubarak',
//     importance: Importance.max,
//     priority: Priority.high,
//     playSound: true,
//     enableVibration: true,
//
//   );
//   var platformChannelSpecifics = NotificationDetails(
//       android: androidPlatformChannelSpecifics,
//   );
//
//   await flutterLocalNotificationsPlugin!.show(
//     0,
//     'فَذَكِّرْ',
//     ' حان الان موعد الصلاة//',
//     platformChannelSpecifics,
//   );
//
// }

void callbackDispatcher() {

  // initial notifications
  var initializationSettingsAndroid = const AndroidInitializationSettings('@mipmap/z');

  var initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  WidgetsFlutterBinding.ensureInitialized();

  flutterLocalNotificationsPlugin!.initialize(
    initializationSettings,
  );


  Workmanager().executeTask((task, inputData) {
    showNotificationDoea();
    return Future.value(true);
  });
}

String durationToString(int minutes) {
  var d = Duration(minutes: minutes);
  List<String> parts = d.toString().split(':');
  return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
}

int intFromTime(DateTime date) {
  return date.hour * 60 + date.minute;
}

double progress(String? currentPrayerTime, String nextPrayerTime) {
  if (currentPrayerTime != null) {
    if (nextPrayerTime != "s" && currentPrayerTime != "s") {
      if (intFromTime(DateFormat("HH:mm").parse(nextPrayerTime)) >= intFromTime(DateTime.now())) {
        return (intFromTime(DateTime.now()) - intFromTime(DateFormat("HH:mm").parse(currentPrayerTime))) /
            (intFromTime(DateFormat("HH:mm").parse(nextPrayerTime)) -
                intFromTime(DateFormat("HH:mm").parse(currentPrayerTime)));
      }
    }
  }
  return 0.0;
}

Text amPm(String dateTime) {
  DateTime dateTimelabtest = DateFormat("HH:mm").parse(dateTime);
  dateTimelabtest = dateTimelabtest.toLocal();
  var hours = dateTimelabtest.hour;
  var minute = dateTimelabtest.minute;
  var ampm = hours >= 12 ? 'pm' : 'am';
  hours = hours % 12;
  hours = hours != 0 ? hours : 12;
  var h = hours < 10 ? '0' + hours.toString() : hours;
  var m = minute < 10 ? '0' + minute.toString() : minute;
  return Text(
    "$h:$m $ampm",
    style: const TextStyle(fontSize: 22),
  );
}

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}
