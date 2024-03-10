import 'package:appeventosflutter_flutter/constants/colores_const.dart';
import 'package:appeventosflutter_flutter/models/evento_model.dart';
import 'package:appeventosflutter_flutter/processes/eventosPage_process.dart';
import 'package:appeventosflutter_flutter/responsive/responsive_breakpoints.dart';
import 'package:appeventosflutter_flutter/responsive/responsive_sizes.dart';
import 'package:appeventosflutter_flutter/services/fireBase_service.dart';
import 'package:appeventosflutter_flutter/utils/msg_scaffold_util.dart';
import 'package:appeventosflutter_flutter/widgets/tituloText_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ResponsiveEventosPage {
  
  //eventos
  static Widget ponerLayoutEventos(BuildContext context, double width, double height, AsyncSnapshot<QuerySnapshot> snapshot) {
    //seleccionar layout para el device
    if(ResponsiveBreakpoints.isSmall(width) || ResponsiveBreakpoints.checkDeviceOrientation(context)) {
      //small device
      return ListView.separated(
        padding: EdgeInsets.symmetric(vertical: 5),
        separatorBuilder: (_, __) => Divider(color: Colors.transparent),
        itemCount: snapshot.data!.docs.length,
        itemBuilder: (context, index) {
          EventoModel evento = EventoModel(snapshot.data!.docs[index]);
          //evento
          return Center(
            child: Container(
              width: ResponsiveSizes.getSizesCustom(width, height, 3.2),
              //deslisable y opciones
              child: Slidable(
                startActionPane: ActionPane(
                  motion: ScrollMotion(),
                  children: [
                    //cambiar estado
                    SlidableAction(
                      backgroundColor: Colors.purpleAccent,
                      foregroundColor: Theme.of(context).colorScheme.primary,
                      icon: MdiIcons.cogOutline,
                      label: 'Cambiar estado',
                      onPressed: (contextEvent) {
                        //validar user
                        EventosPageProcesses.validateCambiarEstado(context, evento);
                      },
                    ),
                  ],
                ),
                //cuerpo del evento
                child: Container(
                  decoration: BoxDecoration(
                    color: Colores.celeste(),
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5)),
                  ),
                  child: Column(
                    children: [
                      //imagen del evento
                      Container(
                        color: Colores.gris(),
                        width: double.maxFinite,
                        height: ResponsiveSizes.getSizesCustom(width, height, 6),
                        child: FutureBuilder(
                          future: FireBaseService().getImage(evento.imagen),
                          builder: (context, snapshot) {
                            //esperando img
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(color: Colores.azul()),
                              );
                            }
                            //legó la img
                            else {
                              String? imgURL = snapshot.data == null ? null : snapshot.data.toString();
                              return EventosPageProcesses.setImg(imgURL);
                            }
                          },
                        ),
                      ),
                      //info del evento
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Column(
                          children: [
                            //titulo del evento
                            TituloTextWidget(titulo: evento.titulo, width: width, height: height),
                            //cant de comentarios y fecha del evento
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  //comentarios
                                  Row(
                                    children: [
                                      Icon(MdiIcons.comment, 
                                        color: Theme.of(context).colorScheme.primary,
                                        size: ResponsiveSizes.getSizesCustom(width, height, 65),
                                      ),
                                      Text('  ${evento.comentarios}', style:TextStyle(
                                        color: Theme.of(context).colorScheme.primary,
                                        fontSize: ResponsiveSizes.getSizesCustom(width, height, 65),
                                      ),),
                                    ],
                                  ),
                                  //fecha
                                  Container(
                                    child: EventosPageProcesses.getFechaEvento(evento.fecha, 
                                      evento.disponible, context),
                                  ),
                                ],
                              ),
                            ),
                            //enlace la ver la descripción del evento
                            InkWell(
                              child: Container(
                                width: double.maxFinite,
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colores.azul(),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    //icono
                                    Icon(MdiIcons.scriptTextOutline, 
                                      color: Theme.of(context).colorScheme.primary,
                                      size: ResponsiveSizes.getSizesCustom(width, height, 70),
                                    ),
                                    //texto
                                    Text(' Descripción', style: TextStyle(
                                      color: Theme.of(context).colorScheme.primary,
                                      fontSize: ResponsiveSizes.getSizesCustom(width, height, 80),
                                      fontWeight: FontWeight.bold,
                                    )),
                                  ],
                                ),
                              ),
                              //link
                              onTap: () {
                                //esta logeado?
                                bool logeado = FireBaseService().userEstaLogeado();
                                if (logeado) {
                                  //si, voy a la descripción
                                  EventosPageProcesses.descripcionEvento(
                                    evento.id, evento.comentarios, context);
                                }
                                //no esta logeado
                                else{
                                  UtilMensaje.mostrarSnackbar(context, MdiIcons.alertCircle, 
                                    'Error, inicie sesión');
                                }
                              },
                            ), 
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    }
    //large device
    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 5),
      separatorBuilder: (_, __) => Divider(color: Colors.transparent),
      itemCount: snapshot.data!.docs.length,
      itemBuilder: (context, index) {
        EventoModel evento = EventoModel(snapshot.data!.docs[index]);
        //evento
        return Center(
          child: Container(
            width: ResponsiveSizes.getSizesCustom(width, height, 1.6),
            height: ResponsiveSizes.getSizesCustom(width, height, 7),
            //deslisable y opciones
            child: Slidable(
              startActionPane: ActionPane(
                motion: ScrollMotion(),
                children: [
                  //cambiar estado
                  SlidableAction(
                    backgroundColor: Colors.purpleAccent,
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    icon: MdiIcons.cogOutline,
                    label: 'Cambiar estado',
                    onPressed: (contextEvent) {
                      //validar user
                      EventosPageProcesses.validateCambiarEstado(context, evento);
                    },
                  ),
                ],
              ),
              //cuerpo del evento
              child: Container(
                decoration: BoxDecoration(
                  color: Colores.celeste(),
                  borderRadius: BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
                ),
                child: Row(
                  children: [
                    //imagen del evento
                    Container(
                      color: Colores.gris(),
                      width: ResponsiveSizes.getSizesCustom(width, height, 3.5),
                      height: ResponsiveSizes.getSizesCustom(width, height, 7),
                      child: FutureBuilder(
                        future: FireBaseService().getImage(evento.imagen),
                        builder: (context, snapshot) {
                          //esperando img
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(color: Colores.azul()),
                            );
                          }
                          //legó la img
                          else {
                            String? imgURL = snapshot.data == null ? null : snapshot.data.toString();
                            return EventosPageProcesses.setImg(imgURL);
                          }
                        },
                      ),
                    ),
                    //info del evento
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(4),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //titulo del evento
                            TituloTextWidget(titulo: evento.titulo, width: width, height: height),
                            //cant de comentarios y fecha del evento
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  //comentarios
                                  Row(
                                    children: [
                                      Icon(MdiIcons.comment, 
                                        color: Theme.of(context).colorScheme.primary,
                                        size: ResponsiveSizes.getSizesCustom(width, height, 65),
                                      ),
                                      Text('  ${evento.comentarios}', style:TextStyle(
                                        color: Theme.of(context).colorScheme.primary,
                                        fontSize: ResponsiveSizes.getSizesCustom(width, height, 65),
                                      ),),
                                    ],
                                  ),
                                  //fecha
                                  Container(
                                    child: EventosPageProcesses.getFechaEvento(evento.fecha,evento.disponible,context),
                                  ),
                                ],
                              ),
                            ),
                            //enlace la ver la descripción del evento
                            InkWell(
                              child: Container(
                                width: double.maxFinite,
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colores.azul(),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    //icono
                                    Icon(MdiIcons.scriptTextOutline, 
                                      color: Theme.of(context).colorScheme.primary,
                                      size: ResponsiveSizes.getSizesCustom(width, height, 70),
                                    ),
                                    //texto
                                    Text(' Descripción', style: TextStyle(
                                      color: Theme.of(context).colorScheme.primary,
                                      fontSize: ResponsiveSizes.getSizesCustom(width, height, 80),
                                      fontWeight: FontWeight.bold,
                                    )),
                                  ],
                                ),
                              ),
                              //link
                              onTap: () {
                                //esta logeado?
                                bool logeado = FireBaseService().userEstaLogeado();
                                if (logeado) {
                                  //si, voy a la descripción
                                  EventosPageProcesses.descripcionEvento(
                                    evento.id, evento.comentarios, context);
                                }
                                //no esta logeado
                                else{
                                  UtilMensaje.mostrarSnackbar(context, MdiIcons.alertCircle, 
                                    'Error, inicie sesión');
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

}