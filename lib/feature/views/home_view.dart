import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instagramclone/feature/models/post_model.dart';
import 'package:instagramclone/product/widget/w_textformfield.dart';
import 'package:intl/intl.dart';

import '../../product/constants/color_constants.dart';
import '../../product/services/auth_service.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
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
                title: Image.asset(
                  "assets/images/textLogo.png",
                  width: deviceWidth * 0.3,
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
                ],
              ),
            ];
          },
          body: Column(
            children: [
              Expanded(
                  flex: 5,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Posts').orderBy("creationDate",descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Veriler alınamıyor: ${snapshot.error}');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      List<PostModel> postList = snapshot.data!.docs
                          .map((doc) => PostModel(
                                userUid: doc['userUid'],
                                postImage: doc['postImage'],
                                postLikes: doc['postLikes'] ?? 0,
                                postDescription: doc['postDescription'],
                                postCreationDate: DateTime.parse(
                                    doc['creationDate'].toDate().toString()),
                              ))
                          .toList();

                      return ListView.builder(
                        itemCount: postList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 30),
                            child: PostWidget(
                              deviceWidth: deviceWidth,
                              deviceheight: deviceheight,
                              userName: postList[index].userUid,
                              avatarPath: postList[index].userUid,
                              imagePath: postList[index].postImage,
                              totalLikes: postList[index].postLikes,
                              description: postList[index].postDescription,
                              creationDate:
                                  postList[index].postCreationDate,
                            ),
                          );
                        },
                      );
                    },
                  )),
            ],
          )),
    );
  }
}

class PostWidget extends StatelessWidget {
  PostWidget(
      {super.key,
      required this.deviceheight,
      required this.deviceWidth,
      required this.avatarPath,
      required this.userName,
      required this.imagePath,
      required this.creationDate,
      required this.totalLikes,
      required this.description});
  final double deviceheight;
  final double deviceWidth;
  TextEditingController x = TextEditingController();
  String avatarPath;
  String userName;
  String imagePath;
  DateTime creationDate;
  int totalLikes;
  String description;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .doc(userName)
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
        var avatarPath = userData['avatarPath'];
        return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                        backgroundImage: NetworkImage(avatarPath ??
                            "https://cdn4.iconfinder.com/data/icons/gray-user-management/512/edit-512.png")),
                    Text(
                      " $name",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: deviceWidth,
                width: deviceWidth,
                child: Image.network(
                  imagePath,
                  errorBuilder: (context, error, stackTrace) => Placeholder(),
                  fit: BoxFit.cover,
                ),
              ),
              Row(
                children: [
                  IconButton(
                      onPressed: () {}, icon: Icon(FontAwesomeIcons.heart)),
                  IconButton(
                      onPressed: () {}, icon: Icon(FontAwesomeIcons.comment)),
                  IconButton(
                      onPressed: () {}, icon: Icon(FontAwesomeIcons.paperPlane))
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  "$totalLikes Likes",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                            style: TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                text: name,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: " $description",
                              ),
                          
                            ]),
                      ),
                         Text("Creation Date ->${DateFormat("dd.MM.yyyy h:m:s").format(creationDate)}",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey,fontSize: 12)),
                    ],
                  )),
               
              
              TextButton(
                  onPressed: () {
                    showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20))),
                      context: context,
                      builder: (context) => Container(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("no comments foundv2"),
                          W_TextFormField(
                              controller: x,
                              hintText: "Comment...",
                              obscureText: false)
                        ],
                      )),
                    );
                  },
                  child: Text(
                    "view comments",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ))
            ],
          ),
        );
      },
    );
  }
}


//  Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "$name ",
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     Flexible(
//                         child: Text(
//                       description,
//                       maxLines: 3,
//                       overflow: TextOverflow.ellipsis,
//                     ))
//                   ],
//                 ),