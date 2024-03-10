import 'package:appeventosflutter_flutter/constants/colores_const.dart';
import 'package:appeventosflutter_flutter/responsive/responsive_breakpoints.dart';
import 'package:appeventosflutter_flutter/responsive/responsive_sizes.dart';
import 'package:appeventosflutter_flutter/widgets/eventoImagen_widget.dart';
import 'package:appeventosflutter_flutter/widgets/subtituloText_widget.dart';
import 'package:appeventosflutter_flutter/widgets/tituloText_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ResponsiveEventoDescripcion {

  //poner layout appbar
  static PreferredSizeWidget ponerAppbar (double width, double height ,BuildContext context) {
    return AppBar(
      toolbarHeight: ResponsiveSizes.getSizesCustom(width, height, 32),
      iconTheme: IconThemeData(
        color: Theme.of(context).colorScheme.primary, 
        size: ResponsiveSizes.getSizesCustom(width, height, 56),
      ),
      backgroundColor: Colores.celeste(),
      title: Text(
        'Info de evento',
        style: TextStyle(
          fontSize: ResponsiveSizes.getSizesCustom(width, height, 65),
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  //poner layout evento
  static Widget ponerLayoutEvento (double width, double height, String eventoID, BuildContext context, DocumentSnapshot evento) {
    //que device es?
    if(ResponsiveBreakpoints.isSmall(width) || ResponsiveBreakpoints.checkDeviceOrientation(context)) {
      //es small
      return Center(
        child: Container(
          width: ResponsiveSizes.getSizesCustom(width, height, 3.2),
          decoration: BoxDecoration(
            color: Colores.celeste(),
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5)),
          ),
          child: Column(
            children: [
              //img
              EventoImagenWidget(eventoIMG: evento['imagen']),
              //titulo
              TituloTextWidget(titulo: evento['titulo'].toString(), width: width, height: height),
              //descripcion
              SubtituloTextWidget(texto: evento['descripcion'].toString(), width: width, height: height),
            ],
          ),
        ),
      );
    }
    //es large
    return Center(
      child: Container(
        width: ResponsiveSizes.getSizesCustom(width, height, 1.6),
        height: ResponsiveSizes.getSizesCustom(width, height, 7),
        decoration: BoxDecoration(
          color: Colores.celeste(),
          borderRadius: BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
        ),
        child: Row(
          children: [
            //img
            EventoImagenWidget(eventoIMG: evento['imagen']),
            //titulo y cdescripcion
            Expanded(
              child: Column(
                children: [
                  //titulo
                  TituloTextWidget(titulo: evento['titulo'].toString(), width: width, height: height),
                  //descripcion
                  SubtituloTextWidget(texto: evento['descripcion'].toString(), width: width, height: height),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}