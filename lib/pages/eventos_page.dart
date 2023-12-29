//librerias
import 'package:appeventosflutter_flutter/constants/colores_const.dart';
import 'package:appeventosflutter_flutter/pages/agregarEvento_page.dart';
import 'package:appeventosflutter_flutter/pages/eventoDescripcion_page.dart';
import 'package:appeventosflutter_flutter/services/fireBase_service.dart';
import 'package:appeventosflutter_flutter/utils/msg_scaffold_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

//fecha del evento
//ver fecha
Text getFechaEvento(Timestamp fecha, bool disponible) {
  final formatoFecha = DateFormat('dd-MM-yyyy');
  var fechaAux = fecha.toDate();
  var hoy = Timestamp.now().toDate();
  //evento disponible?   {comparo si la fecha de hoy es mayor a la del evento}
  if(hoy.compareTo(fechaAux) > 0 || disponible ==  false) {
    //no está disponible
    return Text('NO DISPONIBLE',
      style: TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    );
  }
  //está disponible
  return Text('${formatoFecha.format(fechaAux)}', 
    style: TextStyle(
      color: Colors.white,
      fontSize: 18,
    ),
  );
}

//ir a la descripcion del evento
void descripcionEvento(BuildContext context, String id, int cantComments, BuildContext evContext){
  MaterialPageRoute ruta = MaterialPageRoute(builder: (context) 
    => EventoDescripcionPage(eventoID: id, cantComments: cantComments, eventosContext: evContext)
  );
  Navigator.push(context, ruta);
}

class EventosPage extends StatelessWidget {
  const EventosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            return Column(
              children: [
                //titulo
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(2),
                  margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colores.celeste(),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text('Eventos', style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  )),
                ),
                //eventos
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (_, __) => Divider(color: Colors.transparent),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var evento = snapshot.data!.docs[index];
                      //evento
                      return Center(
                        child: Container(
                          width: 355,
                          height: 350,
                          //deslisable y opciones
                          child: Slidable(
                            startActionPane: ActionPane(
                              motion: ScrollMotion(),
                              children: [
                                //comentar
                                SlidableAction(
                                  backgroundColor: Colors.orangeAccent,
                                  foregroundColor: Colors.white,
                                  icon: MdiIcons.comment,
                                  label: 'Comentar evento',
                                  onPressed: (btnContext) {
                                    bool logeado = FireBaseService().userEstaLogeado();
                                    if (logeado) {
                                      //voy a la descripción
                                      descripcionEvento(context, evento.id, evento['comentarios'], context);
                                    }
                                    //no está logeado
                                    else{
                                      UtilMensaje.mostrarSnackbar(context, MdiIcons.alertCircle, 
                                        'Error, inicie sesión');
                                    }
                                  },
                                ),
                              ],
                            ),
                            endActionPane: ActionPane(
                              motion: ScrollMotion(),
                              children: [
                                //comentar
                                SlidableAction(
                                  backgroundColor: Colors.purpleAccent,
                                  foregroundColor: Colors.white,
                                  icon: MdiIcons.cogOutline,
                                  label: 'Cambiar estado',
                                  onPressed: (contextEvent) {
                                    bool logeado = FireBaseService().userEstaLogeado();
                                    if (logeado) {
                                      //es su evento?
                                      String? userEmail = FirebaseAuth.instance.currentUser!.email;
                                      if (evento['user'] == userEmail) {
                                        //evento ya descontinuado?
                                        FireBaseService().cambiarEstado(evento.id, evento['disponible'])
                                          .then((todoOk) => {
                                            //cambió el estado?
                                            if(todoOk) {
                                              //si
                                              UtilMensaje.mostrarSnackbar(context, MdiIcons.alertCircle, 
                                                'Estado cambiado'),
                                            }
                                            //no
                                            else {
                                              UtilMensaje.mostrarSnackbar(context, MdiIcons.alertCircle, 
                                                'Error, en cambiar estado'),
                                            }
                                          });
                                      }
                                      //no es su evento
                                      else {
                                        UtilMensaje.mostrarSnackbar(context, MdiIcons.alertCircle, 
                                        'Este no es su evento');
                                      }
                                    }
                                    //no está logeado
                                    else{
                                      UtilMensaje.mostrarSnackbar(context, MdiIcons.alertCircle, 
                                        'Error, inicie sesión');
                                    }
                                  },
                                ),
                              ],
                            ),
                            //cuerpo del evento
                            child: Container(
                              width: 355,
                              height: 350,
                              decoration: BoxDecoration(
                                color: Colores.celeste(),
                                border: Border.all(color: Colores.azul(), width: 1.5),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Column(
                                children: [
                                  //imagen del evento
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
                                  //info del evento
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 10),
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    child: Column(
                                      children: [
                                        //titulo del evento
                                        Container(
                                          alignment: Alignment.center,
                                          child: Text('"${evento['titulo']}"', style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          )),
                                        ),
                                        //cant de comentarios y fecha del evento
                                        Container(
                                          margin: EdgeInsets.symmetric(vertical: 8),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              //comentarios
                                              Row(
                                                children: [
                                                  Icon(MdiIcons.comment, color: Colors.white),
                                                  Text('  ${evento['comentarios']}', style:TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                  ),),
                                                ],
                                              ),
                                              //fecha
                                              Container(
                                                child: getFechaEvento(evento['fecha'], evento['disponible']),
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
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                //icono
                                                Icon(MdiIcons.information, color: Colors.white),
                                                //texto
                                                Text(' Descripción', style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                )),
                                              ],
                                            ),
                                          ),
                                          //link
                                          onTap: () {
                                            bool logeado = FireBaseService().userEstaLogeado();
                                            if (logeado) {
                                              //voy a la descripción
                                              descripcionEvento(context, evento.id, evento['comentarios'], context);
                                            }
                                            //no está logeado
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
                  ),
                ),
              ],
            );
          }
        },
      ),
      //btn agregar evento
      floatingActionButton: 
        FloatingActionButton(
          backgroundColor: Colors.green,
          child: Icon(MdiIcons.plus, 
                  color: Colors.white,
                  size: 40,
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
                UtilMensaje.mostrarSnackbar(context, MdiIcons.alertCircle, 
                  'Error, inicie sesión');
              }
          },
        ),
    );
  }
}