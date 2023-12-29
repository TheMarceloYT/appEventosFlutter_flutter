import 'package:appeventosflutter_flutter/constants/colores_const.dart';
import 'package:appeventosflutter_flutter/pages/chatGlobal_page.dart';
import 'package:appeventosflutter_flutter/pages/eventos_page.dart';
import 'package:appeventosflutter_flutter/pages/sobreNosotros_page.dart';
import 'package:appeventosflutter_flutter/widgets/drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class TabHome extends StatelessWidget {
  //key del scaffold
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        //key
        key: scaffoldKey,
        //appbar
        appBar: AppBar(
          //colores
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colores.celeste(),
          //body del appbar
          leading: Icon(MdiIcons.partyPopper),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Eventos', style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              )),
              Text(' Flutter', style: TextStyle(
                color: Colores.azul(),
                fontSize: 26,
                fontWeight: FontWeight.bold,
              )),
            ],
          ),
          //tabbar
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: Colores.azul(),
            labelColor: Colors.white,
            labelStyle: TextStyle(
              fontSize: 16,
            ),
            unselectedLabelColor: Colors.white70,
            unselectedLabelStyle: TextStyle(
              fontSize: 16,
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
        ),
        //body
        body: Padding(
          padding: EdgeInsets.only(top: 8),
          child: Column(
            children: [
              //tab views
              Expanded(
                child: TabBarView(
                  children: [
                    EventosPage(),
                    ChatGlobalPage(),
                    SobreNosotrosPage(),
                  ],
                ),
              ),
            ],
          ),
        ),
        //drawer
        endDrawer: Drawer(
          backgroundColor: Colores.celeste(),
          child: DrawerWidget(homeContext: context),
        ),
      ),
    );
  }
}