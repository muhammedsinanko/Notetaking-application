import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';
import '../widgets/signupform.dart';
import 'loginpage.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: screenHeight,
        width: screenWidth,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              primaryColor,
              backroundColor.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            tileMode: TileMode.clamp,
            stops: const [
              0.0,
              0.99,
            ],
          ),
        ),
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(
                top: screenHeight - 253,
              ),
              width: screenWidth,
              child: Image.asset(
                'asset/signup login image.png',
                fit: BoxFit.contain,
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: screenHeight / 5,
                  ),
                  Text(
                    'Welcome!!!',
                    style: GoogleFonts.quicksand(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'Please login with your details!!!',
                    style: GoogleFonts.quicksand(
                        fontSize: 14,
                        color: const Color(0xff8b8b8b),
                        fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(
                    height: 35,
                  ),

                  //signup form

                  SizedBox(
                    height: screenHeight / 1.5,
                    width: screenWidth,
                    child: Column(
                      children: [
                        //SignUp form with create button
                        SignUpForm(screenWidth: screenWidth),
                        const SizedBox(
                          height: 22,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Do you have an account?',
                              style: GoogleFonts.quicksand(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => const LoginPage()),
                                );
                              },
                              child: Text(
                                'Log in',
                                style: GoogleFonts.quicksand(
                                    fontSize: 14,
                                    color: primaryColor,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
