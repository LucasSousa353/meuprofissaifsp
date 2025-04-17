import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'search_screen.dart';
import 'chat_screen.dart';
import 'profile_screen.dart';
import '../widgets/custom_bottom_navigation_bar.dart';
import 'package:meuprofissadevflu/styles/colors.dart';
import 'package:meuprofissadevflu/styles/font_sizes.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex;
  final Widget? child;

  const MainScreen({super.key, this.initialIndex = 0, this.child});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Lista de títulos para cada página
  final List<String> _titles = [
    'MeuProfissa',
    'Buscar Profissional',
    'Chat',
    'Perfil'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 2
          ? null
          : AppBar(
              automaticallyImplyLeading: false,
              surfaceTintColor: Colors.transparent,
              backgroundColor: AppColors.backgroundColor,
              title: Text(
                _titles[_selectedIndex],
                style: const TextStyle(
                  fontSize: CustomFontSize.subtitleFontSize,
                  fontFamily: 'GeneralSans',
                  color: AppColors.primaryColor,
                ),
              ),
              elevation: 0,
            ),
      body: IndexedStack(
        index: _selectedIndex,
        children: <Widget>[
          const HomeScreen(),
          widget.child ??
              const SearchScreen(
                  initialFilter: ''), // Usa a tela customizada, se fornecida
          const ChatPage(),
          const ProfilePage(),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
