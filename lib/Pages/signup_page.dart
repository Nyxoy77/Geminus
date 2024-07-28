import 'package:ai_bot/Services/alert_services.dart';
import 'package:ai_bot/Services/auth_services.dart';
import 'package:ai_bot/Services/navigation_services.dart';
import 'package:ai_bot/Widgets/custom_form_field.dart';
import 'package:ai_bot/regEx.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final GetIt _getIt = GetIt.instance;
  final GlobalKey<FormState> _registerFormKey = GlobalKey();
  late final AuthServices _authServices;
  late final NavigationService _navigationService;
  late final AlertServices _alertServices;
  bool isLoading = false;


  String? email, password, name;
  @override
  void initState() {
    super.initState();
    _authServices = _getIt.get<AuthServices>();
    _navigationService = _getIt.get<NavigationService>();
    _alertServices = _getIt.get<AlertServices>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      child: Column(
        children: [
          _headerUi(),
            if (isLoading == false) _registerForm(),
            if (isLoading == false) _loginIfAccount(),
            if (isLoading)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            
          
        ],
      ),
    ));
  }

  Widget _headerUi() {
    return const Column(
      children: [
        Text(
          'Lets Get Started ',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        Text(
          'Input your details',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _registerForm() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.40,
      margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.05),
      child: Form(
        key: _registerFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomFormField(
              height: MediaQuery.of(context).size.height * 0.1,
              hintText: 'Name',
              regEx: nameRegExp,
              onSaved: (value) {
                setState(() {
                  name = value;
                });
              },
            ),
            CustomFormField(
              height: MediaQuery.of(context).size.height * 0.1,
              hintText: 'Email',
              regEx: emailRegExp,
              onSaved: (value) {
                setState(() {
                  email = value;
                });
              },
            ),
            CustomFormField(
              height: MediaQuery.of(context).size.height * 0.1,
              hintText: 'Password',
              regEx: passwordRegExp,
              onSaved: (value) {
                setState(() {
                  password = value;
                });
              },
              obscureText: true,
            ),
            _registerButton()
          ],
        ),
      ),
    );
  }

  Widget _registerButton() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: MaterialButton(
        color: Colors.blue,
        onPressed: () async {
          setState(() {
            isLoading= true;
          });
          if (_registerFormKey.currentState!.validate() ?? false) {
            _registerFormKey.currentState!.save();
            bool result =
                await _authServices.signUp(email: email!, password: password!);
            if (result) {
              _alertServices.showToast(text: "Registered User");
            } else {
              _alertServices.showToast(text: "An unexpected error occured !");
            }
          }
          setState(() {
            isLoading= false;
          });
        },
        child: Text('Register'),
      ),
    );
  }

  Widget _loginIfAccount() {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text('Already have an account ?'),
          GestureDetector(
              onTap: () {
                _navigationService.goBack();
              },
              child: Text(
                'Login',
                style: TextStyle(fontWeight: FontWeight.bold),
              ))
        ],
      ),
    );
  }
}
