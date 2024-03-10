import 'package:appeventosflutter_flutter/constants/colores_const.dart';
import 'package:appeventosflutter_flutter/responsive/responsive_sizes.dart';
import 'package:flutter/material.dart';

class UtilMensaje {
  static void mostrarSnackbar(BuildContext context, IconData icono, String texto, {int duracion = 3}) {
    double width = ResponsiveSizes.getWidth(context);
    double height = ResponsiveSizes.getHeight(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icono, color: Theme.of(context).colorScheme.primary, 
            size: ResponsiveSizes.getSizesCustom(width, height, 60),
          ),
          Text(' ' + texto, style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: ResponsiveSizes.getSizesCustom(width, height, 70),
            fontWeight: FontWeight.bold,
          )),
        ],
      ),
      backgroundColor: Colores.celeste(),
      duration: Duration(seconds: duracion),
    ));
  }
}