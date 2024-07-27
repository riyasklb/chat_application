
import 'package:chat_application/pages/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  CollectionReference? _usersCollection;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  DatabaseService() {
    _setupCollectionPreferences();
  }

  void _setupCollectionPreferences() {
    _usersCollection = _firebaseFirestore.collection('users').withConverter<UserProfile>(
          fromFirestore: (snapshot, _) =>
              UserProfile.fromJson(snapshot.data()!),
          toFirestore: (UserProfile, _) => UserProfile.toJson(),
        );
  }

  Future <void>createUserProfile({required UserProfile userprofile})async{
    await _usersCollection?.doc(userprofile.uid).set(userprofile);
  }


  
}
