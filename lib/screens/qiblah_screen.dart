import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:math' show pi;

import 'package:geolocator/geolocator.dart';
import 'package:muslim_app/components/components.dart';

class QiblahScreen extends StatefulWidget {
  const QiblahScreen({super.key});

  @override
  State<QiblahScreen> createState() => _QiblahScreenState();
}

class _QiblahScreenState extends State<QiblahScreen>
    with SingleTickerProviderStateMixin {

  final _deviceSupport = FlutterQiblah.androidDeviceSensorSupport();
  final _compassSvg = SvgPicture.asset('assets/images/compass.svg');
  final _needleSvg = SvgPicture.asset(
    'assets/images/needle.svg',
    fit: BoxFit.contain,
    height: 300,
    alignment: Alignment.center,
  );

  final _locationStreamController = StreamController<LocationStatus>.broadcast();

  get stream => _locationStreamController.stream;

  Future<void> _checkLocationStatus() async {
    final locationStatus = await FlutterQiblah.checkLocationStatus();
    if (locationStatus.enabled &&
        locationStatus.status == LocationPermission.denied) {
      await FlutterQiblah.requestPermissions();
      final s = await FlutterQiblah.checkLocationStatus();
      _locationStreamController.sink.add(s);
    } else {
      _locationStreamController.sink.add(locationStatus);
    }
  }
  @override
  void initState() {
   _checkLocationStatus();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _locationStreamController.close();
    FlutterQiblah().dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 48, 48, 48),
        body: FutureBuilder(
          future: _deviceSupport,
          builder: (_, AsyncSnapshot<bool?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error.toString()}"),
              );
            }
            if (snapshot.data!) {
              return Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8.0),
                child: StreamBuilder(
                  stream: stream,
                  builder: (context, AsyncSnapshot<LocationStatus> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.data!.enabled == true) {
                      switch (snapshot.data!.status) {
                        case LocationPermission.always:
                        case LocationPermission.whileInUse:
                          return StreamBuilder(
                            stream: FlutterQiblah.qiblahStream,
                            builder: (_, AsyncSnapshot<QiblahDirection> snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting)
                              {
                                return const Center(child: CircularProgressIndicator(),);
                              }

                              final qiblahDirection = snapshot.data!;

                              return Stack(
                                alignment: Alignment.center,
                                children: <Widget>[
                                  Transform.rotate(
                                    angle: (qiblahDirection.direction * (pi / 180) * -1),
                                    child: _compassSvg,
                                  ),
                                  Transform.rotate(
                                    angle: (qiblahDirection.qiblah * (pi / 180) * -1),
                                    alignment: Alignment.center,
                                    child: _needleSvg,
                                  ),
                                  Positioned(
                                    bottom: 8,
                                    child: Text("${qiblahDirection.offset.toStringAsFixed(3)}°"),
                                  )
                                ],
                              );
                            },
                          );

                        case LocationPermission.denied:
                          return LocationErrorWidget(
                            error: "Location service permission denied",
                            callback: _checkLocationStatus,
                          );
                        case LocationPermission.deniedForever:
                          return LocationErrorWidget(
                            error: "Location service Denied Forever !",
                            callback: _checkLocationStatus,
                          );
                        default:
                          return Container();
                      }
                    } else {
                      return LocationErrorWidget(
                        error: "Please enable Location service",
                        callback: _checkLocationStatus,
                      );
                    }
                  },
                ),
              );
            } else {
              return const Center(
                child: Text("Your device is not supported"),
              );
            }
          },
        ),
      ),
    );
  }
}
