import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meuprofissadevflu/auth.dart';
import 'package:meuprofissadevflu/screens/photoupload_screen.dart';
import 'package:meuprofissadevflu/services/profilefetch_service.dart';
import 'package:meuprofissadevflu/styles/colors.dart';
import 'package:image_network/image_network.dart';
import 'package:meuprofissadevflu/widget_tree.dart';
import 'package:remixicon/remixicon.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final User? user = Auth().currentUser;
  UserProfile? userProfile;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    if (user != null) {
      ProfileFetchService service = ProfileFetchService();
      UserProfile? profile = await service.fetchUserProfile(user!.uid);
      setState(() {
        userProfile = profile;
      });
    }
  }

  Future<void> signOut() async {
    await Auth().signOut();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const WidgetTree(),
      ),
    );
  }

  Widget _signOutButton() {
    return ElevatedButton(
      onPressed: signOut,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white, // Cor do texto
        side: const BorderSide(color: Colors.grey, width: 1), // Borda cinza
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: const Text("Sair"),
    );
  }

  Widget _userInfo(String label, String value, {bool isName = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8.0),
            isName
                ? TextField(
                    controller: TextEditingController(text: value),
                    readOnly: true,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                    ),
                    style: const TextStyle(color: Colors.black87),
                  )
                : Text(
                    value,
                    style: const TextStyle(color: Colors.black54),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _uploadPhotoButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PhotoUploadPage()),
        );
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white, // Cor do texto
        side: const BorderSide(color: Colors.grey, width: 1), // Borda cinza
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: const Text("Alterar foto de perfil"),
    );
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.backgroundColor,
    body: userProfile == null
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: <Widget>[
              // Verifica se há uma URL de imagem antes de tentar exibir a imagem
              if (userProfile!.imageUrl.isNotEmpty)
                ImageNetwork(
                  image: userProfile!.imageUrl,
                  height: 200,
                  width: 200,
                  fullScreen: true,
                  fitAndroidIos: BoxFit.cover,
                  fitWeb: BoxFitWeb.cover,
                  borderRadius: BorderRadius.circular(70),
                  onLoading: const CircularProgressIndicator(
                    color: Colors.indigoAccent,
                  ),
                  onError: const Icon(Remix.user_3_fill,
                      color: AppColors.primaryColor, size: 200),
                  onTap: () {},
                )
              else
                const Icon(
                  Remix.user_3_fill,
                  color: AppColors.primaryColor,
                  size: 200,
                ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: _uploadPhotoButton(),
              ),
              // Informações do usuário
              Expanded(
                child: ListView(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          // Navegue para a página de edição de informações
                          Navigator.pushNamed(context, '/editProfile');
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.white, // Cor do texto
                          side: const BorderSide(
                              color: Colors.grey, width: 1), // Borda cinza
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text('Alterar informações'),
                      ),
                    ),
                    _userInfo('Nome', userProfile!.name, isName: true),
                    _userInfo('Email', userProfile!.email),
                    if (userProfile!.isWorker)
                      _userInfo('Especialidade', userProfile!.especialidade),
                    // Adicione mais informações conforme necessário
                  ],
                ),
              ),
              // Botão de logout no rodapé
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: _signOutButton(),
              ),
            ],
          ),
  );
}
}
