import 'dart:async';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:instagramclone/feature/base/base.dart';
import 'package:instagramclone/feature/views/home_view.dart';
import 'package:instagramclone/product/constants/padding_constants.dart';
import 'package:instagramclone/product/services/auth_service.dart';
import 'package:instagramclone/product/services/firebase_service.dart';
import 'package:instagramclone/product/widget/w_textformfield.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../view_model/addPost_view_model.dart';
import '../view_model/profile_view_model.dart';

class AddPostView extends StatefulWidget {
  const AddPostView({super.key});

  @override
  State<AddPostView> createState() => _AddPostViewState();
}

class _AddPostViewState extends State<AddPostView> {
  AddPostViewModel _addPostView = Get.put(AddPostViewModel());
  TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
 
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ADD POST",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addPostView.addStorage();
        },
        child: Icon(FontAwesomeIcons.fileCirclePlus),
      ),
      body: Padding(
        padding: PaddingConstants.pagePadding,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Obx(
                () => Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Image.network(
                    _addPostView.imageUrl.value ??
                        "https://firebasestorage.googleapis.com/v0/b/instagramclone-c7084.appspot.com/o/System%2Fuploadimage.png?alt=media&token=79b076c8-db20-4efb-80f3-21efefdd16b5",
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.photo_album,
                      size: 150,
                    ),
                  ),
                ),
              ),
              W_TextFormField(
                  controller: _descriptionController,
                  hintText: "description",
                  obscureText: false),
              ElevatedButton(
                  onPressed: () {
                    print("girdi");
                    Timer(Duration(milliseconds: 1500), () {
                      FirebaseService().addPost(_descriptionController.text,
                          _addPostView.imageUrl.value);

                      final snackBar = SnackBar(
                        /// need to set following properties for best effect of awesome_snackbar_content
                        elevation: 0,
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.transparent,
                        content: AwesomeSnackbarContent(
                          title: 'Succes!',
                          message: "Post Added.",

                          /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                          contentType: ContentType.success,
                        ),
                      );

                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(snackBar);

                      print("cikti");

                      PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: HomeView(),
                        withNavBar: true, // OPTIONAL VALUE. True by default.
                        pageTransitionAnimation:
                            PageTransitionAnimation.cupertino,
                      );
                      _addPostView.clearUrl();
                      _descriptionController.clear();
                    });
                  },
                  child: Text("Share")),
            ]),
      ),
    );
  }
}
