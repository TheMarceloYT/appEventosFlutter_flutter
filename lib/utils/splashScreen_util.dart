import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:appeventosflutter_flutter/home/tab_home.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlutterSplashScreen.fadeIn(
        backgroundColor: Theme.of(context).colorScheme.background,
        childWidget: Center(
          child: SizedBox(
            height: 200,
            width: 200,
            child: Image.asset("images/flutter_logo.png"),
          ),
        ),
        nextScreen: TabHome(),
      ),
    );
  }
}