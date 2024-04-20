// ignore_for_file: deprecated_member_use, must_be_immutable

import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iooi/screens/didthesepage.dart';
import 'package:iooi/screens/homepage.dart';
import 'package:iooi/screens/pinnednotes.dart';
import '../constants.dart';
import 'loginpage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //Uint8List? image;
  File? selectedImage;
  String? addedProfileImage;
  @override
  void didChangeDependencies() {
    getImageUrl();
    super.didChangeDependencies();
  }

  getImageUrl() async {
    QuerySnapshot<Map<String, dynamic>> collRef =
        await FirebaseFirestore.instance.collection("profile").get();
    if (mounted) {
      setState(() {
        addedProfileImage = collRef.docs.first["image"];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: backroundColor,
      appBar: AppBar(
        centerTitle: true,
        leadingWidth: 43,
        leading: IconButton(
          style: IconButton.styleFrom(padding: const EdgeInsets.only(left: 10)),
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
        ),
        backgroundColor: backroundColor,
        title: Text(
          "Profile",
          style: GoogleFonts.quicksand(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
//*personal details

          Padding(
            padding: const EdgeInsets.only(
              left: 25,
              right: 25,
              top: 30,
              bottom: 40,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    addedProfileImage != null
                        ? InkWell(
                            onTap: () {
                              //*pick image
                              showModalBottomSheet(
                                context: context,
                                builder: (context) => Container(
                                  decoration: const ShapeDecoration(
                                    color: Color(0xff252525),
                                    shape: SmoothRectangleBorder(
                                      borderRadius: SmoothBorderRadius.only(
                                        topLeft: SmoothRadius(
                                            cornerRadius: 22,
                                            cornerSmoothing: 1),
                                        topRight: SmoothRadius(
                                            cornerRadius: 22,
                                            cornerSmoothing: 1),
                                      ),
                                    ),
                                  ),
                                  height: screenHeight / 4,
                                  width: double.infinity,
                                  child: Row(
                                    children: [
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: InkWell(
                                          onTap: () {
                                            pickImageFromCamera();
                                          },
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                Icons.camera_alt,
                                                color: Colors.white,
                                                size: 38,
                                              ),
                                              const SizedBox(
                                                height: 4,
                                              ),
                                              Text(
                                                "Camera",
                                                style: GoogleFonts.inter(
                                                    fontSize: 14,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: InkWell(
                                          onTap: () {
                                            pickImageFromGallery();
                                          },
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                Icons.photo,
                                                color: Colors.white,
                                                size: 38,
                                              ),
                                              const SizedBox(
                                                height: 4,
                                              ),
                                              Text(
                                                "Gallery",
                                                style: GoogleFonts.inter(
                                                    fontSize: 14,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                              //pickImageFromGallery();
                            },
                            child: CircleAvatar(
                              radius: 35,
                              backgroundColor: Colors.grey,
                              backgroundImage: NetworkImage(addedProfileImage!),
                            ),
                          )
                        : Stack(
                            children: [
                              //profile photo
                              CircleAvatar(
                                radius: 35,
                                backgroundColor: Colors.grey.shade700,
                                child: IconButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (context) => Container());
                                    //pickImageFromGallery();
                                  },
                                  icon: const Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 50,
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 30,
                                bottom: -10,
                                child: IconButton(
                                    onPressed: () {
                                      //pickImageFromGallery();
                                    },
                                    icon: const Icon(
                                      Icons.add_a_photo_rounded,
                                      color: Colors.white,
                                      size: 25,
                                    )),
                              )
                            ],
                          ),
                    const SizedBox(
                      width: 12,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Muhammed Sinan",
                          style: GoogleFonts.quicksand(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "muhammedsinan12@gmail.com",
                          style: GoogleFonts.inter(
                            color: const Color(0xff9D9D9D),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),

//*pages

                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: ((context) => const HomePage())));
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    alignment: Alignment.centerLeft,
                    height: 45,
                    width: double.infinity,
                    decoration: ShapeDecoration(
                      color: const Color(0xff2F2F2F),
                      shape: SmoothRectangleBorder(
                        borderRadius: SmoothBorderRadius(
                            cornerRadius: 12, cornerSmoothing: 1),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const SizedBox(
                              width: 4,
                            ),
                            const Icon(
                              Icons.today_rounded,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Text(
                              "All notes",
                              style: GoogleFonts.quicksand(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        const Icon(
                          Icons.arrow_right_alt,
                          color: Colors.white,
                          size: 28,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
//*pinned notes
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: ((context) => const PinnedNotesScreen())));
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    alignment: Alignment.centerLeft,
                    height: 45,
                    width: double.infinity,
                    decoration: ShapeDecoration(
                      color: const Color(0xff2F2F2F),
                      shape: SmoothRectangleBorder(
                        borderRadius: SmoothBorderRadius(
                            cornerRadius: 12, cornerSmoothing: 1),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              "asset/typcn--pin.svg",
                              fit: BoxFit.contain,
                              height: 28,
                              //width: 30,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Text(
                              "Pinned notes",
                              style: GoogleFonts.quicksand(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const Icon(
                          Icons.arrow_right_alt,
                          color: Colors.white,
                          size: 28,
                        ),
                        //SvgPicture.asset(
                        //  "asset/svg/arroe back filpped.svg",
                        //),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
//*did these
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: ((context) => const DidThesePage())));
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    alignment: Alignment.centerLeft,
                    height: 50,
                    width: double.infinity,
                    decoration: ShapeDecoration(
                      color: const Color(0xff2F2F2F),
                      shape: SmoothRectangleBorder(
                        borderRadius: SmoothBorderRadius(
                            cornerRadius: 12, cornerSmoothing: 1),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const SizedBox(
                              width: 6,
                            ),
                            const Icon(Icons.done_all, color: Colors.white),
                            const SizedBox(
                              width: 12,
                            ),
                            Text(
                              "Did these",
                              style: GoogleFonts.quicksand(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const Icon(
                          Icons.arrow_right_alt,
                          color: Colors.white,
                          size: 28,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          //*container navigator

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //all notes conainer

                //Container(
                //  padding: const EdgeInsets.symmetric(horizontal: 18),
                //  alignment: Alignment.centerLeft,
                //  height: 45,
                //  width: double.infinity,
                //  decoration: ShapeDecoration(
                //    color: const Color(0xff2F2F2F),
                //    shape: SmoothRectangleBorder(
                //      borderRadius: SmoothBorderRadius(
                //          cornerRadius: 12, cornerSmoothing: 1),
                //    ),
                //  ),
                //  child: Row(
                //    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //    children: [
                //      Row(
                //        children: [
                //          const SizedBox(
                //            width: 6,
                //          ),
                //          //SvgPicture.asset("asset/svg/all notes.svg"),
                //          const SizedBox(
                //            width: 12,
                //          ),
                //          Text(
                //            "All notes",
                //            style: GoogleFonts.quicksand(
                //              color: Colors.white,
                //              fontSize: 16,
                //              fontWeight: FontWeight.w700,
                //            ),
                //          ),
                //        ],
                //      ),
                //      //SvgPicture.asset(
                //      //  "asset/svg/arroe back filpped.svg",
                //      //),
                //    ],
                //  ),
                //),
                //const SizedBox(
                //  height: 16,
                //),
                //Container(
                //  padding: const EdgeInsets.symmetric(horizontal: 18),
                //  alignment: Alignment.centerLeft,
                //  height: 45,
                //  width: double.infinity,
                //  decoration: ShapeDecoration(
                //    color: const Color(0xff2F2F2F),
                //    shape: SmoothRectangleBorder(
                //      borderRadius: SmoothBorderRadius(
                //          cornerRadius: 12, cornerSmoothing: 1),
                //    ),
                //  ),
                //  child: Row(
                //    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //    children: [
                //      Row(
                //        children: [
                //          const SizedBox(
                //            width: 6,
                //          ),
                //          //SvgPicture.asset(
                //          //  "asset/svg/pin.svg",
                //          //  height: 21,
                //          //  color: Colors.white,
                //          //),
                //          const SizedBox(
                //            width: 12,
                //          ),
                //          Text(
                //            "Pinned notes",
                //            style: GoogleFonts.quicksand(
                //              color: Colors.white,
                //              fontSize: 16,
                //              fontWeight: FontWeight.w700,
                //            ),
                //          ),
                //        ],
                //      ),
                //      //SvgPicture.asset(
                //      //  "asset/svg/arroe back filpped.svg",
                //      //),
                //    ],
                //  ),
                //),
                //const SizedBox(
                //  height: 16,
                //),
                //Container(
                //  padding: const EdgeInsets.symmetric(horizontal: 18),
                //  alignment: Alignment.centerLeft,
                //  height: 50,
                //  width: double.infinity,
                //  decoration: ShapeDecoration(
                //    color: const Color(0xff2F2F2F),
                //    shape: SmoothRectangleBorder(
                //      borderRadius: SmoothBorderRadius(
                //          cornerRadius: 12, cornerSmoothing: 1),
                //    ),
                //  ),
                //  child: Row(
                //    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //    children: [
                //      Row(
                //        children: [
                //          const SizedBox(
                //            width: 6,
                //          ),
                //          const Icon(Icons.done_all, color: Colors.white),
                //          //SvgPicture.asset(
                //          //  "asset/svg/double tick.png",
                //          //  color: Colors.white,
                //          //),
                //          const SizedBox(
                //            width: 12,
                //          ),
                //          Text(
                //            "Did these",
                //            style: GoogleFonts.quicksand(
                //              color: Colors.white,
                //              fontSize: 16,
                //              fontWeight: FontWeight.w700,
                //            ),
                //          ),
                //        ],
                //      ),
                //      //SvgPicture.asset(
                //      //  "asset/svg/arroe back filpped.svg",
                //      //),
                //    ],
                //  ),
                //),

//*log out button

                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        //padding:
                        //    EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        backgroundColor: Colors.transparent,
                        foregroundColor: negativeColor,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: ((context) => AlertDialog(
                                backgroundColor: Colors.white,
                                content: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Log out",
                                      style: GoogleFonts.inter(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          logOut(context);
                                        },
                                        icon: const Icon(
                                          Icons.logout,
                                          color: Colors.red,
                                        ))
                                  ],
                                ),
                              )),
                        );
                        //logOut(context);
                      },
                      icon: const Icon(Icons.logout),
                      label: Text(
                        "Log out",
                        style: GoogleFonts.quicksand(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  logOut(context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
            style: GoogleFonts.inter(
              color: negativeColor,
            ),
          ),
        ),
      );
    }
  }

  //*pick image from camera
  pickImageFromCamera() async {
    log("pickimagelauched");
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.camera);
      if (pickedImage == null) {
        return;
      }
      //setState(() {
      //  //image = File(pickedImage.path).readAsBytesSync();
      //});
      selectedImage = File(pickedImage.path);
      //FireStoreStorage().uploadFile(pickedImage.path, selectedImage!);
      uploadImageToFirebase();
    } catch (e) {
      log("error: $e");
    }
  }

  //*pick image from gallery
  pickImageFromGallery() async {
    log("pickimagelauched");
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage == null) {
        return;
      }
      //setState(() {
      //  image = File(pickedImage.path).readAsBytesSync();
      //});
      selectedImage = File(pickedImage.path);
      //FireStoreStorage().uploadFile(pickedImage.path, selectedImage!);
      uploadImageToFirebase();
    } catch (e) {
      log("error: $e");
    }
  }

  uploadImageToFirebase() async {
    var collRef = FirebaseFirestore.instance.collection("profile");
    Reference fireStorageRef = FirebaseStorage.instance.ref();
    Reference dirImagesRef = fireStorageRef.child("images");
    //Reference imageToUploadRef = dirImagesRef.child(Timestamp.now().toString());
    try {
      FirebaseAppCheck.instance.activate();
      dirImagesRef.putFile(selectedImage!);
      String url = await dirImagesRef.getDownloadURL();
//*chech if url added already
      QuerySnapshot<Map<String, dynamic>> imageRef = await collRef.get();
      if (imageRef.docs.isEmpty) {
        //*add profile url to cloud firestor
        collRef.add({"image": url});
        if (mounted) {
          setState(() {
            addedProfileImage = url;
          });
        }
      } else {
        for (var element in imageRef.docs) {
          collRef.doc(element.id).delete();
        }
        collRef.add({"image": url});
        if (mounted) {
          setState(() {
            addedProfileImage = url;
          });
        }
      }

      log("url: $url");
      log("added");
    } catch (error) {
      log("error :$error");
    }
  }
}
