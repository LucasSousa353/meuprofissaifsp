import 'package:flutter/material.dart';
import 'package:meuprofissadevflu/styles/colors.dart';
import 'package:remixicon/remixicon.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  static const Color selectedItemColor = AppColors.primaryColor;
  static const Color unselectedItemColor = Colors.black54;
  static const double iconSize = 28.0;
  static const Duration animationDuration = Duration(milliseconds: 250);

  const CustomBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double indicatorPosition =
        screenWidth / 8 * (selectedIndex * 2 + 1) - screenWidth / 10;

    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Remix.home_line),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Remix.search_line),
                label: 'Busca',
              ),
              BottomNavigationBarItem(
                icon: Icon(Remix.chat_3_line),
                label: 'Chat',
              ),
              BottomNavigationBarItem(
                icon: Icon(Remix.user_line),
                label: 'Perfil',
              ),
            ],
            currentIndex: selectedIndex,
            selectedItemColor: selectedItemColor,
            unselectedItemColor: unselectedItemColor,
            onTap: onItemTapped,
            backgroundColor: Colors.white,
            elevation: 10,
            iconSize: iconSize,
            type: BottomNavigationBarType.fixed,
          ),
          AnimatedPositioned(
            duration: animationDuration,
            curve: Curves.easeInOut,
            left: indicatorPosition,
            top: 0,
            child: AnimatedContainer(
              duration: animationDuration,
              curve: Curves.easeInOut,
              width: screenWidth / 5,
              height: 6.0,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12.0),
                  bottomRight: Radius.circular(12.0),
                ),
                color: selectedItemColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
