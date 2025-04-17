import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ChatSearchService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Stream<List<Worker>> getWorkers() {
    return _firestore
        .collection('workers')
        .snapshots()
        .asyncMap((snapshot) async {
      List<Worker> workers = [];
      for (var doc in snapshot.docs) {
        Worker worker = Worker.fromFirestore(doc);
        // Get the image URL from Firebase Storage
        String imageUrl = await _getImageUrl(worker.uid);
        // print(
        //     'Worker UID: ${worker.uid}, Image URL: $imageUrl'); // Log the UID and URL
        worker.imageUrl = imageUrl;
        workers.add(worker);
      }
      return workers;
    });
  }

  Future<String> _getImageUrl(String uid) async {
    try {
      Reference ref = _storage.ref().child('profile_photos/$uid.jpg');
      String url = await ref.getDownloadURL();
      // print('Successfully fetched image URL: $url'); // Log para sucesso
      return url;
    } catch (e) {
      // Log detalhado do erro
      // print('Error fetching image URL for UID $uid: $e');
      return ''; // Retorna uma string vazia se houver um erro
    }
  }

  Future<void> startNewChat(String workerId) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      // Create a new chat document
      await _firestore.collection('chats').add({
        'participants': [currentUser.uid, workerId],
        'createdAt': Timestamp.now(),
        'messages': [],
      });
    }
  }
}

class Worker {
  final String uid;
  final String name;
  final String email;
  final String especialidade;
  final double latitude;
  final double longitude;
  final String tipo;
  final String numero;
  final String descricao;
  final double rating;
  String imageUrl; // Mude para variável mutável

  Worker(
      {required this.uid,
      required this.name,
      required this.email,
      required this.especialidade,
      required this.latitude,
      required this.longitude,
      required this.tipo,
      required this.numero,
      required this.descricao,
      required this.imageUrl,
      required this.rating});

  factory Worker.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // Debugging data recebido
    // print('Data received: $data');

    return Worker(
      uid: data['uid'] ?? '',
      name: data['Nome'] ?? '',
      email: data['Email'] ?? '',
      especialidade: data['Especialidade'] ?? '',
      latitude: data['Latitude'] != null ? data['Latitude'].toDouble() : 0.0,
      longitude: data['Longitude'] != null ? data['Longitude'].toDouble() : 0.0,
      descricao: data['Descricao'] ?? '',
      tipo: data['Tipo'] ?? '',
      numero: data['Numero'] ?? '',
      rating: (data['Rating'] != null)
          ? double.tryParse(data['Rating'].toString()) ?? 0.0
          : 0.0,
      imageUrl: '',
    );
  }
}
