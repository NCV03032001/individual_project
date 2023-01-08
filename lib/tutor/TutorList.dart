import 'dart:async';
import 'dart:convert';

import 'package:country_picker/country_picker.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:individual_project/model/Tutor/TutorProvider.dart';
import 'package:individual_project/model/User/UserProvider.dart';
import 'package:individual_project/tutor/TutorProfile.dart';
import 'package:provider/provider.dart';
import 'package:time_range_picker/time_range_picker.dart';
import 'package:http/http.dart' as http;
import 'package:number_paginator/number_paginator.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:jitsi_meet_wrapper/jitsi_meet_wrapper.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../main.dart';

class Tutor extends StatefulWidget {
  const Tutor({Key? key}) : super(key: key);

  @override
  State<Tutor> createState() => _TutorState();
}

class _TutorState extends State<Tutor> {
  final FocusNode _screenFocus = FocusNode();
  bool _isLoading = false;
  bool _upcomingLoading = false;
  bool _hasUpcoming = false;
  int _countMode = 1;
  int totalLearn = 0;

  int _maxPage = 1;
  final NumberPaginatorController _pagiController = NumberPaginatorController();

  TextEditingController _errorController = TextEditingController();
  TextEditingController _upErrController = TextEditingController();
  String dateFormat = "";

  final theGetController c = Get.put(theGetController());
  

