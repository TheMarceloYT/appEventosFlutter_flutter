import 'package:appeventosflutter_flutter/constants/colores_const.dart';
import 'package:appeventosflutter_flutter/constants/opcionesUser_const.dart';
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
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      children: opciones.map((opcion) {
        return Container(
          margin: EdgeInsets.only(bottom: 15),
          height: 65,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            //icono
            leading: Icon(opcion['icono'], 
              color: Colores.celeste(),
              size: 32,
            ),
            //titulo
            title: Text(opcion['titulo'].toString(), style: TextStyle(
              color: Colores.azul(),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            )),
            onTap: () {},
          ),
        );
      }).toList(),
    );
  }
}