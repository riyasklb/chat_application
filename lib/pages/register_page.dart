import 'dart:io';

import 'package:chat_application/service/auth_service.dart';
import 'package:chat_application/service/media_service%20.dart';
import 'package:chat_application/service/navigation_service.dart';
import 'package:chat_application/service/storge_service.dart';
import 'package:chat_application/widget/const.dart';
import 'package:chat_application/widget/custiom_formfiled.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ResgisterPage extends StatefulWidget {
  const ResgisterPage({super.key});

  @override
  State<ResgisterPage> createState() => _ResgisterPageState();
}

class _ResgisterPageState extends State<ResgisterPage> {
  @override
  void initState() {
    _mediaService = _getIt.get<MediaService>();
    _navigationService = _getIt.get<NavigationService>();
    _authService = _getIt.get<AuthService>();
    _storgeService = _getIt.get<StorgeService>();
    super.initState();
  }

  late StorgeService _storgeService;
  final GlobalKey<FormState> _registerformkey = GlobalKey();
  late NavigationService _navigationService;
  late AuthService _authService;
  final GetIt _getIt = GetIt.instance;
  late MediaService _mediaService;
  File? selectedimage;
  String? name, email, password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buidUI(),
    );
  }

  Widget _buidUI() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 20,
        ),
        child: Column(
          children: [
            _rgisterform(),
            _loginAcount(),
          ],
        ),
      ),
    );
  }

  Widget _rgisterform() {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.60,
      width: MediaQuery.sizeOf(context).width,
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.sizeOf(context).height * 0.05,
      ),
      child: Form(
        // key: _Loginformkey,
        child: Form(
          key: _registerformkey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              pfpselectionfield(),
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
                hintText: 'User name',
                regExpressionvalidation: NAME_VALIDATION_REGEX,
                onSaved: (value) {
                  setState(() {
                    name = value;
                  });
                },
              ),
              CustiomFormfiled(
                hintText: 'Password',
                regExpressionvalidation: PASSWORD_VALIDATION_REGEX,
                onSaved: (value) {
                  setState(() {
                    password = value;
                  });
                },
              ),
              _registerbutton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget pfpselectionfield() {
    return InkWell(
      onTap: () async {
        File? file = await _mediaService.getimagefromGallery();
        if (file != null) {
          setState(() {
            selectedimage = file;
          });
        }
      },
      child: CircleAvatar(
        radius: MediaQuery.sizeOf(context).width * 0.14,
        backgroundColor: Colors.grey,
        backgroundImage: selectedimage != null
            ? FileImage(selectedimage!)
            : NetworkImage(PLACEHOLDER_PFP) as ImageProvider,
      ),
    );
  }

  Widget _registerbutton() {
    return SizedBox(
        width: double.infinity,
        child: MaterialButton(
          onPressed: () async {
            try {
              if ((_registerformkey.currentState?.validate() ?? false) &&
                  selectedimage != null) {
                _registerformkey.currentState?.save();
                bool result = await _authService.register(email!, password!);

                if (result) {
                  String? pfpURL = await _storgeService.uploadUserPfp(
                      file: selectedimage!, uid: _authService.user!.uid);
                }
              }
            } catch (e) {
              print(e);
            }
          },
          child: const Text('Register'),
        ));
  }

  Widget _loginAcount() {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Already Have An Account"),
          InkWell(
            onTap: () {
              _navigationService.pushNamed("/login");
            },
            child: const Text(
              'Login',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }
}
