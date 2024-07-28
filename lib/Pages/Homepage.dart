import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:ai_bot/Services/alert_services.dart';
import 'package:ai_bot/Services/auth_services.dart';
import 'package:ai_bot/Services/navigation_services.dart';
import 'package:animate_do/animate_do.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:flutter_markdown/flutter_markdown.dart' ;
import 'package:markdown/markdown.dart' as md;

class HomePage extends StatefulWidget {
  final String? name;
  const HomePage({super.key, this.name});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GetIt _getIt = GetIt.instance;
  late final AuthServices _authServices;
  late final NavigationService _navigationService;
  late final AlertServices _alertServices;
  @override
  void initState() {
    super.initState();
    _authServices = _getIt.get<AuthServices>();
    _navigationService = _getIt.get<NavigationService>();
    _alertServices = _getIt.get<AlertServices>();
  }

  final Gemini geminiInstance = Gemini.instance;
  List<ChatMessage> messages = [];
  bool _isTyping = false;
  bool _showIcon = true;
  String m1 = 'Gemini is typing ...';

  ChatUser currentUser = ChatUser(
    id: '0',
    firstName: 'User',
  );

  ChatUser gemini = ChatUser(
    id: '1',
    profileImage:
        'https://www.cryptovantage.com/app/uploads/2020/09/Gemini-Cryptocurrency-Logo-1.png',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                final bool res = await _authServices.logOut();
                if (res) {
                  _alertServices.showToast(
                      text: 'Logged Out', icon: Icons.check);
                  _navigationService.pushReplacementNamed("/login");
                }
              },
              icon: Icon(Icons.logout))
        ],
        centerTitle: true,
        title: BounceInDown(
          child: const Text('Recreating Ai bot'),
        ),
        elevation: 1,
      ),
      body: Stack(
        children: [
          _buildUI(),
          if (_showIcon) ZoomIn(child: Center(child: _buildCenterIcon())),
        ],
      ),
    );
  }

  Widget _buildUI() {
    return Column(
      children: [
        Expanded(
          child: ZoomIn(
            child: DashChat(
              currentUser: currentUser,
              onSend: onSend,
              messages: messages,
              inputOptions: InputOptions(
                leading: [
                  IconButton(
                    onPressed: _imagePicker,
                    icon: const Icon(Icons.photo),
                  ),
                ],
              ),
              messageOptions: const MessageOptions(
                // markdownStyleSheet: MarkdownStyleSheet.fromCupertinoTheme(
                //     MaterialBasedCupertinoThemeData(
                //         materialTheme: ThemeData())),
                currentUserContainerColor:
                    Color(0xFF21F3F3), // Light blue color
                currentUserTextColor: Colors.black,
                marginSameAuthor: EdgeInsets.only(top: 8),
                marginDifferentAuthor: EdgeInsets.all(8),
                containerColor:
                    Color(0xFFEEEEEE), // Equivalent to Colors.grey[200]
                textColor: Colors.black,
              ),
            ),
          ),
        ),
        if (_isTyping)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundImage: NetworkImage(
                    'https://www.cryptovantage.com/app/uploads/2020/09/Gemini-Cryptocurrency-Logo-1.png',
                  ),
                ),
                const SizedBox(width: 10),
                Text(m1),
                const SizedBox(width: 10),
                const CircularProgressIndicator(),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildCenterIcon() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.chat,
          size: 100,
          color: Colors.blue,
        ),
        SizedBox(height: 20),
        Text(
          'Ask me anything!',
          style: TextStyle(fontSize: 24, color: Colors.blue),
        ),
      ],
    );
  }

  void onSend(ChatMessage chatMessage) {
    try {
      setState(() {
        _showIcon = false; // Hide the icon when a message is sent
        // messages = [chatMessage, ...messages];
        _isTyping = true;
      });

      String question = chatMessage.text;
      List<Uint8List>? images;

      if (chatMessage.medias?.isNotEmpty ?? false) {
        images = [File(chatMessage.medias!.first.url).readAsBytesSync()];
      }

      setState(() {
        messages = [chatMessage, ...messages];
        geminiInstance
            .streamGenerateContent(question, images: images)
            .listen((event) {
          ChatMessage? lastMessage = messages.firstOrNull;
          if (lastMessage != null && lastMessage.user == gemini) {
            lastMessage = messages.removeAt(0);
            String response = event.content?.parts?.fold(
                    "", (previous, current) => "$previous ${current.text}") ??
                "";

            lastMessage.text += response;
            setState(() {
              messages = [lastMessage!, ...messages];
            });
          } else {
            String response = event.content?.parts?.fold(
                    "", (previous, current) => "$previous ${current.text}") ??
                "";

            ChatMessage message = ChatMessage(
              isMarkdown: true,
                user: gemini, createdAt: DateTime.now(), text: response);
            setState(() {
              _isTyping = false;
              messages = [message, ...messages];
            });
          }
        });
      });
    } catch (e) {
      print(e);
    }
  }

  void _imagePicker() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      ChatMessage picMessage = ChatMessage(
        user: currentUser,
        createdAt: DateTime.now(),
        medias: [
          ChatMedia(
            url: file.path,
            fileName: "",
            type: MediaType.image,
          ),
        ],
        text: 'Describe the image',
      );
      onSend(picMessage);
    }
  }
}
