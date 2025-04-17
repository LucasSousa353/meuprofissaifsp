import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart'; // Para compatibilidade com Web use XFile

class PhotoUploadService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> uploadProfilePhoto(String userId, XFile imageFile) async {
    String filePath =
        'profile_photos/$userId.jpg'; // Caminho onde a imagem será salva
    Reference storageRef = _storage.ref().child(filePath);

    await storageRef.putData(await imageFile
        .readAsBytes()); // Utiliza putData para compatibilidade Web

    // Aqui você pode salvar o URL da imagem no Firestore, se necessário
    // Exemplo:
    // await _firestore.collection('users').doc(userId).update({'profileImage': downloadURL});
  }
}
