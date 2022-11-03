import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_clone/resources/auth_methods.dart';
import 'package:insta_clone/screens/login_screen.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/utils/utils.dart';
import 'package:insta_clone/widgets/text_field_input.dart';
import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/web_screen_layout.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool _loading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  void signUpUser() async {
    setState(() {
      _loading = true;
    });
    String res = await AuthMethods().signUpUser(
      email: _emailController.text.toString(),
      password: _passwordController.text.toString(),
      username: _usernameController.text.toString(),
      bio: _bioController.text.toString(),
      file: _image!
    );

    setState(() {
      _loading = false;
    });
    //TODO
    if(res == "success"){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ResponsiveLayout(webScreenLayout: WebScreenLayout(), mobileScreenLayout: MobileScreenLayout())));
    }else{
      showSnackBar(res, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(flex: 2,child: Container(),),

              //svg image
              SvgPicture.asset('assets/ic_instagram.svg',color: primaryColor, height: 64,),
              const SizedBox(height: 52,),

              //upload profile pic
              Stack(
                children: [
                  _image!=null?
                  CircleAvatar(
                    radius: 64,
                    backgroundImage: MemoryImage(_image!),
                  ):
                  const CircleAvatar(
                    radius: 64,
                    backgroundImage: NetworkImage("https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png"),
                  ),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                      onPressed: selectImage,
                      icon: Icon(Icons.add_a_photo),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 24,),

              //text field for username
              TextFieldInput(textEditingController: _usernameController, hintText: "Enter username", textInputType: TextInputType.text),
              const SizedBox(height: 24,),

              //text field for email
              TextFieldInput(textEditingController: _emailController, hintText: "Enter email", textInputType: TextInputType.emailAddress),
              const SizedBox(height: 24,),

              //text field for password
              TextFieldInput(textEditingController: _passwordController, hintText: "Enter password", textInputType: TextInputType.text, isPass: true,),
              const SizedBox(height: 24,),

              //text field for bio
              TextFieldInput(textEditingController: _bioController, hintText: "Enter your bio", textInputType: TextInputType.text),
              const SizedBox(height: 24,),

              //login button
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
                      color: blueColor,
                    ),
                  child: _loading? const CircularProgressIndicator(
                    color: primaryColor,
                  ) : const Text(
                    "Sign up",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24,),
              Flexible(flex: 2,child: Container(),),

              //to signup
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text(
                        "Already have an account?"
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        " Login",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 64,),
            ],
          ),
        ),
      ),
    );
  }
}
