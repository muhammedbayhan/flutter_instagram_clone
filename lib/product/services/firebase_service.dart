import 'package:cloud_firestore/cloud_firestore.dart';

import 'auth_service.dart';


class FirebaseService {
  Future<void> updateBiography(
    String description,
    String hobby,
  ) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(AuthService().firebaseAuth.currentUser!.uid)
        .update({
      "description": description,
      "hobby": hobby,
    });
  }

  Future<void> updateAvatar(
    String avatarPath,
  ) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(AuthService().firebaseAuth.currentUser!.uid)
        .update({"avatarPath": avatarPath});
  }

  Future<void> addPost(
      String postDescription, String postImage) async {
        DateTime dateTime=DateTime.now();
    await FirebaseFirestore.instance
        .collection('Posts')
        .doc()
        .set({
      "userUid": AuthService().firebaseAuth.currentUser?.uid,
      "postDescription": postDescription,
      "postImage": postImage,
      "postLikes":0,
      "creationDate":dateTime
    });
  }

Future<void>deletePost(String postImage)async{
  var collection = FirebaseFirestore.instance.collection('Posts');
var snapshot = await collection.where('postImage', isEqualTo: postImage).get();
for (var doc in snapshot.docs) {
 await doc.reference.delete();
}
        
}

}
