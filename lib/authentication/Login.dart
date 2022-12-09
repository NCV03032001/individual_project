import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';
import 'package:individual_project/model/Tokens.dart';
import 'package:individual_project/model/User.dart';
import 'package:individual_project/model/UserProvider.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FocusNode _screenFocus = FocusNode();
  final FocusNode _loginFocus = FocusNode();
  final FocusNode _fgpwFocus = FocusNode();
  bool _isObscure = true;
  bool _isLoading = false;

  String _firstSelected ='assets/images/usaFlag.svg';

  final _loginFormKey = GlobalKey<FormState>();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _pwController = TextEditingController();

  TextEditingController _errorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          FocusScope.of(context).requestFocus(_screenFocus);
        });
      },
      child: Container(
        constraints: const BoxConstraints.expand(),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/authenBG.png'),
            fit: BoxFit.cover,
          ),
          color: Theme.of(context).backgroundColor,
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(backgroundColor: Theme.of(context).backgroundColor,
            title: GestureDetector(
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/login');
                }, //sửa sau
                child: SizedBox(
                  height: 30,
                  child: SvgPicture.asset('assets/images/logo.svg'),
                )
            ),
            centerTitle: true,
            automaticallyImplyLeading: false,
            actions: [
              SizedBox(width: 50),
              PopupMenuButton<String>(
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: Stack(
                    children: [
                      Center(
                        child: SizedBox(
                          width: 25,
                          height: 25,
                          child: SvgPicture.asset(_firstSelected),
                        ),
                      ),
                      Center(
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 8,
                              color: Colors.grey,
                            ),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                offset: Offset(0, 50),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'assets/images/usaFlag.svg',
                    child: Row(
                      children: [
                        SizedBox(
                          width: 30,
                          height: 30,
                          child: SvgPicture.asset('assets/images/usaFlag.svg'),
                        ),
                        SizedBox(width: 20,),
                        Text('Engilish')
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'assets/images/vnFlag.svg',
                    child: Row(
                      children: [
                        SizedBox(
                          width: 30,
                          height: 30,
                          child: SvgPicture.asset('assets/images/vnFlag.svg'),
                        ),
                        SizedBox(width: 20,),
                        Text('Vietnamese')
                      ],
                    ),
                  ),
                ],
                onSelected: (String value) {
                  setState(() {
                    _firstSelected = value;
                  });
                },
              ),
            ],
            //automaticallyImplyLeading: false,
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _loginFormKey,
                child: Container(
                    margin: EdgeInsets.all(30),
                    padding: EdgeInsets.all(35),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(50),
                      color: Theme.of(context).backgroundColor,
                    ),
                    child: Column(
                      children: [
                        Container(
                            margin: EdgeInsets.only(bottom: 20),
                            child: Text(
                              'Say hello to your English tutors',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            )
                        ),
                        Container(
                            margin: EdgeInsets.only(bottom: 20),
                            child: Text(
                              'Become fluent faster through one on one video chat lessons tailored to your goals.',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                        ),
                        Container(
                            margin: EdgeInsets.only(bottom: 10),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'EMAIL',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.grey,
                              ),
                            )
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 20),
                          child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              autovalidateMode: AutovalidateMode.always,
                              controller: _emailController,
                              decoration: InputDecoration(
                                hintText: 'mail@example.com',
                                contentPadding: EdgeInsets.fromLTRB(10, 15, 10, 0),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1, color: Colors.grey),
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1, color: Colors.blue),
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1, color: Colors.red),
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1, color: Colors.orange),
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                errorStyle: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              validator: (val) {
                                if(val == null || val.isEmpty){
                                  return "Please input your Email!";
                                } else if(!EmailValidator.validate(val, true)){
                                  return "Invalid Email Address!";
                                }
                                return null;
                              }
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(bottom: 10),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'PASSWORD',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.grey,
                              ),
                            )
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 20),
                          child: TextFormField(
                              keyboardType: TextInputType.visiblePassword,
                              controller: _pwController,
                              autovalidateMode: AutovalidateMode.always,
                              obscureText: _isObscure,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.fromLTRB(10, 15, 10, 0),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1, color: Colors.grey),
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1, color: Colors.blue),
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1, color: Colors.red),
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1, color: Colors.orange),
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                errorStyle: TextStyle(
                                  fontSize: 15,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isObscure ? Icons.visibility : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isObscure = !_isObscure;
                                    });
                                  },
                                ),
                              ),
                              validator: (val) {
                                if(val == null || val.isEmpty){
                                  return "Please input your Password!";
                                }
                                return null;
                              }
                          ),
                        ),
                        _errorController.text.isNotEmpty
                            ? Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Color(0xffffccc7),
                            ),
                            color: Color(0xfffff2f0),
                          ),
                          child: Row(
                            children: [
                              Image.asset('assets/images/icons/close.png', width: 15, height: 15),
                              SizedBox(width: 15,),
                              Flexible(child: Text(_errorController.text, style: TextStyle(color: Colors.black),),),
                            ],
                          ),
                        ) : Container(),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            focusNode: _fgpwFocus,
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 20,
                              ),
                            ),
                            onPressed: () {
                              _fgpwFocus.requestFocus();
                              _fgpwFocus.unfocus();
                              Navigator.pushNamed(context, '/forgotpw');
                            }, //sửa sau
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 20),
                          width: double.infinity,
                          child: OutlinedButton(
                            focusNode: _loginFocus,
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                backgroundColor: Colors.blue,
                                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _isLoading
                                  ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white,),)
                                  : Container(),
                                  SizedBox(width: 15,),
                                  Text(
                                    'LOG IN',
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  _isLoading
                                  ? SizedBox(width: 35,)
                                  : SizedBox(width: 15,),
                                ],
                              ),
                              onPressed: () async {
                                _loginFocus.requestFocus();
                                if (_loginFormKey.currentState!.validate()) {
                                  setState(() {
                                    _isLoading = true;
                                    _errorController.text = "";
                                  });
                                  var url = Uri.https('sandbox.api.lettutor.com', 'auth/login');
                                  var response = await http.post(url, body: {'email': _emailController.text, 'password': _pwController.text});
                                  if (response.statusCode != 200) {
                                    final Map parsed = json.decode(response.body);
                                    final String err = parsed["message"];
                                    setState(() {
                                      _isLoading = false;
                                      _errorController.text = err;
                                    });
                                  }
                                  else {
                                    setState(() {
                                      _isLoading = false;
                                      _errorController.text = "";
                                    });
                                    final Map parsed = json.decode(response.body);

                                    Provider.of<UserProvider>(context, listen: false).thisUser = User.fromJson(parsed["user"]);
                                    Provider.of<UserProvider>(context, listen: false).thisTokens = Tokens.fromJson(parsed["tokens"]);

                                    Navigator.of(context).pushNamedAndRemoveUntil(
                                        "/tutor", (route) {return false;});
                                  }
                                }
                                else setState(() {
                                  _errorController.text = "";
                                });
                              } //sửa sau
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 20),
                          child: Text(
                            'Or continue with',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: IconButton(
                                  icon: SvgPicture.asset('assets/images/icons/fbIcon.svg'),
                                  iconSize: 45,
                                  onPressed: null, //sửa sau
                                ),
                              ),
                              Expanded(
                                child: IconButton(
                                  icon: SvgPicture.asset('assets/images/icons/ggIcon.svg'),
                                  iconSize: 45,
                                  onPressed: null, //sửa sau
                                ),
                              ),
                              Expanded(
                                child: Container(
                                    alignment: Alignment.center,
                                    width: 45,
                                    height: 45,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 1.5,
                                        color: Color(0xFF0071F0),
                                      ),
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    child: GestureDetector(
                                      onTap: null,
                                      child: Icon(Icons.phone_android_rounded, color: Colors.black, size: 35,), //sửa sau
                                    )
                                ),
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                              style: TextStyle(
                                fontSize: 18,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Not a member yet? ',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                TextSpan(
                                  text: "Sign up",
                                  style: TextStyle(
                                    color: Colors.blue,
                                  ),
                                  recognizer: TapGestureRecognizer()..onTap = () {
                                    Navigator.pushNamed(context, '/signup');
                                  }, //sửa sau
                                ),
                              ]
                          ),
                        ),
                      ],
                    )
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}