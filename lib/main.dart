import 'package:flutter/material.dart';
//import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:individual_project/course/CourseDiscover.dart';
import 'package:individual_project/model/Course/CourseList.dart';
import 'package:individual_project/model/ScheduleNHistory/ScheduleProvider.dart';
import 'package:individual_project/model/ScheduleNHistory/HistoryProvider.dart';
import 'package:individual_project/model/Tutor/TutorProvider.dart';
import 'package:individual_project/model/User/UserProvider.dart';

import 'package:individual_project/profileNsetting/Profile.dart';
import 'package:individual_project/authentication/Signup.dart';
import 'package:individual_project/authentication/forgotpassword/ForgotPassword.dart';
import 'package:individual_project/authentication/Login.dart';
import 'package:individual_project/authentication/forgotpassword/ForgotPassword_sent.dart';
import 'package:individual_project/profileNsetting/Setting.dart';
import 'package:individual_project/tutor/BecomeTutor.dart';
import 'package:individual_project/tutor/TutorList.dart';
import 'package:individual_project/tutor/TutorProfile.dart';
import 'package:individual_project/course/Courses.dart';
import 'package:individual_project/course/Schedule.dart';
import 'package:individual_project/course/History.dart';
import 'package:individual_project/course/CourseDetail.dart';
import 'package:individual_project/videoconference/VideoCall.dart';
import 'package:provider/provider.dart';


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
    //bool isDarkMode = false;

    return ValueChangeObserver<bool>(
        cacheKey: Setting.keyDarkMode,
        defaultValue: false,

        builder: (_, isDarkMode, __) => MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => TutorProvider()),
        ChangeNotifierProvider(create: (context) => CourseList()),
        ChangeNotifierProvider(create: (context) => HistoryProvider()),
        ChangeNotifierProvider(create: (context) => ScheduleProvider()),
      ],
      child: MaterialApp(
        localizationsDelegates: [
          LocaleNamesLocalizationsDelegate(),
          // ... more localization delegates
        ],
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',

        onGenerateRoute: (settings) {
          if (settings.name == '/tutor_profile') {
            final args = settings.arguments as ProfileArg;
            return MaterialPageRoute(
              builder: (context) {
                return TutorProfile(
                  theArg: args,
                );
              },
            );
          }
          if (settings.name == '/course_detail') {
            final args = settings.arguments as String;
            return MaterialPageRoute(
              builder: (context) {
                return CourseDetail(
                  id: args,
                );
              },
            );
          }
          if (settings.name == '/course_discover') {
            final args = settings.arguments as DiscoverArg;
            return MaterialPageRoute(
              builder: (context) {
                return CourseDiscover(
                  thisCourse: args.thisCourse,
                  index: args.index,
                );
              },
            );
          }

          assert(false, 'Need to implement ${settings.name}');
          return null;
        },

        routes:  {
          '/login': (context) => Login(),
          '/tutor': (context) => Tutor(),
          '/profile': (context) => Profile(),
          '/signup': (context) => Signup(),
          '/setting': (context) =>  Setting(),
          '/forgotpw': (context) => ForgotPassword(),
          '/forgotpw_sent': (context) => ForgotPassword_sent(),
          '/history' : (context) => History(),
          '/schedule' : (context) => Schedule(),
          '/courses' : (context) => Courses(),
          '/become_tutor' : (context) => BecomeTutor(),
          '/video_cfr' : (context) => VideoCall(),
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
      ),
    )
    );
  }
}