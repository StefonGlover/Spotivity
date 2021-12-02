import 'package:spotivity/Helpers/authentication.dart';
import 'package:spotivity/Helpers/validation_methods.dart';
import 'package:spotivity/driver.dart';
import 'package:spotivity/views/register_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  //Form key and variables
  final _formKey = GlobalKey<FormState>();

  //Controllers to catch user's inputs
  final TextEditingController _emailField = TextEditingController();
  final TextEditingController _passwordField = TextEditingController();

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
            centerTitle: true,
            title: const Text(
              'Spotivity',
              style: TextStyle(
                  fontSize: 25,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.grey[900],
          ),
          body: SingleChildScrollView(
              child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Center(
                      child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        SizedBox(
                          width: 400,
                          child: Image.network('http://www.desicomments.com/wp-content/uploads/2017/04/Music-image.jpg'),
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
                        const SizedBox(height: 10),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                          },
                          autocorrect: false,
                          controller: _passwordField,
                          obscureText: true,
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
                        const SizedBox(height: 15),
                        Container(
                            width: MediaQuery.of(context).size.width / 1.4,
                            height: 45,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.black),
                            child: MaterialButton(
                                onPressed: () async {
                                  bool isValidated = await Authentication()
                                      .signIn(
                                          _emailField.text, _passwordField.text);

                                  if (_formKey.currentState!.validate()) {
                                    if (isValidated) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AppDriver()));
                                      _emailField.clear();
                                      _passwordField.clear();
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'Incorrect email or password')));
                                    }
                                  }
                                },
                                child: const Text(
                                  "Sign in",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ))),
                        const SizedBox(height: 15),
                        GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const RegisterPage())),
                          child: const Text('No account yet? Create one',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                        ),

                        const SizedBox(height: 10),
                      ],
                    ),
                  ))))),
    );
  }
}
