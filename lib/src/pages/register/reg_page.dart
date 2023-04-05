import 'package:battery_swap_station/src/pages/register/widgets/header_register.dart';
import 'package:battery_swap_station/src/pages/register/widgets/register_form.dart';
import 'package:flutter/material.dart';

class RegPage extends StatefulWidget {
  const RegPage({Key? key}) : super(key: key);

  @override
  _RegPageState createState() => _RegPageState();
}

class _RegPageState extends State<RegPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(bottom: 30),
          child: Column(
            children: const [
              HeaderRegister(),
              RegisterForm(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
