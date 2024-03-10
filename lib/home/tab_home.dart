import 'package:appeventosflutter_flutter/constants/colores_const.dart';
import 'package:appeventosflutter_flutter/pages/chatGlobal_page.dart';
import 'package:appeventosflutter_flutter/pages/eventos_page.dart';
import 'package:appeventosflutter_flutter/pages/sobreNosotros_page.dart';
import 'package:appeventosflutter_flutter/responsive/responsive_sizes.dart';
import 'package:appeventosflutter_flutter/theme/theme_provider.dart';
import 'package:appeventosflutter_flutter/widgets/drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class TabHome extends StatelessWidget {
  const TabHome({super.key});

  @override
  Widget build(BuildContext context) {
    //width y height del movil
    double width = ResponsiveSizes.getWidth(context);
    double height = ResponsiveSizes.getHeight(context);
    //vista
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        //body
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              //appbar {sliver}
              SliverAppBar(
                pinned: true,
                floating: true,
                //colores
                iconTheme: Theme.of(context).iconTheme,
                backgroundColor: Colores.celeste(),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(15))
                ),
                //body del appbar
                leading: InkWell(
                  child: Icon(MdiIcons.themeLightDark),
                  onTap: () {
                    Provider.of<ThemeProvider>(context, listen: false).cambiarTema();
                  },
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Eventos', style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: ResponsiveSizes.getSizesCustom(width, height, 55),
                      fontWeight: FontWeight.bold,
                    )),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(' Flutter', style: TextStyle(
                        color: Colores.azul(),
                        fontSize: ResponsiveSizes.getSizesCustom(width, height, 55),
                        fontWeight: FontWeight.bold,
                      )),
                    ),
                  ],
                ),
                //tabbar
                bottom: TabBar(
                  isScrollable: true,
                  indicatorColor: Colores.azul(),
                  labelColor: Theme.of(context).colorScheme.primary,
                  splashBorderRadius: BorderRadius.circular(10),
                  splashFactory: InkRipple.splashFactory,
                  labelStyle: TextStyle(
                    fontSize: ResponsiveSizes.getSizesCustom(width, height, 70),
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelColor: Theme.of(context).colorScheme.secondary,
                  unselectedLabelStyle: TextStyle(
                    fontSize: ResponsiveSizes.getSizesCustom(width, height, 100),
                  ),
                  tabs: [
                    //eventos
                    Tab(
                      text: 'Eventos',
                    ),
                    //chat global
                    Tab(
                      text: 'Chat global',
                    ),
                    //sobre nosotros
                    Tab(
                      text: 'Sobre nosotros',
                    ),
                  ],
                ),
              )
            ];
          },
          //body
          body: TabBarView(
            children: [
              EventosPage(),
              ChatGlobalPage(),
              SobreNosotrosPage(),
            ],
          ),
        ),
        //drawer
        endDrawer: SafeArea(
          child: Drawer(
            backgroundColor: Colores.celeste(),
            width: ResponsiveSizes.getSizesCustom(width, height, 4),
            child: DrawerWidget(homeContext: context),
          ),
        ),
      ),
    );
  }
}