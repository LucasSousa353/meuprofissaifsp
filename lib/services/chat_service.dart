import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<Map<String, String>> getWorkerDetails(String workerUid) async {
    try {
      // Buscar o nome do trabalhador na coleção workers
      final workerDoc =
          await _firestore.collection('workers').doc(workerUid).get();
      String workerName = workerDoc.exists
          ? (workerDoc.data()?['Nome'] ?? 'Desconhecido')
          : 'Desconhecido';

      // Buscar a imagem diretamente no Firebase Storage
      String workerImageUrl = '';
      try {
        workerImageUrl = await _storage
            .ref('profile_photos/$workerUid.jpg')
            .getDownloadURL();
      } catch (e) {
        print('Erro ao buscar imagem no Storage: $e');
      }

      return {
        'workerName': workerName,
        'workerImageUrl': workerImageUrl,
      };
    } catch (e) {
      print('Erro ao buscar detalhes do trabalhador: $e');
      return {
        'workerName': 'Desconhecido',
        'workerImageUrl': '',
      };
    }
  }

  Stream<List<Chat>> getChatsStartedByUser() {
    final user = _auth.currentUser;
    if (user != null) {
      final userUid = user.uid;
      print("Buscando chats para o usuário: $userUid");

      return _firestore
          .collection('chats')
          .where('participants', arrayContains: userUid)
          .snapshots()
          .map((snapshot) {
        if (snapshot.docs.isEmpty) {
          print("Nenhum chat encontrado para o usuário $userUid");
        } else {
          print("Chats encontrados: ${snapshot.docs.length}");
        }
        return snapshot.docs.map((doc) {
          final data = doc.data();
          return Chat(
            chatId: doc.id,
            userId: data['participants'][0],
            workerUid: data['participants'][1],
            workerName: data['workerName'] ?? 'Desconhecido',
            workerImageUrl: data['workerImageUrl'] ?? '',
            lastMessage: data['lastMessage'] ?? '',
            workerNumber: data['Numero'] ?? '',
            lastMessageSender: data['lastMessageSender'] ?? '',
            createdAt: data['createdAt'],
          );
        }).toList();
      }).handleError((error) {
        print("Erro ao buscar chats: $error");
      });
    }
    print("Usuário não autenticado.");
    return const Stream.empty();
  }
}

class Chat {
  final String chatId;
  final String userId;
  final String workerUid;
  final String workerName;
  final String workerImageUrl;
  final String lastMessage;
  final String lastMessageSender;
  final String workerNumber;
  final Timestamp createdAt;

  Chat({
    required this.chatId,
    required this.userId,
    required this.workerUid,
    required this.workerName,
    required this.workerImageUrl,
    required this.lastMessage,
    required this.lastMessageSender,
    required this.workerNumber,
    required this.createdAt,
  });

  factory Chat.fromFirestore(Map<String, dynamic> data) {
    return Chat(
      chatId: data['chatId'],
      userId: data['userId'],
      workerUid: data['workerUid'],
      workerName: data['workerName'],
      workerImageUrl: data['workerImageUrl'],
      lastMessage: data['lastMessage'] ?? '',
      lastMessageSender: data['lastMessageSender'] ?? '',
      createdAt: data['createdAt'],
      workerNumber: data['Numero'] ?? '',
    );
  }
}
