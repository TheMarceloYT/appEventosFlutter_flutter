import 'package:appeventosflutter_flutter/constants/colores_const.dart';
import 'package:appeventosflutter_flutter/responsive/responsive_chatGlobal.dart';
import 'package:appeventosflutter_flutter/responsive/responsive_sizes.dart';
import 'package:appeventosflutter_flutter/services/fireBase_service.dart';
import 'package:appeventosflutter_flutter/utils/bottomsheet_util.dart';
import 'package:appeventosflutter_flutter/utils/msg_scaffold_util.dart';
import 'package:appeventosflutter_flutter/widgets/formComentarGlobal_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ChatGlobalPage extends StatefulWidget {
  const ChatGlobalPage({super.key});

  @override
  State<ChatGlobalPage> createState() => _ChatGlobalPageState();
}

class _ChatGlobalPageState extends State<ChatGlobalPage> with AutomaticKeepAliveClientMixin {

  Stream<QuerySnapshot>? streamComentariosGlobales;

  @override
  void initState() {
    super.initState();
    this.streamComentariosGlobales = FireBaseService().comentariosGlobales();
  }

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
      //body
      body: StreamBuilder(
        stream: streamComentariosGlobales,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          //esperando datos
          if(!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: Colores.azul()),
            );
          }
          //llegaron los datos
          else {
            return ResponsiveChatGlobal.ponerLayoutChatGlobalComentarios(width, height , snapshot);
          }
        },
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
              UtilBottomSheet.mostrarFormBottomSheet(context, FormComentarChatGlobal());
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