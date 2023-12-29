import 'package:appeventosflutter_flutter/constants/colores_const.dart';
import 'package:flutter/material.dart';

class UtilMensaje {
  static void mostrarSnackbar(BuildContext context, IconData icono, String texto, {int duracion = 3}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icono, color: Colors.white, size: 28),
          Text(' ' + texto, style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          )),
        ],
      ),
      backgroundColor: Colores.celeste(),
      duration: Duration(seconds: duracion),
    ));
  }
}