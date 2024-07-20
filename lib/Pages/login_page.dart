// import 'package:flutter/foundation.dart';

import 'package:ai_bot/Services/auth_services.dart';
import 'package:ai_bot/Widgets/custom_form_field.dart';
import 'package:ai_bot/regEx.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// import 'package:flutter/widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _loginPageKey = GlobalKey();
  String? email;
  String? password;

  //Services
  final GetIt _getIt = GetIt.instance;
  late final AuthServices _authServices;

  @override
  void initState() async {
    super.initState();
    _authServices = _getIt.get<AuthServices>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUi(),
    );
  }

  Widget _buildUi() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        child: Column(
          children: [
            _header(),
            _form(),
            _signUp(),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text('Hello , Welcome Back !',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          Text('You have been missed ',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _form() {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.40,
      margin: EdgeInsets.symmetric(
          vertical: MediaQuery.sizeOf(context).height * 0.05),
      child: Form(
        key: _loginPageKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomFormField(
              height: MediaQuery.sizeOf(context).height * 0.1,
              hintText: 'Email',
              regEx: emailRegExp,
              onSaved: (value) {
                email = value;
              },
            ),
            CustomFormField(
              height: MediaQuery.sizeOf(context).height * 0.1,
              hintText: 'Password',
              regEx: passwordRegExp,
              onSaved: (value) {
                setState(() {
                  password = value;
                });
              },
            ),
            _loginButton()
          ],
        ),
      ),
    );
  }

  Widget _loginButton() {
    return MaterialButton(
      onPressed: () async {
        if (_loginPageKey.currentState?.validate() ?? false) {
          _loginPageKey.currentState?.save();
          bool authenticate = await _authServices.login(email!, password!);
          if (authenticate) {
          } else {}
        }
      },
      color: Colors.blue,
      child: const Text(
        "Login",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _signUp() {
    return const Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text("Dont have an account ?"),
          Text("Sign Up ", style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
