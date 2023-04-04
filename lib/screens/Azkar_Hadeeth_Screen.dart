import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:muslim_app/components/components.dart';
import 'package:muslim_app/cubit/cubit.dart';
import 'package:muslim_app/models/azkar&Tsabeeh.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../components/constants.dart';

// ignore: must_be_immutable
class AzkarAndHadeethScreen extends StatelessWidget {
  int index = 0;
  String title = "";
  List<String> azkar = [];

  AzkarAndHadeethScreen({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);

    if (index == 0) {
      azkar = AzkarAndTsabeeh.azkarElSabah;
      title = "أَذْكَارُ الصَّبَاحِ";
    } else if (index == 1) {
      azkar = AzkarAndTsabeeh.azkarElMasa2;
      title = "أَذْكَارُ المساءِ";
    } else if (index == 2) {
      azkar = AzkarAndTsabeeh.azkarElNoom;
      title = "أَذْكَارُ النَوْم";
    } else if (index == 3) {
      azkar = AzkarAndTsabeeh.ad3ya;
      title = "أدعية";
    }

    return Scaffold(
      appBar:AppBar(
        title:Text(title),
      ),
      body: ListView.separated(
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.symmetric(
                  horizontal: Adaptive.w(5), vertical: Adaptive.h(3)),
              padding: EdgeInsets.symmetric(
                  horizontal: Adaptive.w(3), vertical: Adaptive.h(2)),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                 BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: Theme.of(context).primaryColor,
                      offset: const Offset(3, 3),
                      blurRadius: 7)
                ],
              ),
              child: Column(
                children: [
                  defaultText(
                      text: azkar[index],
                      textColor: Colors.black,
                      fontsize: 22,
                      fontWeight: FontWeight.bold,
                      txtDirection: TextDirection.rtl),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(
                              text: azkar[index]))
                              .then((value) {
                            Fluttertoast.showToast(
                                msg: "تم النسخ", fontSize: 16.sp);
                          });
                        },
                        icon: const Icon(Icons.copy),
                        color: Colors.black.withOpacity(0.5),
                      ),
                      SizedBox(
                        width: 12.w,
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (context, index) => SizedBox(
            height: Adaptive.h(1),
          ),
          itemCount: azkar.length),
    );
  }
}

