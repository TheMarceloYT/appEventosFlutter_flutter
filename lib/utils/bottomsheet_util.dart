import 'package:appeventosflutter_flutter/constants/colores_const.dart';
import 'package:flutter/material.dart';

class UtilBottomSheet{

  //mostrar modal
  static mostrarFormBottomSheet(BuildContext context, Widget widget) {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colores.celeste(),
      context: context,
      builder: (modalContext) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(modalContext).viewInsets.bottom),
          child: widget,
        );
      }
    );
  }

}