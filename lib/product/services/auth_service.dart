import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagramclone/feature/base/base.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final userCollection = FirebaseFirestore.instance.collection("Users");
  final firebaseAuth=FirebaseAuth.instance;

Future<void> signUp(
      {required BuildContext context,required String name,
      required String email,
      required String password})async{
try {
  final UserCredential userCredential= await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
if (userCredential.user!=null) {
  _registerUser(name: name, email: email, password: password);
  SharedPreferences prefs = await SharedPreferences.getInstance();
prefs.setString('uid', userCredential.user!.uid);
  print("Kayıt Başarılı");
  Get.to(() => BaseView());
}
} on FirebaseAuthException catch(e) {
 final snackBar = SnackBar(
                  /// need to set following properties for best effect of awesome_snackbar_content
                  elevation: 0,
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.transparent,
                  content: AwesomeSnackbarContent(
                    title: 'Failure!',
                    message:e.toString(),
                       

                    /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                    contentType: ContentType.failure,
                  ),
                );

                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(snackBar);
}
}


Future<void>signIn({ required BuildContext context,required String email,
      required String password})async{
 try {
    final UserCredential userCredential=await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  if (userCredential.user!=null) {
SharedPreferences prefs = await SharedPreferences.getInstance();
prefs.setString('uid', userCredential.user!.uid);
      print("Giriş Başarılı");
     Get.to(() => BaseView());
    
  }
 }  on FirebaseAuthException catch (e) {
      final snackBar = SnackBar(
                  /// need to set following properties for best effect of awesome_snackbar_content
                  elevation: 0,
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.transparent,
                  content: AwesomeSnackbarContent(
                    title: 'Failure!',
                    message:e.toString(),
                       

                    /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                    contentType: ContentType.failure,
                  ),
                );

                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(snackBar);
 
 }
}


Future<void> signOut()async{

  firebaseAuth.signOut();
  SharedPreferences prefs = await SharedPreferences.getInstance();
prefs.remove('uid');
}
  //Kullanıcı girişi başarılı ise bu fonksiyon çalışır ve veriler firebase'ye kaydedilir.
  Future<void> _registerUser(
      {
      required String email,
      required String name,
      required String password}) async {
    await userCollection
        .doc(firebaseAuth.currentUser!.uid)
        .set({"email": email, "name": name, "password": password});
  }



  
}
