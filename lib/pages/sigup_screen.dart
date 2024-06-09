import 'dart:typed_data';

import 'package:firebaseinstagram/responsive/mobile_screen_layout.dart';
import 'package:firebaseinstagram/responsive/responsive_layout_screen.dart';
import 'package:firebaseinstagram/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:firebaseinstagram/utils/colors.dart';
import 'package:firebaseinstagram/widgets/text_field_input.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/auth_methods.dart';
import '../responsive/web_screen_layout.dart';
import '../utils/global_variable.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }
  selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      _image = im;
    });
  }
  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().signupUser(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        bio: _bioController.text,
        file: _image!
    );
    setState(() {
      _isLoading = false;
    });
    if(res != "success"){
      showSankBar(res, context);
    }else{
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>
        const ResponsiveLayout(
              webScreenLayout: WebScreenLayout(),
              mobileScreenLayout: MobileScreenLayout(),
        )
      ));
    }

  }
  void navigateToLogin(){
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginScreen()));
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
              // Cicular widget to accept and show our selected file
              Stack(
                children: [
                  _image!= null
                      ?
                      CircleAvatar(
                      radius: 64,
                        backgroundImage: MemoryImage(_image!),
                      )
                      : const CircleAvatar(
                      radius: 64,
                      backgroundImage: NetworkImage('https://scontent.fhan5-11.fna.fbcdn.net/v/t39.30808-6/417853424_1038638563887112_1613224520327400362_n.jpg?_nc_cat=1&ccb=1-7&_nc_sid=c42490&_nc_eui2=AeHNWiATkNFs2zXp6uwpiv5Doy_8NhsQQkGjL_w2GxBCQQ2QaPy527t-dydopdRWuI7YzVSlAxuLWUERSodfvdJO&_nc_ohc=enoyGixxI7oAX-sf_5-&_nc_ht=scontent.fhan5-11.fna&oh=00_AfAvIoZTl_aEmsPnF0CtVmAvvXRwKMAm2swSeacTOb9FtA&oe=65A44009'),
                  ),
                  Positioned(
                      bottom: -10,
                      left: 80,
                      child: IconButton(
                        onPressed: selectImage,
                        icon: const Icon(
                            Icons.add_a_photo
                        ),
                      )
                  )
                ],
              ),
              const SizedBox(height: 24,),

              // Text field input for username
              TextFieldInput(
                  textEditingController: _usernameController,
                  hintText: "Enter your username",
                  textInputType: TextInputType.text
              ),
              const SizedBox(height: 24,),
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
              // Text field input bio
              TextFieldInput(
                  textEditingController: _bioController,
                  hintText: "Enter your bio",
                  textInputType: TextInputType.text,
                  
              ),
              const SizedBox(height: 24,),
              // Button Login
              InkWell(
                onTap: signUpUser,
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
                  child:_isLoading ? const Center(child: CircularProgressIndicator(color: primaryColor,),) : const Text("Signup"),
                ),
              ),
              const SizedBox(height: 24,),
              Flexible(child:  Container(), flex: 2,),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text("Have an account"),
                  ),
                  GestureDetector(
                    onTap: navigateToLogin,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text("Login",
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

