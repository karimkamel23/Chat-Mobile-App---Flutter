import 'package:chatapp/components/chat_bubble.dart';
import 'package:chatapp/components/mytext_field.dart';
import 'package:chatapp/services/auth/auth_service.dart';
import 'package:chatapp/services/chat/chat_service.dart';
import 'package:chatapp/services/notification/notification_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverUsername;
  final String receiverID;

  const ChatPage({
    super.key,
    required this.receiverUsername,
    required this.receiverID,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  //text controller
  final TextEditingController _messageController = TextEditingController();

  //chat, notification and auth services
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();
  static final notificatonService = NotificationService();

  //scroll controller
  // final ScrollController _scrollController = ScrollController();
  // GlobalKey for accessing the ListView
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  // ScrollController
  late ScrollController _scrollController;

  //for textfield focus
  FocusNode messageFocusNode = FocusNode();

  @override
  void initState() {
    notificatonService.getReceiverToken(widget.receiverID);
    super.initState();
    _scrollController = ScrollController();

    //add listener to focus node
    messageFocusNode.addListener(() {
      if (messageFocusNode.hasFocus) {
        //cause delay to wait for keyboard to show up
        //then calculate distance and scroll down
        Future.delayed(
          const Duration(milliseconds: 500),
          () => scrollDown(),
        );
      }
    });

    //wait for messages to display then scroll to bottom
    Future.delayed(
      const Duration(milliseconds: 1000),
      () => scrollDown(),
    );
  }

  @override
  void dispose() {
    messageFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  //send message
  void sendMessage() async {
    //if there is something written
    if (_messageController.text.isNotEmpty) {
      String msg = _messageController.text;
      // clear text controller and field
      _messageController.clear();
      //send message
      await _chatService.sendMessage(widget.receiverID, msg);

      String? currentUsername = await _authService.getUsername();
      //send notification
      await notificatonService.sendNotification(
          body: msg,
          senderId: _authService.getCurrentUser()!.uid,
          senderUsername: currentUsername!);
    }

    scrollDown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverUsername),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey.shade600,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),

          //user input area
          _buildInputArea(),
        ],
      ),
    );
  }

  //build message list
  Widget _buildMessageList() {
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(widget.receiverID, senderID),
      builder: (context, snapshot) {
        //errors check
        if (snapshot.hasError) {
          return Container(
              margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
              padding: const EdgeInsets.all(20),
              child: const Text('Error Occured'));
        }

        //loading...
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
              margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
              padding: const EdgeInsets.all(20),
              child: const Text('Loading...'));
        }

        // return list view
        return ListView(
          key: _listKey,
          controller: _scrollController,
          children:
              snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }

  //single message item
  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    //is current user
    bool isCurrentUser = data["senderID"] == _authService.getCurrentUser()!.uid;

    // align message to the right side if it is the current user,
    // if not then align to the left

    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          ChatBubble(
            message: data["message"],
            timestamp: data["timestamp"],
            isCurrentUser: isCurrentUser,
          ),
        ],
      ),
    );
  }

  //build user input area
  Widget _buildInputArea() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35),
      child: Row(
        children: [
          //text field taking up most space
          Expanded(
            child: MyTextField(
              controller: _messageController,
              hintText: "Type Something",
              obscureText: false,
              focusNode: messageFocusNode,
            ),
          ),

          //send button
          Container(
            decoration: BoxDecoration(
              color: Colors.green.shade600,
              shape: BoxShape.circle,
            ),
            margin: const EdgeInsets.only(right: 25),
            child: IconButton(
              onPressed: sendMessage,
              icon: const Icon(Icons.send),
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
