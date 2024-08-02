import 'dart:ui';

import 'package:astrology_app/components/custom_app_bar.dart';
import 'package:astrology_app/components/custom_app_drawer.dart';
import 'package:astrology_app/constants/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Message> _messages = [
    Message(
        isSentByMe: true,
        text:
            "Hello, I am doing good, thanks for asking. How about you? Hello, I am doing good, thanks for asking. How about you?"),
    Message(isSentByMe: false, text: "How're you?"),
    Message(isSentByMe: false, text: "Hello"),
    Message(isSentByMe: true, text: "Hello"),

  ];
  final TextEditingController _controller = TextEditingController();

  void _sendMessage(String text) {
    if (text.isEmpty) return;
    setState(() {
      _messages.add(Message(text: text, isSentByMe: true));
      _messages
          .add(Message(text: text, isSentByMe: false));
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppConstants.bgColor,
      appBar: const CustomAppBar(),
      drawer: const CustomAppDrawer(),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[_messages.length - 1 - index];
                  return ChatMessageWidget(message: message);
                },
              ),
            ),
          ),
          Container(
            height: size.height * 0.12,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      key: const Key("chatForm_passwordInput_textField"),
                      keyboardType: TextInputType.text,
                      cursorColor: Colors.black,
                      controller: _controller,
                      decoration: InputDecoration(
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: () {},
                              splashColor: Colors.white24,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Image.asset(
                                  "assets/images/paper-clip.png",
                                  scale: 25,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {},
                              splashColor: Colors.white24,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Image.asset(
                                  "assets/images/microphone.png",
                                  scale: 25,
                                ),
                              ),
                            )
                          ],
                        ),
                        filled: true,
                        fillColor: AppConstants.bgColor,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        hintText: "Type a message",
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none),
                        border: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: size.width * 0.02,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20)),
                    child: InkWell(
                      onTap: () => _sendMessage(_controller.text),
                      splashColor: Colors.white24,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          "assets/images/send.png",
                          scale: 25,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessageWidget extends StatelessWidget {
  final Message message;

  const ChatMessageWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Align(
      alignment:
          message.isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: message.isSentByMe ? Colors.black : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: message.isSentByMe
                ? const Radius.circular(10)
                : const Radius.circular(0),
            bottomLeft: const Radius.circular(10),
            bottomRight: const Radius.circular(10),
            topRight:
                message.isSentByMe ? Radius.circular(0) : Radius.circular(10),
          ),
          border: Border.all(
            color: message.isSentByMe ? Colors.white : Colors.black,
            width: 0.2,
          ),
        ),
        constraints: BoxConstraints(
          maxWidth: size.width * 0.7,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message.text,
              style: GoogleFonts.acme(
                  color: message.isSentByMe ? Colors.white : Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}

class Message {
  final String text;
  final bool isSentByMe;

  Message({required this.text, required this.isSentByMe});
}
