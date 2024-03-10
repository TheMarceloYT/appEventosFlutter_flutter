import 'package:appeventosflutter_flutter/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ThemeProvider with ChangeNotifier{

  //atributos
  ThemeData _themeData = detectTheme();

  //get y set
  ThemeData get themeData => _themeData;

  set themeData(ThemeData themeData){
    _themeData = themeData;
    notifyListeners();
  }

  //detectar tema de inicio
  static ThemeData detectTheme(){
    Brightness brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
    bool esTemaClaro = brightness == Brightness.light;
    if(esTemaClaro) {
      return ThemeColors.lightMode;
    }
    return ThemeColors.darkMode;
  }

  //cambiar tema
  void cambiarTema(){
    //cual tema tiene activado
    if(_themeData == ThemeColors.lightMode) {
      //tiene tema claro, cambiar a oscuro
      themeData = ThemeColors.darkMode;
    }
    else{
      themeData = ThemeColors.lightMode;
    }
  }

}