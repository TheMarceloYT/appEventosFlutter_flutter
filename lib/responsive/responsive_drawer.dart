import 'package:appeventosflutter_flutter/constants/colores_const.dart';
import 'package:appeventosflutter_flutter/constants/opcionesUser_const.dart';
import 'package:appeventosflutter_flutter/processes/drawerWidget_processes.dart';
import 'package:appeventosflutter_flutter/responsive/responsive_breakpoints.dart';
import 'package:appeventosflutter_flutter/responsive/responsive_sizes.dart';
import 'package:appeventosflutter_flutter/services/fireBase_service.dart';
import 'package:flutter/material.dart';

class ResponsiveDrawer {

  //seleccionar opciones
  static List opcUser() {
    bool user = FireBaseService().userEstaLogeado();
    //hay user?
    if(user) {
      //si hay, paso opciones del user
      return OpcionesUser.opcionesUserLogeado;
    }
    //no hay user
    else{
      //paso opciones normales
      return OpcionesUser.opcionesUserNormal;
    }
  }

  //poner drawer
  static Widget ponerLayoutDrawerUser(double width, double height, BuildContext context) {
    //que device es?
    if(ResponsiveBreakpoints.isSmall(width)) {
      //es small
      return Container(
        child: Column(
          children: [
            //user info
            Container(
              padding: EdgeInsets.symmetric(vertical: 2),
              decoration: BoxDecoration(
                color: Colores.gris(),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  //user image
                  Container(
                    height: ResponsiveSizes.getSizesCustom(width, height, 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colores.azul(), width: 2),
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: DrawerWidgetProcesses.imgUser(),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  //nombre del user
                  Container(
                    margin: EdgeInsets.only(top: 1),
                    child: Text(DrawerWidgetProcesses.nombreUser(),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: ResponsiveSizes.getSizesCustom(width, height, 70),
                        fontWeight: FontWeight.bold,
                    ) ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
    //es large
    return Container(
      child: Column(
        children: [
          //user info
          Container(
            padding: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
            decoration: BoxDecoration(
              color: Colores.gris(),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                //user image
                Expanded(
                  child: Container(
                    width: ResponsiveSizes.getSizesCustom(width, height, 16),
                    height: ResponsiveSizes.getSizesCustom(width, height, 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colores.azul(), width: 2),
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: DrawerWidgetProcesses.imgUser(),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                //nombre del user
                Expanded(
                  flex: 2,
                  child: Container(
                    child: Text(DrawerWidgetProcesses.nombreUser(),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: ResponsiveSizes.getSizesCustom(width, height, 70),
                        fontWeight: FontWeight.bold,
                    )),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}