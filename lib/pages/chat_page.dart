import 'package:chat_application/models/chat.dart';
import 'package:chat_application/models/message.dart';
import 'package:chat_application/models/user_model.dart';
import 'package:chat_application/service/auth_service.dart';
import 'package:chat_application/service/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:dash_chat_2/dash_chat_2.dart';

class ChatPage extends StatefulWidget {
  final UserProfile user;
  const ChatPage({super.key, required this.user});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late DatabaseService _databaseService;
  final GetIt _getIt = GetIt.instance;
  late AuthService _authService;
  ChatUser? currentUser, otheruser;

  @override
  void initState() {
    super.initState();
    _databaseService = _getIt.get<DatabaseService>();
    _authService = _getIt.get<AuthService>();
    currentUser = ChatUser(
      id: _authService.user!.uid,
      firstName: _authService.user!.displayName,
    );
    otheruser = ChatUser(
      id: widget.user.uid!,
      firstName: widget.user.name,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user.name!),
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return StreamBuilder(
      stream: _databaseService.getChatData(
        _authService.user!.uid,
        widget.user.uid!,
      ),
      builder: (context, snapshot) {
        Chat? chat = snapshot.data?.data();
        List<ChatMessage> message = [];
        if (chat != null && chat.messages != null) {
          message = _generatechatMessageList(
            chat.messages!,
          );
        }
        return DashChat(
          messageOptions: const MessageOptions(
            showCurrentUserAvatar: true,
            showTime: true,
          ),
          inputOptions: const InputOptions(
            alwaysShowSend: true,
          ),
          currentUser: currentUser!,
          onSend: _sentmessage,
          messages: message,
        );
      },
    );
  }

  Future<void> _sentmessage(ChatMessage chatmessage) async {
    Message message = Message(
      senderID: currentUser!.id,
      content: chatmessage.text,
      messageType: MessageType.Text,
      sentAt: Timestamp.fromDate(chatmessage.createdAt),
    );

    await _databaseService.sendChatMessage(
      _authService.user!.uid,
      widget.user.uid!,
      message,
    );
  }

  List<ChatMessage> _generatechatMessageList(
    List<Message> message,
  ) {
    List<ChatMessage> chatmessage = message.map((m) {
      return ChatMessage(
        text: m.content!,
        user: m.senderID == currentUser!.id ? currentUser! : otheruser!,
        createdAt: m.sentAt!.toDate(),
      );
    }).toList();
    return chatmessage;
  }
}
