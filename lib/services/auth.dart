import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

//creating a user with email and password got from textfield
  Future<void> createUserWithEmailAndPassword(
      {required String email, required String password}) async {
    await firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

//autheticating email and password got from textfield
  Future<void> signInUserWithEmailAndPassword(
      {required String email, required String password}) async {
    await firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

//signingout user
  Future<void> signOutUser() async {
    await firebaseAuth.signOut();
  }

//current userchanges for streambuilder
  Stream<User?> get currentUser => firebaseAuth.authStateChanges();
}
