//librerias
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';


class FireBaseService{

  //atributos
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseStorage _storage =  FirebaseStorage.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  /* PROCESOS DE LOS EVENTOS */

  //listar eventos
  Stream<QuerySnapshot> eventos() {
    return _fireStore.collection('eventos').snapshots();
  }

  //agregar evento
  Future<bool> eventoAgregar(String emailUser,String titulo,String descripcion,DateTime fecha,
    int coments,File img) async {
    //intento subir evento y imagen
    try {
      //subo imagen
      String imgPath = '/eventosIMG/${Uuid().v1()}.jpg';
      var eventosStorage = _storage.ref().child(imgPath);
      await eventosStorage.putFile(img);
      //subo evento
      _fireStore.collection('eventos').doc().set({
        'titulo': titulo,
        'descripcion': descripcion,
        'comentarios': coments,
        'fecha': fecha,
        'user': emailUser,
        'imagen': imgPath,
        'disponible': true,
      });
      //todo OK
      return true;
    }
    //error
    catch(e) {
      //error shit
      return false;
    }
  }

  //retornar URL de una imagen de evento
  Future<dynamic> getImage(String imgPath) async {
    //intento obtener el URL de la img
    dynamic imgFinal;
    try {
      Reference eventoImgStorage = FirebaseStorage.instance.ref().child(imgPath);
      imgFinal = await eventoImgStorage.getDownloadURL();
      return imgFinal;
    }
    //error shit
    catch(e) {
      return imgFinal;
    }
  }

  //cambiar estado del evento
  Future<bool> cambiarEstado(String id, bool disponible) async {
    //intento actualizar evento
    try {
      bool estadoFinal;
      //verificar estado
      if(disponible) {
        estadoFinal = false;
      }
      else {
        estadoFinal = true;
      }
      //actualizar
      await _fireStore.collection('eventos').doc(id).update({
        'disponible': estadoFinal,
      });
      //todo OK
      return true;
    }
    //error shit
    catch(e) {
      return false;
    }
  }

  //listar un solo evento
  Future<DocumentSnapshot> eventoDescripcion(String id) {
    return _fireStore.collection('eventos').doc(id).get();
  }

  //listar comentarios de un evento
  Stream<QuerySnapshot> eventoComentarios(String id) {
    return _fireStore.collection('comentarios').where('eventoID', isEqualTo: id).snapshots();
  }

  //agregar un comentario a un evento
  Future<bool> comentarEvento(String comment, String emailUser, String eventoID, 
    String user, int cantComments) async {
    //intento subir comentario y imagenURL del user
    String imgURL = _auth.currentUser!.photoURL!;
    try {
      //subo evento y sumo comentario al evento
      await _fireStore.collection('eventos').doc(eventoID).update({
        'comentarios': cantComments+1,
      });
      await _fireStore.collection('comentarios').doc().set({
        'comentario': comment,
        'emailUser': emailUser,
        'eventoID': eventoID,
        'imgUrl': imgURL,
        'userName': user,
      });
      //todo OK
      return true;
    }
    //error
    catch(e) {
      //error shit
      return false;
    }
  }

  /* PROCESOS DE LOS COMENTARIOS GLOBALES */

  //subir comentario
  Future<bool> comentarGlobal(String comentario, String imgUrl, String userEmail, String userName) async {
    try {
      //subo comentario
      await _fireStore.collection('comentariosGlobales').doc().set({
        'comentario': comentario,
        'imgUrl': imgUrl,
        'userEmail': userEmail,
        'userName': userName,
      });
      //todo OK
      return true;
    }
    //error
    catch(e) {
      //error shit
      return false;
    }
  }

  //listar todos los comentarios
  Stream<QuerySnapshot> comentariosGlobales() {
    return _fireStore.collection('comentariosGlobales').snapshots();
  }

  /* PROCESOS DEL USER */

  //login
  Future<bool> iniciarSesion() async {
    int loged = 0;
    //intento iniciar sesión
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      //hay user?
      if (googleUser == null) {
        //NO hay user logeado
        loged = 0;
      }
      //hay user logeado
      else {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final credencial = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await _auth.signInWithCredential(credencial);
        loged = 1;
      }
    }
    //error
    catch (e) {
      print(e);
    }
    //retorna TRUE si loged == 1
    return loged == 1;
  }

  //logout
  Future<void> cerrarSesion() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  //saber si el user está logeado
  bool userEstaLogeado() {
    //retorna TRUE si hay user logeado, sino retorna FALSE
    return _auth.currentUser != null;
  }

  //retornar objeto user tipo stream
  Stream<User?> get usuario {
    return _auth.authStateChanges();
  }

}