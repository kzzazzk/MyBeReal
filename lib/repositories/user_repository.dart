import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:my_be_real/models/image_model.dart';
import 'package:my_be_real/models/user_model.dart';
import 'package:my_be_real/utils/constants.dart';

class UserRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<List<User?>> getUserByEmail(String correo) async {
    String? correo2 = '';

    if (Constants.userEmail == dotenv.env['ZAKA_ID']) {
      correo2 = dotenv.env['ADRI_ID'];
    } else {
      correo2 = dotenv.env['ZAKA_ID'];
    }

    try {
      DocumentSnapshot userDoc =
          await _firebaseFirestore.collection('users').doc(correo).get();

      DocumentSnapshot userDoc2 =
          await _firebaseFirestore.collection('users').doc(correo2).get();

      if (!userDoc.exists) {
        return [null, null];
      } else if (!userDoc2.exists) {
        return [null, null];
      }

      List<dynamic> listaFotosDoc = userDoc.get('lista_fotos');
      List<dynamic> listaFotosDoc2 = userDoc2.get('lista_fotos');

      List<Foto> listaFotos = [];
      List<Foto> listaFotos2 = [];

      for (var i = 0; i < listaFotosDoc.length; i++) {
        DocumentSnapshot fotoDoc = await _firebaseFirestore
            .collection('fotos')
            .doc(listaFotosDoc[i])
            .get();

        // Access the download_url and timestamp fields from each "fotos" document.
        String downloadUrl = fotoDoc.get('id_foto');
        Timestamp timestamp = fotoDoc.get('timestamp');

        listaFotos.add(
          Foto(
            id: downloadUrl,
            timestamp: timestamp,
          ),
        );
      }

      for (var i = 0; i < listaFotosDoc2.length; i++) {
        DocumentSnapshot fotoDoc2 = await _firebaseFirestore
            .collection('fotos')
            .doc(listaFotosDoc2[i])
            .get();

        // Access the download_url and timestamp fields from each "fotos" document.
        String downloadUrl = fotoDoc2.get('id_foto');
        Timestamp timestamp = fotoDoc2.get('timestamp');

        listaFotos2.add(
          Foto(
            id: downloadUrl,
            timestamp: timestamp,
          ),
        );
      }
      return [User(listaFotos: listaFotos), User(listaFotos: listaFotos2)];
    } catch (e) {
      throw Exception('Error al obtener el usuario');
    }
  }
}
