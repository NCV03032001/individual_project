import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:email_validator/email_validator.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _emailErrMsg = '';
  bool _isObscure = true;
  String _pwErrMsg = '';
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
        color: Colors.white,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: GestureDetector(
            onTap: null, //sửa sau
            child: SizedBox(
              height: 30,
              child: SvgPicture.asset('assets/images/logo.svg'),
            )
          ),
          centerTitle: true,
          actions: [
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
                color: Colors.white,
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
                    margin: EdgeInsets.only(bottom: 10),
                    padding:EdgeInsets.fromLTRB(10, 0, 10, 0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'mail@example.com',
                        border: InputBorder.none,
                      ),
                      onChanged: (val){
                        validateEmail(val); //sửa sau
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Text(_emailErrMsg, style: TextStyle(color: Colors.red),),
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
                    margin: EdgeInsets.only(bottom: 10),
                    padding:EdgeInsets.fromLTRB(10, 0, 10, 0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: _isObscure,
                      decoration: InputDecoration(
                        border: InputBorder.none,
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
                      onChanged: (val){
                        validatePassword(val); //sửa sau
                      },
                    ),
                  ),
                  Container(
                    child: Text(_pwErrMsg, style: TextStyle(color: Colors.red),),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 20,
                        ),
                      ),
                      onPressed: null, //sửa sau
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
                        'LOG IN',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: null, //sửa sau
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
                                color: Color(int.parse('#0071F0'.substring(1, 7), radix: 16) + 0xFF000000),
                              ),
                              shape: BoxShape.circle,
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
                            text: 'Not a member yet? ',
                            style: TextStyle(
                              color: Colors.black,
                            )
                          ),
                          TextSpan(
                              text: "Sign up",
                              style: TextStyle(
                                  color: Colors.blue
                              ),
                              recognizer: TapGestureRecognizer()..onTap = null, //sửa sau
                          ),
                        ]
                      ),
                    ),
                  )
                ],
              )
            ),
          ),
        ),
      ),
    );
  }
  void validateEmail(String val) {
    if(val.isEmpty){
      setState(() {
        _emailErrMsg = "Email can not be empty";
      });
    }else if(!EmailValidator.validate(val, true)){
      setState(() {
        _emailErrMsg = "Invalid Email Address";
      });
    }else{
      setState(() {
        _emailErrMsg = "";
      });
    }
  }
  void validatePassword(String val) {
    if(val.isEmpty){
      setState(() {
        _pwErrMsg = "Password can not be empty";
      });
    }else{
      setState(() {
        _pwErrMsg = "";
      });
    }
  }
}