class ComentarioEventoModel{

  //atributos
  String _id;
  String _comentario;
  String _emailUser;
  String _eventoID;
  String _imagen;
  String _userName;

  //constructor por snapshot
  ComentarioEventoModel(dynamic snapshot):
    _id = snapshot.id,
    _comentario = snapshot['comentario'],
    _emailUser = snapshot['emailUser'],
    _eventoID = snapshot['eventoID'],
    _imagen = snapshot['imgUrl'],
    _userName = snapshot['userName'];

  //gets y sets
  String get id => this._id;
  set id(String id) => this._id = id;

  String get comentario => this._comentario;
  set comentario(String comentario) => this._comentario = comentario;

  String get emailUser => this._emailUser;
  set emailUser(String emailUser) => this._emailUser = emailUser;

  String get eventoID => this._eventoID;
  set eventoID(String eventoID) => this._eventoID = eventoID;

  String get imagen => this._imagen;
  set imagen(String imagen) => this._imagen = imagen;

  String get userName => this._userName;
  set userName(String userName) => this._userName = userName;

}