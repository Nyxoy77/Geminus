import 'dart:io';
import 'dart:typed_data';
import 'package:animate_do/animate_do.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:animations/animations.dart';

class Homepage extends StatefulWidget {
  final VoidCallback onThemeToggle;
  final bool isDarkMode;

  const Homepage(
      {super.key, required this.onThemeToggle, required this.isDarkMode});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final Gemini geminiInstance = Gemini.instance;

  List<ChatMessage> messages = [];
  bool _isTyping = false;
  bool _showIcon = true;
  String m1 = 'Gemini is typing ...';
  final border = const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(
        strokeAlign: BorderSide.strokeAlignCenter,
        style: BorderStyle.solid,
        width: 2,
        color: Colors.black,
      ));
  ChatUser currentUser = ChatUser(
    id: '0',
    firstName: 'User',
  );
  ChatUser gemini = ChatUser(
      id: '1',
      profileImage:
          'https://www.cryptovantage.com/app/uploads/2020/09/Gemini-Cryptocurrency-Logo-1.png');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: BounceInDown(
          child: const Text(
            'Recreating Ai bot',
          ),
        ),
        leading: IconButton(
            onPressed: widget.onThemeToggle, icon: const Icon(Icons.dark_mode)),
        elevation: 1,
        // backgroundColor: Colors.black,
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
              messageOptions: widget.isDarkMode
                  ? const MessageOptions(
                      currentUserContainerColor:
                          Color(0xFF424242), // Equivalent to Colors.grey[800]
                      currentUserTextColor: Colors.white,
                      marginSameAuthor: EdgeInsets.only(top: 8),
                      marginDifferentAuthor: EdgeInsets.all(8),
                      containerColor: Colors.black,
                      textColor: Colors.white,
                    )
                  : const MessageOptions(
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
                      'https://www.cryptovantage.com/app/uploads/2020/09/Gemini-Cryptocurrency-Logo-1.png'),
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
    setState(() {
      _showIcon = false; // Hide the icon when a message is sent
    });

    try {
      String question = chatMessage.text;
      List<Uint8List>? images;

      if (chatMessage.medias?.isNotEmpty ?? false) {
        images = [File(chatMessage.medias!.first.url).readAsBytesSync()];
      }

      setState(() {
        messages = [chatMessage, ...messages];
        _isTyping = true;
      });
     

      geminiInstance
          .streamGenerateContent(question, images: images)
          .listen((event) {
        ChatMessage? lastMessage = messages.firstOrNull;
        if (lastMessage != null && lastMessage.user == gemini) {
          lastMessage = messages.removeAt(0);
          String response = event.content?.parts?.fold("",
                  (prevElement, element) => '$prevElement${element.text}') ??
              "";
          lastMessage.text += response;
          setState(() {
            messages = [lastMessage!, ...messages];
            _isTyping = false;
          });
        } else {
          String response = event.content?.parts?.fold("",
                  (prevElement, element) => '$prevElement${element.text}') ??
              "";
          ChatMessage geminiMessage = ChatMessage(
              user: gemini, createdAt: DateTime.now(), text: response);
          setState(() {
            messages = [geminiMessage, ...messages];
            _isTyping = false;
          });
        }
      });
    } catch (e) {
      print('Unexpected error: $e');
      setState(() {
        _isTyping = false;
      });
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
            ChatMedia(url: file.path, fileName: "", type: MediaType.image)
          ],
          text: 'Describe the image ');
      onSend(picMessage);
    }
  }
}
