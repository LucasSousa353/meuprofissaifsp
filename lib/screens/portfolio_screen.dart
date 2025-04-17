import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meuprofissadevflu/services/chatsearch_service.dart';
import 'package:meuprofissadevflu/styles/colors.dart';
import 'package:meuprofissadevflu/styles/font_sizes.dart';
import 'package:image_network/image_network.dart';
import 'package:remixicon/remixicon.dart';
import 'package:meuprofissadevflu/services/location_parser.dart';
import 'package:meuprofissadevflu/widgets/top_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class PortfolioScreen extends StatefulWidget {
  final Worker worker;

  const PortfolioScreen({super.key, required this.worker});

  @override
  _PortfolioScreenState createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<String> portfolioImages = [];
  String? distance;
  bool isLoading = true;
  String? errorMessage;
  String? whatsappLink;

  @override
  void initState() {
    super.initState();
    _fetchPortfolioImages();
    _fetchWhatsAppLink();
    _calculateDistance();
  }

  void _showToast(BuildContext context) {
    ScaffoldMessenger.of(context)
        .hideCurrentSnackBar(); // Esconde qualquer SnackBar anterior
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Redirecionaria ao Whatsapp',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: CustomFontSize.bodyFontSize,
          ),
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _fetchPortfolioImages() async {
    try {
      final ListResult result = await _storage
          .ref('portfolios_photos/${widget.worker.uid}')
          .listAll();

      List<String> imageUrls = [];
      for (var ref in result.items) {
        final url = await ref.getDownloadURL();
        imageUrls.add(url);
      }

      setState(() {
        portfolioImages = imageUrls;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        portfolioImages = [];
        errorMessage = 'Erro ao carregar imagens: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _fetchWhatsAppLink() async {
    try {
      DocumentSnapshot doc = await _firestore.doc('parameters/links').get();
      if (doc.exists) {
        setState(() {
          whatsappLink = doc['whatsapp'];
          print('WhatsApp link fetched: $whatsappLink');
        });
      } else {
        print('Document parameters/links does not exist.');
      }
    } catch (e) {
      print('Error fetching WhatsApp link: $e');
    }
  }

  Future<void> _calculateDistance() async {
    try {
      final Position currentPosition =
          await LocationParser.getCurrentLocation();
      final double workerDistance = LocationParser.calculateDistance(
        currentPosition.latitude,
        currentPosition.longitude,
        widget.worker.latitude,
        widget.worker.longitude,
      );

      setState(() {
        distance = '${(workerDistance / 1000).toStringAsFixed(1)} km de você';
      });
    } catch (e) {
      setState(() {
        distance = 'Erro ao calcular distância';
      });
    }
  }

  Future<void> _startNewChat() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      print('Usuário não está autenticado.');
      return;
    }

    final String chatId = '${currentUser.uid}-${widget.worker.uid}';
    try {
      await _firestore.collection('chats').doc(chatId).set({
        'createdAt': Timestamp.now(),
        'participants': [currentUser.uid, widget.worker.uid],
      });
      print('Chat registrado com sucesso: $chatId');
    } catch (e) {
      print('Erro ao registrar chat: $e');
    }
  }

  void _openWhatsApp() async {
    if (whatsappLink != null) {
      final fullLink = '$whatsappLink${widget.worker.numero}';
      print('Attempting to open WhatsApp link: $fullLink');

      await _startNewChat(); // Registra o chat antes de abrir o WhatsApp

      try {
        final uri = Uri.parse(fullLink);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.platformDefault);
          print('WhatsApp link opened successfully.');
        } else {
          print('Cannot launch WhatsApp link.');
        }
      } catch (e) {
        print('Error launching WhatsApp link: $e');
      }
    } else {
      print('WhatsApp link is null.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Column(
                        children: [
                          TopBar(height: screenHeight * 0.36),
                          const SizedBox(height: 10),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      widget.worker.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            CustomFontSize.subtitleFontSize,
                                        color: AppColors.blackColor,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.star,
                                            color: Colors.amber, size: 42),
                                        const SizedBox(width: 4),
                                        Text(
                                          widget.worker.rating
                                              .toStringAsFixed(1),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                                CustomFontSize.subtitleFontSize,
                                            color: AppColors.blackColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                // Distância
                                Row(
                                  children: [
                                    const Icon(Remix.map_pin_2_fill, size: 18),
                                    const SizedBox(width: 4),
                                    Text(
                                      distance ?? 'Calculando distância...',
                                      style: const TextStyle(
                                        fontSize: CustomFontSize.bodyFontSize,
                                        color: AppColors.secondaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                // UID e descrição
                                Row(
                                  children: [
                                    const Text(
                                      'UID:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: CustomFontSize.smallFontSize,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      widget.worker.uid,
                                      style: const TextStyle(
                                        fontSize: CustomFontSize.smallFontSize,
                                        color: AppColors.secondaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Descrição',
                                        style: TextStyle(
                                          fontSize:
                                              CustomFontSize.subtitleFontSize,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        widget.worker.descricao.isNotEmpty
                                            ? widget.worker.descricao
                                            : 'Nenhuma descrição fornecida.',
                                        style: const TextStyle(
                                          fontSize: CustomFontSize.bodyFontSize,
                                          color: AppColors.secondaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const Divider(thickness: 1, color: Colors.grey),
                                const SizedBox(height: 16),
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Portfólio',
                                    style: TextStyle(
                                      fontSize: CustomFontSize.subtitleFontSize,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                errorMessage != null
                                    ? const SizedBox(height: 16)
                                    : portfolioImages.isEmpty
                                        ? const Column(
                                            children: [
                                              SizedBox(
                                                  height: 50), // Espaço inicial
                                              Text(
                                                'Sem portfólio disponível.',
                                                style: TextStyle(
                                                  fontSize: CustomFontSize
                                                      .bodyFontSize,
                                                  color:
                                                      AppColors.secondaryColor,
                                                ),
                                              ),
                                              SizedBox(
                                                  height:
                                                      200), // Espaço para ocupar a tela
                                            ],
                                          )
                                        : GridView.builder(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            gridDelegate:
                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              crossAxisSpacing: 5,
                                              mainAxisSpacing: 5,
                                            ),
                                            itemCount: portfolioImages.length,
                                            itemBuilder: (context, index) {
                                              return GestureDetector(
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return Dialog(
                                                        insetPadding:
                                                            const EdgeInsets
                                                                .all(10),
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        child: Stack(
                                                          children: [
                                                            Center(
                                                              child:
                                                                  InteractiveViewer(
                                                                panEnabled:
                                                                    true, // Permite arrastar a imagem
                                                                minScale:
                                                                    1.0, // Escala mínima
                                                                maxScale:
                                                                    5.0, // Escala máxima
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  child: Image
                                                                      .network(
                                                                    portfolioImages[
                                                                        index],
                                                                    fit: BoxFit
                                                                        .contain,
                                                                    loadingBuilder:
                                                                        (context,
                                                                            child,
                                                                            loadingProgress) {
                                                                      if (loadingProgress ==
                                                                          null) {
                                                                        return child;
                                                                      }
                                                                      return const Center(
                                                                        child:
                                                                            CircularProgressIndicator(),
                                                                      );
                                                                    },
                                                                    errorBuilder:
                                                                        (context,
                                                                            error,
                                                                            stackTrace) {
                                                                      return const Center(
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .error,
                                                                          size:
                                                                              50,
                                                                          color:
                                                                              Colors.red,
                                                                        ),
                                                                      );
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Positioned(
                                                              top: 10,
                                                              right: 10,
                                                              child:
                                                                  GestureDetector(
                                                                onTap: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child:
                                                                    Container(
                                                                  width: 40,
                                                                  height: 40,
                                                                  decoration:
                                                                      const BoxDecoration(
                                                                    color: AppColors
                                                                        .primaryColor,
                                                                    shape: BoxShape
                                                                        .circle,
                                                                  ),
                                                                  child:
                                                                      const Icon(
                                                                    Icons.close,
                                                                    color: Colors
                                                                        .white,
                                                                    size: 24,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(0),
                                                  child: Image.network(
                                                    portfolioImages[index],
                                                    fit: BoxFit.cover,
                                                    loadingBuilder: (context,
                                                        child,
                                                        loadingProgress) {
                                                      if (loadingProgress ==
                                                          null) {
                                                        return child;
                                                      }
                                                      return const Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      );
                                                    },
                                                    errorBuilder: (context,
                                                        error, stackTrace) {
                                                      return const Center(
                                                        child: Icon(
                                                          Icons.error,
                                                          size: 50,
                                                          color: Colors.red,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // Imagem do worker sobreposta
                      Positioned(
                        top: 50,
                        left: 0,
                        right: 20,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Seta no canto esquerdo
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: IconButton(
                                icon: const Icon(Icons.arrow_back,
                                    color: Colors.white),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                            // Especialidade centralizada
                            Expanded(
                              child: Text(
                                widget.worker.especialidade,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: CustomFontSize.subtitleFontSize,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            // Placeholder para espaço à direita
                            const SizedBox(
                                width:
                                    48), // Tamanho equivalente ao ícone para equilíbrio visual
                          ],
                        ),
                      ),
                      Positioned(
                        top: 100,
                        left: MediaQuery.of(context).size.width / 2 - 100,
                        child: Center(
                          child: widget.worker.imageUrl.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: ImageNetwork(
                                    image: widget.worker.imageUrl,
                                    height: 200,
                                    width: 200,
                                    fitAndroidIos: BoxFit.cover,
                                    fitWeb: BoxFitWeb.cover,
                                    onLoading:
                                        const CircularProgressIndicator(),
                                    onError: const Icon(
                                      Remix.user_3_fill,
                                      size: 200,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                )
                              : const Icon(
                                  Remix.user_3_fill,
                                  size: 200,
                                  color: AppColors.primaryColor,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
          Positioned(
            bottom: 16,
            right: 16,
            child: ElevatedButton.icon(
              onPressed: () => _showToast(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.greenZap, // Cor verde claro
                padding: const EdgeInsets.symmetric(
                    vertical: 8, horizontal: 12), // Botão menor
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight:
                        Radius.zero, // Sem borda no canto inferior direito
                  ),
                ),
              ),
              icon: const Icon(Remix.chat_3_line,
                  color: Colors.white, size: 24), // Ícone menor
              label: const Text(
                'Chamar Agora',
                style: TextStyle(
                  fontSize: 14, // Texto menor
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
