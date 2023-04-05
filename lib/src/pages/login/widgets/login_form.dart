import 'package:battery_swap_station/src/constants/color.dart';
import 'package:battery_swap_station/src/constants/setting.dart';
import 'package:battery_swap_station/src/models/login_model.dart';
import 'package:battery_swap_station/src/services/network_service.dart';
import 'package:battery_swap_station/src/widgets/bnt_widget.dart';
import 'package:battery_swap_station/src/widgets/dialogs/dialog_error_awesome.dart';
import 'package:battery_swap_station/src/widgets/dialogs/dialog_loading.dart';
import 'package:flutter/material.dart';
import 'package:battery_swap_station/src/config/route.dart' as custom_route;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

// Create storage
const storage = FlutterSecureStorage();

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late TextEditingController? usernameController;
  late TextEditingController? passwordController;

  String _errorUsername = '';
  String _errorPassword = '';

  @override
  void initState() {
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    if (usernameController != null) {
      usernameController?.dispose();
    }
    if (passwordController != null) {
      passwordController?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildForm(),
        _buildSubmitFormButton(),
        _buildFlatButton(
          onPressed: () {
            Navigator.pushReplacementNamed(
                context, custom_route.Route.register);
          },
        ),
      ],
    );
  }

  Widget _buildForm() {
    return FormInput(
      usernameController: usernameController!,
      passwordController: passwordController!,
      errorUsername: _errorUsername,
      errorPassword: _errorPassword,
    );
  }

  _buildSubmitFormButton() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 30),
      child: Center(
        child: ButtonWidget(
          btnText: "LOGIN",
          onClick: () {
            _onLogin();
          },
        ),
      ),
    );
  }

  TextButton _buildFlatButton({
    required VoidCallback onPressed,
  }) =>
      TextButton(
        onPressed: onPressed,
        child: RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: "Don't have an account ?",
                style: TextStyle(
                  color: CustomColors.textTherm,
                  fontSize: 18,
                ),
              ),
              TextSpan(
                text: "Register",
                style: TextStyle(
                  color: Colors.deepOrange,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      );

  Future<void> _onLogin() async {
    String username = usernameController!.text;
    String password = passwordController!.text;

    _errorUsername = '';
    _errorPassword = '';

    if (username.length < 4) {
      _errorUsername = 'Mute be at least 4 characters.';
    }

    if (password.length < 6) {
      _errorPassword = 'Mute be at least 6 characters.';
    }

    if (_errorUsername == '' && _errorPassword == '') {
      dialogLoading('Login ...');

      final LoginModel? getAllModel = await NetworkService().postLogin(username, password);

      if (getAllModel != null) {
        Get.back();
        // print('Data = ' + prettyPrint(getAllModel));
        await storage.write(key: Setting.TOKEN_STORAGE, value: getAllModel.token);
        // await storage.write(
        //     key: Setting.TOKEN_REFRESH, value: model!.refreshToken);
        await storage.write(key: Setting.USERNAME_STORAGE, value: username);

        Navigator.pushReplacementNamed(
          context,
          custom_route.Route.navigation,
        );
      } else {
        Get.back();
        dialogErrorAwesome(context, 'Login Fail!', 'Username or Password is incorrect', (){});
        setState(() {
          //todo
        });
      }
      setState(() {
        //  todo
      });
    } else {
      setState(() {
        //todo
      });
    }
  }
}

class FormInput extends StatefulWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final String errorUsername;
  final String errorPassword;

  const FormInput({
    Key? key,
    required this.usernameController,
    required this.passwordController,
    required this.errorUsername,
    required this.errorPassword,
  }) : super(key: key);

  @override
  State<FormInput> createState() => _FormInputState();
}

class _FormInputState extends State<FormInput> {
  final _color = Colors.black54;
  late bool _obscureTextPassword;

  @override
  void initState() {
    _obscureTextPassword = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 30),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          _buildUsername(),
          _buildPassword(),
        ],
      ),
    );
  }

  TextFormField _buildUsername() {
    return TextFormField(
      controller: widget.usernameController,
      decoration: InputDecoration(
        hintText: "Enter your username",
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.7),
          borderSide: const BorderSide(width: 0.0, style: BorderStyle.none),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.7),
          borderSide: const BorderSide(width: 0.0, style: BorderStyle.none),
        ),
        contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
        prefixIcon: const Padding(
          padding: EdgeInsets.only(right: 15.0, left: 15, top: 15, bottom: 15),
          child: FaIcon(
            FontAwesomeIcons.userAlt,
          ),
        ),
        errorText: widget.errorUsername,
      ),
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
    );
  }

  TextFormField _buildPassword() {
    return TextFormField(
      controller: widget.passwordController,
      decoration: InputDecoration(
        hintText: "Enter your password",
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.7),
          borderSide: const BorderSide(width: 0.0, style: BorderStyle.none),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.7),
          borderSide: const BorderSide(width: 0.0, style: BorderStyle.none),
        ),
        contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
        prefixIcon: const Padding(
          padding: EdgeInsets.only(right: 15.0, left: 15, top: 15, bottom: 15),
          child: FaIcon(
            FontAwesomeIcons.lock,
          ),
        ),
        errorText: widget.errorPassword,
        suffixIcon: IconButton(
          icon: FaIcon(_obscureTextPassword
              ? FontAwesomeIcons.eyeSlash
              : FontAwesomeIcons.eye),
          color: _color,
          iconSize: 20.0,
          onPressed: () {
            setState(() {
              _obscureTextPassword = !_obscureTextPassword;
            });
          },
        ),
      ),
      obscureText: _obscureTextPassword,
    );
  }
}
