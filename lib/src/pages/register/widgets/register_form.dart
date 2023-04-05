import 'package:battery_swap_station/src/constants/color.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:battery_swap_station/src/constants/setting.dart';
import 'package:battery_swap_station/src/widgets/bnt_widget.dart';
import 'package:battery_swap_station/src/models/register_model.dart';
import 'package:battery_swap_station/src/utils/regex_validator.dart';
import 'package:battery_swap_station/src/services/network_service.dart';
import 'package:battery_swap_station/src/config/route.dart' as custom_route;

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  State<RegisterForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<RegisterForm> {
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController fullNameController;
  late TextEditingController usernameController;
  late TextEditingController passwordController;

  String _errorEmail = '';
  String _errorPhone = '';
  String _errorFullName = '';
  String _errorUsername = '';
  String _errorPassword = '';

  @override
  void initState() {
    emailController = TextEditingController();
    phoneController = TextEditingController();
    fullNameController = TextEditingController();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    if (emailController != null) {
      emailController.dispose();
    }
    if (phoneController != null) {
      phoneController.dispose();
    }
    if (fullNameController != null) {
      fullNameController.dispose();
    }
    if (usernameController != null) {
      usernameController.dispose();
    }
    if (passwordController != null) {
      passwordController.dispose();
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
            Navigator.pushReplacementNamed(context, custom_route.Route.login);
          },
        ),
      ],
    );
  }

  Widget _buildForm() {
    return FormInput(
      emailController: emailController,
      phoneController: phoneController,
      fullNameController: fullNameController,
      usernameController: usernameController,
      passwordController: passwordController,
      errorEmail: _errorEmail,
      errorPhone: _errorPhone,
      errorFullName: _errorFullName,
      errorUsername: _errorUsername,
      errorPassword: _errorPassword,
    );
  }

  _buildSubmitFormButton() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 30),
      child: Center(
        child: ButtonWidget(
          btnText: "REGISTER",
          onClick: () {
            // Navigator.pop(context);
            //todo
            _onRegister();
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
                text: "Already a account ? ",
                style: TextStyle(
                  color: CustomColors.textTherm,
                  fontSize: 18,
                ),
              ),
              TextSpan(
                text: "Login",
                style: TextStyle(
                  color: Colors.deepOrange,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      );

  void showFailed() {
    Get.defaultDialog(
      title: '',
      titlePadding: const EdgeInsets.all(0),
      radius: 8,
      content: Column(
        children: const [
          FaIcon(
            FontAwesomeIcons.timesCircle,
            size: 48,
            color: Colors.red,
          ),
          SizedBox(height: 16),
          Text(
            ' Fail! ',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text('Can not register'),
        ],
      ),
    );
  }

  void showLoading() {
    Get.defaultDialog(
      title: '',
      titlePadding: const EdgeInsets.all(0),
      radius: 8,
      content: Column(
        children: const [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(' Register .... '),
        ],
      ),
      barrierDismissible: false,
    );
  }

  Future<void> _onRegister() async {
    String email = emailController.text;
    String phone = phoneController.text;
    String fullName = fullNameController.text;
    String username = usernameController.text;
    String password = passwordController.text;

    _errorEmail = '';
    _errorPhone = '';
    _errorFullName = '';
    _errorUsername = '';
    _errorPassword = '';

    if (!EmailSubmitRegexValidator().isValid(email)) {
      _errorEmail = 'The email mute be a valid email.';
    }

    if (fullName.isEmpty) {
      _errorFullName = "You haven't entered your full name yet.";
    }

    if (phone.length != 10) {
      _errorPhone = 'Invalid phone number.';
    }

    if (username.length < 4) {
      _errorUsername = 'Mute be at least 4 characters.';
    }

    if (password.length < 6) {
      _errorPassword = 'Mute be at least 6 characters.';
    }

    if (_errorEmail == '' &&
        _errorFullName == '' &&
        _errorPhone == '' &&
        _errorUsername == '' &&
        _errorPassword == '') {

      showLoading();
      final RegisterModel? getAllModel = await NetworkService().postRegister(
        email,
        phone,
        fullName,
        username,
        password,
      );

      if (getAllModel?.token != null) {
        Get.back();
        // print('Data = ' + prettyPrint(getAllModel));
        await storage.write(
            key: Setting.TOKEN_STORAGE, value: getAllModel?.token);
        // await storage.write(
        //     key: Setting.TOKEN_REFRESH, value: model!.refreshToken);
        await storage.write(key: Setting.USERNAME_STORAGE, value: username);

        Navigator.pushReplacementNamed(
          context,
          custom_route.Route.navigation,
        );
      } else {
        Get.back();
        showFailed();
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
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController fullNameController;
  final TextEditingController usernameController;
  final TextEditingController passwordController;

  final String errorEmail;
  final String errorPhone;
  final String errorFullName;
  final String errorUsername;
  final String errorPassword;

  const FormInput({
    Key? key,
    required this.emailController,
    required this.phoneController,
    required this.fullNameController,
    required this.usernameController,
    required this.passwordController,
    required this.errorUsername,
    required this.errorEmail,
    required this.errorPhone,
    required this.errorFullName,
    required this.errorPassword,
  }) : super(key: key);

  @override
  State<FormInput> createState() => _FormInputState();
}

class _FormInputState extends State<FormInput> {
  final _color = Colors.black54;
  late bool _obscureTextPassword;
  // final _passwordFocusNode = FocusNode();

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
          _buildEmail(),
          _buildFullName(),
          _buildPhone(),
          _buildUsername(),
          _buildPassword(),
        ],
      ),
    );
  }

  TextFormField _buildEmail() {
    return TextFormField(
      controller: widget.emailController,
      decoration: InputDecoration(
        hintText: 'Enter your email',
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
          child: Icon(
            Icons.email,
          ),
        ),
        errorText: widget.errorEmail,
      ),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
    );
  }

  TextFormField _buildFullName() {
    return TextFormField(
      controller: widget.fullNameController,
      decoration: InputDecoration(
        hintText: 'Enter your full name',
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
          child: Icon(
            Icons.drive_file_rename_outline,
          ),
        ),
        errorText: widget.errorFullName,
      ),
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
    );
  }

  TextFormField _buildPhone() {
    return TextFormField(
      controller: widget.phoneController,
      decoration: InputDecoration(
        hintText: 'Enter your phone number',
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
          child: Icon(
            Icons.phone,
          ),
        ),
        errorText: widget.errorPhone,
      ),
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
    );
  }

  TextFormField _buildUsername() {
    return TextFormField(
      controller: widget.usernameController,
      decoration: InputDecoration(
        hintText: 'Enter your username (for login)',
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
        hintText: 'Enter your password (for login)',
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
