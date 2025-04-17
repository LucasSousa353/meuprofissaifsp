import 'package:flutter/material.dart';
import 'package:meuprofissadevflu/services/chat_service.dart';
import 'package:meuprofissadevflu/styles/colors.dart';
import 'package:meuprofissadevflu/widgets/top_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:remixicon/remixicon.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatService _chatService = ChatService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();
  String? whatsappLink;

  @override
  void initState() {
    super.initState();
    print('initState chamado');
    _fetchWhatsAppLink();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  Future<void> _fetchWhatsAppLink() async {
    print('Iniciando _fetchWhatsAppLink');
    try {
      DocumentSnapshot<Map<String, dynamic>> doc =
          await _firestore.doc('parameters/links').get();
      print('Documento recuperado: ${doc.data()}');
      if (doc.exists) {
        setState(() {
          whatsappLink = doc.data()?['whatsapp'];
          print('WhatsApp link fetched: $whatsappLink');
        });
      } else {
        print('Documento parameters/links não existe.');
      }
    } catch (e) {
      print('Erro ao buscar link do WhatsApp: $e');
    }
  }

  Future<void> _startNewChat(String workerUid) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      print('Usuário não está logado.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Você precisa estar logado para iniciar um chat.')),
      );
      return;
    }

    final String chatId = '${currentUser.uid}-$workerUid';
    print('Criando chat com ID: $chatId');
    try {
      await _firestore.collection('chats').doc(chatId).set({
        'createdAt': Timestamp.now(),
        'participants': [currentUser.uid, workerUid],
      });
      print('Chat registrado com sucesso: $chatId');
    } catch (e) {
      print('Erro ao registrar chat: $e');
    }
  }

  Future<void> _openWhatsApp(String workerUid) async {
    if (whatsappLink == null) {
      print('Link do WhatsApp não configurado.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Link do WhatsApp não configurado.')),
      );
      return;
    }

    try {
      // Obtendo os dados do trabalhador do Firebase
      DocumentSnapshot<Map<String, dynamic>> workerDoc =
          await _firestore.collection('workers').doc(workerUid).get();

      if (!workerDoc.exists) {
        print('Trabalhador não encontrado.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Trabalhador não encontrado.')),
        );
        return;
      }

      // Extraindo o número de telefone
      String workerNumber = workerDoc.data()?['numero'] ?? '';

      if (workerNumber.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Redirecionaria ao Whatsapp')),
        );
        return;
      }

      // Montando o link do WhatsApp
      final fullLink = '$whatsappLink$workerNumber';
      print('Link do WhatsApp gerado: $fullLink');

      // Registrando o chat antes de abrir o WhatsApp
      await _startNewChat(workerUid);

      // Abrindo o link no WhatsApp
      final uri = Uri.parse(fullLink);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        print('Link do WhatsApp aberto com sucesso: $fullLink');
      } else {
        print('Não foi possível abrir o WhatsApp.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Não foi possível abrir o WhatsApp.')),
        );
      }
    } catch (e) {
      print('Erro ao buscar número do trabalhador ou abrir o WhatsApp: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          // TopBar com título e campo de busca
          SizedBox(
            child: Stack(
              children: [
                TopBar(height: screenHeight * 0.23),
                const Positioned(
                  top: 20,
                  left: 16,
                  right: 16,
                  child: SafeArea(
                    child: Text(
                      "Suas Conversas",
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Positioned(
                  top: 55, // Ajustado para reduzir espaço do topo
                  left: 16,
                  right: 16,
                  child: SafeArea(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        color: AppColors.whiteColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Buscar chats',
                          hintStyle:
                              const TextStyle(color: AppColors.primaryColor),
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
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, // Reduzido o padding vertical
                            horizontal: 16,
                          ),
                        ),
                        style: const TextStyle(color: AppColors.secondaryColor),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Lista de chats
          Expanded(
            child: StreamBuilder<List<Chat>>(
              stream: _chatService.getChatsStartedByUser(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Nenhum chat ativo.'));
                }

                final activeChats = snapshot.data!;

                return ListView.builder(
                  padding: const EdgeInsets.only(top: 4), // Reduzido o padding
                  itemCount: activeChats.length,
                  itemBuilder: (context, index) {
                    final chat = activeChats[index];

                    return FutureBuilder<Map<String, String>>(
                      future: _chatService.getWorkerDetails(chat.workerUid),
                      builder: (context, workerSnapshot) {
                        if (workerSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const ListTile(
                            title: Text('Carregando...'),
                            subtitle:
                                Text('Buscando detalhes do trabalhador...'),
                          );
                        }
                        if (workerSnapshot.hasError) {
                          return ListTile(
                            title: const Text('Erro ao buscar detalhes'),
                            subtitle: Text(workerSnapshot.error.toString()),
                          );
                        }

                        final workerDetails = workerSnapshot.data ?? {};
                        final workerName =
                            workerDetails['workerName'] ?? 'Desconhecido';
                        final workerImageUrl =
                            workerDetails['workerImageUrl'] ?? '';

                        final createdAt = chat.createdAt.toDate();
                        final formattedDate =
                            '${createdAt.day.toString().padLeft(2, '0')}/${createdAt.month.toString().padLeft(2, '0')}/${createdAt.year}';

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4.0,
                              horizontal: 12.0), // Reduzido padding
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: AppColors.whiteColor,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 4, // Suavizado
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 6.0, horizontal: 16.0),
                              leading: CircleAvatar(
                                radius: 28, // Leve ajuste no tamanho
                                backgroundColor: AppColors.primaryColor,
                                backgroundImage: workerImageUrl.isNotEmpty
                                    ? NetworkImage(workerImageUrl)
                                    : null,
                                child: workerImageUrl.isEmpty
                                    ? const Icon(Icons.person,
                                        color: Colors.white)
                                    : null,
                              ),
                              title: Text(
                                workerName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                formattedDate,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              trailing: GestureDetector(
                                onTap: () {
                                  _openWhatsApp(chat.workerUid);
                                },
                                child: Container(
                                  width: 36, // Levemente reduzido
                                  height: 36,
                                  decoration: const BoxDecoration(
                                    color: AppColors.greenZap,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Remix.chat_3_line,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
