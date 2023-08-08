import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagramclone/product/services/auth_service.dart';

class DiscoverView extends StatelessWidget {
  const DiscoverView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
body: 
               StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Posts')
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
                          return Container(
                            child: Image.network(
                              product['postImage'],
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      );
                    },
                  ),
    );
  }
}