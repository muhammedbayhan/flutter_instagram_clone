
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../product/services/auth_service.dart';

class AddPostViewModel extends GetxController {
    Rx imageUrl = "".obs;

  addStorage() async {
 try {
    var alinanDosya=await ImagePicker().pickImage(source: ImageSource.gallery);
    var postResimAdi=DateTime.now().millisecondsSinceEpoch;
    Reference referenceRoot = FirebaseStorage.instance.ref();

    Reference referenceDirImages = referenceRoot
        .child(AuthService().firebaseAuth.currentUser!.uid).child("PostImage")
        .child(postResimAdi.toString());

    await referenceDirImages.putFile(File(alinanDosya!.path));
    
    
      imageUrl.value = await referenceDirImages.getDownloadURL();
    print("---------------${imageUrl.value}");
 } catch (e) {
   print(e);
 }
    
  }
clearUrl(){
  imageUrl.value="";
}




}