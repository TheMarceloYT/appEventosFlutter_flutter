import 'package:appeventosflutter_flutter/constants/colores_const.dart';
import 'package:appeventosflutter_flutter/processes/eventoDescripcion_processes.dart';
import 'package:appeventosflutter_flutter/responsive/responsive_sizes.dart';
import 'package:appeventosflutter_flutter/services/fireBase_service.dart';
import 'package:appeventosflutter_flutter/utils/msg_scaffold_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class FormEventoComentarioWidget extends StatefulWidget {
  const FormEventoComentarioWidget({super.key,
    required this.eventoID,
    required this.cantComments,
    required this.eventosContext,
  });

  final String eventoID;
  final int cantComments;
  final BuildContext eventosContext;

  @override
  State<FormEventoComentarioWidget> createState() => _FormEventoComentarioWidgetState();
}

class _FormEventoComentarioWidgetState extends State<FormEventoComentarioWidget> {
  //controllers del form
  TextEditingController ctrlComentario = TextEditingController(); 

  //variables
  final formKey = GlobalKey<FormState>();
  bool tareaActiva = false;

  @override
  Widget build(BuildContext context) {
    //width y height del movil
    double width = ResponsiveSizes.getWidth(context);
    double height = ResponsiveSizes.getHeight(context);
    //vista
    return Container(
      color: Colores.celeste(),
      padding: EdgeInsets.all(5),
      child: Form(
        //key
        key: formKey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //input
            Container(
              width: EventoDescripcionProcesses.defWidthInputEventoDescripcion(context, width, height),
              child: TextFormField(
                controller: ctrlComentario,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  prefixIcon: Icon(MdiIcons.comment, 
                    color: Theme.of(context).colorScheme.primary,
                    size: ResponsiveSizes.getSizesCustom(width, height, 55),
                  ),
                  filled: true,
                  fillColor: Colores.gris(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (comentario) {
                  //validar errores
                  if(comentario!.isEmpty) {return 'Ingrese el comentario';}
                  if(comentario.length < 4) {return 'Comentario > 4 caracteres';}
                  if(comentario.length > 50) {return 'Comentario < 50 caracteres';}
                  //todo ok
                  return null;
                },
              ),
            ),
            //btn comentar
            SizedBox(
              height: ResponsiveSizes.getSizesCustom(width, height, 30),
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: Icon(
                  MdiIcons.plus, 
                  color: Theme.of(context).colorScheme.primary,
                  size: ResponsiveSizes.getSizesCustom(width, height, 35),
                ),
                onPressed: () {
                  //user logeado?
                  bool logeado = FireBaseService().userEstaLogeado();
                  if(logeado){
                    //si, form valido?
                    if(formKey.currentState!.validate() && tareaActiva == false) {
                      //si, es valido
                      tareaActiva = true;
                      String comentario = ctrlComentario.text.trim();
                      String email = FirebaseAuth.instance.currentUser!.email!;
                      String userName = FirebaseAuth.instance.currentUser!.displayName!;
                      FireBaseService().comentarEvento(comentario, 
                        email, widget.eventoID, userName, widget.cantComments).then((todoOk) => {
                          //se subió?
                          if(todoOk) {
                            //si se subió
                            setState(() {
                              ctrlComentario.text = '';
                              tareaActiva = false;
                              //rompo context del MODAL BOTTOM SHEET y el actual
                              Navigator.pop(context);
                              Navigator.pop(this.context);
                              //msg de subida
                              UtilMensaje.mostrarSnackbar(widget.eventosContext, MdiIcons.comment, 
                                'Evento comentado');
                            },)
                          }
                          //error
                          else {
                            tareaActiva = false,
                            UtilMensaje.mostrarSnackbar(context, MdiIcons.alertCircle, 
                              'Error en comentar'),
                          }
                        });
                    }
                  }
                  //user no logeado
                  else {
                    UtilMensaje.mostrarSnackbar(context, MdiIcons.alertCircle, 
                      'Error, inicie sesión');
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}