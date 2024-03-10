import 'package:appeventosflutter_flutter/constants/colores_const.dart';
import 'package:appeventosflutter_flutter/processes/drawerWidget_processes.dart';
import 'package:appeventosflutter_flutter/responsive/responsive_drawer.dart';
import 'package:appeventosflutter_flutter/responsive/responsive_sizes.dart';
import 'package:appeventosflutter_flutter/services/fireBase_service.dart';
import 'package:appeventosflutter_flutter/widgets/opcionesUser_widget.dart';
import 'package:flutter/material.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({
    super.key,
    required this.homeContext,
  });

  //scaffoldKey del home
  final BuildContext homeContext;

  @override
  Widget build(BuildContext context) {
    //width y height del movil
    double width = ResponsiveSizes.getWidth(context);
    double height = ResponsiveSizes.getHeight(context);
    //vista
    return StreamBuilder(
      stream: FireBaseService().usuario,
      builder: (context, User) {
        return Container(
          margin: EdgeInsets.only(top: 5, left: 5, right: 5),
          child: Column(
            children: [
              //user section
              ResponsiveDrawer.ponerLayoutDrawerUser(width, height ,context),
              //options section
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 3),
                  decoration: BoxDecoration(
                    color: Colores.gris(),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: OpcionesUserWidget(),
                ),
              ),
              //btns cerrar y iniciar sesion
              Container(
                //                    drawerContext   homeContext
                child: DrawerWidgetProcesses.btnInicioCerrado(context, homeContext),
              ),
            ],
          ),
        );
      },
    );
  }
}