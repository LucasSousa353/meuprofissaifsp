import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileFetchService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<UserProfile?> fetchUserProfile(String userId) async {
    // Primeiro, tenta buscar na coleção 'users'
    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(userId).get();

    if (userDoc.exists) {
      String imageUrl = await _getImageUrl(userId);
      return UserProfile.fromFirestore(userDoc,
          isWorker: false, imageUrl: imageUrl);
    }

    // Se não encontrado em 'users', tenta buscar na coleção 'workers'
    DocumentSnapshot workerDoc =
        await _firestore.collection('workers').doc(userId).get();

    if (workerDoc.exists) {
      String imageUrl = await _getImageUrl(userId);
      return UserProfile.fromFirestore(workerDoc,
          isWorker: true, imageUrl: imageUrl);
    }

    // Se não encontrado em nenhuma das coleções
    return null;
  }

  Future<String> _getImageUrl(String userId) async {
    try {
      // Referência para o arquivo da imagem
      Reference ref = _storage.ref().child('profile_photos/$userId.jpg');
      // Obtém a URL de download
      String url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      // print('Error fetching image URL: $e');
      return ''; // Retorna uma string vazia se houver um erro
    }
  }
}

class UserProfile {
  final String id;
  final String name;
  final String email;
  final String especialidade;
  final double latitude;
  final double longitude;
  final String tipo;
  final String imageUrl;
  final double rating;
  final bool isWorker; // Adicionado para saber se é um trabalhador

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.especialidade,
    required this.latitude,
    required this.longitude,
    required this.tipo,
    required this.imageUrl,
    required this.rating,
    required this.isWorker,
  });

  factory UserProfile.fromFirestore(DocumentSnapshot doc,
      {required bool isWorker, required String imageUrl}) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // Debugging data received
    // print('Data received: $data');

    return UserProfile(
      id: doc.id,
      name: data['Nome'] ?? '',
      email: data['Email'] ?? '',
      especialidade: isWorker ? (data['Especialidade'] ?? '') : 'Not available',
      latitude: data['Latitude'] != null ? data['Latitude'].toDouble() : 0.0,
      longitude: data['Longitude'] != null ? data['Longitude'].toDouble() : 0.0,
      tipo: data['Tipo'] ?? '',
      imageUrl: imageUrl,
      rating: (data['Rating'] != null)
          ? double.tryParse(data['Rating'].toString()) ?? 0.0
          : 0.0,
      isWorker: isWorker,
    );
  }
}
