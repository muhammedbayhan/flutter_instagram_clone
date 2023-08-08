
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagramclone/product/services/firebase_service.dart';
import 'dart:io';
import '../../product/services/auth_service.dart';

class ProfileViewModel extends GetxController {
    Rx imageUrl = "".obs;

  addStorage() async {
try {
    var alinanDosya=await ImagePicker().pickImage(source: ImageSource.gallery);
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot
        .child(AuthService().firebaseAuth.currentUser!.uid)
        .child("avatar.png");

    await referenceDirImages.putFile(File(alinanDosya!.path));
    
    
      imageUrl.value = await referenceDirImages.getDownloadURL();
    FirebaseService().updateAvatar(imageUrl.value);
} catch (e) {
 print(e); 
}
  }


}