import 'package:appeventosflutter_flutter/constants/colores_const.dart';
import 'package:appeventosflutter_flutter/services/fireBase_service.dart';
import 'package:appeventosflutter_flutter/utils/msg_scaffold_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

//poner img de user comentario
imgUserComentario(String imgURL) {
    //intento encontrar su imagen
    try {
      return NetworkImage(imgURL);
    }
    //error
    catch(e) {
      //error, saldrá al return de afuera
    }
  //no se encontró img del user
  return AssetImage('images/unloged_user_image.png');
}

class ChatGlobalPage extends StatefulWidget {
  const ChatGlobalPage({super.key});

  @override
  State<ChatGlobalPage> createState() => _ChatGlobalPageState();
}

class _ChatGlobalPageState extends State<ChatGlobalPage> {
  //controllers del form
  TextEditingController ctrlComentario = TextEditingController(); 

  //variables
  final formKey = GlobalKey<FormState>();
  bool tareaActiva = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //body
      body: Column(
        children: [
          //titulo y comentarios
          Container(
            child: Expanded(
              child: ListView(
                children: [
                  //titulo
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(2),
                    margin: EdgeInsets.only(left: 10, right: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colores.celeste(),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text('Chat Global', style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    )),
                  ),
                  Divider(color: Colors.transparent),
                  //comentarios
                  StreamBuilder(
                    stream: FireBaseService().comentariosGlobales(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      //esperando datos
                      if(!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(color: Colores.azul()),
                        );
                      }
                      //llegaron los datos
                      else {
                        return SizedBox(
                          height: 570,
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 40),
                            child: ListView.separated(
                              separatorBuilder: (_, __) => Divider(color: Colors.transparent),
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                var comentario = snapshot.data!.docs[index];
                                //cuerpo de los comentarios comentarios
                                return Center(
                                  child: Container(
                                    height: 100,
                                    width: 325,
                                    decoration: BoxDecoration(
                                      color: Colores.gris(),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colores.azul(), width: 2),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        //imagen
                                        Container(
                                          height: 80,
                                          width: 100,
                                          child: Image(image: imgUserComentario(comentario['imgUrl'])),
                                        ),
                                        //comentario
                                        Container(
                                          margin: EdgeInsets.only(left: 5),
                                          width: 210,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              //nombre del user
                                              Container(
                                                margin: EdgeInsets.only(top: 5),
                                                child: Text('${comentario['userName']}', style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold
                                                )),
                                              ),
                                              //comentario
                                              Text('${comentario['comentario']}', style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                              )),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          //form de comentar
          Container(
            color: Colores.celeste(),
            padding: EdgeInsets.all(8),
            child: SizedBox(
              height: 80,
              child: ListView(
                children: [
                  Form(
                    //key
                    key: formKey,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //input
                        Container(
                          height: 80,
                          width: 300,
                          child: TextFormField(
                            controller: ctrlComentario,
                            decoration: InputDecoration(
                              prefixIcon: Icon(MdiIcons.comment, 
                                color: Colors.white,
                                size: 30,
                              ),
                              hintText: 'Comentario',
                              hintStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
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
                              if(comentario.length < 4) {return 'El comentario debe ser mayor a 4 caracteres';}
                              //todo ok
                              return null;
                            },
                          ),
                        ),
                        //divider
                        //btn comentar
                        Container(
                          height: 60,
                          margin: EdgeInsets.only(left: 10),
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                            child: Icon(
                              MdiIcons.plus, 
                              color: Colors.white,
                              size: 35,
                            ),
                            onPressed: () {
                              //form valido?
                              bool loged = FireBaseService().userEstaLogeado();
                              if(formKey.currentState!.validate() && tareaActiva == false) {
                                //si, es valido, hay user?
                                if(loged) {
                                  var authUser = FirebaseAuth.instance.currentUser!;
                                  tareaActiva = true;
                                  //si hay user, subir comentario
                                  String comentario = ctrlComentario.text.trim();
                                  var imgUrl = authUser.photoURL!;
                                  var userEmail = authUser.email!;
                                  var userName = authUser.displayName!;
                                  FireBaseService().comentarGlobal(comentario, imgUrl, userEmail, userName)
                                    .then((todoOK) {
                                      //se subio el comentario?
                                      if(todoOK) {
                                        //si se subió
                                        setState(() {
                                          ctrlComentario.text = '';
                                          tareaActiva == false;
                                          UtilMensaje.mostrarSnackbar(context, MdiIcons.comment, 
                                            'Comentario subido');
                                        });
                                      }
                                      //no se subió
                                      else {
                                        UtilMensaje.mostrarSnackbar(context, MdiIcons.alertCircle, 
                                            'Comentario NO subido');
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}