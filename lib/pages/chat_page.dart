import 'dart:io';

import 'package:chat_application/models/chat.dart';
import 'package:chat_application/models/message.dart';
import 'package:chat_application/models/user_model.dart';
import 'package:chat_application/service/auth_service.dart';
import 'package:chat_application/service/database_service.dart';
import 'package:chat_application/service/media_service%20.dart';
import 'package:chat_application/service/storge_service.dart';
import 'package:chat_application/utils.dart';
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
  late MediaService _mediaService;
  ChatUser? currentUser, otheruser;
  late StorgeService _storgeService;

  @override
  void initState() {
    super.initState();
    _storgeService = _getIt.get<StorgeService>();
    _mediaService = _getIt.get<MediaService>();
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
          inputOptions: InputOptions(
            trailing: [
              _mediaMessageButton(),
            ],
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
    if (chatmessage.medias?.isNotEmpty ?? false) {
      if (chatmessage.medias!.first.type == MediaType.image) {
        Message message = Message(
          senderID: currentUser!.id,
          content: chatmessage.medias!.first.url,
          messageType: MessageType.Image,
          sentAt: Timestamp.fromDate(chatmessage.createdAt),
        );
        await _databaseService.sendChatMessage(
          currentUser!.id,
          otheruser!.id,
          message,
        );
      }
    } else {
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
  }

  List<ChatMessage> _generatechatMessageList(
    List<Message> message,
  ) {
    List<ChatMessage> chatmessage = message.map((m) {
      if (m.messageType == MessageType.Image) {
        return ChatMessage(
          medias: [
            ChatMedia(
              url: m.content!,
              fileName: "",
              type: MediaType.image,
            ),
          ],
          user: m.senderID == currentUser!.id ? currentUser! : otheruser!,
          createdAt: m.sentAt!.toDate(),
        );
      } else {
        return ChatMessage(
          text: m.content!,
          user: m.senderID == currentUser!.id ? currentUser! : otheruser!,
          createdAt: m.sentAt!.toDate(),
        );
      }
    }).toList();
    chatmessage.sort((a, b) {
      return b.createdAt.compareTo(a.createdAt);
    });
    return chatmessage;
  }

  Widget _mediaMessageButton() {
    return IconButton(
      onPressed: () async {
        File? file = await _mediaService.getimagefromGallery();
        if (file != null) {
          String chatID = generateChatID(
            uid1: _authService.user!.uid,
            uid2: widget.user.uid!,
          );
          String? downloadURL = await _storgeService.uploadImageToChat(
            file: file,
            chatID: chatID,
          );
          if (downloadURL != null) {
            ChatMessage chatMessage = ChatMessage(
              user: currentUser!,
              createdAt: DateTime.now(),
              medias: [
                ChatMedia(
                  url: downloadURL,
                  fileName: '',
                  type: MediaType.image,
                ),
              ],
            );
            _sentmessage(chatMessage);
          }
        }
      },
      icon: Icon(Icons.image),
      color: Theme.of(context).colorScheme.primary,
    );
  }
}
