import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:email_validator/email_validator.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool _isObscure = true;
  String _firstSelected ='assets/images/usaFlag.svg';

  @override
  Widget build(BuildContext context) {
    return Container(
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
                Navigator.of(context).pushNamedAndRemoveUntil(
                    "/login",
                        (route) => route.isCurrent && route.settings.name == "/login"
                        ? false
                        : true);
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
                          focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1, color: Colors.orange),
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1, color: Colors.red),
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
                          focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1, color: Colors.orange),
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1, color: Colors.red),
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
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        backgroundColor: Colors.blue,
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                      ),
                      child: Text(
                        'SIGN UP',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: null,//sửa sau
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
                                child: Icon(Icons.phone_android_rounded, color: Colors.black, size: 35,),
                                onTap: null, //sửa sau
                              )
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: RichText(
                      text: TextSpan(
                          style: TextStyle(
                            fontSize: 18,
                          ),
                          children: [
                            TextSpan(
                                text: 'Already have an account? ',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                )
                            ),
                            TextSpan(
                              text: "Log in",
                              style: TextStyle(
                                  color: Colors.blue
                              ),
                              recognizer: TapGestureRecognizer()..onTap = () {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    "/login",
                                        (route) => route.isCurrent && route.settings.name == "/login"
                                        ? false
                                        : true);
                              }, //sửa sau
                            ),
                          ]
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}