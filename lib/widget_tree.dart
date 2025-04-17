import 'package:meuprofissadevflu/auth.dart';
import 'package:meuprofissadevflu/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:meuprofissadevflu/screens/main_screen.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Auth().authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const MainScreen(initialIndex: 0);
          } else {
            return const LoginScreen();
          }
        });
  }
}
