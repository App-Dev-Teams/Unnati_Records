import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unnati_app/login_page_1.dart';

void main() {
  runApp(const UnnatiApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      //screen responsiveness
      designSize: Size(360.0, 800.0),
      minTextAdapt: true,

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // title: 'Flutter Demo',
        // theme: ThemeData(
        //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        // ),
        home: LoginPage1(),
      ),
    );
  }
}

