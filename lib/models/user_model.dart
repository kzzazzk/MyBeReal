import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_be_real/models/image_model.dart';

class User {
  List<Foto> listaFotos = [];

  User({
    required this.listaFotos,
  });

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
      listaFotos: doc['lista_fotos'],
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'lista_fotos': listaFotos,
    };
  }

  bool userHasImages(String id) {
    for (var i = 0; i < listaFotos.length; i++) {
      if (listaFotos[i].id == id) {
        return true;
      }
    }
    return false;
  }

  @override
  String toString() {
    return 'User{listaFotos: $listaFotos}';
  }
}
