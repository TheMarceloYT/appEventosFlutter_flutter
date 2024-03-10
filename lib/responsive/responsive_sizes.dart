import 'package:flutter/material.dart';

class ResponsiveSizes{

  //obtener width
  static double getWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  //obtener height
  static double getHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  //obtener font {custom}
  static double getSizesCustom(double width, double height, double divisor) {
    return (width + height) / divisor;
  }

}