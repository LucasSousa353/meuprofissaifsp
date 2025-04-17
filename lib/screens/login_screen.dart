import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meuprofissadevflu/auth.dart';
import 'package:meuprofissadevflu/styles/font_sizes.dart';
import 'preregister_screen.dart';
import 'package:meuprofissadevflu/styles/colors.dart';
import 'package:meuprofissadevflu/widgets/top_bar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isObscured = true;
  String? errorMessage = '';

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<void> _handleAuth() async {
    try {
      await Auth().signInWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  void _toggleVisibility() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // TopBar no fundo
            TopBar(height: screenHeight * 0.40),
            Column(
              children: [
                const SizedBox(height: 65), // Espaço para a TopBar
                // Logo sobreposto
                Center(
                  child: SvgPicture.asset(
                    'lib/assets/logo.svg',
                    height: 150,
                    width: 150,
                    allowDrawingOutsideViewBox: true,
                  ),
                ),
                const SizedBox(height: 50),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.01,
                        vertical: screenHeight * 0.03),
                    decoration: const BoxDecoration(
                      color: AppColors.backgroundColor,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.elliptical(80, 70)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        const Text(
                          'e-mail',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: CustomFontSize.bodyFontSize,
                          ),
                        ),
                        _buildTextField(
                          controller: _controllerEmail,
                          label: 'email@hotmail.com',
                          isPassword: false,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'senha',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: CustomFontSize.bodyFontSize,
                          ),
                        ),
                        _buildTextField(
                          controller: _controllerPassword,
                          label: 'senha',
                          isPassword: true,
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              // Lógica para recuperação de senha
                            },
                            child: const Text(
                              'esqueceu a senha?',
                              style: TextStyle(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                fontSize: CustomFontSize.bodyFontSize,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Center(
                          child: ElevatedButton(
                            onPressed: _handleAuth,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.2,
                                vertical: screenHeight * 0.03,
                              ),
                              minimumSize: Size(screenWidth * 0.8, 50),
                            ),
                            child: const Text(
                              'entrar',
                              style: TextStyle(
                                color: AppColors.backgroundColor,
                                fontSize: CustomFontSize.buttonFontSize,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Center(
                          child: Row(
                            children: [
                              Spacer(),
                              SizedBox(
                                width: 50,
                                child: Divider(
                                  color: Colors.black54,
                                  thickness: 1,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  'ou entre com',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: CustomFontSize.bodyFontSize,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 50,
                                child: Divider(
                                  color: Colors.black54,
                                  thickness: 1,
                                ),
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Primeiro círculo com imagem Apple
                            Container(
                              width: 50,
                              height: 50,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  'lib/assets/apple.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.05),

                            // Segundo círculo com imagem Google
                            Container(
                              width: 50,
                              height: 50,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  'lib/assets/google.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.05),

                            // Terceiro círculo com imagem Facebook
                            Container(
                              width: 50,
                              height: 50,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  'lib/assets/face.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegisterScreen(),
                                ),
                              );
                            },
                            child: RichText(
                              text: const TextSpan(
                                text: 'não possui uma conta? ',
                                style: TextStyle(
                                  color: AppColors.secondaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Inter',
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Faça o cadastro',
                                    style: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Inter',
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        if (errorMessage != null && errorMessage!.isNotEmpty)
                          Text(
                            errorMessage!,
                            style: const TextStyle(
                              color: AppColors.errorColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required bool isPassword,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? _isObscured : false,
      decoration: InputDecoration(
        hintText: label,
        hintStyle: const TextStyle(
          color: AppColors.primaryColor,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.borderColor),
          borderRadius: BorderRadius.circular(28),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.borderColor),
          borderRadius: BorderRadius.circular(28),
        ),
        filled: true,
        fillColor: AppColors.whiteColor,
        contentPadding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.025,
          horizontal: MediaQuery.of(context).size.width * 0.05,
        ),
        suffixIcon: isPassword
            ? TextButton(
                onPressed: _toggleVisibility,
                child: Text(
                  _isObscured ? 'Mostrar' : 'Ocultar',
                  style: const TextStyle(
                    color: AppColors.primaryColor,
                  ),
                ),
              )
            : null,
      ),
      style: const TextStyle(color: AppColors.secondaryColor),
    );
  }
}
