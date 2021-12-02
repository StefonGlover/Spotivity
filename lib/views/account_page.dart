import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spotivity/widgets/profile_builder.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return   ProfileBuilder();
  }
}
