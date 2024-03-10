import 'package:appeventosflutter_flutter/constants/colores_const.dart';
import 'package:appeventosflutter_flutter/processes/eventoDescripcion_processes.dart';
import 'package:appeventosflutter_flutter/responsive/responsive_breakpoints.dart';
import 'package:appeventosflutter_flutter/responsive/responsive_sizes.dart';
import 'package:appeventosflutter_flutter/services/fireBase_service.dart';
import 'package:flutter/material.dart';

class EventoImagenWidget extends StatefulWidget {
  const EventoImagenWidget({
    super.key,
    required this.eventoIMG,
  });

  final String eventoIMG;

  @override
  State<EventoImagenWidget> createState() => _EventoImagenWidget();
}

class _EventoImagenWidget extends State<EventoImagenWidget> {

  Future<dynamic>? futureImagenEvento;

  @override
  void initState() {
    super.initState();
    this.futureImagenEvento = FireBaseService().getImage(widget.eventoIMG);
  }

  @override
  Widget build(BuildContext context) {
    //width y height del movil
    double width = ResponsiveSizes.getWidth(context);
    double height = ResponsiveSizes.getHeight(context);
    //vista
    return Container(
      width: ResponsiveBreakpoints.checkDeviceOrientation(context) ? double.maxFinite : ResponsiveSizes.getSizesCustom(width, height, 3.5),
      height: ResponsiveBreakpoints.checkDeviceOrientation(context) ? ResponsiveSizes.getSizesCustom(width, height, 6) : ResponsiveSizes.getSizesCustom(width, height, 7),
      color: Colores.gris(),
      child: FutureBuilder(
        future: this.futureImagenEvento,
        builder: (context, snapshot) {
          //esperando img
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: Colores.azul()),
            );
          }
          //legó la img
          else {
            var imgURL = snapshot.data == null ? null : snapshot.data.toString();
            return EventoDescripcionProcesses.setImg(imgURL);
          }
        },
      ),
    );
  }
}
