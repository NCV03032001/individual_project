import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:individual_project/model/UserProvider.dart';
import 'package:provider/provider.dart';


class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final FocusNode _screenFocus = FocusNode();
  TextEditingController _pwController = TextEditingController();
  TextEditingController _npwController = TextEditingController();
  TextEditingController _cnpwController = TextEditingController();
  TextEditingController _errorController = TextEditingController();
  bool _isLoading = false;
  final _cpwController = GlobalKey<FormState>();
  final FocusNode _fgpwFocus = FocusNode();
  String _firstSelected ='assets/images/usaFlag.svg';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
          setState(() {
            FocusScope.of(context).requestFocus(_screenFocus);
          });
        },
      child: Scaffold(
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
                else if (value == 'Setting') {
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
                  'Settings',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
      ),
      // child: Container(
      //   constraints: const BoxConstraints.expand(),
      //   decoration: BoxDecoration(
      //     image: DecorationImage(
      //       image: AssetImage('assets/images/authenBG.png'),
      //       fit: BoxFit.cover,
      //     ),
      //     color: Theme.of(context).backgroundColor,
      //   ),
      //   child: Scaffold(
      //     backgroundColor: Colors.transparent,
      //     appBar: AppBar(backgroundColor: Theme.of(context).backgroundColor,
      //       title: GestureDetector(
      //           onTap: () {
      //             Navigator.of(context).pushNamedAndRemoveUntil(
      //                 "/login",
      //                     (route) => route.isCurrent && route.settings.name == '/login'
      //                     ? false
      //                     : true);
      //           }, //sửa sau
      //           child: SizedBox(
      //             height: 30,
      //             child: SvgPicture.asset('assets/images/logo.svg'),
      //           )
      //       ),
      //       centerTitle: true,
      //       automaticallyImplyLeading: false,
      //       actions: [
      //         SizedBox(width: 50),
      //         PopupMenuButton<String>(
      //           child: SizedBox(
      //             width: 40,
      //             height: 40,
      //             child: Stack(
      //               children: [
      //                 Center(
      //                   child: SizedBox(
      //                     width: 25,
      //                     height: 25,
      //                     child: SvgPicture.asset(_firstSelected),
      //                   ),
      //                 ),
      //                 Center(
      //                   child: Container(
      //                     width: 40,
      //                     height: 40,
      //                     decoration: BoxDecoration(
      //                       border: Border.all(
      //                         width: 8,
      //                         color: Colors.grey,
      //                       ),
      //                       shape: BoxShape.circle,
      //                     ),
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ),
      //           offset: Offset(0, 50),
      //           itemBuilder: (context) => [
      //             PopupMenuItem(
      //               value: 'assets/images/usaFlag.svg',
      //               child: Row(
      //                 children: [
      //                   SizedBox(
      //                     width: 30,
      //                     height: 30,
      //                     child: SvgPicture.asset('assets/images/usaFlag.svg'),
      //                   ),
      //                   SizedBox(width: 20,),
      //                   Text('Engilish')
      //                 ],
      //               ),
      //             ),
      //             PopupMenuItem(
      //               value: 'assets/images/vnFlag.svg',
      //               child: Row(
      //                 children: [
      //                   SizedBox(
      //                     width: 30,
      //                     height: 30,
      //                     child: SvgPicture.asset('assets/images/vnFlag.svg'),
      //                   ),
      //                   SizedBox(width: 20,),
      //                   Text('Vietnamese')
      //                 ],
      //               ),
      //             ),
      //           ],
      //           onSelected: (String value) {
      //             setState(() {
      //               _firstSelected = value;
      //             });
      //           },
      //         ),
      //       ],
      //       //automaticallyImplyLeading: false,
      //     ),
      //     body: Center(
      //       child: SingleChildScrollView(
      //         child: Container(
      //             margin: EdgeInsets.all(30),
      //             padding: EdgeInsets.all(35),
      //             decoration: BoxDecoration(
      //               border: Border.all(
      //                 width: 1,
      //                 color: Colors.grey,
      //               ),
      //               borderRadius: BorderRadius.circular(50),
      //               color: Theme.of(context).backgroundColor,
      //             ),
      //             child: Column(
      //               children: [
      //                 Container(
      //                     margin: EdgeInsets.only(bottom: 20),
      //                     child: Text(
      //                       'Reset Password',
      //                       style: TextStyle(
      //                         fontSize: 30,
      //                         fontWeight: FontWeight.bold,
      //                       ),
      //                     )
      //                 ),
      //                 Container(
      //                     margin: EdgeInsets.only(bottom: 20),
      //                     child: Text(
      //                       'Please enter your email address to search for your account.',
      //                       style: TextStyle(
      //                         fontSize: 15,
      //                       ),
      //                     )
      //                 ),
      //                 Container(
      //                     margin: EdgeInsets.only(bottom: 10),
      //                     alignment: Alignment.centerLeft,
      //                     child: Text(
      //                       'Email',
      //                       style: TextStyle(
      //                         fontSize: 20,
      //                       ),
      //                     )
      //                 ),
      //                 Container(
      //                   margin: EdgeInsets.only(bottom: 20),
      //                   child: Form(
      //                     key: _cpwController,
      //                     child: TextFormField(
      //                         controller: _pwController,
      //                         keyboardType: TextInputType.emailAddress,
      //                         autovalidateMode: AutovalidateMode.always,
      //                         decoration: InputDecoration(
      //                           hintText: 'mail@example.com',
      //                           contentPadding: EdgeInsets.fromLTRB(10, 15, 10, 0),
      //                           enabledBorder: OutlineInputBorder(
      //                             borderSide: BorderSide(width: 1, color: Colors.grey),
      //                             borderRadius: BorderRadius.all(Radius.circular(10)),
      //                           ),
      //                           focusedBorder: OutlineInputBorder(
      //                             borderSide: BorderSide(width: 1, color: Colors.blue),
      //                             borderRadius: BorderRadius.all(Radius.circular(10)),
      //                           ),
      //                           focusedErrorBorder: OutlineInputBorder(
      //                             borderSide: BorderSide(width: 1, color: Colors.orange),
      //                             borderRadius: BorderRadius.all(Radius.circular(10)),
      //                           ),
      //                           errorBorder: OutlineInputBorder(
      //                             borderSide: BorderSide(width: 1, color: Colors.red),
      //                             borderRadius: BorderRadius.all(Radius.circular(10)),
      //                           ),
      //                           errorStyle: TextStyle(
      //                             fontSize: 15,
      //                           ),
      //                         ),
      //                         validator: (val) {
      //                           if(val == null || val.isEmpty) {
      //                             return "Please input your Email!";
      //                           }
      //                           return null;
      //                         }
      //                     ),
      //                   ),
      //                 ),
      //                 _errorController.text.isNotEmpty
      //                     ? Container(
      //                   margin: EdgeInsets.only(bottom: 15),
      //                   padding: EdgeInsets.all(10),
      //                   decoration: BoxDecoration(
      //                     border: Border.all(
      //                       width: 1,
      //                       color: Color(0xffffccc7),
      //                     ),
      //                     color: Color(0xfffff2f0),
      //                   ),
      //                   child: Row(
      //                     children: [
      //                       Image.asset('assets/images/icons/close.png', width: 15, height: 15),
      //                       SizedBox(width: 15,),
      //                       Flexible(child: Text(_errorController.text, style: TextStyle(color: Colors.black),),),
      //                     ],
      //                   ),
      //                 ) : Container(),
      //                 Container(
      //                   child: OutlinedButton(
      //                     focusNode: _fgpwFocus,
      //                     style: OutlinedButton.styleFrom(
      //                       padding: EdgeInsets.all(15),
      //                       backgroundColor: Colors.blue,
      //                       shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
      //                     ),
      //                     child: Row(
      //                       mainAxisAlignment: MainAxisAlignment.center,
      //                       children: [
      //                         _isLoading
      //                             ? SizedBox(height: 15, width: 15, child: CircularProgressIndicator(color: Colors.white,),)
      //                             : Container(),
      //                         SizedBox(width: 10,),
      //                         Text(
      //                           'Sent reset link',
      //                           style: TextStyle(
      //                             fontSize: 15,
      //                             color: Colors.white,
      //                           ),
      //                         ),
      //                         _isLoading
      //                         ? SizedBox(width: 25,)
      //                         : SizedBox(width: 10,),
      //                       ],
      //                     ),
      //                     onPressed: () async {
      //                       _fgpwFocus.requestFocus();
      //                       if (_cpwController.currentState!.validate()) {
      //                         setState(() {
      //                           _isLoading = true;
      //                           _errorController.text = "";
      //                         });
      //                         var url = Uri.https('sandbox.api.lettutor.com', 'user/ChangePassword');
      //                         var response = await http.post(url, body: {'email': _pwController.text});
      //                         if (response.statusCode != 200) {
      //                           final Map parsed = json.decode(response.body);
      //                           final String err = parsed["message"];
      //                           setState(() {
      //                             _isLoading = false;
      //                             _errorController.text = err;
      //                           });
      //                         }
      //                         else {
      //                           setState(() {
      //                             _isLoading = false;
      //                             _errorController.text = "";
      //                           });
      //                           Navigator.popAndPushNamed(context, '/forgotpw_sent');
      //                         }
      //                       }
      //                       else setState(() {
      //                         _errorController.text = "";
      //                       });
      //                     }, //sửa sau
      //                   ),
      //                 ),
      //               ],
      //             )
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}