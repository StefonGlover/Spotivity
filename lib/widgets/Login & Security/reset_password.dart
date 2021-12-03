import 'package:flutter/material.dart';
import 'package:spotivity/Helpers/authentication.dart';

Future resetPasswordDialog(BuildContext context) {
  //Controllers to catch user's inputs
  TextEditingController _emailField = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        scrollable: true,
        title: Text('A password reset link will be sent to your email',
            style: TextStyle(color: Colors.grey[900])),
        content: Padding(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
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
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      )),
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
                          if (_formKey.currentState!.validate()) {
                            Authentication().resetPassword(_emailField.text);
                            Navigator.of(context, rootNavigator: true).pop();
                          }
                        },
                        child: const Text(
                          "Update",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        )))
              ],
            ),
          ),
        ),
      );
    },
  );
}