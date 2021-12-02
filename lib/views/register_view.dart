import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spotivity/Helpers/authentication.dart';
import 'package:spotivity/Helpers/validation_methods.dart';
import 'package:spotivity/views/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:flutter/material.dart';

import '../driver.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  //Controllers to catch user's inputs
  final TextEditingController _emailField = TextEditingController();
  final TextEditingController _passwordField = TextEditingController();
  final TextEditingController _confirmPasswordField = TextEditingController();
  final TextEditingController _firstNameField = TextEditingController();
  final TextEditingController _lastNameField = TextEditingController();
  /// The variable and method below allows the user to pick an image
  /// from their gallery
  /// @params none
  /// returns void
  File? _image;

  Future<void> pickImage() async {
    try {
      final image =
      await ImagePicker.platform.pickImage(source: ImageSource.gallery);
      if (image == null) {
        return;
      }

      final imageTemporary = File(image.path);
      setState(() {
        _image = imageTemporary;
      });
    } on PlatformException catch (e) {
      debugPrint('Failed to pick image: $e');
    }
  }

  /// This method obtains the url of the profile pic
  /// @params none
  /// returns String url
  /// This method obtains the url of the profile pic
  /// @params none
  /// returns String url
  Future<String> uploadProfileImage() async {
    try {
      String time = DateTime.now().toString();
      TaskSnapshot taskSnapshot = await FirebaseStorage.instance
          .ref()
          .child("profilePics")
          .child(time)
          .putFile(_image!);

      return await taskSnapshot.ref.getDownloadURL();
    } catch (e) {
      debugPrint('Failed upload image: $e');

      //Default image
      return "https://firebasestorage.googleapis.com/v0/b/beautyfaux-things.appspot.com/o/uploadPic.jpg?alt=media&token=7eb881d6-6c91-49de-af9e-4f80102ebdfb";
    }
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.blue,
          toggleableActiveColor: Colors.black,
          inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          )),
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Colors.black,
            selectionColor: Colors.black12,
            selectionHandleColor: Colors.black,
          )),
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.grey[900],
            title: const  Text('Register',
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold)),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () =>  Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (con) => AppDriver()))

            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Center(
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Create your account. It\'s free and only takes a minute!',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () async {
                            await pickImage();
                          },
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.black,
                            backgroundImage: _image != null
                                ? FileImage(_image!) as ImageProvider
                                : const AssetImage("images/vinyl.png"),
                            child: Stack(children: const [
                              Align(
                                alignment: Alignment.bottomRight,
                                child: CircleAvatar(
                                  radius: 18,
                                  backgroundColor: Colors.white70,
                                  child: Icon(
                                    CupertinoIcons.camera,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ]),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your first name';
                            }
                          },
                          autocorrect: false,
                          controller: _firstNameField,
                          style: const TextStyle(color: Colors.black),
                          decoration: const InputDecoration(
                            labelText: 'First name',
                            labelStyle: TextStyle(color: Colors.black),
                            isDense: true,
                            hintStyle: TextStyle(
                              color: Colors.black,
                            ),
                            prefixIcon: Icon(
                              Icons.menu_book_outlined,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your last name';
                            }
                          },
                          autocorrect: false,
                          controller: _lastNameField,
                          style: const TextStyle(color: Colors.black),
                          decoration: const InputDecoration(
                            labelText: 'Last name',
                            labelStyle: TextStyle(color: Colors.black),
                            isDense: true,
                            hintStyle: TextStyle(
                              color: Colors.black,
                            ),
                            prefixIcon: Icon(
                              Icons.menu_book_outlined,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          validator: (value) {
                            if (ValidationMethods().validateEmail(value!) ==
                                false) {
                              return 'Please enter a valid email';
                            }
                          },
                          autocorrect: false,
                          controller: _emailField,
                          style: const TextStyle(color: Colors.black),
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(color: Colors.black),
                            isDense: true,
                            hintStyle: TextStyle(
                              color: Colors.black,
                            ),
                            prefixIcon: Icon(
                              Icons.email,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          validator: (value) {
                            if (ValidationMethods().isPasswordValid(value!) ==
                                false) {
                              return 'Password must be greater than 8 characters';
                            }
                          },
                          autocorrect: false,
                          obscureText: true,
                          controller: _passwordField,
                          style: const TextStyle(color: Colors.black),
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(color: Colors.black),
                            isDense: true,
                            hintStyle: TextStyle(
                              color: Colors.black,
                            ),
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          validator: (value) {
                            if (ValidationMethods().isPasswordValid(value!) ==
                                false) {
                              return 'Password must be greater than 8 characters';
                            }
                            if (!_passwordField.text
                                .contains(_confirmPasswordField.text)) {
                              return 'Passwords do not match';
                            }
                          },
                          autocorrect: false,
                          obscureText: true,
                          controller: _confirmPasswordField,
                          style: const TextStyle(color: Colors.black),
                          decoration: const InputDecoration(
                            labelText: 'Confirm password',
                            labelStyle: TextStyle(color: Colors.black),
                            isDense: true,
                            hintStyle: TextStyle(
                              color: Colors.black,
                            ),
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                            width: MediaQuery.of(context).size.width / 1.4,
                            height: 45,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.black),
                            child: MaterialButton(
                                onPressed: () async {
                                  if (_passwordField.text
                                      .contains(_confirmPasswordField.text)) {
                                    if (_formKey.currentState!.validate()) {
                                      String profilePic;

                                      bool isUserValidated =
                                          await Authentication().register(
                                              _emailField.text,
                                              _passwordField.text,
                                              _firstNameField.text,
                                              _lastNameField.text,
                                             profilePic = (await uploadProfileImage()),
                                              Timestamp.fromDate(DateTime.now()));

                                      if (isUserValidated) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    'Registration successful')));
                                        Navigator.of(context).pop();
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    'Error. Email may be in use')));
                                      }
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content:
                                                Text('Passwords do not match')));
                                  }
                                },
                                child: const Text(
                                  "Sign up",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                )))
                      ],
                    )),
              ),
            ),
          )),
    );
  }


}
