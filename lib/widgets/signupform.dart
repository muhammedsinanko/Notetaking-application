import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants.dart';
import '../../services/auth.dart';

TextEditingController _fullNameController = TextEditingController();
TextEditingController _passwordController = TextEditingController();
TextEditingController _emailController = TextEditingController();
final _formKey = GlobalKey<FormState>();

String firebaseException = '';

class SignUpForm extends StatefulWidget {
  final double screenWidth;
  const SignUpForm({super.key, required this.screenWidth});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
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
                    if (value == null || value.isEmpty) {
                      return "Please enter your full name here";
                    } else {
                      return null;
                    }
                  },
                  controller: _fullNameController,
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
                    hintText: "Full name",
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
            createUserWithEmailAndPassword();
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
              'Create account',
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

  Future<void> createUserWithEmailAndPassword() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    debugPrint('emal========$email');
    if (_formKey.currentState!.validate()) {
      try {
        await Auth()
            .createUserWithEmailAndPassword(email: email, password: password);
        debugPrint('sign up success');
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
