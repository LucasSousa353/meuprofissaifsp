import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:meuprofissadevflu/screens/userterms_screen.dart';
import 'package:meuprofissadevflu/styles/colors.dart';
import 'package:meuprofissadevflu/styles/font_sizes.dart';
import 'package:meuprofissadevflu/widget_tree.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _termsAccepted = false;

  // Função para mostrar o toast
  void _showToast(BuildContext context) {
    ScaffoldMessenger.of(context)
        .hideCurrentSnackBar(); // Esconde qualquer SnackBar anterior
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Funcionalidade em melhorias/construção',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: CustomFontSize.bodyFontSize,
          ),
        ),
        duration: Duration(seconds: 2),
      ),
    );
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
                    Color.fromRGBO(0, 78, 69, 1),
                    Color.fromRGBO(0, 78, 69, 1)
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: screenHeight * 0.03),
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
                    'registre-se',
                    style: TextStyle(
                        fontSize: 55,
                        fontFamily: 'Inter',
                        color: AppColors.backgroundColor,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(screenWidth * 0.06),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundColor,
                        borderRadius: BorderRadius.vertical(
                            top: Radius.elliptical(
                                screenWidth * 0.2, screenWidth * 0.15)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'quem é você?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 28,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w900,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.03),
                          ElevatedButton(
                            onPressed: () {
                              if (!_termsAccepted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Você precisa aceitar os termos de uso para continuar.',
                                    ),
                                  ),
                                );
                                return;
                              }
                              // Mostrar o toast em vez de navegar
                              _showToast(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(screenWidth * 0.1),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.1,
                                  vertical: screenHeight * 0.025),
                              minimumSize: Size(screenWidth * 0.9, 50),
                            ),
                            child: const Text(
                              'sou profissa',
                              style: TextStyle(
                                color: AppColors.backgroundColor,
                                fontSize: CustomFontSize.buttonFontSize,
                                fontWeight: FontWeight.normal,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          const Text(
                            'Conecte-se com clientes',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: CustomFontSize.bodyFontSize,
                              fontFamily: 'Inter',
                            ),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(height: screenHeight * 0.04),
                          ElevatedButton(
                            onPressed: () {
                              if (!_termsAccepted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Você precisa aceitar os termos de uso para continuar.',
                                    ),
                                  ),
                                );
                                return;
                              }
                              // Mostrar o toast em vez de navegar
                              _showToast(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(screenWidth * 0.1),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.1,
                                  vertical: screenHeight * 0.025),
                              minimumSize: Size(screenWidth * 0.9, 50),
                            ),
                            child: const Text(
                              'sou cliente',
                              style: TextStyle(
                                color: AppColors.backgroundColor,
                                fontSize: CustomFontSize.buttonFontSize,
                                fontWeight: FontWeight.normal,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          const Text(
                            'Conecte-se com profissionais qualificados',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: CustomFontSize.bodyFontSize,
                              fontFamily: 'Inter',
                            ),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          CheckboxListTile(
                            title: RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                    text: "Eu concordo com os ",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: CustomFontSize.bodyFontSize,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                  TextSpan(
                                    text: "termos de uso",
                                    style: const TextStyle(
                                      color: AppColors.primaryColor,
                                      decoration: TextDecoration.underline,
                                      fontSize: CustomFontSize.bodyFontSize,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Inter',
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const UserTerms()),
                                        );
                                      },
                                  )
                                ],
                              ),
                            ),
                            value: _termsAccepted,
                            onChanged: (bool? newValue) {
                              setState(() {
                                _termsAccepted = newValue!;
                              });
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          const Center(
                            child: Row(
                              children: [
                                Spacer(flex: 1),
                                SizedBox(
                                  width: 50,
                                  child: Divider(
                                    color: Colors.black54,
                                    thickness: 1,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text(
                                    'ou cadastre-se com',
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
                                Spacer(flex: 1),
                              ],
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 65,
                                height: 65,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey[300],
                                ),
                              ),
                              SizedBox(width: screenWidth * 0.05),
                              Container(
                                width: 65,
                                height: 65,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey[300],
                                ),
                              ),
                              SizedBox(width: screenWidth * 0.05),
                              Container(
                                width: 65,
                                height: 65,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey[300],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.03),
                          Center(
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const WidgetTree(),
                                  ),
                                );
                              },
                              child: RichText(
                                text: const TextSpan(
                                  text: 'já possui uma conta? ',
                                  style: TextStyle(
                                    color: AppColors.secondaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Inter',
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'Faça o login',
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
}
