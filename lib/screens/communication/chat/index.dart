import 'dart:async';

import 'package:astrology_app/blocs/chat/chat_bloc.dart';
import 'package:astrology_app/components/custom_app_bar.dart';
import 'package:astrology_app/components/custom_app_drawer.dart';
import 'package:astrology_app/constants/index.dart';
import 'package:astrology_app/models/chat_messages.dart';
import 'package:astrology_app/repository/payment_repository.dart';
import 'package:astrology_app/screens/home/main.dart';
import 'package:astrology_app/services/user_manager.dart';
import 'package:astrology_app/utils/app_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../components/custom_navigation_bar.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.senderId, this.chatRate, this.walletBalance, required this.isMentor});
  final String senderId;
  final int? chatRate;
  final int? walletBalance;
  final bool isMentor;
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final PaymentRepository _paymentRepository = PaymentRepository();
  final user = UserManager.instance.user;
    Timer? _timer;
    int _minutesElapsed = 0;

  @override
  void initState() {
    super.initState();
    if (widget.senderId.isEmpty) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.pop(context);
      });
      return;
    }
    if (!user!.isMentor) {
      _startTimer();
    }
    context
        .read<ChatBloc>()
        .add(MarkMessagesAsRead(_createChatId([user?.id ?? "", widget.senderId]), user?.id ?? ""));
    context
        .read<ChatBloc>()
        .add(LoadChatMessages(_createChatId([user?.id ?? "", widget.senderId])));
  }

  void _sendMessage(String text) {
    if (text.isEmpty) return;
    final newMessage = ChatMessages(
      dateTime: Timestamp.now(),
      message: text,
      members: [user?.id ?? "", widget.senderId],
      sentBy: user?.id ?? "",
    );
    context
        .read<ChatBloc>()
        .add(SendMessage(_createChatId(newMessage.members), newMessage));
    _controller.clear();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _minutesElapsed++;
      if (mounted) {
        checkUserBalance(widget.walletBalance!, widget.chatRate!);
      } else {
        timer.cancel();
      }
    });
  }

  void checkUserBalance(int walletBalance, int chatRate) {
    int totalCost = _minutesElapsed * chatRate;
    if (totalCost >= walletBalance) {
      if (mounted) {
        showErrorDialog(context);
        _paymentRepository.updateWalletBalance(userId: user!.id, transactionAmount: totalCost, isAdding: false);
      }
      _timer?.cancel();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
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
              child: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  if (state is ChatLoading) {
                    return Center(child: CircularProgressIndicator(color: Colors.blue.shade900));
                  } else if (state is ChatLoaded) {
                    final messages = state.messages.reversed.toList();
                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        return ChatMessageWidget(
                          message: message,
                          currentUserId: user?.id ?? "",
                        );
                      },
                    );
                  } else if (state is ChatError) {
                    return Center(child: Text('Error: ${state.error}'));
                  } else {
                    return const Center(child: Text('No messages'));
                  }
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

showErrorDialog(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Alert'),
        content: const Text(
          'You do not have enough balance to proceed',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: AppConstants.bgColor,
        actionsPadding:
        const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainScreen()));
            },
            child: const Text('CLOSE', style: TextStyle(color: Colors.black)),
          ),
        ],
      );
    },
  );
}

class ChatMessageWidget extends StatelessWidget {
  final ChatMessages message;
  final String currentUserId;
  const ChatMessageWidget(
      {super.key, required this.message, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final isSentByMe = message.sentBy == currentUserId;
    return Align(
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: isSentByMe ? Colors.black : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: isSentByMe
                ? const Radius.circular(10)
                : const Radius.circular(0),
            bottomLeft: const Radius.circular(10),
            bottomRight: const Radius.circular(10),
            topRight: isSentByMe
                ? const Radius.circular(0)
                : const Radius.circular(10),
          ),
          border: Border.all(
            color: isSentByMe ? Colors.white : Colors.black,
            width: 0.2,
          ),
        ),
        constraints: BoxConstraints(
          maxWidth: size.width * 0.7,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.message,
              style: GoogleFonts.acme(
                color: isSentByMe ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              formatTimestamp(message.dateTime),
              style: GoogleFonts.acme(
                fontSize: 10,
                color: isSentByMe ? Colors.white70 : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _createChatId(List<String> members) {
  members.sort();
  return members.join('_').substring(0, 8);
}
