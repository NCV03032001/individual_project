import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

import 'package:individual_project/profileNsetting/Profile.dart';
import 'package:individual_project/authentication/Signup.dart';
import 'package:individual_project/authentication/forgotpassword/ForgotPassword.dart';
import 'package:individual_project/authentication/Login.dart';
import 'package:individual_project/authentication/forgotpassword/ForgotPassword_sent.dart';
import 'package:individual_project/profileNsetting/Setting.dart';
import 'package:individual_project/tutor/BecomeTutor.dart';
import 'package:individual_project/tutor/Tutor.dart';
import 'package:individual_project/tutor/TutorProfile.dart';
import 'package:individual_project/course/Courses.dart';
import 'package:individual_project/course/Schedule.dart';
import 'package:individual_project/course/History.dart';
import 'package:individual_project/course/CourseDetail.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Settings.init(cacheProvider: SharePreferenceCache());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ValueChangeObserver<bool>(
        cacheKey: Setting.keyDarkMode,
        defaultValue: false,

        builder: (_, isDarkMode, __) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',

          routes:  {
            '/login': (context) => Login(),
            '/tutor': (context) => Tutor(),
            '/tutor_profile': (context) => TutorProfile(),
            '/profile': (context) => Profile(),
            '/signup': (context) => Signup(),
            '/setting': (context) =>  Setting(),
            '/forgotpw': (context) => ForgotPassword(),
            '/forgotpw_sent': (context) => ForgotPassword_sent(),
            '/history' : (context) => History(),
            '/schedule' : (context) => Schedule(),
            '/courses' : (context) => Courses(),
            '/courses_detail' : (context) => CourseDetail(),
            '/become_tutor' : (context) => BecomeTutor(),
          },

          theme: isDarkMode?
          ThemeData.dark().copyWith(
            primaryColor: Colors.white,
            scaffoldBackgroundColor: Color(0xff170635),
            backgroundColor: Color(0xff170635),
            canvasColor: Color(0xff170635),
          )
              : ThemeData.light().copyWith(
            primaryColor: Color(0xff170635),
            scaffoldBackgroundColor: Colors.white,
            backgroundColor: Colors.white,
            canvasColor: Colors.white,
          ),
          home: const Login(),
        )
    );
  }
}