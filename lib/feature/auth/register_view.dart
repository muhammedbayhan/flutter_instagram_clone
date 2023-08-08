import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagramclone/feature/auth/login_view.dart';
import 'package:instagramclone/product/constants/padding_constants.dart';
import 'package:instagramclone/product/services/auth_service.dart';
import 'package:instagramclone/product/widget/w_textformfield.dart';

class RegisterView extends StatelessWidget {
  RegisterView({super.key});
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: Padding(
        padding: PaddingConstants.pagePadding,
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          SizedBox(
              width: deviceWidth * 0.5,
              child: Image.asset("assets/images/textLogo.png")),
          Text(
            "Sign up to see photos and videos from your friends.",
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          W_TextFormField(
              controller: _emailController,
              hintText: "Email",
              obscureText: false),
          W_TextFormField(
              controller: _nameController,
              hintText: "Name",
              obscureText: false),
          W_TextFormField(
            keyboard: TextInputType.visiblePassword,
              controller: _passwordController,
              hintText: "Password",
              obscureText: true),
          SizedBox(
              width: deviceWidth,
              child: ElevatedButton(
                  onPressed: () {
                    AuthService().signUp(
                      context: context,
                        email: _emailController.text,
                        name: _nameController.text,
                        password: _passwordController.text);
                  },
                  child: Text("Sign Up"))),
          TextButton(
              onPressed: () {},
              child: Text(
                "By signing up, you agree to our  Terms, Data Policy and Cookies Policy.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black),
              )),
          Divider(
            thickness: 2,
          ),
          Text("OR"),
          TextButton(onPressed: () {Get.to(() => LoginView());}, child: Text("Have an account?")),
        ]),
      ),
    );
  }
}