  Timer? countdownTimer;
  Duration myDuration = Duration(days: 1);
  String? userId = "";
  String? tutorId = "";
  int startTime = 0;
  int endTime = 0;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    setState(() {
      _errorController.text = "";
      _upErrController.text = "";
      tags = ['All', 'English for kids', 'English for Business', 'Conversational', 'STARTERS', 'MOVERS', 'FLYERS', 'KET', 'PET', 'IELTS', 'TOEFL', 'TOEIC'];
      isSelectedTag = List.generate(tags.length, (index) => false);
      isSelectedTag[0] = true;
      _isLoading = true;
      _upcomingLoading = true;
      _hasUpcoming = false;
      totalLearn = 0;
    });
    getUpcomingLesson();
    searchTutorList();
  }
  /// Timer related methods ///
  void startTimer(int mode, Duration endDur) {
    countdownTimer =
        Timer.periodic(Duration(seconds: 1), (_) => setCountDown(mode, endDur));
  }
  void stopTimer() {
    setState(() => countdownTimer!.cancel());
  }
  void resetTimer() {
    stopTimer();
    getUpcomingLesson();
  }
  void setCountDown(int mode, Duration endDur) {
    const reduceSecondsBy = 1;
    final endGap = endDur.inSeconds;
    if (mode == -1) {
      setState(() {
        final seconds = myDuration.inSeconds + reduceSecondsBy;
        if (seconds >= endGap) {
          resetTimer();
        } else {
          myDuration = Duration(seconds: seconds);
        }
      });
    }
    else {
      setState(() {
        final seconds = myDuration.inSeconds - reduceSecondsBy;
        if (seconds < 0) {
          resetTimer();
        } else {
          myDuration = Duration(seconds: seconds);
        }
      });
    }
  }

  List<String> tooltipMsg = ['terrible', 'bad', 'normal', 'good', 'wonderful'];

  final TextEditingController _nController = TextEditingController();
  final FocusNode _nFocus = FocusNode();

  List<String> selectedNation = [];
  final _ntKey = GlobalKey<DropdownSearchState<String>>();

  final FocusNode _ntFocus = FocusNode();
  List<Map<String, dynamic>> nationList = [
    {"nation": "Foreign Tutor", "nationClause": {"isVietNamese": false, "isNative": false}},
    {"nation": "Vietnamese Tutor", "nationClause": {"isVietNamese": true}},
    {"nation": "Native English Tutor", "nationClause": {"isNative": true}},
  ];

  DateTime selectedDate = DateTime.now();
  final TextEditingController _dController = TextEditingController();
  final FocusNode _dFocus = FocusNode();

  _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
    );
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      setState(() {
        _dController.text = "${selectedDate.toLocal()}".split(' ')[0];
        _dFocus.requestFocus();
      });
    }
  }

  TimeOfDay initS = TimeOfDay(hour: 7, minute: 0);
  TimeOfDay initE = TimeOfDay(hour: 8, minute: 0);

  final TextEditingController _tController = TextEditingController();
  final FocusNode _tFocus = FocusNode();

  List<String> tags = [];
  List<bool> isSelectedTag = [];
  List<Map<String, String>> specList = [
    {'inJson': 'business-english', 'toShow': 'English for Business'},
    {'inJson': 'conversational-english', 'toShow': 'Conversational'},
    {'inJson': 'english-for-kids', 'toShow': 'English for kids'},
    {'inJson': 'starters', 'toShow': 'STARTERS'},
    {'inJson': 'movers', 'toShow': 'MOVERS'},
    {'inJson': 'flyers', 'toShow': 'FLYERS'},
    {'inJson': 'ket', 'toShow': 'KET'},
    {'inJson': 'pet', 'toShow': 'PET'},
    {'inJson': 'ielts', 'toShow': 'IELTS'},
    {'inJson': 'toefl', 'toShow': 'TOEFL'},
    {'inJson': 'toeic', 'toShow': 'TOEIC'},
  ];

  final FocusNode _tgFocus = FocusNode();

  final FocusNode _searchFocus = FocusNode();
  final FocusNode _rsFocus = FocusNode();

  void searchTutorList({Map<String, dynamic> postBody = const {
    "filters": {
      "date": null,
      "nationality": {},
      "specialties": [],
      "tutoringTimeAvailable": [null, null]
    },
    "page": "1",
    "perPage": 9,
    "search": "",
  }, }
  ) async {
    var url = Uri.https('sandbox.api.lettutor.com', 'tutor/search');
    var response = await http.post(url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': "Bearer ${context.read<UserProvider>().thisTokens.access.token}"
      },
      body: jsonEncode(postBody)
    );
    if (response.statusCode != 200) {
      final Map parsed = json.decode(response.body);
      final String err = parsed["message"];
      setState(() {
        _errorController.text = err;
      });
    }
    else {
      final Map parsed = json.decode(response.body);
      //print(parsed);
      var tutorProv = Provider.of<TutorProvider>(context, listen: false);
      tutorProv.fromSearchJson(parsed);
      setState(() {
        _errorController.text = "";
      });
    }
    setState(() {
      _isLoading = false;
      var maxCount = context.read<TutorProvider>().count;
      if (maxCount~/9 < maxCount/9) {
        _maxPage = maxCount~/9 + 1;
      }
      else {
        _maxPage = maxCount~/9;
      }

      if (_maxPage < 1) _maxPage = 1;
    });
  }

  void getUpcomingLesson() async{
    var timeStampNow = DateTime.now().millisecondsSinceEpoch.toString();

    String thisToken = context.read<UserProvider>().thisTokens.access.token;

    Map<String, dynamic> queryParameters = {"dateTime": timeStampNow};
    var url = Uri.https('sandbox.api.lettutor.com', 'booking/next', queryParameters);
    var response = await http.get(url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': "Bearer $thisToken"
      },
    );

    if (response.statusCode != 200) {
      final Map parsed = json.decode(response.body);
      final String err = parsed["message"];
      setState(() {
        _upErrController.text = err;
      });
    }
    else {
      final Map parsed = json.decode(response.body);
      var nextL = parsed["data"].length;

      if (nextL != 0) {
        int timeNow = DateTime.now().millisecondsSinceEpoch;
        List<Map<String, dynamic>> nextList = List.generate(nextL, (index) {
          return {
            'start': parsed['data'][index]['scheduleDetailInfo']['startPeriodTimestamp'],
            'end': parsed['data'][index]['scheduleDetailInfo']['endPeriodTimestamp'],
            'userId': parsed['data'][index]['userId'],
            'tutorId': parsed['data'][index]['scheduleDetailInfo']['scheduleInfo']['tutorId']
          };
        });
        nextList.sort((a, b) => a['start'].compareTo(b['start']));
        //print(nextList);
        startTime = nextList[0]['start'];
        endTime = nextList[0]['end'];
        userId = nextList[0]['userId'];
        tutorId = nextList[0]['tutorId'];

        if (endTime < timeNow) {
          for (var i = 1; i < nextL; i++) {
            startTime = nextList[i]['start'];
            endTime = nextList[i]['end'];
            userId = nextList[i]['userId'];
            tutorId = nextList[i]['tutorId'];
            if (endTime >= timeNow) {
              break;
            }
          }
        }

        setState(() {
          _hasUpcoming = false;
          return;
        });

        setState(() {
          dateFormat = "${DateFormat('EEE, d MMM, yyyy, HH:mm', c.testLocale.value.languageCode).format(DateTime.fromMillisecondsSinceEpoch(startTime))} - ${DateFormat('HH:mm', c.testLocale.value.languageCode).format(DateTime.fromMillisecondsSinceEpoch(endTime))}";
          myDuration = Duration(milliseconds: startTime - timeNow);
          if (myDuration.isNegative) {
            myDuration = -myDuration;
            _countMode = -1;
          }
          _hasUpcoming = true;
        });

        var endDur = Duration(milliseconds: endTime - timeNow);
        startTimer(_countMode, endDur);
      }
      else {
        setState(() {
          _hasUpcoming = false;
        });
      }
    }

    var urlTotal = Uri.https('sandbox.api.lettutor.com', 'call/total');
    var responseTotal = await http.get(urlTotal,
      headers: {
        "Content-Type": "application/json",
        'Authorization': "Bearer $thisToken"
      },
    );
    if (responseTotal.statusCode == 200) {
      final Map parsed = json.decode(responseTotal.body);
      setState(() {
        totalLearn = parsed["total"];
      });
    }

    setState(() {
      _upErrController.text = "";
      _upcomingLoading = false;
    });
  }

  final Map<String, dynamic> postBody = {
    "filters": {
      "date": null,
      "nationality": {},
      "specialties": [],
      "tutoringTimeAvailable": [null, null]
    },
    "page": 1,
    "perPage": 9
  };

  @override
  void dispose() {
    stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var readTutorProv = context.read<TutorProvider>();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    
    String strDigits(int n) => n.toString().padLeft(2, '0');
    final hours = strDigits(myDuration.inHours);
    final minutes = strDigits(myDuration.inMinutes.remainder(60));
    final seconds = strDigits(myDuration.inSeconds.remainder(60));

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
                Navigator.pushReplacementNamed(context, '/tutor');
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
                  Navigator.pushReplacementNamed(context, '/tutor');
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
                  Navigator.pushNamed(context, '/setting');
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
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF0C3DDF), Color(0xFF05179D)]
                    )
                ),
                child: Center(
                  child: _upcomingLoading == true
                    ? CircularProgressIndicator(color: Colors.white,)
                    : _upErrController.text.isNotEmpty
                    ? Text(_upErrController.text)
                    : _hasUpcoming == false
                    ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.only(bottom: 15),
                          child: Text(
                            'You have no upcoming lesson'.tr,
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          child: totalLearn > 0
                          ? Text(
                            '${'Total lesson time is'.tr} ${totalLearn~/60} ${'hours'.tr} ${totalLearn%60} ${'minutes'.tr}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          )
                          : Text(
                            'Welcome to LetTutor!'.tr,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    )
                    : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.only(bottom: 15),
                          child: Text(
                            'Upcoming lesson'.tr,
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 5),
                          child: Text(
                            dateFormat,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: _countMode > 0
                            ? Text(
                            '${'(starts in'.tr} $hours:$minutes:$seconds)',
                            style: TextStyle(
                              color: Colors.yellow,
                              fontSize: 15,
                            ),
                          )
                          : Text(
                            '${'(class time'.tr} $hours:$minutes:$seconds)',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () async{
                            var userInfo = context.read<UserProvider>().thisUser;

                            var options = JitsiMeetingOptions(
                              roomNameOrUrl: "${userId}-${tutorId}",
                              serverUrl: "https://meet.lettutor.com",
                              isAudioMuted: true,
                              isVideoMuted: true,
                              userDisplayName: "${userInfo.name}",
                              userEmail: "${userInfo.email}",
                              configOverrides: {
                                'prejoinPageEnabled': false //This here
                              },
                            );

                            await JitsiMeetWrapper.joinMeeting(
                              options: options,
                              listener: JitsiMeetingListener(
                                onConferenceWillJoin: (url) => print("onConferenceWillJoin: url: $url"),
                                onConferenceJoined: (url) => print("onConferenceJoined: url: $url"),
                                onConferenceTerminated: (url, error) => print("onConferenceTerminated: url: $url, error: $error"),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: EdgeInsets.all(15),
                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
                          ),
                          child: RichText(
                            text: TextSpan(
                                children: [
                                  WidgetSpan(
                                      child: SizedBox(
                                        height: 20,
                                        child: Image.asset('assets/images/icons/Ytb.png', color: Colors.blue,),
                                      )
                                  ),
                                  TextSpan(
                                    text: '  ',
                                  ),
                                  TextSpan(
                                      text: 'Enter lesson room'.tr,
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 20,
                                      )
                                  )
                                ]
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          child: totalLearn > 0
                              ? Text(
                            '${'Total lesson time is'.tr} ${totalLearn~/60} ${'hours'.tr} ${totalLearn%60} ${'minutes'.tr}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          )
                              : Text(
                            'Welcome to LetTutor!'.tr,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),

                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Find a tutor'.tr,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 5),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Specify tutor detail:'.tr,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        focusNode: _nFocus,
                        controller: _nController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 0),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1, color: Colors.grey),
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1, color: Colors.blue),
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                          ),
                          hintText: 'Enter tutor name...'.tr,
                          suffixIcon: (_nController.text.isNotEmpty && _nFocus.hasFocus) ?
                          IconButton(onPressed: () {setState(() {
                            _nController.clear();
                            _nFocus.requestFocus();
                            _nFocus.unfocus();
                          });}, icon: Icon(Icons.clear)) :
                          Icon(Icons.search_outlined),
                        ),
                        onChanged: (val) => {
                          if (_nController.text.isEmpty || _nController.text.length == 1) {
                            setState(() {
                            })
                          }
                        },
                        onTap: () {
                          setState(() {
                            _nFocus.requestFocus();
                          });
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Focus(
                          focusNode: _ntFocus,
                          child: Listener(
                            onPointerDown: (_) {
                              FocusScope.of(context).requestFocus(_ntFocus);
                            },
                            child: DropdownSearch<String>.multiSelection(
                              selectedItems: selectedNation,
                              key: _ntKey,
                              items: nationList.map((e) => e['nation'].toString().tr).toList(),
                              popupProps: PopupPropsMultiSelection.menu(
                                showSelectedItems: true,
                                showSearchBox: true,
                              ),
                              clearButtonProps: ClearButtonProps(
                                isVisible: true,
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.zero,
                              ),
                              dropdownButtonProps: DropdownButtonProps(
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.only(right: 12),
                              ),
                              dropdownDecoratorProps: DropDownDecoratorProps(
                                dropdownSearchDecoration: InputDecoration(
                                  contentPadding: EdgeInsets.fromLTRB(20, 15, 0, 0),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1, color: Colors.grey),
                                    borderRadius: BorderRadius.all(Radius.circular(50)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1, color: Colors.blue),
                                    borderRadius: BorderRadius.all(Radius.circular(50)),
                                  ),
                                  hintText: 'Select tutor nationnality'.tr,
                                ),
                              ),
                              onChanged: (val) {
                                setState(() {
                                  _ntFocus.requestFocus();
                                });
                              },
                            ),
                          )
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 5),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Select available tutoring time'.tr,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              focusNode: _dFocus,
                              controller: _dController,
                              autovalidateMode: AutovalidateMode.always,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.fromLTRB(20, 15, 0, 0),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1, color: Colors.grey),
                                  borderRadius: BorderRadius.all(Radius.circular(50)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1, color: Colors.blue),
                                  borderRadius: BorderRadius.all(Radius.circular(50)),
                                ),
                                hintText: 'Date'.tr,
                                suffixIcon: (_dController.text.isNotEmpty && _dFocus.hasFocus) ?
                                IconButton(onPressed: () {setState(() {
                                  _dController.clear();
                                  selectedDate = DateTime.now();
                                  _dFocus.requestFocus();
                                  _dFocus.unfocus();
                                });}, icon: Icon(Icons.clear)) :
                                Icon(Icons.calendar_month_outlined),
                              ),
                              readOnly: true,
                              onTap: () => _selectDate(context),
                            ),
                          ),
                          flex: 4,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              controller: _tController,
                              focusNode: _tFocus,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.fromLTRB(20, 15, 0, 0),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1, color: Colors.grey),
                                  borderRadius: BorderRadius.all(Radius.circular(50)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1, color: Colors.blue),
                                  borderRadius: BorderRadius.all(Radius.circular(50)),
                                ),
                                hintText: 'Time range'.tr,
                                suffixIcon: (_tController.text.isNotEmpty && _tFocus.hasFocus) ?
                                IconButton(onPressed: () {setState(() {
                                  _tController.clear();
                                  initS = TimeOfDay(hour: 7, minute: 0);
                                  initE = TimeOfDay(hour: 8, minute: 0);
                                  _tFocus.requestFocus();
                                  _tFocus.unfocus();
                                });}, icon: Icon(Icons.clear)) :
                                Container(
                                    width: 42,
                                    child: Center(
                                      child: SizedBox(
                                        width: 21,
                                        height: 21,
                                        child: Image.asset('assets/images/icons/Clock.png', color: _tFocus.hasFocus ? Colors.blue : Colors.grey,),
                                      ),
                                    )
                                ),
                              ),
                              readOnly: true,
                              onTap: () async {
                                TimeRange? result = await showTimeRangePicker(
                                  context: context,
                                  strokeWidth: 4,
                                  timeTextStyle: TextStyle(
                                      color: Colors.orange[700],
                                      fontSize: 24,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold),
                                  activeTimeTextStyle: const TextStyle(
                                      color: Colors.orange,
                                      fontSize: 26,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold),
                                  ticks: 12,
                                  ticksOffset: 2,
                                  ticksLength: 8,
                                  handlerRadius: 8,
                                  ticksColor: Colors.grey,
                                  rotateLabels: false,
                                  interval: const Duration(minutes: 30),
                                  minDuration: const Duration(hours: 1),
                                  labels: [
                                    "24 h",
                                    "3 h",
                                    "6 h",
                                    "9 h",
                                    "12 h",
                                    "15 h",
                                    "18 h",
                                    "21 h"
                                  ].asMap().entries.map((e) {
                                    return ClockLabel.fromIndex(idx: e.key, length: 8, text: e.value);
                                  }).toList(),
                                  disabledTime: TimeRange(
                                      startTime: const TimeOfDay(hour: 0, minute: 0),
                                      endTime: const TimeOfDay(hour: 7, minute: 0)),
                                  disabledColor: Colors.red,
                                  labelOffset: 30,
                                  padding: 55,
                                  labelStyle: const TextStyle(fontSize: 18, color: Colors.grey,),
                                  start: initS,
                                  end: initE,
                                  clockRotation: 180.0,
                                );
                                if (result != null)  {
                                  var sh = result.startTime.hour > 9 ? result.startTime.hour.toString() : ('0' + result.startTime.hour.toString());
                                  var sm = result.startTime.minute > 9 ? result.startTime.minute.toString() : ('0' + result.startTime.minute.toString());
                                  var eh = result.endTime.hour > 9 ? result.endTime.hour.toString() : ('0' + result.endTime.hour.toString());
                                  var em = result.endTime.minute > 9 ? result.endTime.minute.toString() : ('0' + result.endTime.minute.toString());
                                  setState(() {
                                    _tController.text = sh + ':' + sm + ' --> ' + eh + ':' + em;
                                    _tFocus.requestFocus();
                                    initS = TimeOfDay(hour: result.startTime.hour, minute: result.startTime.minute);
                                    initE = TimeOfDay(hour: result.endTime.hour, minute: result.endTime.minute);
                                  });
                                }
                              },
                            ),
                          ),
                          flex: 5,
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 5),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Select specialtie:'.tr,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Wrap(
                      runSpacing: 5,
                      spacing: 5,
                      //key: ValueKey('tag'),
                      children: List.generate(tags.length, (i) {
                        return ChoiceChip(
                          label: Text(tags[i].tr),
                          selected: isSelectedTag[i],
                          selectedColor: Colors.blue,
                          focusNode: _tgFocus,
                          labelStyle: TextStyle(
                            fontSize: 15,
                          ),
                          onSelected: (isSltd) => setState(() {
                            _tgFocus.requestFocus();
                            if (isSelectedTag[i] == true) return;
                            isSelectedTag = List.generate(tags.length, (index) => false);
                            isSelectedTag[i] = true;
                          }),
                        );
                      })
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.all(10),
                            child: OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  _searchFocus.requestFocus();
                                  _isLoading = true;
                                });
                                if (_nController.text.isNotEmpty) {
                                  postBody['search'] = _nController.text;
                                }
                                else postBody.remove('search');

                                Map<String, bool> nationMap = {};
                                List<String> tempNations = _ntKey.currentState!.getSelectedItems;
                                tempNations.forEach((element) {
                                  var tempNL = nationList.indexWhere((e) => e['nation'].toString().tr == element);
                                  if (nationList[tempNL]['nationClause']['isVietNamese'] != null) {
                                    if(nationMap['isVietNamese'] == null) {
                                      nationMap['isVietNamese'] = nationList[tempNL]['nationClause']['isVietNamese'];
                                    }
                                    else if(nationMap['isVietNamese'] != null) {
                                      if (nationMap['isVietNamese']! || nationList[tempNL]['nationClause']['isVietNamese']) {
                                        nationMap.remove('isVietNamese');
                                      }
                                    }
                                  }
                                  if (nationList[tempNL]['nationClause']['isNative'] != null) {
                                    if(nationMap['isNative'] == null) {
                                      nationMap['isNative'] = nationList[tempNL]['nationClause']['isNative'];
                                    }
                                    else if(nationMap['isNative'] != null) {
                                      if (nationMap['isNative']! || nationList[tempNL]['nationClause']['isNative']) {
                                        nationMap.remove('isNative');
                                      }
                                    }
                                  }
                                });
                                postBody['filters']['nationality'] = nationMap;

                                if(_dController.text.isNotEmpty) {
                                  String tempDate = _dController.text;
                                  DateTime tempDatetime = DateTime.parse(tempDate);
                                  postBody['filters']['date'] = tempDate;

                                  if(_tController.text.isEmpty) {
                                    int tempStart = tempDatetime.millisecondsSinceEpoch;
                                    int tempEnd = tempDatetime.add(Duration(days: 1)).millisecondsSinceEpoch;
                                    postBody['filters']['tutoringTimeAvailable'] = [tempStart, tempEnd];
                                  }
                                  else {
                                    int tempStart = tempDatetime.add(Duration(hours: initS.hour, minutes: initS.minute)).millisecondsSinceEpoch;
                                    int tempEnd = tempDatetime.add(Duration(hours: initE.hour, minutes: initE.minute)).millisecondsSinceEpoch;
                                    postBody['filters']['tutoringTimeAvailable'] = [tempStart, tempEnd];
                                  }
                                }
                                else {
                                  postBody['filters']['date'] = null;
                                  postBody['filters']['tutoringTimeAvailable'] = [null, null];
                                }

                                if (specList.indexWhere((element) => element['toShow'] == tags[isSelectedTag.indexWhere((element) => element == true)]) >= 0) {
                                  String? tempSpec = specList[specList.indexWhere((
                                      element) => element['toShow'] ==
                                      tags[isSelectedTag.indexWhere((
                                          element) => element == true)])]['inJson'];
                                  postBody['filters']['specialties'].add(tempSpec);
                                }
                                else {
                                  postBody['filters']['specialties'] = [];
                                }
                                _pagiController.currentPage = 0;
                                postBody['page'] = 1;

                                print(postBody);
                                searchTutorList(postBody: postBody);
                              },
                              focusNode: _searchFocus,
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                backgroundColor: Colors.white,
                                side: BorderSide(color: Colors.blue, width: 2),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(50)),
                                ),
                              ),
                              child: Text(
                                'Search'.tr,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.all(10),
                            child: OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  _rsFocus.requestFocus();
                                  _nController.clear();
                                  selectedDate = DateTime.now();
                                  _dController.clear();
                                  initS = TimeOfDay(hour: 7, minute: 0);
                                  initE = TimeOfDay(hour: 8, minute: 0);
                                  _tController.clear();
                                  selectedNation = [];
                                  _ntKey.currentState?.popupValidate(selectedNation);
                                  isSelectedTag = List.generate(tags.length, (index) => false);
                                  isSelectedTag[0] = true;
                                });
                              },
                              focusNode: _rsFocus,
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                backgroundColor: Colors.white,
                                side: BorderSide(color: Colors.blue, width: 2),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(50)),
                                ),
                              ),
                              child: Text(
                                'Reset Filters'.tr,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      thickness: 2,
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 15, 0, 30),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Recommened Tutors'.tr,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    _isLoading == true
                        ? CircularProgressIndicator()
                        : _errorController.text.isEmpty
                        ? readTutorProv.theList.isNotEmpty
                        ? SizedBox(
                      height: 375,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: List.generate(readTutorProv.theList.length, (i) {
                          return Row(
                            children: [
                              Container(
                                width: width-30,
                                margin: EdgeInsets.only(bottom: 10),
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  color: Theme.of(context).backgroundColor,
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 120,
                                          width: 100,
                                          child: readTutorProv.theList[i].avatar != null
                                              ? ImageProfile(Image.network(readTutorProv.theList[i].avatar!).image, readTutorProv.theList[i].isOnline!, ProfileArg(readTutorProv.theList[i].userId, postBody))
                                              : ImageProfile(Image.network("").image, readTutorProv.theList[i].isOnline!, ProfileArg(readTutorProv.theList[i].userId, postBody)),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: SizedBox(
                                            child: Column(
                                              children: [
                                                GestureDetector(
                                                  onTap: () => Navigator.pushNamed(context, '/tutor_profile', arguments: ProfileArg(readTutorProv.theList[i].userId, postBody)),
                                                  child: Container(
                                                    alignment: Alignment.centerLeft,
                                                    padding: EdgeInsets.only(left: 10),
                                                    margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                                    child: Text(
                                                      readTutorProv.theList[i].name,
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis ,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.only(left: 10),
                                                  margin: EdgeInsets.only(bottom: 10),
                                                  child: readTutorProv.theList[i].country != null
                                                      ? Country.tryParse(readTutorProv.theList[i].country!) != null
                                                      ? Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 20,
                                                        height: 20,
                                                        child: Text(Country.tryParse(readTutorProv.theList[i].country!)!.flagEmoji),
                                                      ),
                                                      SizedBox(width: 10),
                                                      Text(Country.tryParse(readTutorProv.theList[i].country!)!.name),
                                                    ],
                                                  )
                                                      : Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 20,
                                                        height: 20,
                                                        child: Image.asset('assets/images/icons/close.png'),
                                                      ),
                                                      SizedBox(width: 10),
                                                      Text("Invalid country"),
                                                    ],
                                                  )
                                                      : Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 20,
                                                        height: 20,
                                                        child: Image.asset('assets/images/icons/close.png'),
                                                      ),
                                                      SizedBox(width: 10),
                                                      Text("Not set country".tr),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.only(left: 10),
                                                  margin: EdgeInsets.only(bottom: 10),
                                                  alignment: Alignment.centerLeft,
                                                  child: readTutorProv.theList[i].rating != null
                                                      ? Row(
                                                      children: []..addAll(List.generate(readTutorProv.theList[i].rating!.toInt(), (index) {
                                                        return Tooltip(
                                                          message: tooltipMsg[index].tr,
                                                          child: Icon(Icons.star, color: Colors.yellow,),
                                                        );
                                                      }))
                                                        ..addAll(List.generate((5-readTutorProv.theList[i].rating!.toInt()), (index) {
                                                          return Tooltip(
                                                            message: tooltipMsg[4-index].tr,
                                                            child: Icon(Icons.star, color: Colors.grey,),
                                                          );
                                                        }).reversed)
                                                  )
                                                      : Text('No review yet'.tr, style:  TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                  ),),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            var url = Uri.https('sandbox.api.lettutor.com', 'user/manageFavoriteTutor');
                                            var response = await http.post(url,
                                                headers: {
                                                  'Content-Type': 'application/json',
                                                  'Authorization': 'Bearer ${context.read<UserProvider>().thisTokens.access.token}',
                                                },
                                                body: jsonEncode({'tutorId': readTutorProv.theList[i].userId})
                                            );

                                            if (response.statusCode != 200) {
                                              final Map parsed = json.decode(response.body);
                                              final String err = parsed["message"];
                                              setState(() {
                                                _errorController.text = err;
                                              });
                                            }
                                            else {
                                              searchTutorList(postBody: postBody);
                                              setState(() {
                                                _errorController.text = "";
                                              });
                                            }
                                          },
                                          icon: readTutorProv.theList[i].isFavorite!
                                              ? Image.asset('assets/images/icons/Heart.png', color: Colors.red,)
                                              : Image.asset('assets/images/icons/Heart_outline.png', color: Colors.blue,),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
                                      height: 50,
                                      width: double.infinity,
                                      child: SingleChildScrollView(
                                        child: Wrap(
                                          runSpacing: 5,
                                          spacing: 5,
                                          crossAxisAlignment: WrapCrossAlignment.start,
                                          verticalDirection: VerticalDirection.down,
                                          children: readTutorProv.theList[i].specialties.split(',').map((value) => Container(
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                width: 1,
                                                color: Colors.grey,
                                              ),
                                              borderRadius: BorderRadius.circular(20),
                                              color: Colors.blue,
                                            ),
                                            child: specList.indexWhere((e) => e['inJson'] == value) != -1
                                                ? Text(specList.firstWhere((sl) => sl['inJson'] == value)['toShow']!.tr)
                                                : Text(value.toUpperCase()),
                                          )).toList(),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 70,
                                      alignment: Alignment.topLeft,
                                      margin: EdgeInsets.only(bottom: 15),
                                      child: Text(
                                        readTutorProv.theList[i].bio,
                                        maxLines: 4,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      alignment: Alignment.centerRight,
                                      child: ElevatedButton.icon(
                                        onPressed: () => Navigator.pushNamed(context, '/tutor_profile', arguments: ProfileArg(readTutorProv.theList[i].userId, postBody)),
                                        style: OutlinedButton.styleFrom(
                                          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                          backgroundColor: Colors.white,
                                          side: BorderSide(color: Colors.blue, width: 2),
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(20)),
                                          ),
                                        ),
                                        icon: SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: Image.asset('assets/images/icons/Book.png', color: Colors.blue,),
                                        ),
                                        label: Text(
                                          'Book'.tr,
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                            ],
                          );
                        }),
                      ),
                    ) : Text("No Tutor found.".tr)
                        : Text(_errorController.text),
                    NumberPaginator(
                      controller: _pagiController,
                      // by default, the paginator shows numbers as center content
                      numberPages: _maxPage,
                      initialPage: 0,
                      onPageChange: (int index) {
                        postBody['page'] = _pagiController.currentPage + 1;
                        searchTutorList(postBody: postBody);
                        //var queryParameters = {'perPage': '9','page': (_pagiController.currentPage + 1).toString(),};
                        //getPreTutorList(queryParameters: queryParameters);
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        /*floatingActionButton: FloatingActionButton(
          onPressed: () {

          },
          backgroundColor: Colors.grey,
          child: const Icon(Icons.message_outlined),
        ),*/
      ),
    );
  }

  Widget ImageProfile(ImageProvider input, bool online, ProfileArg arg) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/tutor_profile' , arguments: arg),
          child: CircleAvatar(
            radius: 80.0,
            backgroundImage: input,
          ),
        ),
        online
        ? Positioned(
            bottom: 10,
            right: 10,
            child: Icon(Icons.circle, color: Colors.green,)
        )
        : Container(),
      ],
    );
  }
}