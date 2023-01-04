import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';

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
import 'package:individual_project/scheduleNhistory/Schedule.dart';
import 'package:individual_project/tutor/BecomeTutor.dart';
import 'package:individual_project/tutor/TutorList.dart';
import 'package:individual_project/tutor/TutorProfile.dart';
import 'package:individual_project/course/Courses.dart';
import 'package:individual_project/scheduleNhistory/History.dart';
import 'package:individual_project/course/CourseDetail.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';//
import 'package:get_storage/get_storage.dart';//

import 'LocaleString.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Settings.init(cacheProvider: SharePreferenceCache());
  await GetStorage.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final theGetController c = Get.put(theGetController());
    c.readGetStorage();

    // String? appTitle = FlavorConfig.instance.variables["appTitle"];
    // if (appTitle == null) print("Build mode: null");
    // appTitle ??= 'LetTutor - 19120713';

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => TutorProvider()),
        ChangeNotifierProvider(create: (context) => CourseList()),
        ChangeNotifierProvider(create: (context) => HistoryProvider()),
        ChangeNotifierProvider(create: (context) => ScheduleProvider()),
      ],
      child: GetMaterialApp(//
        localizationsDelegates: [
          LocaleNamesLocalizationsDelegate(),
          // ... more localization delegates
        ],
        debugShowCheckedModeBanner: false,
        translations: LocaleString(),//
        //locale: Locale('en','US'),//
        builder: (context, child) => MediaQuery(data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true), child: child!),
        locale: c.testLocale.value,//
        //title: appTitle,
        title: 'LetTutor - 19120713',

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
        },

        theme: ThemeData.light().copyWith(
          primaryColor: Color(0xff170635),
          scaffoldBackgroundColor: Colors.white,
          backgroundColor: Colors.white,
          canvasColor: Colors.white,
        ),
        darkTheme: ThemeData.dark().copyWith(
          primaryColor: Colors.white,
          scaffoldBackgroundColor: Color(0xff170635),
          backgroundColor: Color(0xff170635),
          canvasColor: Color(0xff170635),
        ),
        themeMode: c.testDark.value == true ? ThemeMode.dark : ThemeMode.light,
        home: const Login(),
      ),
    );
  }
}

class theGetController extends GetxController{
  var firstSelected  = GetStorage().read('locale') != null
      ? GetStorage().read('locale') != 'vi'
      ? 'assets/images/usaFlag.svg'.obs
      : 'assets/images/vnFlag.svg'.obs
      : 'assets/images/usaFlag.svg'.obs;

  readGetStorage() {
    print(GetStorage().read('isDark'));
    print(GetStorage().read('locale'));

    firstSelected  = GetStorage().read('locale') != null
        ? GetStorage().read('locale') != 'vi'
        ? 'assets/images/usaFlag.svg'.obs
        : 'assets/images/vnFlag.svg'.obs
        : 'assets/images/usaFlag.svg'.obs;

    testLocale = GetStorage().read('locale') != null ?
    GetStorage().read('locale') == 'vi'
        ? Locale('vi', 'VN').obs
        : Locale('en', 'US').obs
        : Locale('en', 'US').obs;

    testDark = GetStorage().read('isDark') != null
        ? GetStorage().read('isDark') == true
        ? true.obs : false.obs  : false.obs;
  }

  updateImg(String newImg) => firstSelected.value = newImg;

  var testLocale = GetStorage().read('locale') != null ?
  GetStorage().read('locale') == 'vi'
  ? Locale('vi', 'VN').obs
  : Locale('en', 'US').obs
  : Locale('en', 'US').obs;

  updateLocale(Locale newLocale) {
    testLocale.value = newLocale;
    Get.updateLocale(newLocale);
    GetStorage().write('locale', newLocale.languageCode);
  }

  var testDark = GetStorage().read('isDark') != null
  ? GetStorage().read('isDark') == true
  ? true.obs : false.obs  : false.obs;

  updateIsDark(bool val) {
    testDark.value = val;
    //Get.changeTheme(val ? ThemeData.dark() :ThemeData.light());
    Get.changeThemeMode(val ? ThemeMode.dark : ThemeMode.light);
    GetStorage().write('isDark', val);
  }
}