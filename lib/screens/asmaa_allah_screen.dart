import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:muslim_app/cubit/cubit.dart';
import 'package:muslim_app/cubit/states.dart';
import 'package:muslim_app/models/asmaa_allah_elhosna.dart';
import '../components/components.dart';
import '../components/constants.dart';

class AsmaaAllahScreen extends StatelessWidget {
  const AsmaaAllahScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!joinedAsmaaAllahScreenBefore) {
      Future.delayed(
          const Duration(milliseconds: 150),
          () => {
                onScreenOpen(context),
              });
      joinedAsmaaAllahScreenBefore = true;
    }

    return BlocProvider(
        create: (context) => AppCubit()..getAsmaaAllahElHosna(),
        child: BlocConsumer<AppCubit, AppStates>(
            listener: (context, state) {},
            builder: (context, state) {
              return SafeArea(
                child: Scaffold(
                  body: Directionality(
                    textDirection: TextDirection.rtl,
                    child: StaggeredGridView.countBuilder(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 0.0),
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 12,
                        itemCount: AsmaaAllahElHosna.name.length,
                        itemBuilder: (BuildContext context, index) {
                          return InkWell(
                            onTap: () {
                              awesomeDialog(
                                  context,
                                  'التفسير',
                                  AsmaaAllahElHosna.name[index],
                                  AsmaaAllahElHosna.meaning[index]);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  gradient: const LinearGradient(
                                      begin: Alignment.topCenter,
                                      tileMode: TileMode.repeated,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Color(0xFFBC9975),
                                        Color(0xFFE5D0B8),
                                      ]),
                                  border: Border.all(
                                    color: Colors.black54,
                                    width: .3,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.black87,
                                        offset: Offset(1, 1),
                                        blurRadius: 7)
                                  ]),
                              child: defaultText(
                                  text: AsmaaAllahElHosna.name[index],
                                  fontsize: 30,
                                  fontWeight: FontWeight.bold,
                                  txtDirection: TextDirection.rtl),
                            ),
                          );
                        },
                        staggeredTileBuilder: (index) {
                          return StaggeredTile.count(
                              index == 0 ? 2 : 1, index.isEven ? 1.0 : 1.0);
                        }),
                  ),
                ),
              );
            }));
  }
}
