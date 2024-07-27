import 'package:chat_application/service/alert_service.dart';
import 'package:chat_application/service/auth_service.dart';
import 'package:chat_application/service/database_service.dart';
import 'package:chat_application/service/navigation_service.dart';
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
                    text: 'User registerd successfuly', icon: Icons.check);
              }
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
  body: _buidUI(),   );
  }
  Widget _buidUI() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 20,
        ),
        child: Column(
      
          children: [
          _profilelist(),
          ],
        ),
      ),
    );
  }
Widget _profilelist(){
  return Column(children: [Text('')],);
}
}
