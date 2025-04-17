import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' as io;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:meuprofissadevflu/screens/main_screen.dart';
import 'package:meuprofissadevflu/services/photoupload_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PhotoUploadPage extends StatefulWidget {
  const PhotoUploadPage({super.key});

  @override
  _PhotoUploadPageState createState() => _PhotoUploadPageState();
}

class _PhotoUploadPageState extends State<PhotoUploadPage> {
  XFile? _imageFile;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_imageFile != null) {
      String userId = FirebaseAuth.instance.currentUser!.uid;

      PhotoUploadService service = PhotoUploadService();
      await service.uploadProfilePhoto(userId, _imageFile!);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const MainScreen(initialIndex: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Faça o upload de uma foto'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_imageFile != null)
              kIsWeb
                  ? Image.network(
                      _imageFile!.path,
                      width: 350,
                      height: 350,
                    )
                  : Image.file(
                      io.File(_imageFile!.path),
                      width: 350,
                      height: 350,
                    )
            else
              const Text('Nenhuma imagem selecionada'),
            SizedBox(height: screenHeight * 0.05),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Escolher a Imagem'),
            ),
            SizedBox(height: screenHeight * 0.05),
            ElevatedButton(
              onPressed: _uploadImage,
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
