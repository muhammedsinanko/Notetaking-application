// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants.dart';
import '../../services/auth.dart';
import '../screens/homepage.dart';

TextEditingController _emailController = TextEditingController();
TextEditingController _passwordController = TextEditingController();
final _formKey = GlobalKey<FormState>();

String firebaseException = '';

class LoginForm extends StatefulWidget {
  final double screenWidth;
  const LoginForm({super.key, required this.screenWidth});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(
                height: 12,
              ),
              const SizedBox(
                height: 12,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                alignment: Alignment.center,
                height: 45,
                width: widget.screenWidth,
                decoration: BoxDecoration(
                  color: noteContainerColor,
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [
                      noteContainerColor,
                      noteContainerColor.withOpacity(0.7)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: TextFormField(
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        !value.contains('@') ||
                        value.length < 6) {
                      return "Please enter your valid email";
                    } else {
                      return null;
                    }
                  },
                  controller: _emailController,
                  maxLines: 1,
                  style: GoogleFonts.quicksand(
                    textStyle: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                    ),
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    hintMaxLines: 1,
                    fillColor: Colors.white,
                    border: InputBorder.none,
                    hintText: "e-mail",
                    hintStyle: GoogleFonts.quicksand(
                      fontSize: 12,
                      color: const Color(0xff8B8B8B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Container(
                //
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                alignment: Alignment.center,
                height: 45,
                width: widget.screenWidth,
                decoration: BoxDecoration(
                  color: noteContainerColor,
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [
                      noteContainerColor,
                      noteContainerColor.withOpacity(0.7)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 6) {
                      return "Please enter your valid password here";
                    } else {
                      return null;
                    }
                  },
                  controller: _passwordController,
                  maxLines: 1,
                  style: GoogleFonts.quicksand(
                    textStyle: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                    ),
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    hintMaxLines: 1,
                    fillColor: Colors.white,
                    border: InputBorder.none,
                    hintText: "Password",
                    hintStyle: GoogleFonts.quicksand(
                      fontSize: 12,
                      color: const Color(0xff8B8B8B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        //create account button
        InkWell(
          onTap: () {
            //debugPrint('fullname: ${_fullNameController.text}');
            //debugPrint('email: ${_emailController.text}');
            //debugPrint('confirmpassword: ${_passwordController.text}');
            _formKey.currentState!.validate();
            signInUserWithEmailAndPassword();
          },
          child: Container(
            margin: const EdgeInsets.only(top: 32),
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            alignment: Alignment.center,
            height: 45,
            width: widget.screenWidth,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [primaryColor, primaryColor.withOpacity(0.75)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Text(
              'Log In',
              style: GoogleFonts.quicksand(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

//Authenticating Email and password and signing in
  Future<void> signInUserWithEmailAndPassword() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    debugPrint('emal========$email');
    if (_formKey.currentState!.validate()) {
      try {
        await Auth()
            .signInUserWithEmailAndPassword(email: email, password: password);
        debugPrint('sign up success');
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: ((context) => const HomePage())));
      } on FirebaseAuthException catch (e) {
        debugPrint('Something went wronf=$e');

//showing snackbar to user on firebase exception
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Something went wrong on $e')));
        //ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        //    content: Text(
        //        'Something went wrong on please check if your e mail is valid')));
      }
    } else {
      null;
    }
  }
}
