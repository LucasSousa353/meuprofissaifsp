import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Função pública para obter a localização
Future<void> getLocation() async {
  Position position = await determinePosition();
  double latitude = position.latitude;
  double longitude = position.longitude;

  // Envie os dados para o Firestore antes de navegar
  await enviarLocalizacaoFirestore(latitude, longitude);
}

Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Teste se os serviços de localização estão habilitados.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Serviços de localização não estão habilitados, não será possível continuar
    return Future.error('Os serviços de localização estão desabilitados.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissões foram negadas
      return Future.error('As permissões de localização foram negadas.');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissões foram negadas permanentemente
    return Future.error(
        'As permissões de localização foram negadas permanentemente.');
  }

  // Quando chegar aqui, as permissões estão garantidas e podemos
  // chamar Geolocator.getCurrentPosition()
  return await Geolocator.getCurrentPosition();
}

Future<void> enviarLocalizacaoFirestore(
    double latitude, double longitude) async {
  try {
    // Obtenha o UID do usuário logado
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("Usuário não está logado");
    }
    String loginUidText = user.uid;

    // Crie uma referência ao documento na coleção 'users' com o ID do usuário
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('users').doc(loginUidText);

    // Dados a serem enviados
    Map<String, dynamic> data = {
      'Latitude': latitude,
      'Longitude': longitude,
    };

    // Envie os dados para o Firestore
    await docRef.update(data);

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
