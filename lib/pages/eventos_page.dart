//librerias
import 'package:appeventosflutter_flutter/constants/colores_const.dart';
import 'package:appeventosflutter_flutter/pages/agregarEvento_page.dart';
import 'package:appeventosflutter_flutter/responsive/responsive_eventosPage.dart';
import 'package:appeventosflutter_flutter/responsive/responsive_sizes.dart';
import 'package:appeventosflutter_flutter/services/fireBase_service.dart';
import 'package:appeventosflutter_flutter/utils/msg_scaffold_util.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class EventosPage extends StatefulWidget {
  const EventosPage({super.key});

  @override
  State<EventosPage> createState() => _EventosPageState();
}

class _EventosPageState extends State<EventosPage> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    //width y height del movil
    double width = ResponsiveSizes.getWidth(context);
    double height = ResponsiveSizes.getHeight(context);
    //vista
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: StreamBuilder(
        stream: FireBaseService().eventos(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          //hay data?
          if(!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
            //esperando data
            return Center(
              child: CircularProgressIndicator(color: Colores.azul()),
            );
          }
          //hay data
          else {
            return ResponsiveEventosPage.ponerLayoutEventos(context, width, height, snapshot);
          }
        },
      ),
      //btn agregar evento
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: SizedBox(
        height: ResponsiveSizes.getSizesCustom(width, height, 38),
        child: FloatingActionButton.extended(
          backgroundColor: Colors.green,
          label: Text('Subir evento', style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
            fontSize: ResponsiveSizes.getSizesCustom(width, height, 75),
          )),
          icon: Icon(MdiIcons.plus,
            color: Theme.of(context).colorScheme.primary,
            size: ResponsiveSizes.getSizesCustom(width, height, 45),
          ),
          onPressed: () {
            bool logeado = FireBaseService().userEstaLogeado();
            if (logeado) {
              //voy a agregar evento
              MaterialPageRoute ruta = MaterialPageRoute(builder: (context) => AgregarEventoPage());
              Navigator.push(context, ruta);
            }
            //no está logeado
            else{
              UtilMensaje.mostrarSnackbar(context, MdiIcons.alertCircle, 'Error, inicie sesión');
            }
          },
        ),
      ),
    );
  }
}