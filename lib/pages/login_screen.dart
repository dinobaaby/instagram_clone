
import 'package:firebaseinstagram/pages/sigup_screen.dart';
import 'package:firebaseinstagram/utils/colors.dart';
import 'package:firebaseinstagram/utils/global_variable.dart';
import 'package:firebaseinstagram/utils/utils.dart';
import 'package:firebaseinstagram/widgets/text_field_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../controllers/auth_methods.dart';
import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/web_screen_layout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async{
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(email: _emailController.text, password: _passwordController.text);
    if(res == "success"){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>
          const ResponsiveLayout(
            webScreenLayout: WebScreenLayout(),
            mobileScreenLayout: MobileScreenLayout(),
          )
      ));
    }else{
      showSankBar(res, context);
    }
    setState(() {
      _isLoading = false;
    });
  }
  void navigateToSingup(){
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const SignupScreen()));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: MediaQuery.of(context).size.width > webScreenSize
              ?  EdgeInsets.symmetric(horizontal:  MediaQuery.of(context).size.width /3 )
              :  const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(child: Container(), flex: 2,),
              // svg image
              SvgPicture.asset("assets/logos/ic_instagram.svg", color: primaryColor, height: 64,),
              const SizedBox(height: 64,),
              // Text field input email
              TextFieldInput(
                  textEditingController: _emailController,
                  hintText: "Enter your email",
                  textInputType: TextInputType.emailAddress
              ),
              const SizedBox(height: 24,),
              // Text field input password
              TextFieldInput(
                  textEditingController: _passwordController,
                  hintText: "Enter your password",
                  textInputType: TextInputType.text,
                  isPass: true
              ),
              const SizedBox(height: 24,),
              // Button Login
              InkWell(
                onTap: loginUser,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                    color: blueColor
                  ),
                  child: _isLoading ? const Center(child: CircularProgressIndicator(color: primaryColor,),) :  const Text("Login"),
                ),
              ),
              const SizedBox(height: 24,),
              Flexible(child:  Container(), flex: 2,),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text("Don's have an account"),
                  ),
                  GestureDetector(
                    onTap: navigateToSingup,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text("Sign up",
                        style: TextStyle(fontWeight: FontWeight.bold),

                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 14,),

              // Transitiontin to signing up


            ],
          ),
        ),
      ),
    );
  }
}

