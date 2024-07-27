import 'package:chat_application/models/chat.dart';
import 'package:chat_application/models/message.dart';
import 'package:chat_application/models/user_model.dart';
import 'package:chat_application/service/auth_service.dart';
import 'package:chat_application/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

class DatabaseService {
  final GetIt _getIt = GetIt.instance;
  CollectionReference? _usersCollection;
  CollectionReference? _userschatcollection;
  late AuthService _authService;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  DatabaseService() {
    _authService = _getIt.get<AuthService>();
    _setupCollectionPreferences();
  }

  void _setupCollectionPreferences() {
    _usersCollection =
        _firebaseFirestore.collection('users').withConverter<UserProfile>(
              fromFirestore: (snapshot, _) =>
                  UserProfile.fromJson(snapshot.data()!),
              toFirestore: (UserProfile, _) => UserProfile.toJson(),
            );

    _userschatcollection = _firebaseFirestore
        .collection('chats')
        .withConverter<Chat>(
            fromFirestore: (snapshot, _) => Chat.fromJson(snapshot.data()!),
            toFirestore: (chat, _) => chat.toJson());
  }

  Future<void> createUserProfile({required UserProfile userprofile}) async {
    await _usersCollection?.doc(userprofile.uid).set(userprofile);
  }

  Stream<QuerySnapshot<UserProfile>> getUserProfile() {
    return _usersCollection
        ?.where("uid", isNotEqualTo: _authService.user!.uid)
        .snapshots() as Stream<QuerySnapshot<UserProfile>>;
  }

  Future<bool> checkchatExist(String uid1, String uid2) async {
    String chatID = generateChatID(uid1: uid1, uid2: uid2);
    final result = await _userschatcollection?.doc(chatID).get();
    if (result != null) {
      return result.exists;
    }
    return false;
  }

  Future createNewChat(String uid1, String uid2) async {
    String chatID = generateChatID(uid1: uid1, uid2: uid2);
    final docref = _userschatcollection!.doc(chatID);
    final chat = Chat(
      id: chatID,
      participants: [uid1, uid2],
      messages: [],
    );
    await docref.set(chat);
  }

  Future<void> sendChatMessage(
      String uid1, String uid2, Message message) async {
    String chatID = generateChatID(uid1: uid1, uid2: uid2);
    final docref = _userschatcollection!.doc(chatID);
    await docref.update(
      {
        "messages": FieldValue.arrayUnion(
          [
            message.toJson(),
          ],
        ),
      },
    );
  }
  Stream <DocumentSnapshot<Chat>>getChatData(String uid1,String uid2){
    String chatID = generateChatID(uid1: uid1, uid2: uid2);
    return   _userschatcollection?.doc(chatID).snapshots() as Stream<DocumentSnapshot<Chat>>;
  }
}
