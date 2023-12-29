import 'package:appeventosflutter_flutter/constants/colores_const.dart';
import 'package:appeventosflutter_flutter/services/fireBase_service.dart';
import 'package:appeventosflutter_flutter/utils/msg_scaffold_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

//ponerImg
Image setImg(String? imgUrl) {
  //hay img?
  if(imgUrl != null) {
    //si hay, la muestro
    return Image.network(imgUrl);
  }
  //no hay imagen
  return Image.asset('images/no_imagen.jpg');
}

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
  //controllers del form
  TextEditingController ctrlComentario = TextEditingController(); 

  //variables
  final formKey = GlobalKey<FormState>();
  bool tareaActiva = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appbar
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colores.celeste(),
        title: Text(
          'Info de evento',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      //body
      body: Padding(
        padding: EdgeInsets.only(top: 8),
        child: Container(
          child: Column(
            children: [
              Container(
                child: Expanded(
                  child: ListView(
                    children: [
                      //evento
                      StreamBuilder(
                        stream: FireBaseService().eventoDescripcion(widget.eventoID),
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
                            return Center(
                              child: Container(
                                width: 355,
                                height: 340,
                                decoration: BoxDecoration(
                                  color: Colores.celeste(),
                                  border: Border.all(color: Colores.azul(), width: 1.5),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Column(
                                  children: [
                                    //img
                                    Container(
                                      height: 200,
                                      child: FutureBuilder(
                                        future: FireBaseService().getImage(evento['imagen']),
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
                                            return setImg(imgURL);
                                          }
                                        },
                                      ),
                                    ),
                                    //titulo
                                    Container(
                                      alignment: Alignment.center,
                                      child: Text('"${evento['titulo']}"', style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      )),
                                    ),
                                    //descripcion
                                    Container(
                                      margin: EdgeInsets.symmetric(horizontal: 10),
                                      child: Text('${evento['descripcion']}', style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      )),
                                    ),
                                  ],
                                ),
                              ),
                            ); 
                          }
                        },
                      ),
                      //divider
                      Divider(color: Colors.transparent),
                      //titulo
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(2),
                        margin: EdgeInsets.only(left: 8, right: 8),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colores.celeste(),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text('Comentarios', style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        )),
                      ),
                      Divider(color: Colors.transparent),
                      //comentarios
                      StreamBuilder(
                        stream: FireBaseService().eventoComentarios(widget.eventoID),
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
                              height: 370,
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
              //input comentar
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
                                  if(comentario.length > 50) {return 'El comentario debe ser menor a 50 caracteres';}
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
                                  if(formKey.currentState!.validate() && tareaActiva == false ) {
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
                                            Navigator.pop(context);
                                            tareaActiva == false;
                                            UtilMensaje.mostrarSnackbar(widget.eventosContext, MdiIcons.comment, 
                                              'Evento comentado');
                                          },)
                                        }
                                        //error
                                        else {
                                          UtilMensaje.mostrarSnackbar(context, MdiIcons.alertCircle, 
                                            'Error en comentar'),
                                        }
                                      });
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
        ),
      ),
    );
  }
}