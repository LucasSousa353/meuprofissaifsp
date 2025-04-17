import 'dart:async';
import 'package:flutter/material.dart';
import 'package:meuprofissadevflu/screens/main_screen.dart';
import 'package:meuprofissadevflu/screens/search_screen.dart';
import 'package:meuprofissadevflu/screens/specialities_screen.dart';
import 'package:meuprofissadevflu/services/locationservice.dart';
import 'package:meuprofissadevflu/services/homefetch_service.dart';
import 'package:meuprofissadevflu/services/profilefetch_service.dart';
import 'package:meuprofissadevflu/styles/colors.dart';
import 'package:meuprofissadevflu/styles/font_sizes.dart';
import 'package:geolocator/geolocator.dart';
import 'package:remixicon/remixicon.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meuprofissadevflu/services/location_parser.dart';

class ListItem {
  final String text;
  final IconData icon;
  final String url;

  ListItem({required this.text, required this.icon, required this.url});
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<UserProfile> workers = [];
  List<UserProfile> filteredWorkers = [];
  bool isLoadingWorkers = true;

  final ProfileFetchService _fetchService = ProfileFetchService();
  final List<String> galleryItems =
      List.generate(6, (index) => 'Item ${index + 1}');
  final List<ListItem> items = [
    ListItem(
        text: 'Elétrica', icon: Icons.star, url: 'https://www.amazon.com/'),
    ListItem(
        text: 'Pintura', icon: Icons.favorite, url: 'https://www.amazon.com/'),
    ListItem(
        text: 'Encanador', icon: Icons.home, url: 'https://www.amazon.com/'),
    ListItem(
        text: 'Reforma',
        icon: Icons.person,
        url: 'https://www.amazon.com/reforma'),
    ListItem(
        text: 'Marcenaria',
        icon: Icons.settings,
        url: 'https://www.amazon.com/'),
    ListItem(
        text: 'Gesso', icon: Icons.map, url: 'https://www.amazon.com/gesso'),
    ListItem(
        text: 'Mecânica',
        icon: Icons.camera,
        url: 'https://www.amazon.com/mecanica'),
    ListItem(
        text: 'Soldagem',
        icon: Icons.phone,
        url: 'https://www.amazon.com/soldagem'),
    ListItem(
        text: 'Limpeza',
        icon: Icons.email,
        url: 'https://www.amazon.com/limpeza'),
  ];

  late PageController _pageController;
  late Timer _timer;
  final TextEditingController _searchController = TextEditingController();
  final HomeFetchService _fetchAdService = HomeFetchService();
  String selectedFilter = 'Todos';

  List<String> adImageUrls = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    selectedFilter = 'Todos';
    getLocation();
    _loadAds();
    _loadWorkers();

