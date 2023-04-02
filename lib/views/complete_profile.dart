import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
// import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onechat/const.dart';
import 'package:onechat/helpers/image_helper.dart';
import 'package:onechat/model/user_models.dart';
import 'package:onechat/views/home_view.dart';

final imageHelper = ImageHelper();

class CompleteProfileView extends StatefulWidget {
  const CompleteProfileView(
      {super.key,
      required this.initals,
      required this.userModel,
      required this.user});
  final String initals;
  final UserModel userModel;
  final User user;
  @override
  State<CompleteProfileView> createState() => _CompleteProfileViewState();
}

class _CompleteProfileViewState extends State<CompleteProfileView> {
  File? imageFile;
  TextEditingController nameController = TextEditingController();

  void checkValue() {
    String username = nameController.text.trim();
    if (username == null || imageFile == null) {
      print('hellll Nah');
    } else {
      uploadData();
    }
  }

  uploadData() async {
    UploadTask uploadTask = FirebaseStorage.instance
        .ref('userProfilePictures')
        .child(widget.userModel.uid.toString())
        .putFile(imageFile!);
    TaskSnapshot taskSnapshot = await uploadTask;
    String imageUrl = await taskSnapshot.ref.getDownloadURL();
    String fulllName = nameController.text.trim();

    widget.userModel.name = fulllName;
    widget.userModel.profilepictureURL = imageUrl;
    firebaseFirestore
        .collection('users')
        .doc(widget.userModel.uid)
        .set(
          widget.userModel.toMap(),
        )
        .then((value) {
      print('Data Uploaded');
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeView(
              userModel: widget.userModel,
              user: widget.user,
            ),
          ));
    });
  }

  void showPicOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                Colors.blue[200]!,
                Colors.blue[300]!,
                Colors.blue[400]!,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              const Text(
                'Select Profile Picture',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              ListTile(
                leading:
                    const Icon(Icons.camera_alt, size: 30, color: Colors.black),
                title: const Text(
                  'Take a photo',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  imageHelper.pickImage(source: ImageSource.camera);
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.photo_library,
                    size: 30, color: Colors.black),
                title: const Text(
                  'Choose from gallery',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () async {
                  final files =
                      await imageHelper.pickImage(source: ImageSource.gallery);

                  final croppedFile = await imageHelper.crop(file: files!);
                  if (croppedFile != null) {
                    setState(() {
                      imageFile = File(
                        croppedFile.path,
                      );
                    });
                  }
                  // log('');
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurpleAccent[700]!, Colors.pinkAccent],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Complete Profile',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                        fontSize: 30,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 70,
                          foregroundImage:
                              imageFile != null ? FileImage(imageFile!) : null,
                          backgroundColor: Colors.deepPurpleAccent[700],
                          child: const Text(
                            'JD',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.pinkAccent,
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                          child: IconButton(
                            onPressed: () {
                              showPicOptions();
                            },
                            icon: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      controller: nameController,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        hintText: 'User Name',
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                        prefixIcon:
                            const Icon(Icons.person, color: Colors.purple),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey[400]!,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.purple,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                      onChanged: (value) {},
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pinkAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        onPressed: () {
                          checkValue();
                        },
                        child: const Text(
                          'SAVE',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 22,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
