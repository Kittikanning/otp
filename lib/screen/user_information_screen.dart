import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:otp/model/user_model.dart';
import 'package:otp/provider/auth_provider.dart';
import 'package:otp/screen/home_screen.dart';
import 'package:otp/utils/utils.dart';
import 'package:otp/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class UserInformationScreen extends StatefulWidget {
  const UserInformationScreen({super.key});

  @override
  State<UserInformationScreen> createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends State<UserInformationScreen> {
  File? image;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final bioController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    bioController.dispose();
  }

  // for select image
  void selectImage() async {
    image = await pickImage(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        Provider.of<AuthProvider>(context, listen: true).isLoading;
    return Scaffold(
      body: SafeArea(
        child: isLoading == true
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              )
            : SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(vertical: 25.0, horizontal: 5.0),
                child: Center(
                    child: Column(
                  children: [
                    InkWell(
                      onTap: () => selectImage(),
                      child: image == null
                          ? const CircleAvatar(
                              backgroundColor: Colors.blue,
                              radius: 50,
                              child: Icon(
                                Icons.account_circle,
                                size: 50,
                                color: Colors.white,
                              ),
                            )
                          : CircleAvatar(
                              backgroundImage: FileImage(image!),
                              radius: 50,
                            ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 15),
                      margin: const EdgeInsets.only(top: 20),
                      child: Column(
                        children: [
                          // name
                          textFeld(
                            hintText: "John Smith",
                            icon: Icons.account_circle,
                            inputType: TextInputType.name,
                            maxLines: 1,
                            controller: nameController,
                          ),

                          // email
                          textFeld(
                            hintText: "kiti124@gmail.com",
                            icon: Icons.email,
                            inputType: TextInputType.emailAddress,
                            maxLines: 1,
                            controller: emailController,
                          ),

                          // bio
                          textFeld(
                            hintText: "Enter bio here..",
                            icon: Icons.edit,
                            inputType: TextInputType.name,
                            maxLines: 2,
                            controller: bioController,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.90,
                      child: CustomButton(
                        text: "Continue",
                        onPressed: () => storeData(),
                      ),
                    )
                  ],
                )),
              ),
      ),
    );
  }

  Widget textFeld(
      {required String hintText,
      required IconData icon,
      required TextInputType inputType,
      required int maxLines,
      required TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        cursorColor: Colors.blue,
        controller: controller,
        keyboardType: inputType,
        maxLines: maxLines,
        decoration: InputDecoration(
            prefixIcon: Container(
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.blue,
              ),
              child: Icon(
                icon,
                size: 20,
                color: Colors.white,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.transparent),
            ),
            hintText: hintText,
            alignLabelWithHint: true,
            border: InputBorder.none,
            fillColor: Colors.blue.shade50,
            filled: true),
      ),
    );
  }

  // store user data to database.
  void storeData() async {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    UserModel userModel = UserModel(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      bio: bioController.text.trim(),
      profilePic: "",
      createdAt: "",
      phoneNumber: "",
      uid: "",
    );
    if (image != null) {
      ap.saveUserDataToFirebase(
        context: context,
        userModel: userModel,
        profilePic: image!,
        onSuccess: () {
          // data is save we need to store it locall also
          ap.saveUserDataToSp().then(
                (value) => ap.setSignIn().then(
                      (value) => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                          (route) => false),
                    ),
              );
        },
      );
    } else {
      showSnackBar(context, "Please upload your profile photo");
    }
  }
}
