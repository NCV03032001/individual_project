import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:individual_project/model/UserProvider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class Setting extends StatefulWidget {
  static const keyDarkMode = 'key-darkmode';
  const Setting({Key? key}) : super(key: key);

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  String _firstSelected ='assets/images/usaFlag.svg';

  static const keyDarkMode = 'key-darkmode';

  TextEditingController _pwController = TextEditingController();
  TextEditingController _npwController = TextEditingController();
  TextEditingController _cnpwController = TextEditingController();
  TextEditingController _errorController = TextEditingController();
  bool _isSuccess = false;
  bool _isLoading = false;
  final FocusNode _cpwFocus = FocusNode();
  final FocusNode _dialogFocus = FocusNode();
  final _cpwKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).backgroundColor,
        title: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  "/tutor",
                      (route) => route.isCurrent && route.settings.name == "/tutor"
                      ? false
                      : true);
            },  //sửa sau
            child: SizedBox(
              height: 30,
              child: SvgPicture.asset('assets/images/logo.svg'),
            )
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
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
          SizedBox(width: 10,),
          PopupMenuButton<String>(
            child: SizedBox(
              width: 40,
              height: 40,
              child: Center(
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey,
                  ),
                  child: Icon(Icons.menu, color: Theme.of(context).backgroundColor,),
                ),
              ),
            ),
            offset: Offset(0, 50),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'Profile',
                child: Row(
                  children: [
                    SizedBox(
                      width: 30,
                      height: 30,
                      child: CircleAvatar(
                        radius: 80.0,
                        backgroundImage: Image.network('${context.read<UserProvider>().thisUser.avatar}').image,
                      ),
                    ),
                    SizedBox(width: 20,),
                    Text(
                      'Profile',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'BuyLessons',
                child: Row(
                  children: [
                    SizedBox(
                      width: 30,
                      height: 30,
                      child: Image.asset('assets/images/icons/BuyLessons.png', color: Colors.blue,),
                    ),
                    SizedBox(width: 20,),
                    Text(
                      'Buy Lessons',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'Tutor',
                child: Row(
                  children: [
                    SizedBox(
                      width: 30,
                      height: 30,
                      child: Image.asset('assets/images/icons/Tutor.png', color: Colors.blue,),
                    ),
                    SizedBox(width: 20,),
                    Text(
                      'Tutor',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'Schedule',
                child: Row(
                  children: [
                    SizedBox(
                      width: 30,
                      height: 30,
                      child: Image.asset('assets/images/icons/Schedule.png', color: Colors.blue,),
                    ),
                    SizedBox(width: 20,),
                    Text(
                      'Schedule',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'History',
                child: Row(
                  children: [
                    SizedBox(
                      width: 30,
                      height: 30,
                      child: Image.asset('assets/images/icons/History.png', color: Colors.blue,),
                    ),
                    SizedBox(width: 20,),
                    Text(
                      'History',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'Courses',
                child: Row(
                  children: [
                    SizedBox(
                      width: 30,
                      height: 30,
                      child: Image.asset('assets/images/icons/Courses.png', color: Colors.blue,),
                    ),
                    SizedBox(width: 20,),
                    Text(
                      'Courses',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'MyCourse',
                child: Row(
                  children: [
                    SizedBox(
                      width: 30,
                      height: 30,
                      child: Image.asset('assets/images/icons/MyCourse.png', color: Colors.blue,),
                    ),
                    SizedBox(width: 20,),
                    Text(
                      'My Course',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'BecomeTutor',
                child: Row(
                  children: [
                    SizedBox(
                      width: 30,
                      height: 30,
                      child: Image.asset('assets/images/icons/BecomeTutor.png', color: Colors.blue,),
                    ),
                    SizedBox(width: 20,),
                    Text(
                      'Become a Tutor',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'Setting',
                child: Row(
                  children: [
                    SizedBox(
                      width: 30,
                      height: 30,
                      child: Image.asset('assets/images/icons/Setting.png', color: Colors.blue,),
                    ),
                    SizedBox(width: 20,),
                    Text(
                      'Settings',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'Logout',
                child: Row(
                  children: [
                    SizedBox(
                      width: 30,
                      height: 30,
                      child: Image.asset('assets/images/icons/Logout.png', color: Colors.blue,),
                    ),
                    SizedBox(width: 20,),
                    Text(
                      'Logout',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'Profile') {
                Navigator.pushNamed(context, '/profile');
              }
              else if (value == 'Tutor') {
                Navigator.pushNamed(context, '/tutor');
              }
              else if (value == 'Schedule') {
                Navigator.pushNamed(context, '/schedule');
              }
              else if (value == 'History') {
                Navigator.pushNamed(context, '/history');
              }
              else if (value == 'Courses') {
                Navigator.pushNamed(context, '/courses');
              }
              else if (value == 'BecomeTutor') {
                Navigator.pushNamed(context, '/become_tutor');
              }
              else if (value == 'Logout') {
                Navigator.of(context).pushNamedAndRemoveUntil("/login",
                        (route) {return false;});
              }
            },
          ),
        ],
        //automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 20),
              alignment: Alignment.centerLeft,
              child: Text(
                'Settings',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: CircleAvatar(
                      radius: 80.0,
                      backgroundImage: Image.network('${context.read<UserProvider>().thisUser.avatar}').image,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: SizedBox(
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.all(10),
                            child: Text(
                              '${context.watch<UserProvider>().thisUser.name}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            'Account ID: ${context.read<UserProvider>().thisUser.id}',
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushNamedAndRemoveUntil("/profile",
                                      (route) => route.isCurrent && route.settings.name == "/profile"
                                      ? false
                                      : true);
                            },
                            child: Text(
                              'Edit profile',
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SettingsGroup(
              title: 'GENERAL',
              children: <Widget>[
                setDarkMode(),
              ],
            ),
            SettingsGroup(
              title: 'ACCOUNT',
              children: <Widget>[
                changePassword(),
                deleteAccount(),
              ],
            ),
            SettingsGroup(
              title: 'CONTRACT',
              children: <Widget>[
                reportabug(),
                sendFeadback(),
                aboutDeveloper(),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
        },
        backgroundColor: Colors.grey,
        child: const Icon(Icons.message_outlined),
      ),
    );
  }

  Widget setDarkMode() => SwitchSettingsTile(
    settingKey: keyDarkMode,
    leading: Icon(
      Icons.dark_mode_outlined,
      size: 30,
      color: Colors.blue,
    ),
    title: 'Dark Mode',
    onChange: (val) {
      print(val);
      print(Settings.getValue<bool>(Setting.keyDarkMode));
      //Settings.setValue<bool>(keyDarkMode, val);
    },
  );

  Widget changePassword() => SimpleSettingsTile(
    title: 'Change password',
    leading: SizedBox(
      width: 30,
      height: 30,
      child: Image.asset('assets/images/icons/ChangePassword.png', color: Colors.blue,),
    ),
    onTap: () {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
                builder: (context, setState) {
                  return AlertDialog(
                    title: Text('Change Password'),
                    content: GestureDetector(
                      onTap: () {
                        FocusScope.of(context).requestFocus(_dialogFocus);
                      },
                      child: SizedBox(
                        width: 280,
                        height: 300,
                        child: SingleChildScrollView(
                          child: Form(
                            key: _cpwKey,
                            child: Column(
                              children: [
                                Container(
                                    margin: EdgeInsets.only(bottom: 10),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Current Password',
                                    )
                                ),
                                Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: TextFormField(
                                      keyboardType: TextInputType.visiblePassword,
                                      controller: _pwController,
                                      autovalidateMode: AutovalidateMode.always,
                                      obscureText: true,
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
                                          fontSize: 10,
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
                                    margin: EdgeInsets.only(bottom: 10),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'New Password',
                                    )
                                ),
                                Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: TextFormField(
                                      keyboardType: TextInputType.visiblePassword,
                                      controller: _npwController,
                                      autovalidateMode: AutovalidateMode.always,
                                      obscureText: true,
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
                                          fontSize: 10,
                                        ),
                                      ),
                                      validator: (val) {
                                        if(val == null || val.isEmpty){
                                          return "Please input New Password!";
                                        }
                                        return null;
                                      }
                                  ),
                                ),
                                Container(
                                    margin: EdgeInsets.only(bottom: 10),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Confirm New Password',
                                    )
                                ),
                                Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: TextFormField(
                                      keyboardType: TextInputType.visiblePassword,
                                      controller: _cnpwController,
                                      autovalidateMode: AutovalidateMode.always,
                                      obscureText: true,
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
                                          fontSize: 10,
                                        ),
                                      ),
                                      validator: (val) {
                                        if(val == null || val.isEmpty){
                                          return "Please input Confirm!";
                                        }
                                        return null;
                                      }
                                  ),
                                ),
                                _errorController.text.isNotEmpty
                                    ? Container(
                                  margin: EdgeInsets.only(bottom: 20),
                                  width: double.infinity,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: _isSuccess ? Color(0xff99FF99) : Color(0xffffccc7),
                                    ),
                                    color: _isSuccess ? Color(0xffF2FFF0) : Color(0xfffff2f0),
                                  ),
                                  child: Row(
                                    children: [
                                      _isSuccess
                                          ? Icon(Icons.check_circle, color: Colors.green, size: 17.5,)
                                          : Image.asset('assets/images/icons/close.png', width: 15, height: 15),
                                      SizedBox(width: 15,),
                                      Flexible(child: Text(_errorController.text, style: TextStyle(color: Colors.black),),),
                                    ],
                                  ),
                                ) : Container(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    actions: [
                      OutlinedButton(
                        focusNode: _cpwFocus,
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.all(15),
                          backgroundColor: Colors.blue,
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _isLoading
                                ? SizedBox(height: 15, width: 15, child: CircularProgressIndicator(color: Colors.white,),)
                                : SizedBox(width: 15,),
                            SizedBox(width: 10,),
                            Text(
                              'Confirm Change',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 25,),
                          ],
                        ),
                        onPressed: () async {
                          _cpwFocus.requestFocus();
                          if (_cpwKey.currentState!.validate()) {
                            if (_cnpwController.text != _npwController.text) {
                              setState(() {
                                _errorController.text = "Confirm doesn't match!";
                                _isSuccess = false;
                              });
                              return;
                            }
                            setState(() {
                              _isLoading = true;
                              _isSuccess = false;
                              _errorController.text = "";
                            });
                            var url = Uri.https('sandbox.api.lettutor.com', 'auth/change-password');
                            var response = await http.post(url,
                                headers: {
                                  "Content-Type": "application/json",
                                  'Authorization': "Bearer ${context.read<UserProvider>().thisTokens.access.token}"
                                },
                                body: jsonEncode({'password': _pwController.text, "newPassword": _npwController.text})
                            );
                            if (response.statusCode != 200) {
                              final Map parsed = json.decode(response.body);
                              final String err = parsed["message"];
                              setState(() {
                                _isLoading = false;
                                _isSuccess = false;
                                _errorController.text = err;
                              });
                            }
                            else {
                              setState(() {
                                _isLoading = false;
                                _isSuccess = true;
                                _errorController.text = "Successfully changed password!";
                              });
                            }
                          }
                          else setState(() {
                            _isSuccess = false;
                            _errorController.text = "";
                          });
                        }, //sửa sau
                      ),
                    ],
                  );
                }
            );
          }
      );
    }, //lead to change password page
  );
  Widget deleteAccount() => SimpleSettingsTile(
      title: 'Delete account',
      leading: SizedBox(
        width: 30,
        height: 30,
        child: Image.asset('assets/images/icons/DeleteAccount.png', color: Colors.blue,),
      ),
    onTap: null, //lead to delete account page
  );
  Widget reportabug() => SimpleSettingsTile(
    title: 'Report A Bug',
    leading: SizedBox(
      width: 30,
      height: 30,
      child: Image.asset('assets/images/icons/ReportBug.png', color: Colors.blue,),
    ),
    onTap: null, //lead to delete account page
  );

  Widget sendFeadback() => SimpleSettingsTile(
      title: 'Send Feedback',
      leading: SizedBox(
        width: 30,
        height: 30,
        child: Image.asset('assets/images/icons/SendFeedback.png', color: Colors.blue,),
      ),
      onTap: null, //lead to delete account page
    );
  Widget aboutDeveloper() => SimpleSettingsTile(
    title: 'About Developer',
    leading: SizedBox(
      width: 30,
      height: 30,
      child: Icon(Icons.info_outline, color: Colors.blue, size: 30,)
    ),
    onTap: null, //lead to delete account page
  );
}
