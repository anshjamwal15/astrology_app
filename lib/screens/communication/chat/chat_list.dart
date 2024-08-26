import 'package:astrology_app/components/custom_app_bar.dart';
import 'package:astrology_app/constants/index.dart';
import 'package:astrology_app/screens/communication/chat/index.dart';
import 'package:astrology_app/services/user_manager.dart';
import 'package:astrology_app/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:astrology_app/blocs/chat/chat_bloc.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {

  @override
  void initState() {
    final userId = UserManager.instance.user?.id;
    context.read<ChatBloc>().add(LoadUsersWhoMessaged(userId!));
    context.read<ChatBloc>().add(GetUnreadCount(userId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: AppConstants.bgColor,
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state is UsersLoading) {
            return Center(
                child: CircularProgressIndicator(color: Colors.blue.shade900));
          } else if (state is UsersLoaded) {
            final users = state.users;
            return Padding(
              padding: const EdgeInsets.only(top: 20),
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(senderId: user.senderId),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Container(
                                height: size.height * 0.07,
                                width: size.height * 0.07,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.black, width: 0.5),
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    "assets/images/astologer.jpg",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20, left: 10, top: 10),
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(maxWidth: size.width * 0.65),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            user.userName,
                                            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            formatTimestamp(user.dateTime),
                                            style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black54, fontSize: 12),
                                            overflow: TextOverflow.ellipsis,
                                          )
                                        ],
                                      ),
                                      SizedBox(height: size.height * 0.006),
                                      Text(
                                        user.message,
                                        style: TextStyle(color: user.isRead ? Colors.black54 : Colors.black, fontSize: 15, fontWeight: user.isRead ? FontWeight.bold : FontWeight.w500),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          } else if (state is ChatError) {
            return const Center(child: Text('Something went wrong! Please try again later.'));
          }
          return const Center(child: Text('No users found.'));
        },
      ),
    );
  }
}
