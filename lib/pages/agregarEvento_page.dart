import 'dart:io';
import 'package:appeventosflutter_flutter/constants/colores_const.dart';
import 'package:appeventosflutter_flutter/services/fireBase_service.dart';
import 'package:appeventosflutter_flutter/utils/msg_scaffold_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

//mostrar que no hay imagen
Widget noHayImagen() {
  return Image.asset('images/no_imagen.jpg');
}

//mostrar imagen
Widget mostrarImagen(File img) {
  return Image.file(img);
}

class AgregarEventoPage extends StatefulWidget {
  const AgregarEventoPage({super.key});

  @override
  State<AgregarEventoPage> createState() => _AgregarEventoPageState();
}

class _AgregarEventoPageState extends State<AgregarEventoPage> {
  //controllers del form
  TextEditingController ctrlTitulo = TextEditingController();
  TextEditingController ctrlDescripcion = TextEditingController();
  //variables de ayuda
  final formKey = GlobalKey<FormState>();
  final formatoFecha = DateFormat('dd-MM-yyyy');
  DateTime fecha_hoy = DateTime.now();
  final ImagePicker _img = ImagePicker();
  XFile? imagen = null;
  File? imagen_para_subir;
  String msgImgError = '';
  bool processSubida = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appbar
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colores.celeste(),
        title: Text(
          'Agregar un evento',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      //body
      body: Container(
        //formulario
        child: Form(
          //key
          key: formKey,
          child: Column(
            children: [
              //cuerpo del form
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(top: 8, left: 8, right: 8),
                  child: ListView(
                    children: [
                      //campo titulo
                      TextFormField(
                        controller: ctrlTitulo,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          prefixIcon: Icon(MdiIcons.formatText, 
                            color: Colores.azul(),
                            size: 30,
                          ),
                          hintText: 'Titulo',
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          filled: true,
                          fillColor: Colores.celeste(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (titulo) {
                          //validar errores
                          if(titulo!.isEmpty) {return 'Ingrese el titulo';}
                          if(titulo.length < 4) {return 'El titulo debe ser mayor a 4 caracteres';}
                          //todo ok
                          return null;
                        },
                      ),
                      Divider(color: Colors.transparent),
                      //campo descripcion
                      TextFormField(
                        controller: ctrlDescripcion,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          prefixIcon: Icon(MdiIcons.textBox, 
                            color: Colores.azul(),
                            size: 30,
                          ),
                          hintText: 'Descripción',
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          filled: true,
                          fillColor: Colores.celeste(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (descripcion) {
                          //validar errores
                          if(descripcion!.isEmpty) {return 'Ingrese la descripcion';}
                          if(descripcion.length < 10) {return 'La descripcion debe ser mayor a 10 caracteres';}
                          //todo ok
                          return null;
                        },
                      ),
                      //campo fecha
                      Container(
                        margin: EdgeInsets.only(top: 15),
                        padding: EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                          color: Colores.celeste(),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Fecha: ', style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            )),
                            Text(formatoFecha.format(fecha_hoy), style: 
                            TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold, 
                                fontSize: 16,
                              )),
                            IconButton(
                              icon: Icon(MdiIcons.calendar, 
                                color: Colores.azul(),
                                size: 30,
                              ),
                              onPressed: () {
                                showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2025),
                                  locale: Locale('es', 'ES'),
                                ).then((fecha) {
                                  setState(() {
                                    fecha_hoy = fecha ?? fecha_hoy;
                                  });
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Divider(color: Colors.transparent),
                      //campo imagen
                      Container(
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colores.celeste(),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: InkWell(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(MdiIcons.imageArea, 
                                color: Colores.azul(),
                                size: 35,
                              ),
                              Text(' Seleccione imagen', style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              )),
                            ],
                          ),
                          onTap: () async {
                            imagen = await _img.pickImage(source: ImageSource.gallery);
                            //hay imagen para mostrar?
                            if(imagen != null) {
                              setState(() {
                                //refrescar pagina para mostrar la imagen
                                imagen_para_subir = File(imagen!.path);
                              });
                            }
                          },
                        ),
                      ),
                      //error en imagen
                      Container(
                        child: Text('     $msgImgError', style: TextStyle(
                          color: Colors.red,
                          fontSize: 13,
                        )),
                      ),
                      //fin error imagen
                      Divider(color: Colors.transparent),
                      //mostrar imagen
                      Container(
                        alignment: Alignment.center,
                        height: 200,
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Colores.azul(),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: imagen == null ? noHayImagen() : Image.file(imagen_para_subir!),
                      ),
                      Divider(color: Colors.transparent),
                    ],
                  ),
                ),
              ),
              //bns agregar y cancelar
              Container(
                color: Colores.celeste(),
                padding: EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //btn cancelar
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: Icon(MdiIcons.close, 
                              color: Colors.white,
                              size: 35,
                            ),
                      onPressed: () {
                        //hay un proceso activo?
                        if(processSubida == false) {
                          //no hay
                          Navigator.pop(context);
                        }
                      },
                    ),
                    //btn agregar
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: Icon(MdiIcons.plus, 
                              color: Colors.white,
                              size: 35,
                            ),
                      onPressed: () {
                        //hay un proceso activo?
                        if(processSubida == false) {
                          //no hay procesos, hay imagen?
                          if (imagen == null) {
                            //no hay, asigno error
                            msgImgError = 'Ingrese la imagen';
                          }
                          //si hay
                          else {
                            msgImgError = '';
                          }
                          setState(() {
                            //hay errores en el form?
                            if(formKey.currentState!.validate() || msgImgError == '') {
                              //todo OK, asigno variables para subir
                              processSubida = true;
                              String titulo = ctrlTitulo.text.trim();
                              String descripcion = ctrlDescripcion.text.trim();
                              String emailUser = FirebaseAuth.instance.currentUser!.email.toString();
                              //subo el evento
                              FireBaseService().eventoAgregar(emailUser, titulo, descripcion, fecha_hoy, 0, imagen_para_subir!)
                                .then((subioEvento) => {
                                  //subió el evento?
                                  if(subioEvento) {
                                    //todo ok
                                    Navigator.pop(context),
                                    processSubida = false,
                                  }
                                  //no se subió
                                  else {
                                    UtilMensaje.mostrarSnackbar(context, MdiIcons.alertCircle, 
                                      'Error en ingresar evento'),
                                      processSubida =  false,
                                  }
                                });
                            }
                          });
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
    );
  }
}