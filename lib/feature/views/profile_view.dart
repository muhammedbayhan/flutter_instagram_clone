import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagramclone/feature/view_model/profile_view_model.dart';
import 'package:instagramclone/product/constants/padding_constants.dart';
import 'package:instagramclone/product/services/auth_service.dart';
import 'package:instagramclone/product/services/firebase_service.dart';
import 'package:instagramclone/product/widget/w_textformfield.dart';

import '../../product/constants/color_constants.dart';
import '../auth/login_view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  TextEditingController _hobbyController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  ProfileViewModel _profileViewModel = Get.put(ProfileViewModel());

  @override
  Widget build(BuildContext context) {
    var deviceWidth = MediaQuery.of(context).size.width;
    var deviceheight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              floating: true,
              title: Text(
                AuthService().firebaseAuth.currentUser!.email.toString(),
                style: TextStyle(color: Colors.black),
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(FontAwesomeIcons.heart),
                  color: ColorConstants.appbarIcon,
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(FontAwesomeIcons.comment),
                  color: ColorConstants.appbarIcon,
                ),
                IconButton(
                  onPressed: () {
                    AuthService().signOut();
                    Get.to(() => LoginView());
                  },
                  icon: const Icon(FontAwesomeIcons.rightFromBracket),
                  color: ColorConstants.appbarIcon,
                ),
              ],
            ),
          ];
        },
        body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc(AuthService().firebaseAuth.currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return Text('Document not found');
            }

            var userData = snapshot.data!.data() as Map<String, dynamic>;
            var name = userData['name'];
            var description = userData['description'];
            var hobby = userData['hobby'];
            var followers = userData['followers'];
            var following = userData['following'];
            var avatarPath = userData['avatarPath'];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        GestureDetector(
                          child: CircleAvatar(
                            backgroundColor: Colors.white38,
                            radius: deviceheight * 0.05,
                            backgroundImage: NetworkImage(
                              avatarPath ??
                                  "https://cdn4.iconfinder.com/data/icons/gray-user-management/512/edit-512.png",
                            ),
                          ),
                          onTap: () {
                            _profileViewModel.addStorage();
                          },
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('Posts')
                                .where("userUid",
                                    isEqualTo: AuthService()
                                        .firebaseAuth
                                        .currentUser
                                        ?.uid)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return CircularProgressIndicator();
                              }
                              return Text(snapshot.data!.docs.length.toString(),
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold));
                            }),
                        Text("Posts")
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "${followers ?? 0}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text("Followers")
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "${following ?? 0}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text("Following")
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            name,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            hobby ?? "",
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(description ?? ""),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(255, 209, 208, 208),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40))),
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return Padding(
                                      padding: PaddingConstants.pagePadding,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Text(
                                            "Biography",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall,
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          W_TextFormField(
                                              controller: _hobbyController,
                                              hintText: "biography",
                                              obscureText: false),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          W_TextFormField(
                                              controller:
                                                  _descriptionController,
                                              hintText: "Description",
                                              obscureText: false),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                          255, 209, 208, 208),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              40))),
                                              onPressed: () {
                                                FirebaseService()
                                                    .updateBiography(
                                                        _descriptionController
                                                            .text,
                                                        _hobbyController.text);
                                              },
                                              child: Text("Save")),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Text("Edit ")),
                        ]),
                  ),
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Posts')
                        .where('userUid',
                            isEqualTo:
                                AuthService().firebaseAuth.currentUser?.uid)
                        .orderBy("creationDate", descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      // Firestore'dan gelen verileri kullanın
                      List<DocumentSnapshot> products = snapshot.data!.docs;

                      // Listelenen ürünleri listelemek için ListView.builder kullanabilirsiniz
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 1,
                            mainAxisSpacing: 1),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          var product = products[index];
                          //product['urunAd']
                          return GestureDetector(
                            child: Container(
                              child: Image.network(
                                product['postImage'],
                                fit: BoxFit.cover,
                              ),
                            ),
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) => Container(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: deviceWidth * 0.5,
                                      child: Image.network(
                                        product['postImage'],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        FirebaseService()
                                            .deletePost(product['postImage']);

                                        final snackBar = SnackBar(
                                          /// need to set following properties for best effect of awesome_snackbar_content
                                          elevation: 0,
                                          behavior: SnackBarBehavior.floating,
                                          backgroundColor: Colors.transparent,
                                          content: AwesomeSnackbarContent(
                                            title: 'Succes!',
                                            message: "Post Deleted.",

                                            /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                            contentType: ContentType.failure,
                                          ),
                                        );

                                        ScaffoldMessenger.of(context)
                                          ..hideCurrentSnackBar()
                                          ..showSnackBar(snackBar);
                                        Navigator.pop(context);
                                      },
                                      child: Icon(FontAwesomeIcons.trash),
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red),
                                    )
                                  ],
                                )),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
