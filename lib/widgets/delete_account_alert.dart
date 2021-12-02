import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spotivity/Helpers/authentication.dart';
import 'package:spotivity/Helpers/validation_methods.dart';
import 'package:spotivity/views/login_view.dart';

Future accountDeleteAlert(BuildContext context) {

  //Controllers to catch user's inputs
  TextEditingController _emailField = TextEditingController();
  TextEditingController _passwordField = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        scrollable: true,
        title: Text('Delete account',
            style: TextStyle(color: Colors.grey[900])),
        content: Padding(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  validator: (value) {
                    if (ValidationMethods().validateEmail(value!) == false) {
                      return 'Please enter a valid email';
                    }
                  },
                  autocorrect: false,
                  controller: _emailField,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: const TextStyle(color: Colors.black),
                      isDense: true,
                      hintStyle: const TextStyle(
                        color: Colors.black,
                      ),
                      prefixIcon: const Icon(
                        Icons.email,
                        color: Colors.black,
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(20))),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  validator: (value) {
                    if (ValidationMethods().isPasswordValid(value!) == false) {
                      return 'Please enter a valid password';
                    }
                  },
                  autocorrect: false,
                  controller: _passwordField,
                  obscureText: true,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: const TextStyle(color: Colors.black),
                      isDense: true,
                      hintStyle: const TextStyle(
                        color: Colors.black,
                      ),
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Colors.black,
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(20))),
                ),
                Row(
                  children: [
                    TextButton(
                        onPressed: () =>
                            Navigator.of(context, rootNavigator: true)
                                .pop(),
                        child: const Text('Cancel',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold))),
                    TextButton(
                      onPressed: () async {
                        //Need a method to validate user's password
                        if (_formKey.currentState!.validate()) {
                          if (await Authentication().userReauthenticated(
                              _emailField.text, _passwordField.text)) {
                            var collection = FirebaseFirestore.instance
                                .collection('users');
                            await collection
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .delete();

                            await Authentication().deleteUser(
                                _emailField.text, _passwordField.text);
                            _emailField.clear();
                            _passwordField.clear();

                            Navigator.of(context, rootNavigator: true)
                                .pop();

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Incorrect email or password')));
                          }
                        }
                      },
                      child: const Text(
                        'Delete',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}