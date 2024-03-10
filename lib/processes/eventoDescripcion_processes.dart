import 'package:appeventosflutter_flutter/constants/colores_const.dart';
import 'package:appeventosflutter_flutter/responsive/responsive_sizes.dart';
import 'package:flutter/material.dart';

class EventoDescripcionProcesses{

  //poner img
  static Widget setImg(String? imgUrl) {
    //hay img?
    if(imgUrl != null) {
      //si hay, la muestro
      return Image.network(imgUrl,
        fit: BoxFit.fill,
        loadingBuilder: (context, child, loadingProgress) {
          //cargó la img
          if(loadingProgress == null) return child;
          //cargando
          return Center(child: CircularProgressIndicator(color: Colores.azul()));
        },
      );
    }
    //no hay imagen
    return Image.asset('images/no_imagen.jpg');
  }

  //poner img de user comentario
  static imgUserComentario(String imgURL) {
      //intento encontrar su imagen
      try {
        return NetworkImage(imgURL);
      }
      //error
      catch(e) {
        //error, saldrá al return de afuera
      }
    //no se encontró img del user
    return AssetImage('images/unloged_user_image.png');
  }

   //definir width del input segun orientation
  static double defWidthInputEventoDescripcion(BuildContext context, double width, double height) {
    //orientation
    Orientation deviceOrientation = MediaQuery.of(context).orientation;
    //comprobar
    if(deviceOrientation == Orientation.portrait) {
      //es portrait
      return ResponsiveSizes.getSizesCustom(width, height, 4.5);
    }
    //es large
    return ResponsiveSizes.getSizesCustom(width, height, 2);
  }

}