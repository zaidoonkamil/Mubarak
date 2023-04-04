import 'package:flutter/material.dart';
import 'package:muslim_app/components/components.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/mm.png',
            fit: BoxFit.cover,
          ),
          defaultText(
              text: 'Mubarak',
              textColor: Colors.white,
              fontWeight: FontWeight.bold,
            fontsize: 20.sp
          ),
        ],
      ),
    );
  }
}
