import 'package:flutter/material.dart';
import 'package:meuprofissadevflu/screens/main_screen.dart';
import 'package:meuprofissadevflu/screens/search_screen.dart';
import 'package:meuprofissadevflu/styles/colors.dart';
import 'package:meuprofissadevflu/styles/font_sizes.dart';

class SpecialtiesScreen extends StatelessWidget {
  const SpecialtiesScreen({super.key});

  final List<Map<String, dynamic>> specialties = const [
    {'text': 'Elétrica', 'icon': Icons.star},
    {'text': 'Pintura', 'icon': Icons.favorite},
    {'text': 'Encanamento', 'icon': Icons.home},
    {'text': 'Reforma', 'icon': Icons.person},
    {'text': 'Marcenaria', 'icon': Icons.settings},
    {'text': 'Gesso', 'icon': Icons.map},
    {'text': 'Mecânica', 'icon': Icons.camera},
    {'text': 'Soldagem', 'icon': Icons.phone},
    {'text': 'Limpeza', 'icon': Icons.email},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title: const Text(
          'Todas as Especialidades',
          style: TextStyle(
            color: AppColors.primaryColor,
            fontSize: CustomFontSize.subtitleFontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.primaryColor),
        elevation: 0,
      ),
      backgroundColor: AppColors.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: specialties.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            final specialty = specialties[index];
            return GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainScreen(
                      initialIndex: 1,
                      child: SearchScreen(initialFilter: specialty['text']),
                    ),
                  ),
                );
              },
              child: Column(
                children: [
                  Container(
                    width: 65,
                    height: 65,
                    decoration: const BoxDecoration(
                      color: AppColors.lightgreyColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      specialty['icon'],
                      size: 30,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    specialty['text'],
                    style: const TextStyle(
                      color: AppColors.primaryColor,
                      fontFamily: 'Inter',
                      fontSize: CustomFontSize.bodyFontSize,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
