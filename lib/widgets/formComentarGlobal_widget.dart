import 'package:appeventosflutter_flutter/constants/colores_const.dart';
import 'package:appeventosflutter_flutter/processes/chatGlobal_processes.dart';
import 'package:appeventosflutter_flutter/responsive/responsive_sizes.dart';
import 'package:appeventosflutter_flutter/services/fireBase_service.dart';
import 'package:appeventosflutter_flutter/utils/msg_scaffold_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class FormComentarChatGlobal extends StatefulWidget {
  const FormComentarChatGlobal({super.key});

  @override
  State<FormComentarChatGlobal> createState() => _FormComentarChatGlobalState();
}

class _FormComentarChatGlobalState extends State<FormComentarChatGlobal> {
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
              width: ChatGlobalProcesses.defWidthInputGlobal(context, width, height),
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
                  //form valido?
                  bool loged = FireBaseService().userEstaLogeado();
                  if(formKey.currentState!.validate() && tareaActiva == false) {
                    //si, es valido, hay user?
                    if(loged) { 
                      User authUser = FirebaseAuth.instance.currentUser!;
                      tareaActiva = true;
                      //si hay user, subir comentario
                      String comentario = ctrlComentario.text.trim();
                      String imgUrl = authUser.photoURL!;
                      String userEmail = authUser.email!;
                      String userName = authUser.displayName!;
                      FireBaseService().comentarGlobal(comentario, imgUrl, userEmail, userName)
                        .then((todoOK) {
                          //se subio el comentario?
                          if(todoOK) {
                            //si se subió
                            setState(() {
                              ctrlComentario.text = '';
                              tareaActiva = false;
                              //rompo context del MODAL BOTTOM SHEET
                              Navigator.pop(context);
                              //msg de subida
                              UtilMensaje.mostrarSnackbar(context, MdiIcons.comment, 
                                'Comentario subido');
                            });
                          }
                          //no se subió
                          else {
                            UtilMensaje.mostrarSnackbar(context, MdiIcons.alertCircle, 
                                'Comentario NO subido');
                            tareaActiva = false;
                          }
                        });
                    }
                    //no hay user,
                    else{
                      UtilMensaje.mostrarSnackbar(context, MdiIcons.alertCircle, 
                        'Error, inicie sesión');
                    }
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