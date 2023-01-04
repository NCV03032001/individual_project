import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:individual_project/model/User/UserProvider.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../main.dart';

class Setting extends StatefulWidget {
  static String keyDarkMode = 'key-darkmode';
  const Setting({Key? key}) : super(key: key);

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  final theGetController c = Get.put(theGetController());

  static String keyDarkMode = 'key-darkmode';

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
              Navigator.of(context).pushNamedAndRemoveUntil('/tutor', (Route route) => false);
            }, //sửa sau
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
                      child: SvgPicture.asset('${c.firstSelected}'),
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
                    Text('Engilish'.tr)
                  ],
                ),
                onTap: () => {
                  
                  c.updateImg('assets/images/usaFlag.svg'),
                  c.updateLocale(Locale('en', 'US')),
                },
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
                    Text('Vietnamese'.tr)
                  ],
                ),
                onTap: () => {
                  
                  c.updateImg('assets/images/vnFlag.svg'),
                  c.updateLocale(Locale('vi', 'VN')),
                }, //
              ),
            ],
            /*onSelected: (String value) {
              setState(() {
                _firstSelected = value;
              });
            },*/
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
                      'Profile'.tr,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              /*PopupMenuItem(
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
                ),*/
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
                      'Tutor'.tr,
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
                      'Schedule'.tr,
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
                      'History'.tr,
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
                      'Courses'.tr,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              /*PopupMenuItem(
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
                ),*/
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
                      'Become a Tutor'.tr,
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
                      'Settings'.tr,
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
                      'Logout'.tr,
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
              else if (value == 'Settings') {
                Navigator.pushReplacementNamed(context, '/setting');
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
                'Settings'.tr,
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
                              'Edit profile'.tr,
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
              title: 'GENERAL'.tr,
              children: <Widget>[
                setDarkMode(),
              ],
            ),
            SettingsGroup(
              title: 'ACCOUNT'.tr,
              children: <Widget>[
                changePassword(),
                deleteAccount(),
              ],
            ),
            SettingsGroup(
              title: 'CONTRACT'.tr,
              children: <Widget>[
                reportabug(),
                sendFeadback(),
                aboutDeveloper(),
              ],
            ),
          ],
        ),
      ),
      /*floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
        },
        backgroundColor: Colors.grey,
        child: const Icon(Icons.message_outlined),
      ),*/
    );
  }

  Widget setDarkMode() => SwitchSettingsTile(
    settingKey: keyDarkMode,
    leading: Icon(
      Icons.dark_mode_outlined,
      size: 30,
      color: Colors.blue,
    ),
    title: 'Dark Mode'.tr,
    onChange: (val) async {
      /*await Settings.setValue(Setting.keyDarkMode, val).then((e) => {
        setState(() {
          c.updateIsDark(val);
          print(c.testDark);
          print(val);
          print(Settings.getValue<bool>(Setting.keyDarkMode));
        })
      });*/
      await Settings.setValue(Setting.keyDarkMode, val).then((e) => c.updateIsDark(val));
      //c.updateIsDark(val);
      //Get.changeTheme(c.testDark.value == true? ThemeData.dark() : ThemeData.light());
      //Get.changeTheme(Get.isDarkMode? ThemeData.dark() : ThemeData.light());
      //Get.changeThemeMode(c.testDark.value? ThemeMode.dark : ThemeMode.light);
      /*setState(() {
        print(c.testDark);
        print(Get.isDarkMode);
        print(Settings.getValue<bool>(Setting.keyDarkMode));
      });*/
    },
  );

  Widget changePassword() => SimpleSettingsTile(
    title: 'Change password'.tr,
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
                  double width = MediaQuery.of(context).size.width;
                  double height = MediaQuery.of(context).size.height;
                  return Focus(
                    focusNode: _dialogFocus,
                    child: AlertDialog(
                      title: Text('Change Password'.tr),
                      content: GestureDetector(
                        onTap: () {
                          _dialogFocus.requestFocus();
                        },
                        child: Container(
                          width: width - 30,
                          constraints: BoxConstraints(
                            maxHeight: height/2,
                          ),
                          child: SingleChildScrollView(
                            child: Form(
                              key: _cpwKey,
                              child: Column(
                                children: [
                                  Container(
                                      margin: EdgeInsets.only(bottom: 10),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Current Password'.tr,
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
                                            fontSize: 15,
                                          ),
                                        ),
                                        validator: (val) {
                                          if(val == null || val.isEmpty){
                                            return "Please input your Password!".tr;
                                          }
                                          return null;
                                        }
                                    ),
                                  ),
                                  Container(
                                      margin: EdgeInsets.only(bottom: 10),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'New Password'.tr,
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
                                            fontSize: 15,
                                          ),
                                        ),
                                        validator: (val) {
                                          if(val == null || val.isEmpty){
                                            return "Please input New Password!".tr;
                                          }
                                          return null;
                                        }
                                    ),
                                  ),
                                  Container(
                                      margin: EdgeInsets.only(bottom: 10),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Confirm New Password'.tr,
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
                                            fontSize: 15,
                                          ),
                                        ),
                                        validator: (val) {
                                          if(val == null || val.isEmpty){
                                            return "Please input Confirm!".tr;
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
                                'Confirm Change'.tr,
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
                                  _errorController.text = "Confirm doesn't match!".tr;
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
                                  _errorController.text = "Successfully changed password!".tr;
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
                    ),
                  );
                }
            );
          }
      );
    }, //lead to change password page
  );
  Widget deleteAccount() => SimpleSettingsTile(
      title: 'Delete account'.tr,
      leading: SizedBox(
        width: 30,
        height: 30,
        child: Image.asset('assets/images/icons/DeleteAccount.png', color: Colors.blue,),
      ),
    onTap: () => showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete account'.tr),
            content: Text('Under construction'.tr),
          );
        }
    ), //lead to delete account page
  );

  Widget reportabug() => SimpleSettingsTile(
    title: 'Report A Bug'.tr,
    leading: SizedBox(
      width: 30,
      height: 30,
      child: Image.asset('assets/images/icons/ReportBug.png', color: Colors.blue,),
    ),
    onTap: () => showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Report A Bug'.tr),
            content: Text('Under construction'.tr),
          );
        }
    ), //lead to delete account page
  );
  Widget sendFeadback() => SimpleSettingsTile(
      title: 'Send Feedback'.tr,
      leading: SizedBox(
        width: 30,
        height: 30,
        child: Image.asset('assets/images/icons/SendFeedback.png', color: Colors.blue,),
      ),
      onTap: () => showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Send Feedback'.tr),
            content: Text('Under construction'.tr),
          );
        }
      ), //lead to delete account page
    );
  Widget aboutDeveloper() => SimpleSettingsTile(
    title: 'About Developer'.tr,
    leading: SizedBox(
      width: 30,
      height: 30,
      child: Icon(Icons.info_outline, color: Colors.blue, size: 30,)
    ),
    onTap: () => showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('About Developer'.tr),
          content: Text('Nguyễn Công Văn - 19120713'),
        );
      }
    ), //lead to delete account page
  );
}
