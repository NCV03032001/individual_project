import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../main.dart';

class ForgotPassword_sent extends StatefulWidget {
  const ForgotPassword_sent({Key? key}) : super(key: key);

  @override
  State<ForgotPassword_sent> createState() => _ForgotPassword_sentState();
}

class _ForgotPassword_sentState extends State<ForgotPassword_sent> {
  final theGetController c = Get.put(theGetController());

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
                        (route) {return false;});
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
                      Text('English'.tr)
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
                        'Reset Password'.tr,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                  ),
                  Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Text(
                        'Check your inbox for a link to reset your password.'.tr,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      )
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}