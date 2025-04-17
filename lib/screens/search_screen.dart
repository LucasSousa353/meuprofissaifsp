import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meuprofissadevflu/services/chatsearch_service.dart';
import 'package:meuprofissadevflu/styles/colors.dart';
import 'package:meuprofissadevflu/styles/font_sizes.dart';
import 'package:image_network/image_network.dart';
import 'package:remixicon/remixicon.dart';
import 'portfolio_screen.dart';

class SearchScreen extends StatefulWidget {
  final String initialFilter;

  const SearchScreen({super.key, required this.initialFilter});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ChatSearchService _service = ChatSearchService();
  String _filterQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filterQuery = widget.initialFilter;
    _searchController.text = widget.initialFilter;
  }

  Future<void> _refresh() async {
    setState(() {});
  }

  void _onSearchChanged(String query) {
    setState(() {
      _filterQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
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
                    onChanged: _onSearchChanged,
                  ),
                ),
                const SizedBox(width: 20),
                CircleAvatar(
                  backgroundColor: AppColors.primaryColor,
                  radius: 28,
                  child: IconButton(
                    icon: const Icon(Icons.search, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        _filterQuery = _searchController.text.trim();
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (_filterQuery.isNotEmpty)
              Text(
                'Exibindo resultados para: $_filterQuery',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.secondaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            const SizedBox(height: 10),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  setState(() {});
                },
                child: StreamBuilder<List<Worker>>(
                  stream: _service.getWorkers(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Erro: ${snapshot.error}'));
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text('Não encontramos profissionais.'),
                      );
                    }

                    final filteredWorkers = snapshot.data!
                        .where((worker) => worker.especialidade
                            .toLowerCase()
                            .contains(_filterQuery.toLowerCase()))
                        .toList();

                    if (filteredWorkers.isEmpty) {
                      return const Center(
                        child: Text('Não encontramos profissionais.'),
                      );
                    }

                    return ListView.builder(
                      itemCount: filteredWorkers.length,
                      itemBuilder: (context, index) {
                        final worker = filteredWorkers[index];
                        return WorkerCard(worker: worker);
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WorkerCard extends StatefulWidget {
  final Worker worker;

  const WorkerCard({super.key, required this.worker});

  @override
  _WorkerCardState createState() => _WorkerCardState();
}

class _WorkerCardState extends State<WorkerCard> {
  String? _distance;

  @override
  void initState() {
    super.initState();
    _fetchDistance();
  }

  Future<void> _fetchDistance() async {
    try {
      final currentLocation = await Geolocator.getCurrentPosition();
      final distanceInMeters = Geolocator.distanceBetween(
        currentLocation.latitude,
        currentLocation.longitude,
        widget.worker.latitude,
        widget.worker.longitude,
      );

      setState(() {
        _distance = '${(distanceInMeters / 1000).toStringAsFixed(1)} km';
      });
    } catch (e) {
      setState(() {
        _distance = 'Erro ao obter distância';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          color: AppColors.whiteColor,
          margin: const EdgeInsets.symmetric(vertical: 5.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: AppColors.borderColor),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 150,
                width: 150,
                child: Center(
                  child: widget.worker.imageUrl.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: ImageNetwork(
                            image: widget.worker.imageUrl,
                            height: 150,
                            width: 150,
                            fitAndroidIos: BoxFit.cover,
                            fitWeb: BoxFitWeb.cover,
                            onLoading: const CircularProgressIndicator(
                              color: Colors.indigoAccent,
                            ),
                            onError: const Icon(
                              Remix.user_3_fill,
                              color: AppColors.primaryColor,
                              size: 150,
                            ),
                          ),
                        )
                      : const Icon(Remix.user_3_fill,
                          color: AppColors.primaryColor, size: 150),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(widget.worker.name,
                                style: const TextStyle(
                                    fontSize: CustomFontSize.bodyFontSize,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'GeneralSans')),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star,
                                  color: Colors.amber, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                widget.worker.rating.toString(),
                                style: const TextStyle(
                                  fontSize: CustomFontSize.bodyFontSize,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          widget.worker.especialidade,
                          style: const TextStyle(
                            fontSize: CustomFontSize.smallFontSize,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 45),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          '${_distance ?? 'Calculando distância'} de você',
                          style: const TextStyle(
                            fontSize: CustomFontSize.smallFontSize,
                            color: AppColors.blackColor,
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
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PortfolioScreen(worker: widget.worker),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
