import 'package:chat_application/models/user_model.dart';
import 'package:chat_application/service/auth_service.dart';
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
  final GetIt _getIt = GetIt.instance;
  late AuthService _authService;
  ChatUser? currentUser, otheruser;

  @override
  void initState() {
    super.initState();
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
    return DashChat(
      currentUser: currentUser!,
      onSend: (ChatMessage message) {},
      messages: [],
    );
  }
}
