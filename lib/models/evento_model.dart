import 'package:cloud_firestore/cloud_firestore.dart';

class EventoModel{

  //atributos
  String _id;
  String _titulo;
  String _descripcion;
  int _comentarios;
  Timestamp _fecha;
  String _emailUser;
  String _imagen;
  bool _disponible;

  //constructor por snapshot
  EventoModel(dynamic snapshot):
    _id = snapshot.id,
    _titulo = snapshot['titulo'],
    _descripcion = snapshot['descripcion'],
    _comentarios = int.parse(snapshot['comentarios'].toString()),
    _fecha = snapshot['fecha'],
    _emailUser = snapshot['user'],
    _imagen = snapshot['imagen'],
    _disponible = snapshot['disponible'];

  //gets y sets
  String get id => this._id;
  set id(String id) => this._id = id;

  String get titulo => this._titulo;
  set titulo(String titulo) => this._titulo = titulo;

  String get descripcion => this._descripcion;
  set descripcion(String descripcion) => this._descripcion = descripcion;

  int get comentarios => this._comentarios;
  set comentarios(int comentarios) => this._comentarios = comentarios;

  Timestamp get fecha => this._fecha;
  set fecha(Timestamp fecha) => this._fecha = fecha;

  String get emailUser => this._emailUser;
  set emailUser(String emailUser) => this._emailUser = emailUser;

  String get imagen => this._imagen;
  set imagen(String imagen) => this._imagen = imagen;

  bool get disponible => this._disponible;
  set disponible(bool disponible) => this._disponible = disponible;

}