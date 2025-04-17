import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class HomeFetchService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<List<String>> fetchAdImages(BuildContext context) async {
    List<String> imageUrls = [];

    // Loop para buscar os arquivos 'ad1.png' até 'ad7.png'
    for (int i = 1; i <= 7; i++) {
      String fileName = 'ad$i.png';
      String url = await _getImageUrl(fileName);

      if (url.isNotEmpty) {
        imageUrls.add(url);

        // Pré-carregar a imagem
        // ignore: use_build_context_synchronously
        precacheImage(NetworkImage(url), context);
      }
    }

    return imageUrls;
  }

  Future<String> _getImageUrl(String fileName) async {
    try {
      // Caminho fixo no Firebase Storage
      Reference ref = _storage.ref().child('advertising/$fileName');
      return await ref.getDownloadURL();
    } catch (e) {
      return ''; // Retorna string vazia em caso de erro
    }
  }
}
