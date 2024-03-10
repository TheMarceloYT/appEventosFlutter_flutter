import 'package:appeventosflutter_flutter/constants/colores_const.dart';
import 'package:appeventosflutter_flutter/models/comentarioEvento_model.dart';
import 'package:appeventosflutter_flutter/processes/eventoDescripcion_processes.dart';
import 'package:appeventosflutter_flutter/responsive/responsive_breakpoints.dart';
import 'package:appeventosflutter_flutter/responsive/responsive_sizes.dart';
import 'package:appeventosflutter_flutter/services/fireBase_service.dart';
import 'package:appeventosflutter_flutter/widgets/comentarioText_widget.dart';
import 'package:appeventosflutter_flutter/widgets/usernameText_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EventoComentariosWidget extends StatefulWidget {
  const EventoComentariosWidget({super.key,
    required this.eventoID,
  });

  final String eventoID;

  @override
  State<EventoComentariosWidget> createState() => _EventoComentariosWidgetState();
}

class _EventoComentariosWidgetState extends State<EventoComentariosWidget> {

  Stream<QuerySnapshot>? streamComentariosGlobales;

  @override
  void initState() {
    super.initState();
    this.streamComentariosGlobales = FireBaseService().eventoComentarios(widget.eventoID);
  }

  @override
  Widget build(BuildContext context) {
    //width y height del movil
    double width = ResponsiveSizes.getWidth(context);
    double height = ResponsiveSizes.getHeight(context);
    //vista
    return StreamBuilder(
      stream: this.streamComentariosGlobales,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        //esperando datos
        if(!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(color: Colores.azul()),
          );
        }
        //no hay comentarios
        else if(snapshot.hasData && snapshot.data!.size == 0) {
          return Container(
            padding: EdgeInsets.all(2),
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colores.celeste(),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text('Sin comentarios', style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: ResponsiveSizes.getSizesCustom(width, height, 60),
              fontWeight: FontWeight.bold,
            )),
          );
        }
        //llegaron los datos
        else {
          //comentarios
          return ListView.separated(
            padding: EdgeInsets.symmetric(vertical: 5),
            separatorBuilder: (_, __) => Divider(color: Colors.transparent),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              ComentarioEventoModel comentario = ComentarioEventoModel(snapshot.data!.docs[index]);
              //cuerpo de los comentarios comentarios
              return Center(
                child: Container(
                  width: ResponsiveBreakpoints.isSmall(width) ? ResponsiveSizes.getSizesCustom(width, height, 3.4) : ResponsiveSizes.getSizesCustom(width, height, 2),
                  decoration: BoxDecoration(
                    color: Colores.gris(),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //imagen
                      Container(
                        margin: EdgeInsets.only(left: 8),
                        constraints: BoxConstraints(
                          maxWidth: 80,
                          maxHeight: 80,
                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: EventoDescripcionProcesses.imgUserComentario(comentario.imagen),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      //nombre y comentario
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //nombre del user
                              UserNameTextWidget(userName: comentario.userName, width: width, height: height),
                              //comentario
                              ComentarioTextWidget(comentario: comentario.comentario, width: width, height: height),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}