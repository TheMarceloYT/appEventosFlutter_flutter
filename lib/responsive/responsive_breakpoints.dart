import 'package:flutter/material.dart';

class ResponsiveBreakpoints{

  //medidas
  static double small = 440;

  //small device
  static bool isSmall(double width) {
    return width <= small;
  }

  //dar orientacion del celular
  static checkDeviceOrientation(BuildContext context) {
    //retorna TRUE si está modo vertical
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

}