import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// Função para abrir uma URL externa
Future<void> launchURL(String url) async {
  // ignore: deprecated_member_use
  if (await canLaunch(url)) {
    // ignore: deprecated_member_use
    await launch(url);
  } else {
    throw 'Não foi possível abrir a URL: $url';
  }
}

// Função que retorna um GestureDetector para abrir uma URL
GestureDetector createGestureDetector(String url, Widget child) {
  return GestureDetector(
    onTap: () => launchURL(url),
    child: child,
  );
}
