import 'package:appeventosflutter_flutter/constants/colores_const.dart';
import 'package:appeventosflutter_flutter/constants/opcionesUser_const.dart';
import 'package:appeventosflutter_flutter/responsive/responsive_sizes.dart';
import 'package:appeventosflutter_flutter/services/fireBase_service.dart';
import 'package:flutter/material.dart';

//obtener opciones del user
List opcUser() {
  bool user = FireBaseService().userEstaLogeado();
  //hay user?
  if(user) {
    //si hay, paso opciones del user
    return OpcionesUser.opcionesUserLogeado;
  }
  //no hay user
  else{
    //paso opciones normales
    return OpcionesUser.opcionesUserNormal;
  }
}

class OpcionesUserWidget extends StatelessWidget {
  final List opciones = opcUser();

  @override
  Widget build(BuildContext context) {
    //width y height del movil
    double width = ResponsiveSizes.getWidth(context);
    double height = ResponsiveSizes.getHeight(context);
    //vista
    return ListView.builder(
      padding: EdgeInsets.only(left: 10, right: 10, top: 15),
      itemCount: opciones.length,
      itemBuilder:(context, index) {
        dynamic opcion = opciones[index];
        return Container(
          margin: EdgeInsets.only(bottom: 15),
          padding: EdgeInsets.all(2),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            //icono
            leading: Icon(opcion['icono'], 
              color: Colores.celeste(),
              size: ResponsiveSizes.getSizesCustom(width, height, 50),
            ),
            //titulo
            title: Text(opcion['titulo'].toString(), style: TextStyle(
              color: Colores.azul(),
              fontSize: ResponsiveSizes.getSizesCustom(width, height, 80),
              fontWeight: FontWeight.bold,
            )),
            onTap: () {
              //hay opcion disponible?
              if(opcion['action'] != null){
                //si la hay
                
              }
            },
          ),
        );
      }
    );
  }
}