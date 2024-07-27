import 'package:chat_application/models/user_model.dart';
import 'package:chat_application/pages/chat_page.dart';
import 'package:chat_application/service/alert_service.dart';
import 'package:chat_application/service/auth_service.dart';
import 'package:chat_application/service/database_service.dart';
import 'package:chat_application/service/navigation_service.dart';
import 'package:chat_application/widget/chat_tile.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GetIt _getIt = GetIt.instance;
  late NavigationService _navigationService;
  late AuthService _authService;
  late DatabaseService _databaseService;
  late AlertService _alertService;

  @override
  void initState() {
    _authService = _getIt.get<AuthService>();
    _navigationService = _getIt.get<NavigationService>();
    _alertService = _getIt.get<AlertService>();
    _databaseService = _getIt.get<DatabaseService>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Message'),
        actions: [
          IconButton(
            onPressed: () async {
              bool result = await _authService.logout();
              if (result) {
                _navigationService.pushReplacementNamed("/login");
                _alertService.showToasr(
                    text: 'User logged out successfully', icon: Icons.check);
              }
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 20,
        ),
        child: _chatList(),
      ),
    );
  }

  Widget _chatList() {
    return StreamBuilder(
      stream: _databaseService.getUserProfile(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Unable to load data'),
          );
        } else if (snapshot.hasData && snapshot.data != null) {
          final data = snapshot.data!.docs;
          return ListView.builder(
            itemBuilder: (context, index) {
              UserProfile user = data[index].data();
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ChatTile(
                  userProfile: user,
                  ontap: () async {
                    final chatExist = await _databaseService.checkchatExist(
                        _authService.user!.uid, user.uid!);
                    if (!chatExist) {
                      await _databaseService.createNewChat(
                        _authService.user!.uid,
                        user.uid!,
                      );
                    }
                    _navigationService.push(
                      MaterialPageRoute(
                        builder: (context) {
                          return ChatPage(user: user);
                        },
                      ),
                    );
                  },
                ),
              );
            },
            itemCount: data.length,
          );
        } else {
          return Center(
            child: Text('No data available'),
          );
        }
      },
    );
  }
}
