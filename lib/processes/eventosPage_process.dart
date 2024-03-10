import 'package:appeventosflutter_flutter/constants/colores_const.dart';
import 'package:appeventosflutter_flutter/models/evento_model.dart';
import 'package:appeventosflutter_flutter/pages/eventoDescripcion_page.dart';
import 'package:appeventosflutter_flutter/responsive/responsive_sizes.dart';
import 'package:appeventosflutter_flutter/services/fireBase_service.dart';
import 'package:appeventosflutter_flutter/utils/msg_scaffold_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class EventosPageProcesses{

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
    return Image.asset('images/no_imagen.jpg', fit: BoxFit.fill);
  }

  //ver fecha
  static Text getFechaEvento(Timestamp fecha, bool disponible, BuildContext context) {
    double width = ResponsiveSizes.getWidth(context);
    double height = ResponsiveSizes.getHeight(context);
    final formatoFecha = DateFormat('dd-MM-yyyy');
    var fechaAux = fecha.toDate();
    var hoy = Timestamp.now().toDate();
    //evento disponible?   {comparo si la fecha de hoy es mayor a la del evento}
    if(hoy.compareTo(fechaAux) > 0 || disponible ==  false) {
      //no está disponible
      return Text('NO DISPONIBLE',
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
          fontSize: ResponsiveSizes.getSizesCustom(width, height, 80),
        ),
      );
    }
    //está disponible
    return Text('${formatoFecha.format(fechaAux)}', 
      style: TextStyle(
        color: Theme.of(context).colorScheme.primary,
        fontSize: ResponsiveSizes.getSizesCustom(width, height, 80),
      ),
    );
  }

  //ir a la descripcion del evento
  static void descripcionEvento(String id, int cantComments, BuildContext evContext) {
    MaterialPageRoute ruta = MaterialPageRoute(builder: (evContext) 
      => EventoDescripcionPage(eventoID: id, cantComments: cantComments, eventosContext: evContext)
    );
    Navigator.push(evContext, ruta);
  }

  //validar cambio de estado
  static void validateCambiarEstado(BuildContext context, EventoModel evento) {
    //el user esta logeado?
    bool logeado = FireBaseService().userEstaLogeado();
    if (logeado) {
      //si, es su evento?
      String? userEmail = FirebaseAuth.instance.currentUser!.email;
      if (userEmail != null && evento.emailUser == userEmail) {
        //si es suyo, evento ya descontinuado?
        FireBaseService().cambiarEstado(evento.id, evento.disponible).then((todoOk) {
          //cambió el estado?
          if(todoOk) {
            //si
            UtilMensaje.mostrarSnackbar(context, MdiIcons.checkBold, 'Estado cambiado');
          }
          //no
          else {
            UtilMensaje.mostrarSnackbar(context, MdiIcons.alertCircle, 'Error en cambiar estado');
          }
        });
      }
      //no es su evento
      else {
        UtilMensaje.mostrarSnackbar(context, MdiIcons.alertCircle, 'Este no es su evento');
      }
    }
    //no esta logeado
    else{
      UtilMensaje.mostrarSnackbar(context, MdiIcons.alertCircle, 'Error, inicie sesión');
    }
  }

}