import 'dart:io';
import 'package:appeventosflutter_flutter/constants/colores_const.dart';
import 'package:appeventosflutter_flutter/responsive/responsive_agregarEvento.dart';
import 'package:appeventosflutter_flutter/responsive/responsive_sizes.dart';
import 'package:appeventosflutter_flutter/services/fireBase_service.dart';
import 'package:appeventosflutter_flutter/utils/msg_scaffold_util.dart';
import 'package:appeventosflutter_flutter/widgets/tituloText_widget.dart';
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
    //width y height del movil
    double width = ResponsiveSizes.getWidth(context);
    double height = ResponsiveSizes.getHeight(context);
    //vista
    return Scaffold(
      resizeToAvoidBottomInset: false,
      //appbar
      appBar: ResponsiveAgregarEvento.ponerLayoutAppbar(width, height ,context),
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
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: ListView(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    children: [
                      //campo titulo
                      TextFormField(
                        controller: ctrlTitulo,
                        style: TextStyle(color: Theme.of(context).colorScheme.primary),
                        decoration: InputDecoration(
                          prefixIcon: Icon(MdiIcons.formatText, 
                            color: Colores.azul(),
                            size: ResponsiveSizes.getSizesCustom(width, height, 42),
                          ),
                          hintText: 'Titulo',
                          hintStyle: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: ResponsiveSizes.getSizesCustom(width, height, 65),
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
                          if(titulo.length > 25) {return 'El titulo debe ser menor a 25 caracteres';}
                          //todo ok
                          return null;
                        },
                      ),
                      Divider(color: Colors.transparent),
                      //campo descripcion
                      TextFormField(
                        controller: ctrlDescripcion,
                        style: TextStyle(color: Theme.of(context).colorScheme.primary),
                        decoration: InputDecoration(
                          prefixIcon: Icon(MdiIcons.textBox, 
                            color: Colores.azul(),
                            size: ResponsiveSizes.getSizesCustom(width, height, 42),
                          ),
                          hintText: 'Descripción',
                          hintStyle: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: ResponsiveSizes.getSizesCustom(width, height, 65),
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
                          if(descripcion.length > 100) {return 'La descripcion debe ser menor a 100 caracteres';}
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
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: ResponsiveSizes.getSizesCustom(width, height, 60),
                              fontWeight: FontWeight.bold,
                            )),
                            Text(formatoFecha.format(fecha_hoy), style: 
                            TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold, 
                                fontSize: ResponsiveSizes.getSizesCustom(width, height, 75),
                              )),
                            IconButton(
                              icon: Icon(MdiIcons.calendar, 
                                color: Colores.azul(),
                                size: ResponsiveSizes.getSizesCustom(width, height, 42),
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
                        padding: EdgeInsets.symmetric(vertical:4),
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
                                size: ResponsiveSizes.getSizesCustom(width, height, 30),
                              ),
                              Text(' Seleccione imagen', style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: ResponsiveSizes.getSizesCustom(width, height, 60),
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
                          fontSize: ResponsiveSizes.getSizesCustom(width, height, 80),
                        )),
                      ),
                      //mostrar imagen
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 5),
                          width: ResponsiveSizes.getSizesCustom(width, height, 3.2),
                          height: ResponsiveSizes.getSizesCustom(width, height, 5),
                          color: Colores.gris(),
                          child: imagen == null ? noHayImagen() : Image.file(imagen_para_subir!, fit: BoxFit.fill),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //bns agregar y cancelar
              Container(
                color: Colores.celeste(),
                padding: EdgeInsets.symmetric(vertical: 3, horizontal: 3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //btn cancelar
                    SizedBox(
                      height: ResponsiveSizes.getSizesCustom(width, height, 32),
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: TituloTextWidget(titulo: 'Cancelar', width: width, height: height),
                        onPressed: () {
                          //hay un proceso activo?
                          if(processSubida == false) {
                            //no hay
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ),
                    //btn agregar
                    SizedBox(
                      height: ResponsiveSizes.getSizesCustom(width, height, 32),
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        child: TituloTextWidget(titulo: 'Agregar', width: width, height: height),
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
                              if(formKey.currentState!.validate() && msgImgError == '') {
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