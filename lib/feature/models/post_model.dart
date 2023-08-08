class PostModel {
String userUid;//uid
  String postImage;//postImage
  int postLikes;//postLike
  String postDescription;//postDescription
  DateTime postCreationDate;//postDescription

  PostModel(
      {required this.userUid,     
      required this.postImage,
      required this.postLikes,
      required this.postDescription,
      required this.postCreationDate
      });
}
