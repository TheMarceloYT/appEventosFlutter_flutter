class comentarioGlobalModel{

  //atributos
  String _id;
  String _comentario;
  String _imagen;
  String _userEmail;
  String _userName;

  //constructor
  comentarioGlobalModel(dynamic snapshot):
    _id = snapshot.id,
    _comentario = snapshot['comentario'],
    _imagen = snapshot['imgUrl'],
    _userEmail = snapshot['userEmail'],
    _userName = snapshot['userName'];

  //gets y sets
  String get id => this._id;
  set id(String id) => this._id = id;

  String get comentario => this._comentario;
  set comentario(String id) => this._comentario = comentario;

  String get imagen => this._imagen;
  set imagen(String id) => this._imagen = imagen;

  String get userEmail => this._userEmail;
  set userEmail(String id) => this._userEmail = userEmail;

  String get userName => this._userName;
  set userName(String id) => this._userName = userName;
}