import 'package:appeventosflutter_flutter/constants/colores_const.dart';
import 'package:appeventosflutter_flutter/responsive/responsive_eventoDescripcion.dart';
import 'package:appeventosflutter_flutter/responsive/responsive_sizes.dart';
import 'package:appeventosflutter_flutter/services/fireBase_service.dart';
import 'package:appeventosflutter_flutter/utils/bottomsheet_util.dart';
import 'package:appeventosflutter_flutter/utils/msg_scaffold_util.dart';
import 'package:appeventosflutter_flutter/widgets/eventoComentarios_widget.dart';
import 'package:appeventosflutter_flutter/widgets/formEventoComentario_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class EventoDescripcionPage extends StatefulWidget {
  const EventoDescripcionPage({super.key,
    required this.eventoID,
    required this.cantComments,
    required this.eventosContext,
  });

  final String eventoID;
  final int cantComments;
  final BuildContext eventosContext;

  @override
  State<EventoDescripcionPage> createState() => _EventoDescripcionPageState();
}

class _EventoDescripcionPageState extends State<EventoDescripcionPage> {

  Future<DocumentSnapshot>? futureEvento;

  @override
  void initState() {
    super.initState();
    this.futureEvento = FireBaseService().eventoDescripcion(widget.eventoID);
  }

  @override
  Widget build(BuildContext context) {
    //width y height del movil
    double width = ResponsiveSizes.getWidth(context);
    double height = ResponsiveSizes.getHeight(context);
    //vista
    return Scaffold(
      resizeToAvoidBottomInset: false,
      //appbar
      appBar: ResponsiveEventoDescripcion.ponerAppbar(width, height ,context),
      //body
      body: Padding(
        padding: EdgeInsets.only(top: 5),
        child: Column(
          children: [
            //evento
            FutureBuilder(
              future: futureEvento,
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                //esperando datos
                if(!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(color: Colores.azul()),
                  );
                }
                //llegaron los datos
                else {
                  var evento = snapshot.data!;
                  //evento
                  return ResponsiveEventoDescripcion.ponerLayoutEvento(width, height, widget.eventoID, context, evento); 
                }
              },
            ),
            //comentarios
            Expanded(child: EventoComentariosWidget(eventoID: widget.eventoID)),
          ],
        ),
      ),  
      //btn agregar comentario
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: SizedBox(
        height: ResponsiveSizes.getSizesCustom(width, height, 38),
        child: FloatingActionButton.extended(
          backgroundColor: Colors.green,
          label: Text('Comentar', style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
            fontSize: ResponsiveSizes.getSizesCustom(width, height, 75),
          )),
          icon: Icon(MdiIcons.comment,
            color: Theme.of(context).colorScheme.primary,
            size: ResponsiveSizes.getSizesCustom(width, height, 65),
          ),
          onPressed: () {
            bool logeado = FireBaseService().userEstaLogeado();
            if (logeado) {
              //muestro modal para comentar
              UtilBottomSheet.mostrarFormBottomSheet(
                context,
                FormEventoComentarioWidget(eventoID: widget.eventoID, 
                  cantComments: widget.cantComments, eventosContext: widget.eventosContext
                ),
              );
            }
            //no está logeado
            else{
              UtilMensaje.mostrarSnackbar(context, MdiIcons.alertCircle, 
                'Error, inicie sesión');
            }
          },
        ),
      ),
    );
  }
}