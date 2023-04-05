import 'package:battery_swap_station/src/pages/login/widgets/header_login.dart';
import 'package:battery_swap_station/src/pages/login/widgets/login_form.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(bottom: 30),
          child: Column(
            children: const <Widget>[
              HeaderLogin(),
              LoginForm(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
