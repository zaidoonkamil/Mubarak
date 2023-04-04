import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:geolocator/geolocator.dart';
import 'package:just_audio/just_audio.dart';
import 'package:muslim_app/components/components.dart';
import 'package:muslim_app/components/constants.dart';
import 'package:muslim_app/cubit/states.dart';
import 'package:muslim_app/models/asmaa_allah_elhosna.dart';
import 'package:muslim_app/screens/asmaa_allah_screen.dart';
import 'package:muslim_app/screens/azkar_screen.dart';
import 'package:muslim_app/screens/home_screen.dart';
import 'package:muslim_app/screens/prayer_beads_screen.dart';
import 'package:muslim_app/screens/quran_screen.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitialAppState());

  static AppCubit get(context) => BlocProvider.of(context);
  String? lat, long;

  int currentIndex=4;
  final List<Widget> screens = [
    const PrayerBeads(),
    const AsmaaAllahScreen(),
    const QuranScreen(),
    const AzkarScreen(),
    const HomeScreen(),
  ];

  List<BottomNavigationBarItem> bottomItems =
  [
    const BottomNavigationBarItem(
      icon: ImageIcon(
          AssetImage('assets/images/tasbih.png',
          ),
        size: 25,
      )
    ),
    const BottomNavigationBarItem(
      icon: ImageIcon(
        AssetImage('assets/images/icons8-allah-64.png',
        ),
        size: 30,
      ),
    ),
    const BottomNavigationBarItem(
        icon: ImageIcon(
          AssetImage('assets/images/icons8-reading-quran-64.png',
          ),
          size: 29,
        )
    ),
    const BottomNavigationBarItem(
        icon: ImageIcon(
          AssetImage('assets/images/icons8-praying-hand-prayer-worship-islam-muslim-respect-dua-64.png',
          ),
          size: 28,
        ),
    ),
    const BottomNavigationBarItem(
        icon: ImageIcon(
          AssetImage('assets/images/icons8-azan-64 (1).png',
          ),
          size: 35,
        ),
    ),
  ];

  void changeIndex(int index){
    currentIndex=index;
    emit(AppBottomNavBarState());
  }

  List<String> zkrList=[
    'سبحان الله',
    'الحمد لله',
    'لا الله الا الله',
    'الله اكبر',
  ];

  String zkr='سبحان الله';
  var i=0;
  void arrowZkr(){
    if(i<3) {
      i++;
      zkr = zkrList[i];
      emit(ZkrPrayerBeadsState());
    }else{
      i=0;
      zkr = zkrList[i];
      emit(ZkrPrayerBeadsState());
    }
  }

  int prayerBeads=0;

  void addPrayerBeads(){
    prayerBeads++;
    emit(AddPrayerBeadsState());
  }
  void resetPrayerBeads(){
    prayerBeads=0;
    emit(AddPrayerBeadsState());
  }

  void getAsmaaAllahElHosna(){
    Map<String, dynamic> json2 = jsonDecode(asmaaAllahElHosna);
    AsmaaAllahElHosna.fromJson(json2);
  }

  Future getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    lat = position.latitude.toString();
    long = position.longitude.toString();
    emit(GotLocationAppState());
  }

  bool isPlaying = false;

  AudioPlayer quranSound = AudioPlayer();
  AudioPlayer azanSound = AudioPlayer();
  IconData soundIcon = Icons.play_arrow;
  bool quranSoundActive = false;
  String surahName = '';
  int surahNumber = 0;
  int currentPageNumber = 0;
  bool isCached = false;
  String quranSoundUrl = "";

  void setCurrentPageNumber(int pageNumber) {
    currentPageNumber = pageNumber;
    emit(SetCurrentPageNumberAppState());
  }

  void setSurahInfo(int number, String name) {
    surahNumber = number;
    if (name == 'اللهب') {
      name = 'المسد';
    }
    surahName = name;
  }

  void setUrlQuranSoundSrcOnline({required String urlSrc}) {
    quranSoundActive = true;
    quranSoundUrl = urlSrc;
    quranSound.setUrl(urlSrc);
  }

  void setUrlQuranSoundSrcOffline({required String urlSrc}) {
    quranSoundActive = true;
    quranSound.setFilePath(urlSrc);
  }

  void changeQuranSoundActive() {
    soundIcon = Icons.play_arrow;
    quranSoundActive = false;
    quranSound.stop();
    quranSound.seek(Duration.zero);
    isPlaying = false;
    emit(ChangeQuranSoundActiveState());
  }

  void togglePlay() {
    if (!isPlaying) {
      quranSound.play();
      soundIcon = Icons.pause;
      emit(PlaySoundAppState());
    } else {
      quranSound.pause();
      soundIcon = Icons.play_arrow;
      emit(PauseSoundAppState());
    }
    isPlaying = !isPlaying;

    quranSound.playerStateStream.listen((event) {
      if (event.processingState == ProcessingState.completed ||
          (!isCached && !internetConnection)) {
        quranSound.seek(Duration.zero);
        quranSound.stop();
        isPlaying = false;
        soundIcon = Icons.play_arrow;
        emit(PauseSoundAppState());
      }
    });
  }

  bool isDownloading = false;

  void downloadSurahSound() {
    isDownloading = true;
    soundIcon = Icons.download;
    emit(DownloadSoundAppState());
    DefaultCacheManager().downloadFile(quranSoundUrl).then((value) {
      isCached = true;
      isDownloading = false;
      defaultFlutterToast(
          msg: "تم تحميل السورة بنجاح", backgroundColor: Colors.green);
      soundIcon = Icons.play_arrow;
      emit(DownloadSoundAppState());
    });
  }

}
