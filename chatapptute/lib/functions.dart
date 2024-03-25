import 'package:chatapptute/model/message.dart';
import 'package:chatapptute/services/auth/auth_service.dart';
import 'package:chatapptute/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Functions {
  final AuthService _authService = AuthService();
  final ChatService _chatService = ChatService();

  // Register user and add to database
  Future<void> registerUser(String email, String password) async {
    UserCredential userCredential =
        await _authService.signUpWithEmailandPassword(email, password);
    addUserToDatabase(userCredential.user!.uid, email);
  }

  // Add user to Firestore database
  Future<void> addUserToDatabase(String uid, String email) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'uid': uid,
      'email': email,
    });
  }

  // Sign in user
  Future<void> signInUser(String email, String password) async {
    await _authService.signInWithEmailandPassword(email, password);
  }

  // Sign out user
  Future<void> signOutUser() async {
    await _authService.signOut();
  }

  // Send a message in a chat room
  Future<void> sendMessage(String receiverId, String message) async {
    await _chatService.sendMessage(receiverId, message);
  }

  // Get messages stream for a chat room
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    return _chatService.getMessages(userId, otherUserId);
  }
}
