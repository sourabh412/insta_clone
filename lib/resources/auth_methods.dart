import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:insta_clone/resources/storage_methods.dart';
import 'package:insta_clone/models/user.dart' as model;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //get details only once
  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap = await _firestore.collection('users').doc(currentUser.uid).get();
    return model.User.fromSnap(snap);
  }

  //Signup
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "Some error occurred!";
    try{
      if(email.isNotEmpty && password.isNotEmpty && username.isNotEmpty && bio.isNotEmpty && file != null){
        //register
        UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
        _auth.signInWithEmailAndPassword(email: email, password: password);

        String photoUrl = await StorageMethods().uploadImageToStorage(childName: 'profilePics',file: file,isPost: false);
        
        //add user details to db
        model.User user = model.User(
          username: username,
          email: email,
          uid: cred.user!.uid,
          bio: bio,
          photoUrl: photoUrl,
          followers: [],
          following: [],
        );

        await _firestore.collection('users').doc(cred.user!.uid).set(user.toJson());
        res = "success";
      } else{
        res = "Please enter all the fields";
      }
    } catch(e) {
      res = e.toString();
    }
    return res;
  }

  //Login
  Future<String> loginUser({
    required String email,
    required String password
  }) async{
    String res = "Some error occurred";

    try{
      if(email.isNotEmpty && password.isNotEmpty){
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        res = "success";
      } else{
        res = "Please enter all the fields";
      }
    } catch(e){
      res = e.toString();
    }
    return res;
  }

  //Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

}