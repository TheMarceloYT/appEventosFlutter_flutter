import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class OpcionesUser{
  //listas 
  static List opcionesUserLogeado = [
    {'icono': MdiIcons.cogBox, 'titulo': 'Administrar cuenta'},
    {'icono': MdiIcons.informationBox, 'titulo': 'Sobre nosotros'},
    {'icono': MdiIcons.progressHelper, 'titulo': 'Soporte'},
    {'icono': MdiIcons.comment, 'titulo': 'Comentar'},
    {'icono': MdiIcons.partyPopper, 'titulo': 'Mis eventos'},
    {'icono': MdiIcons.swapHorizontal, 'titulo': 'Cambiar cuenta'},
    {'icono': MdiIcons.accountGroup, 'titulo': 'Suscripciones'},
    {'icono': MdiIcons.cog, 'titulo': 'Opciones'},
  ];
  
  static List opcionesUserNormal = [
    {'icono': MdiIcons.informationBox, 'titulo': 'Sobre nosotros'},
    {'icono': MdiIcons.progressHelper, 'titulo': 'Soporte'},
    {'icono': MdiIcons.comment, 'titulo': 'Comentar'},
    {'icono': MdiIcons.google, 'titulo': 'Cuenta google'},
    {'icono': MdiIcons.cog, 'titulo': 'Opciones'},
  ];

  /*
  //para user logeado
  List getOpcionesLogeado() {
    return opcionesUserLogeado;
  }
  
  //para user normal
  List getOpcionesNormal() {
    return opcionesUserNormal;
  }*/
}