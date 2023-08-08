import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagramclone/feature/auth/login_view.dart';
import 'package:instagramclone/feature/base/base.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userLogin();
  }

  Future<void> userLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
   // <-- Import statement
Timer(Duration(milliseconds:500 ), () { // <-- Delay here
 bool userStatus = prefs.containsKey('uid');

      if (userStatus) {
        //kullanıcı giriş yapmış ise BaseViewe yönlendirir
        print("Giriş Yapmış (+)");
        Get.to(() => BaseView());
      } else {
        //kullanıcı giriş yapmamış ise loginViewe yönlendirir
        print("Giriş Yapmamış (-)");
        Get.to(() => LoginView());
      }
});
     
   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.25,
            child: Image.asset("assets/images/logo.png")),
      ),
    );
  }
}
