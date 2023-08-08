import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagramclone/feature/auth/register_view.dart';
import 'package:instagramclone/product/constants/padding_constants.dart';
import 'package:instagramclone/product/services/auth_service.dart';
import 'package:instagramclone/product/widget/w_textformfield.dart';

class LoginView extends StatelessWidget {
   LoginView({super.key});
final TextEditingController _emailController=TextEditingController();
final TextEditingController _passwordController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    var deviceWidth=MediaQuery.of(context).size.width;
    return  Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: Padding(
        padding: PaddingConstants.pagePadding,
        child: Column(
       mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
          SizedBox(width: deviceWidth*0.5,child: Image.asset("assets/images/textLogo.png")),
          W_TextFormField(controller: _emailController,hintText: "Email",obscureText: false),
          W_TextFormField(keyboard: TextInputType.visiblePassword,controller: _passwordController,hintText: "Password",obscureText: true),
         
          SizedBox(width: deviceWidth,child: ElevatedButton(onPressed: (){AuthService().signIn(context: context,email: _emailController.text, password: _passwordController.text);}, child: Text("Login"))),
          TextButton(onPressed: (){}, child: Text("Forgot your login details? Get help logging in.",style: TextStyle(color: Colors.black),)),
          Divider(thickness: 2,),Text( "OR"),
          TextButton(onPressed: (){ 
        }, child: Text("Log in with Google")),
          TextButton(onPressed: (){Get.to(() => RegisterView());}, child: Text("Dont have an account? Sign up.")),

        ]),
      ),
    );
  }
}
