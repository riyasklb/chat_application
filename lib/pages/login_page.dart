import 'package:chat_application/service/auth_service.dart';
import 'package:chat_application/widget/const.dart';
import 'package:chat_application/widget/custiom_formfiled.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    _authService = _getIt.get<AuthService>();
    super.initState();
  }

  final GlobalKey<FormState> _Loginformkey = GlobalKey();

  final GetIt _getIt = GetIt.instance;

  late AuthService _authService;

  String? email, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buidUI(),
    );
  }

  Widget _buidUI() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _formfiled(),
            _createanacount(),
          ],
        ),
      ),
    );
  }

  Widget _formfiled() {
    return Form(
      key: _Loginformkey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: [
          CustiomFormfiled(
            hintText: 'Email',
            regExpressionvalidation: EMAIL_VALIDATION_REGEX,
            onSaved: (value) {
              setState(() {
                email = value;
              });
            },
          ),
          CustiomFormfiled(
            onSaved: (value) {
              setState(() {
                password = value;
              });
            },
            hintText: 'Password',
            regExpressionvalidation: PASSWORD_VALIDATION_REGEX,
          ),
          _loginbutton(),
        ],
      ),
    );
  }

  Widget _loginbutton() {
    return SizedBox(
        width: double.infinity,
        child: MaterialButton(
          onPressed: () async {
            if (_Loginformkey.currentState?.validate() ?? false) {
              _Loginformkey.currentState?.save();
              bool result = await _authService.login(email!, password!);
              print(email);
              print(password);
              print(result);
              if (result) {
              } else {}
            }
          },
          child: Text('login'),
        ));
  }

  Widget _createanacount() {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Don't have an account"),
          Text(
            'SignUp',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }
}