import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String email;
  final String photoUrl;
  final String username;
  final String bio;
  final List followers;
  final List following;

  User({
    required this.uid,
    required this.email,
    required this.photoUrl,
    required this.username,
    required this.bio,
    required this.followers,
    required this.following,
  });

  Map<String, dynamic> toJson() =>{
    'username': username,
    'uid': uid,
    'bio': bio,
    'email':email,
    'followers': followers,
    'following': following,
    'photoUrl': photoUrl,
  };

  static User fromSnap(DocumentSnapshot snap){
    var snapshot = (snap.data() as Map<String, dynamic>);
    return User(
      username: snapshot['username'],
      uid: snapshot['uid'],
      email: snapshot['email'],
      bio: snapshot['bio'],
      photoUrl: snapshot['photoUrl'],
      followers: snapshot['followers'],
      following: snapshot['following'],
    );
  }
}