import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_be_real/models/image_model.dart';
import 'package:my_be_real/models/user_model.dart';

class UserRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<User> getUserByEmail(String correo) async {
    try {
      DocumentSnapshot userDoc =
          await _firebaseFirestore.collection('users').doc(correo).get();

      List<dynamic> listaFotosDoc = userDoc.get('lista_fotos');

      List<Image> listaFotos = [];

      for (var i = 0; i < listaFotosDoc.length; i++) {
        DocumentSnapshot fotoDoc = await _firebaseFirestore
            .collection('fotos')
            .doc(listaFotosDoc[i])
            .get();

        // Access the download_url and timestamp fields from each "fotos" document.
        String downloadUrl = fotoDoc.get('id_foto');
        Timestamp timestamp = fotoDoc.get('timestamp');

        listaFotos.add(
          Image(
            id: downloadUrl,
            timestamp: timestamp,
          ),
        );
      }
      print(listaFotos);
      return User(listaFotos: listaFotos);
    } catch (e) {
      print(e);
      throw Exception('Error al obtener el usuario');
    }
  }
}
/*zsahraoui20@gmail.com
danaurav@gmail.com
ahouchsalim@gmail.com*/
