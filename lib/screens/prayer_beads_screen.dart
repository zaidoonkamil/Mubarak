import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslim_app/cubit/cubit.dart';
import 'package:muslim_app/cubit/states.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PrayerBeads extends StatelessWidget {
  const PrayerBeads({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit(),
      child: BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var cubit = AppCubit.get(context);
            return SafeArea(
              child: Scaffold(
                body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 20),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: (){
                          cubit.arrowZkr();
                        },
                        child: Container(
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          alignment: Alignment.center,
                          child: Text(cubit.zkr,style: const TextStyle(
                            fontSize: 24,
                            color: Colors.black
                          ),),
                        ),
                      ),
                      const Spacer(),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                           Row(
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                               SizedBox(width: 10.w,),
                               Image.asset(
                                   'assets/images/tasbih.png',
                                 width: 130,
                                 height: 130,
                               ),
                             ],
                           ),
                          Text('${cubit.prayerBeads}',
                            style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                              color: Colors.grey.shade300,
                          ),),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Spacer(
                            flex: 2,
                          ),
                           GestureDetector(
                             onTap: (){
                               cubit.addPrayerBeads();
                             },
                             child: CircleAvatar(
                               backgroundColor: Theme.of(context).primaryColor,
                              radius: 70,
                              child: const Text('انقر',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20),
                                  textAlign: TextAlign.center),
                          ),
                           ),
                          IconButton(
                              onPressed: () {
                                cubit.resetPrayerBeads();
                              },
                              icon: Icon(
                                Icons.restart_alt,
                                size: 30,
                                color:  Colors.grey.shade300,
                              )),
                          const Spacer(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
