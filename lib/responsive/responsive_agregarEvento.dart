import 'package:appeventosflutter_flutter/constants/colores_const.dart';
import 'package:appeventosflutter_flutter/responsive/responsive_sizes.dart';
import 'package:flutter/material.dart';

class ResponsiveAgregarEvento {

  //poner layout del appbar
  static PreferredSizeWidget ponerLayoutAppbar (double width, double height, BuildContext context) {
    return AppBar(
      toolbarHeight: ResponsiveSizes.getSizesCustom(width, height, 32),
      iconTheme: IconThemeData(
        color: Theme.of(context).colorScheme.primary,
        size: ResponsiveSizes.getSizesCustom(width, height, 56),
      ),
      backgroundColor: Colores.celeste(),
      title: Text(
        'Agregar un evento',
        style: TextStyle(
          fontSize: ResponsiveSizes.getSizesCustom(width, height, 65),
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}