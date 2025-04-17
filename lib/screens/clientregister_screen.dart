import 'package:flutter/material.dart';
import 'package:meuprofissadevflu/services/clientregisterservice.dart';
import 'package:meuprofissadevflu/styles/colors.dart';
import 'package:meuprofissadevflu/styles/font_sizes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meuprofissadevflu/auth.dart';
import 'package:meuprofissadevflu/widget_tree.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ClientRegisterScreen extends StatefulWidget {
  const ClientRegisterScreen({super.key});

  @override
  _ClientRegisterScreenState createState() => _ClientRegisterScreenState();
}

class _ClientRegisterScreenState extends State<ClientRegisterScreen> {
  bool _isObscured = true;
  String? errorMessage = '';
  final db = FirebaseFirestore.instance;

  void _toggleVisibility() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  final TextEditingController _controllerName = TextEditingController();

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerConfirmEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerConfirmPassword =
      TextEditingController();

  Future<void> _handleAuth() async {
    if (_controllerEmail.text != _controllerConfirmEmail.text) {
      setState(() {
        errorMessage = 'Os e-mails não são iguais.';
      });
      return;
    }

    if (_controllerPassword.text != _controllerConfirmPassword.text) {
      setState(() {
        errorMessage = 'As senhas não são iguais.';
      });
      return;
    }

    try {
      await Auth().createUserWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Cadastro realizado com sucesso!',
          ),
        ),
      );
      await CadastrarCliente(_controllerName.text);

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const WidgetTree(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: screenHeight,
          ),
          child: IntrinsicHeight(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.center,
                  colors: [
                    Color.fromRGBO(5, 0, 66, 1),
                    Color.fromRGBO(2, 0, 29, 1),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                      height: screenHeight *
                          0.03), // Espaço entre a logo e o título
                  Container(
                    padding: EdgeInsets.all(screenWidth * 0.02),
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back,
                          color: AppColors.whiteColor),
                      iconSize: screenWidth * 0.1,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const Text(
                    'Registro de Cliente',
                    style: TextStyle(
                      fontSize: CustomFontSize.titleFontSize,
                      fontFamily: 'GeneralSans',
                      color: AppColors.primaryColor,
                    ),
                  ),
                  SizedBox(
                      height: screenHeight *
                          0.05), // Espaço entre o título e o boxDecoration
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(screenWidth * 0.05),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundColor,
                        borderRadius: BorderRadius.vertical(
                            top: Radius.elliptical(
                                screenWidth * 0.2, screenWidth * 0.15)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: screenHeight * 0.02),
                          const Text(
                            'Preencha com suas informações:',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: CustomFontSize.subtitleFontSize,
                              fontFamily: 'GeneralSans',
                              fontWeight: FontWeight.normal,
                              color: AppColors.secondaryColor,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          if (errorMessage != null && errorMessage!.isNotEmpty)
                            Text(
                              errorMessage!,
                              style: const TextStyle(
                                color: AppColors.errorColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          SizedBox(height: screenHeight * 0.02),
                          _buildTextField(
                            controller: _controllerName,
                            label: 'Como gostaria de ser chamado?',
                            hint: 'Seu nome',
                            isPassword: false,
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          _buildTextField(
                            controller: _controllerEmail,
                            label: 'E-mail',
                            hint: 'Digite seu e-mail',
                            isPassword: false,
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          _buildTextField(
                            controller: _controllerConfirmEmail,
                            label: 'Confirme seu e-mail',
                            hint: 'Confirme seu e-mail',
                            isPassword: false,
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          _buildTextField(
                            controller: _controllerPassword,
                            label: 'Senha',
                            hint: 'Digite sua senha',
                            isPassword: true,
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          _buildTextField(
                            controller: _controllerConfirmPassword,
                            label: 'Confirme sua senha',
                            hint: 'Confirme sua senha',
                            isPassword: true,
                          ),
                          SizedBox(height: screenHeight * 0.03),
                          ElevatedButton(
                            onPressed: () {
                              _handleAuth();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(screenWidth * 0.1),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.1,
                                  vertical: screenHeight * 0.02),
                              minimumSize: Size(screenWidth * 0.9, 50),
                            ),
                            child: const Text(
                              'Registrar como Cliente',
                              style: TextStyle(
                                color: AppColors.secondaryColor,
                                fontSize: CustomFontSize.buttonFontSize,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool isPassword,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? _isObscured : false,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.primaryColor),
        hintText: hint,
        hintStyle: const TextStyle(color: Color.fromRGBO(170, 170, 170, 1)),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.greyColor),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.primaryColor),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.whiteColor),
          borderRadius: BorderRadius.circular(10),
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
                  _isObscured ? 'Exibir' : 'Ocultar',
                  style: const TextStyle(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : null,
      ),
      style: const TextStyle(color: AppColors.secondaryColor),
    );
  }
}
