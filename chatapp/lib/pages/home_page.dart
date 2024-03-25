import 'package:chatapp/components/main_drawer.dart';
import 'package:chatapp/components/user_tile.dart';
import 'package:chatapp/pages/chat_page.dart';
import 'package:chatapp/services/auth/auth_service.dart';
import 'package:chatapp/services/chat/chat_service.dart';
import 'package:chatapp/services/notification/notification_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //chat and auth services
  final ChatService _chatService = ChatService();

  final AuthService _authService = AuthService();

  final notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    notificationService.firebaseNotification(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('H O M E'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey.shade600,
        elevation: 0,
      ),
      drawer: const MainDrawer(),
      body: _buildUserList(),
    );
  }

  // build a list of all users except the logged in one
  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUserStream(),
      builder: (context, snapshot) {
        //error
        if (snapshot.hasError) {
          return const Center(
              child: Text(
                  "Error has occured. Please restart and check connection"));
        }

        //loading..
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Text("Loading.."));
        }

        //return list view

        return ListView(
          children: snapshot.data!
              .map<Widget>((userData) => _buildUserListItem(userData, context))
              .toList(),
        );
      },
    );
  }

  //build individual list tile for each user
  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    if (userData["email"] != _authService.getCurrentUser()!.email) {
      return UserTile(
        text: userData["username"],
        onTap: () {
          print(userData["uid"]);
          //go to chat page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverUsername: userData["username"],
                receiverID: userData["uid"],
              ),
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }
}
