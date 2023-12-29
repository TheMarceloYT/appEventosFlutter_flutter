import 'package:appeventosflutter_flutter/constants/colores_const.dart';
import 'package:appeventosflutter_flutter/services/fireBase_service.dart';
import 'package:appeventosflutter_flutter/utils/msg_scaffold_util.dart';
import 'package:appeventosflutter_flutter/widgets/opcionesUser_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

//poner imagen al user
imgUser() {
  //hay user?
  bool user = FireBaseService().userEstaLogeado();
  if(user) {
    //el user es está logeado
    User? usuario = FirebaseAuth.instance.currentUser;
    //intento encontrar su imagen
    try {
      return NetworkImage('${usuario!.photoURL}');
    }
    //error
    catch(e) {
      //error, saldrá al return de afuera
    }
  }
  //el user NO está logeado
  return AssetImage('images/unloged_user_image.png');
}

//poner nombre al user
String nombreUser() {
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

Widget btnInicioCerrado(BuildContext drawerContext, BuildContext homeContext) {
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
            color: Colores.celeste(),
            size: 35,
          ),
          Text(' Cerrar sesión', style: TextStyle(
            color: Colors.white,
            fontSize: 24,
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
      backgroundColor: Colors.white,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(MdiIcons.account, 
          color: Colores.celeste(),
          size: 35,
        ),
        Text(' Iniciar sesión', style: TextStyle(
          color: Colores.azul(),
          fontSize: 24,
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

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({
      super.key,
      required this.homeContext,
    });

  //scaffoldKey del home
  final BuildContext homeContext;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FireBaseService().usuario,
      builder: (context, User) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            children: [
              //user section
              Container(
                child: Column(
                  children: [
                    //user info
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        color: Colores.gris(),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          //user image
                          Container(
                            height: 130,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colores.azul(), width: 4),
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: imgUser(),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          //nombre del user
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Text(nombreUser(), style: TextStyle(
                              color: Colors.white,
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            )),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              //options section
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 10, bottom: 6),
                  decoration: BoxDecoration(
                    color: Colores.gris(),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: OpcionesUserWidget(),
                ),
              ),
              //btns cerrar y iniciar sesion
              Container(
                //                    drawerContext   homeContext
                child: btnInicioCerrado(context, homeContext),
              ),
            ],
          ),
        );
      },
    );
  }
}