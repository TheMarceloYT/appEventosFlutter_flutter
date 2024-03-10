import 'package:appeventosflutter_flutter/constants/colores_const.dart';
import 'package:appeventosflutter_flutter/responsive/responsive_sizes.dart';
import 'package:appeventosflutter_flutter/services/fireBase_service.dart';
import 'package:appeventosflutter_flutter/utils/msg_scaffold_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class DrawerWidgetProcesses{

  //poner imagen al user
  static imgUser() {
    //hay user?
    bool user = FireBaseService().userEstaLogeado();
    if(user) {
      //el user es está logeado
      User? usuario = FirebaseAuth.instance.currentUser;
      //intento encontrar su imagen
      return NetworkImage('${usuario!.photoURL}');
    }
    //el user NO está logeado
    return AssetImage('images/unloged_user_image.png');
  }

  //poner nombre al user
  static String nombreUser() {
    //hay user?
    bool user = FireBaseService().userEstaLogeado();
    if(user) {
      //el user es está logeado
      User? usuario = FirebaseAuth.instance.currentUser;
      return '${usuario!.displayName}';
    }
    //el user NO está logeado
    return 'inicie sesión';
  }

  //elegir botones
  static Widget btnInicioCerrado(BuildContext drawerContext, BuildContext homeContext) {
    double width = ResponsiveSizes.getWidth(homeContext);
    double height = ResponsiveSizes.getHeight(homeContext);
    //hay user?
    bool user = FireBaseService().userEstaLogeado();
    if(user){
      //hay user
      return FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: Colors.red,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(MdiIcons.logout, 
              color: Theme.of(homeContext).colorScheme.primary,
              size: ResponsiveSizes.getSizesCustom(width, height, 55),
            ),
            Text(' Cerrar sesión', style: TextStyle(
              color: Theme.of(homeContext).colorScheme.primary,
              fontSize: ResponsiveSizes.getSizesCustom(width, height, 70),
              fontWeight: FontWeight.bold,
            )),
          ],
        ),
        onPressed: () => FireBaseService().cerrarSesion().then((cerradoOK) {
          //cierro drawer
          Navigator.pop(drawerContext);
          //mando mensaje en el home
          UtilMensaje.mostrarSnackbar(homeContext, MdiIcons.checkBold, 
            'Cerrado de sesión exitoso');
        }),
      );
    }
    //no hay user
    return FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: Colores.azul(),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(MdiIcons.account, 
            color: Theme.of(homeContext).colorScheme.primary,
            size: ResponsiveSizes.getSizesCustom(width, height, 55),
          ),
          Text(' Iniciar sesión', style: TextStyle(
            color: Theme.of(homeContext).colorScheme.primary,
            fontSize: ResponsiveSizes.getSizesCustom(width, height, 70),
            fontWeight: FontWeight.bold,
          )),
        ],
      ),
      onPressed: () => FireBaseService().iniciarSesion().then((inicioOK) {
        //inició sesion?
        if (inicioOK) {
          //si inició, cierro drawer
          Navigator.pop(drawerContext);
          //mando mensaje en el home
          UtilMensaje.mostrarSnackbar(homeContext, MdiIcons.checkBold, 
            'Inicio de sesión exitoso');
        }
      }),
    );
  }

}