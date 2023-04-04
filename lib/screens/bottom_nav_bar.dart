import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:muslim_app/cubit/cubit.dart';
import 'package:muslim_app/cubit/states.dart';

class BottomNavBar extends StatelessWidget {
   const BottomNavBar({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=>AppCubit (),
      child: BlocConsumer<AppCubit ,AppStates>(
        listener:( context, state){},
        builder: ( context, state) {
          var cubit = AppCubit .get(context);
          return Scaffold(
            body: cubit.screens[cubit.currentIndex],
            bottomNavigationBar: SnakeNavigationBar.color(
              showUnselectedLabels: false,
              showSelectedLabels: true,
              snakeShape: SnakeShape.circle,
              snakeViewColor: const Color(0xFFBC9975),
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeIndex(index);
              },
              items: cubit.bottomItems,
            ),
          );
        },
      ),
    );
  }
}
