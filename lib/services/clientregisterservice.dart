import 'package:geolocator/geolocator.dart';
import 'package:meuprofissadevflu/services/locationservice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Função pública para obter a localização
// ignore: non_constant_identifier_names
Future<void> CadastrarCliente(String username) async {
  Position position = await determinePosition();
  double latitude = position.latitude;
  double longitude = position.longitude;

  // Envie os dados para o Firestore antes de navegar
  await enviarCadastroClienteFirestore(latitude, longitude, username);
}

// Função para enviar dados para o Firestore
Future<void> enviarCadastroClienteFirestore(
    double latitude, double longitude, String username) async {
  try {
    // Obtenha o UID do usuário logado
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("Usuário não está logado");
    }
    String loginUidText = user.uid;

    // Crie uma referência ao documento na coleção 'users' com o ID do usuário
    DocumentReference registerDef =
        FirebaseFirestore.instance.collection('users').doc(loginUidText);

    // Dados a serem enviados
    Map<String, dynamic> registerData = {
      'Latitude': latitude,
      'Longitude': longitude,
      'Email': user.email,
      'Nome': username,
      'Tipo': 'Cliente',
      'uid': user.uid,
    };

    // Envie os dados para o Firestore
    await registerDef.set(registerData);

    // print("Dados enviados com sucesso!");
  } catch (e) {
    // print("Erro ao enviar dados para o Firestore: $e");
    // Adiciona mais detalhes sobre o erro
    if (e is FirebaseException) {
      // print("Código do erro: ${e.code}");
      // print("Mensagem do erro: ${e.message}");
    }
  }
}
