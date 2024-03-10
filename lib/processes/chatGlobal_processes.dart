import 'package:appeventosflutter_flutter/responsive/responsive_sizes.dart';
import 'package:flutter/material.dart';

class ChatGlobalProcesses{

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
  static double defWidthInputGlobal(BuildContext context, double width, double height) {
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