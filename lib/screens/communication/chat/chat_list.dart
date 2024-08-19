import 'package:astrology_app/components/custom_app_bar.dart';
import 'package:astrology_app/constants/index.dart';
import 'package:astrology_app/services/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:astrology_app/models/user.dart';
import 'package:astrology_app/blocs/chat/chat_bloc.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = UserManager.instance.user?.id;
    context.read<ChatBloc>().add(LoadUsersWhoMessaged(userId!));
    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: AppConstants.bgColor,
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state is UsersLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UsersLoaded) {
            final users = state.users;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  title: Text(user.name),
                  subtitle: Text(user.email),
                  onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => ChatScreen(userId: user.id),
                      //   ),
                      // );
                  },
                );
              },
            );
          } else if (state is ChatError) {
            return Center(child: Text('Error: ${state.error}'));
          }
          return const Center(child: Text('No users found.'));
        },
      ),
    );
  }
}