    _pageController = PageController();
    _timer = Timer.periodic(const Duration(seconds: 2), (Timer timer) {
      if (_pageController.hasClients && adImageUrls.isNotEmpty) {
        int nextPage = (_pageController.page!.toInt() + 1) % adImageUrls.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  Future<void> _loadAds() async {
    try {
      List<String> ads = await _fetchAdService.fetchAdImages(context);
      setState(() {
        adImageUrls = ads;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loadWorkers() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('workers')
          .limit(10)
          .get();

      List<UserProfile> fetchedWorkers = [];
      for (var doc in snapshot.docs) {
        UserProfile? worker = await _fetchService.fetchUserProfile(doc.id);
        if (worker != null) {
          fetchedWorkers.add(worker);
        }
      }

      setState(() {
        workers = fetchedWorkers;
        filteredWorkers = List.from(fetchedWorkers);
        isLoadingWorkers = false;
      });
    } catch (e) {
      print("Erro ao carregar os trabalhadores: $e");
      setState(() {
        isLoadingWorkers = false;
      });
    }
  }

  void _applyFilter() async {
    setState(() {
      if (selectedFilter == 'Todos') {
        filteredWorkers = List.from(workers);
      } else {
        final maxDistance =
            int.parse(selectedFilter.split(' ')[1].replaceAll('km', '')) * 1000;

        Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
            .then((Position position) {
          double userLatitude = position.latitude;
          double userLongitude = position.longitude;

          filteredWorkers = workers.where((worker) {
            double distance = Geolocator.distanceBetween(
              userLatitude,
              userLongitude,
              worker.latitude,
              worker.longitude,
            );
            return distance <= maxDistance;
          }).toList();

          setState(() {});
        }).catchError((e) {
          print("Erro ao obter localização: $e");
          setState(() {
            filteredWorkers = List.from(workers);
          });
        });
      }
    });
  }

  Widget _buildFilterButton(String label) {
    final isSelected = selectedFilter == label;
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedFilter = label;
          _applyFilter();
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? AppColors.primaryColor : Colors.white,
        side: const BorderSide(color: Colors.grey, width: 0.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontSize: 14,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    _searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Busca',
                      hintStyle: const TextStyle(color: AppColors.primaryColor),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: AppColors.borderColor),
                        borderRadius: BorderRadius.circular(28),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: AppColors.borderColor),
                        borderRadius: BorderRadius.circular(28),
                      ),
                      filled: true,
                      fillColor: AppColors.whiteColor,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * 0.020,
                        horizontal: MediaQuery.of(context).size.width * 0.05,
                      ),
                    ),
                    style: const TextStyle(color: AppColors.secondaryColor),
                  ),
                ),
                const SizedBox(width: 20),
                CircleAvatar(
                  backgroundColor: AppColors.primaryColor,
                  radius: 28,
                  child: IconButton(
                    icon: const Icon(Icons.search, color: Colors.white),
                    onPressed: () {
                      final searchText = _searchController.text.trim();
                      if (searchText.isNotEmpty) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => MainScreen(
                              initialIndex: 1, // Índice da SearchScreen
                              // Passa o filtro como argumento
                              child: SearchScreen(initialFilter: searchText),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.01),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Anúncios (carrossel)
                      SizedBox(
                        height: 220,
                        child: Column(
                          children: [
                            Expanded(
                              child: Stack(
                                children: [
                                  if (isLoading)
                                    const Center(
                                        child: CircularProgressIndicator())
                                  else if (adImageUrls.isEmpty)
                                    const Center(
                                        child:
                                            Text("Nenhum anúncio disponível"))
                                  else
                                    PageView.builder(
                                      controller: _pageController,
                                      itemCount: adImageUrls.length,
                                      itemBuilder: (context, index) {
                                        String imageUrl = adImageUrls[index];
                                        return Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            image: DecorationImage(
                                              image: NetworkImage(imageUrl),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                ],
                              ),
                            ),
                            if (adImageUrls.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: SmoothPageIndicator(
                                  controller: _pageController,
                                  count: adImageUrls.length,
                                  effect: const WormEffect(
                                    dotWidth: 12,
                                    dotHeight: 12,
                                    spacing: 8,
                                    dotColor: Colors.grey,
                                    activeDotColor: AppColors.primaryColor,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      // Especialidades
                      SizedBox(height: screenHeight * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Especialidades',
                            style: TextStyle(
                              color: AppColors.blackColor,
                              fontSize: CustomFontSize.subtitleFontSize,
                              fontFamily: "Inter",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const SpecialtiesScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'ver todas',
                              style: TextStyle(
                                color: AppColors.primaryColor,
                                fontSize: CustomFontSize.bodyFontSize,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      SizedBox(
                        height: 125,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final item = items[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => MainScreen(
                                      initialIndex:
                                          1, // Índice para SearchScreen
                                      child: SearchScreen(
                                          initialFilter:
                                              item.text), // Passa o filtro
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                width: 110,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 8),
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
                                        item.icon,
                                        size: 30,
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      item.text,
                                      style: const TextStyle(
                                        color: AppColors.primaryColor,
                                        fontFamily: 'Inter',
                                        fontSize: CustomFontSize.bodyFontSize,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.01),
                      const Text(
                        'Próximos de você',
                        style: TextStyle(
                            color: AppColors.blackColor,
                            fontSize: CustomFontSize.subtitleFontSize,
                            fontFamily: "Inter",
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: screenHeight * 0.01),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildFilterButton('Todos'),
                          _buildFilterButton('Até 2km'),
                          _buildFilterButton('Até 5km'),
                          _buildFilterButton('Até 10km'),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final itemSize = (constraints.maxWidth - 20) / 2;
                          if (isLoadingWorkers) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: filteredWorkers.isEmpty
                                ? [
                                    const Center(
                                        child: Text(
                                            'Nenhum trabalhador encontrado'))
                                  ]
                                : filteredWorkers.map((worker) {
                                    return SizedBox(
                                      width: itemSize,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          worker.imageUrl.isNotEmpty
                                              ? ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  child: Image.network(
                                                    worker.imageUrl,
                                                    fit: BoxFit.cover,
                                                    width: 150,
                                                    height: 150,
                                                  ),
                                                )
                                              : const Icon(
                                                  Remix.user_3_fill,
                                                  size: 150,
                                                  color: AppColors.primaryColor,
                                                ),
                                          const SizedBox(height: 8),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Text(
                                              worker.name,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                color: AppColors.blackColor,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(Icons.star,
                                                  size: 16,
                                                  color: Colors.yellow),
                                              Text(
                                                worker.rating
                                                    .toStringAsFixed(1),
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: AppColors.blackColor,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              const Icon(Icons.location_on,
                                                  size: 16,
                                                  color:
                                                      AppColors.primaryColor),
                                              FutureBuilder<Position>(
                                                future: LocationParser
                                                    .getCurrentLocation(),
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return const Text(
                                                        'Calculando...');
                                                  }

                                                  if (snapshot.hasError) {
                                                    return const Text(
                                                        'Erro ao obter localização');
                                                  }

                                                  final currentPosition =
                                                      snapshot.data!;
                                                  final distance =
                                                      LocationParser
                                                          .calculateDistance(
                                                    currentPosition.latitude,
                                                    currentPosition.longitude,
                                                    worker.latitude,
                                                    worker.longitude,
                                                  );

                                                  return Text(
                                                    '${(distance / 1000).toStringAsFixed(1)} km',
                                                    style: const TextStyle(
                                                        fontSize: 12),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                          // Botão "Ver mais profissionais" no final da tela
                                        ],
                                      ),
                                    );
                                  }).toList(),
                          );
                        },
                      ),
                      const SizedBox(height: 20), // Espaço antes do botão
                      Center(
                        child: SizedBox(
                          width:
                              double.infinity, // Ocupar toda a largura da tela
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MainScreen(
                                    initialIndex: 1, // Índice para SearchScreen
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  AppColors.primaryColor, // Fundo verde
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12), // Altura do botão
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    10), // Bordas arredondadas
                              ),
                            ),
                            child: const Text(
                              'Ver mais profissionais',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: CustomFontSize.bodyFontSize,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
