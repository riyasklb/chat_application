import 'package:chat_application/firebase_options.dart';
import 'package:chat_application/service/alert_service.dart';
import 'package:chat_application/service/auth_service.dart';
import 'package:chat_application/service/database_service.dart';
import 'package:chat_application/service/media_service%20.dart';
import 'package:chat_application/service/navigation_service.dart';
import 'package:chat_application/service/storge_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';

Future<void> setupfirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

Future<void> registerservice() async {
  final GetIt getIt = GetIt.instance;
  getIt.registerSingleton<AuthService>(
    AuthService(),
  );

  getIt.registerSingleton<NavigationService>(
    NavigationService(),
  );

  getIt.registerSingleton<AlertService>(
    AlertService(),
  );
  getIt.registerSingleton<MediaService>(
    MediaService(),
  );

  getIt.registerSingleton<StorgeService>(
    StorgeService(),
  );
  getIt.registerSingleton<DatabaseService>(
    DatabaseService(),
  );
}

String generateChatID({required String uid1, required String uid2}) {
  List uids = [uid1, uid2];
  uids.sort();
  String chatID = uids.fold("", (id, uid) => "$id$uid");
  return chatID;
}
