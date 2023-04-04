import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:muslim_app/components/components.dart';
import 'package:muslim_app/components/constants.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'Azkar_Hadeeth_Screen.dart';
import 'qiblah_screen.dart';

class AzkarScreen extends StatelessWidget {
  const AzkarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 5),
            child: Column(
              children: [
                InkWell(
                  onTap: (){
                    navigateTo(context, const QiblahScreen());
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    width: double.maxFinite,
                    height: Adaptive.h(26),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        gradient: const LinearGradient(
                            begin: Alignment.bottomCenter,
                            tileMode: TileMode.mirror,
                            end: Alignment.center,
                            colors: [
                              Color(0xFFE0C7AB),
                              Color(0xFFE5D0B8),
                            ]),
                        border: Border.all(
                          color: Colors.black54,
                          width: .3,
                        ),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black87,
                              offset: Offset(0, 0),
                              blurRadius: 7)
                        ]),
                    child: Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        Image(
                          image: const AssetImage('assets/images/icons8-qibla-direction-48.png'),
                          fit: BoxFit.fill,
                          width: Adaptive.w(23),
                          height: Adaptive.h(14),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              width: Adaptive.w(37),
                              color: Colors.black.withOpacity(.7),
                              child: defaultText(
                                  text: 'القبلة',
                                  textColor: Colors.white,
                                  fontsize: 17,
                                  textAlign: TextAlign.center,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                StaggeredGridView.countBuilder(
                  shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 0.0),
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 12,
                      itemCount: azkarList.length,
                      itemBuilder: (BuildContext context, index) {
                        return InkWell(
                          onTap: () {
                            navigateTo(context, AzkarAndHadeethScreen(index: index));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                gradient: const LinearGradient(
                                    begin: Alignment.topCenter,
                                    tileMode: TileMode.mirror,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0xFFBC9975),
                                      Color(0xFFE5D0B8),                                      Color(0xFFE5D0B8),
                                    ]),
                                border: Border.all(
                                  color: Colors.black54,
                                  width: .3,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.black87,
                                      offset: Offset(0, 0),
                                      blurRadius: 7)
                                ]),
                            child: Stack(
                              alignment: AlignmentDirectional.center,
                              children: [
                                Image(
                                  image: AssetImage(azkarList[index].img),
                                  fit: BoxFit.fill,
                                  width: Adaptive.w(27),
                                  height: Adaptive.h(13),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      width: Adaptive.w(27),
                                      color: Colors.black.withOpacity(.7),
                                      child: defaultText(
                                          text: azkarList[index].text,
                                          textColor: Colors.white,
                                          fontsize: 17,
                                          textAlign: TextAlign.center,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      staggeredTileBuilder: (index) {
                        return const StaggeredTile.count(1,  1.0);
                      }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
