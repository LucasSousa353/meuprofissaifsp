import 'package:flutter/material.dart';
import 'package:meuprofissadevflu/styles/colors.dart';

class TopBar extends StatelessWidget {
  final double height; // Parâmetro para definir a altura

  const TopBar({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CurvePainter(),
      child: Container(
        height: height, // Altura recebida como parâmetro
      ),
    );
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    Paint paint = Paint();

    // Define a cor da onda
    paint.color = AppColors.primaryColor;

    // Início no canto superior esquerdo
    path.lineTo(0, size.height * 0.75);

    // Primeira onda - variação leve
    path.quadraticBezierTo(size.width * 0.10, size.height * 0.65,
        size.width * 0.25, size.height * 0.75);

    // Segunda onda - um pouco mais acentuada
    path.quadraticBezierTo(size.width * 0.40, size.height * 0.80,
        size.width * 0.55, size.height * 0.70);

    // Terceira onda - levemente mais baixa
    path.quadraticBezierTo(size.width * 0.70, size.height * 0.60,
        size.width * 0.80, size.height * 0.70);

    // Quarta onda - volta a uma altura média
    path.quadraticBezierTo(
        size.width * 0.90, size.height * 0.80, size.width, size.height * 0.75);

    // Fecha o caminho no canto superior direito
    path.lineTo(size.width, 0);
    path.close();

    // Desenha o caminho com a cor
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
