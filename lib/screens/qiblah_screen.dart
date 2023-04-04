import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:location/location.dart';

import 'home_screen.dart';


class QiblahScreen extends StatefulWidget {
  const QiblahScreen({super.key});

  @override
  State<QiblahScreen> createState() => _QiblahScreenState();
}

Animation<double>? animation;
AnimationController? _animationController;
double begin = 0.0;

class _QiblahScreenState extends State<QiblahScreen>
    with SingleTickerProviderStateMixin {

  Location location = Location();

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    animation = Tween(begin: 0.0, end: 0.0).animate(_animationController!);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 48, 48, 48),
        body: permissionGranted == PermissionStatus.granted ?
        StreamBuilder(
                stream: FlutterQiblah.qiblahStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                        ));
                  }
                  final qiblahDirection = snapshot.data;
                  animation = Tween(
                          begin: begin,
                          end: (qiblahDirection!.qiblah * (pi / 180) * -1))
                      .animate(_animationController!);
                  begin = (qiblahDirection.qiblah * (pi / 180) * -1);
                  _animationController!.forward(from: 0);
                  return Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${qiblahDirection.direction.toInt()}°",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 24),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                              height: 300,
                              child: AnimatedBuilder(
                                animation: animation!,
                                builder: (context, child) => Transform.rotate(
                                    angle: animation!.value,
                                    child:
                                        Image.asset('assets/images/qibla.png')),
                              ))
                        ]),
                  );
                })
            : const Center(
                child: Text(
                'الرجاء قم بتفعيل الموقع الجغرافي الخاص بك لكي نتمكن من تحديد اتجاه القبلة او قم بتفعيلها من الاعدادات',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              )),
      ),
    );
  }
}
