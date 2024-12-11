import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';

final String assetName = "assets/logo.svg";

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xFF00A1F1),
        body: Center(
          child: Container(
            width: Get.width,
            height: Get.width,
            child: SvgPicture.asset(
              assetName,
              width: 135 * 0.5,
              height: 135 * 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
