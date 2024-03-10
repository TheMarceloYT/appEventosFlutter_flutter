import 'package:appeventosflutter_flutter/constants/colores_const.dart';
import 'package:appeventosflutter_flutter/models/comentarioGlobal_model.dart';
import 'package:appeventosflutter_flutter/processes/chatGlobal_processes.dart';
import 'package:appeventosflutter_flutter/responsive/responsive_breakpoints.dart';
import 'package:appeventosflutter_flutter/responsive/responsive_sizes.dart';
import 'package:appeventosflutter_flutter/widgets/comentarioText_widget.dart';
import 'package:appeventosflutter_flutter/widgets/usernameText_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ResponsiveChatGlobal {

  static Widget ponerLayoutChatGlobalComentarios (double width, double height, AsyncSnapshot<QuerySnapshot> snapshot) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 5),
      separatorBuilder: (_, __) => Divider(color: Colors.transparent),
      itemCount: snapshot.data!.docs.length,
      itemBuilder: (context, index) {
        comentarioGlobalModel comentario = comentarioGlobalModel(snapshot.data!.docs[index]);
        //cuerpo de los comentarios comentarios
        return Center(
          child: Container(
            width: ResponsiveBreakpoints.isSmall(width) ? ResponsiveSizes.getSizesCustom(width, height, 3.4) : ResponsiveSizes.getSizesCustom(width, height, 2),
            padding: EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: Colores.gris(),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //imagen
                Container(
                  margin: EdgeInsets.only(left: 8),
                  width: ResponsiveSizes.getSizesCustom(width, height, 16.5),
                  height: ResponsiveSizes.getSizesCustom(width, height, 16.5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: ChatGlobalProcesses.imgUserComentario(comentario.imagen),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                //nombre y comentario
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //nombre del user
                        UserNameTextWidget(userName: comentario.userName, width: width, height: height),
                        //comentario
                        ComentarioTextWidget(comentario: comentario.comentario, width: width, height: height),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}