import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:muslim_app/components/components.dart';
import 'package:muslim_app/cubit/states.dart';
import 'package:quran/quran.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../components/constants.dart';
import '../cubit/cubit.dart';
import 'surah_screen.dart';

class QuranScreen extends StatelessWidget {
  const QuranScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);
    if (surahNameFromSharedPref != null) {
      Future.delayed(
          const Duration(milliseconds: 150),
          () => {
                AwesomeDialog(
                  barrierColor: Colors.black.withOpacity(0.5),
                  context: context,
                  dialogType: DialogType.noHeader,
                  animType: AnimType.scale,
                  title: 'هل تود الانتقال الي العلامة؟',
                  btnOkOnPress: () {
                    navigateTo(
                        context,
                        SurahScreen(
                          surahNumber: surahNumFromSharedPref,
                        ));
                  },
                  btnOkText: 'نعم',
                  customHeader: Icon(
                    Icons.bookmark,
                    color: defaultColor,
                    size: 50,
                  ),
                  btnOkColor: defaultColor,
                  btnCancelOnPress: () {},
                  btnCancelText: 'لا',
                  btnCancelColor: Colors.red,
                )..show()
              });
    }
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            body: myPanel(
                screen: WillPopScope(
                  onWillPop: () async {
                    if (cubit.isPlaying) {
                      cubit.togglePlay();
                    }
                    return true ;
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 12),
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                        itemCount: 114,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                gradient: const LinearGradient(
                                    begin: Alignment.topCenter,
                                    tileMode: TileMode.mirror,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0xFFBC9975),
                                      Color(0xFFE5D0B8),                                      Color(0xFFE5D0B8),
                                    ]),
                                border: Border.all(
                                  color: Colors.black,
                                  width: .3,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Color(0xFF232B31),
                                      offset: Offset(3, 3),
                                     )
                                ]),
                            child: InkWell(
                                  onTap: () async {
                                    cubit.quranSoundActive = true;
                                    // to not stop the audio when we navigate to the same surah
                                    if (cubit.surahName !=
                                        getSurahNameArabic(index + 1)) {
                                      FileInfo? cacheIsEmpty =
                                          await DefaultCacheManager().getFileFromCache(
                                              "$quranSoundUrl${index + 1}.mp3");
                                      if (cacheIsEmpty == null) {
                                        cubit.isCached = false;
                                        if (internetConnection) {
                                          cubit.setUrlQuranSoundSrcOnline(
                                              urlSrc: "$quranSoundUrl${index + 1}.mp3");
                                        }
                                      } else {
                                        cubit.isCached = true;
                                        DefaultCacheManager()
                                            .getFileFromCache(
                                                "$quranSoundUrl${index + 1}.mp3")
                                            .then((value) {
                                          cubit.setUrlQuranSoundSrcOffline(
                                              urlSrc: value!.file.path);
                                        });
                                      }
                                      cubit.setSurahInfo(
                                          index + 1, getSurahNameArabic(index + 1));

                                      if (cubit.isPlaying) {
                                        cubit.togglePlay();
                                      }
                                    }
                                    // ignore: use_build_context_synchronously
                                    navigateTo(
                                        context, SurahScreen(surahNumber: index + 1)
                                    );
                                  },
                                  child: Row(
                                    textDirection: TextDirection.rtl,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: HexColor('22211f'),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        width: 13.w,
                                        height: 16.h,
                                        alignment: AlignmentDirectional.center,
                                        child: Text(
                                          '${index + 1}',
                                          style: const TextStyle(
                                              color: Colors.white, fontSize: 17),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 3.w,
                                      ),
                                      defaultText(
                                        textAlign: TextAlign.right,
                                        text: getSurahNameArabic(index + 1) == 'اللهب'
                                            ? 'المسد'
                                            : getSurahNameArabic(index + 1),
                                        fontsize: 28,
                                      ),
                                      const Spacer(),
                                      Column(
                                        children: [
                                          defaultText(text: "اّياتها", fontsize: 18),
                                          SizedBox(
                                            height: Adaptive.h(2.5),
                                          ),
                                          defaultText(
                                              text: '${getVerseCount(index + 1)}',
                                              fontsize: 18),
                                        ],
                                      ),
                                      SizedBox(
                                        width: Adaptive.w(8),
                                      ),
                                      Column(
                                        children: [
                                          defaultText(
                                            textColor: Colors.green,
                                              text: getPlaceOfRevelation(index + 1) ==
                                                      "Makkah"
                                                  ? "مكية"
                                                  : "مدنية",
                                              fontsize: 18),
                                          SizedBox(
                                            height: Adaptive.h(2),
                                          ),
                                          getPlaceOfRevelation(index + 1) == "Makkah"
                                              ? Image(
                                                  image: const AssetImage(
                                                      'assets/images/kaba.png'),
                                                  width: Adaptive.w(9.5),
                                                )
                                              : Image(
                                                  image: const AssetImage(
                                                      'assets/images/MasjidElnabwy.png'),
                                                  width: Adaptive.w(9.5),
                                                ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 3.w,
                                      ),
                                    ],
                                  ),
                                ),
                          ),
                        ),
                    ),
                  ),
                ),
                context: context,
                cubit: cubit),
          ),
        );
      },
    );
  }
}
