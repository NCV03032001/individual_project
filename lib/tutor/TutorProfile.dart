import 'dart:convert';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:individual_project/model/Tutor/Tutor.dart';
import 'package:individual_project/model/User/UserProvider.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../model/Tutor/TutorProvider.dart';

class TutorProfile extends StatefulWidget {
  final ProfileArg theArg;

  const TutorProfile({Key? key, required this.theArg}) : super(key: key);

  @override
  State<TutorProfile> createState() => _TutorProfileState();
}

class _TutorProfileState extends State<TutorProfile> {
  String _firstSelected = Get.locale?.languageCode == 'vi' ? 'assets/images/vnFlag.svg' : 'assets/images/usaFlag.svg';
  bool _isLoading = false;

  Tutor thisTutor = Tutor(
      name: "", isPublicRecord: false, courses: [],
      userId: "", video: "", bio: "", education: "", experience: "", profession: "",
      targetStudent: "", interests: "", languages: "", specialties: "", toShow: false);

  final TextEditingController _rpController = TextEditingController();
  bool firstVal = false;
  bool secondVal = false;
  bool thirdVal = false;

  final FocusNode _dialogFocus = FocusNode();
  bool _isFbLoading = false;
  List<FeedbackItem> fbList = [];
  final TextEditingController _fbError = TextEditingController();
  int _maxFbPage = 1;
  Locale? appLocal = Get.locale;

  final TextEditingController _errorController = TextEditingController();
  String _videoErr = "";

  List<String> tooltipMsg = ['terrible', 'bad', 'normal', 'good', 'wonderful'];
  List<Map<String, String>> specList = [
    {'inJson': 'business-english', 'toShow': 'English for Business'},
    {'inJson': 'conversational-english', 'toShow': 'Conversational'},
    {'inJson': 'english-for-kids', 'toShow': 'English for kids'},
    {'inJson': 'starters', 'toShow': 'STARTERS'},
    {'inJson': 'movers', 'toShow': 'MOVERS'},
    {'inJson': 'flyers', 'toShow': 'FLYERS'},
    {'inJson': 'ket', 'toShow': 'PET'},
    {'inJson': 'ielts', 'toShow': 'IELTS'},
    {'inJson': 'toefl', 'toShow': 'TOEFL'},
    {'inJson': 'toeic', 'toShow': 'TOEIC'},
  ];

  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  final CalendarController _calendarController = CalendarController();

  @override
  void initState() {
    super.initState();
    _calendarController.selectedDate = now;
    setState(() {
      _isLoading = true;
      _errorController.text = "";
    });
    getATutor();
    query['startTimestamp'] = getDate(now).millisecondsSinceEpoch.toString();
    query['endTimestamp'] = (getDate(now.add(Duration(days: DateTime.daysPerWeek))).millisecondsSinceEpoch - 1).toString();
  }

  void getATutor() async {
    var url = Uri.https('sandbox.api.lettutor.com', 'tutor/${widget.theArg.id}');
    var response = await http.get(url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': "Bearer ${context.read<UserProvider>().thisTokens.access.token}"
      },
    );

    if (response.statusCode != 200) {
      final Map parsed = json.decode(response.body);
      final String err = parsed["message"];
      setState(() {
        _errorController.text = err;
      });
    }
    else {
      final Map<String, dynamic> parsed = json.decode(response.body);
      setState(() {
        thisTutor = Tutor.fromDetailJson(parsed);
        _errorController.text = "";
      });
    }

    _videoPlayerController = VideoPlayerController.network(thisTutor.video)..addListener(() {
      if (_videoPlayerController.value.hasError) {
        setState(() {
          _videoErr = _videoPlayerController.value.errorDescription!;
          _isLoading = false;
          return;
        });
      }
    });
    await _videoPlayerController.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
    );

    setState(() {
      _isLoading = false;
    });
  }

  final Map<String, dynamic> query = {
    //"tutorId" : thisTutor.id,
    //"startTimestamp": getDate(now).millisecondsSinceEpoch,
    //"endTimestamp": 9
  };

  final now = DateTime.now();
  List<TutorSchedule> scheList = [];
  TextEditingController _noteController = TextEditingController();

  DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);

  void getTimeSheet(/*{int start = -1, int end = -1}*/) async {
    query['tutorId'] = thisTutor.userId;
    var url = Uri.https('sandbox.api.lettutor.com', 'schedule', query);
    var response = await http.get(url);
    if (response.statusCode != 200) {
      final Map parsed = json.decode(response.body);
      final String err = parsed["message"];
      print(err);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error getting Tutor\'s Schedule: $err', style: TextStyle(color: Colors.red),),
          duration: Duration(seconds: 3),
        ),
      );
    }
    else {
      final Map<String, dynamic> parsed = json.decode(response.body);
      setState(() {
        scheList = List.from(parsed['scheduleOfTutor']).map((e) => TutorSchedule.fromJson(e['scheduleDetails'][0])).toList();
      });
    }
  }

  Appointment makeAppoint(TutorSchedule aSch) {
    if (aSch.isBooked && aSch.bookingInfo.isNotEmpty) {
      String tempId = aSch.bookingInfo.firstWhere((element) => !element.isDeleted).userId;
      String thisUserId = context.read<UserProvider>().thisUser.id;
      if (tempId == thisUserId) {
        return Appointment(
          startTime: DateTime.fromMillisecondsSinceEpoch(aSch.startPeriodTimestamp),
          endTime: DateTime.fromMillisecondsSinceEpoch(aSch.endPeriodTimestamp),
          subject: 'Booked',
          id: aSch.id,
        );
      }
      else {
        return Appointment(
          startTime: DateTime.fromMillisecondsSinceEpoch(aSch.startPeriodTimestamp),
          endTime: DateTime.fromMillisecondsSinceEpoch(aSch.endPeriodTimestamp),
          subject: 'Reserved',
          id: aSch.id,
        );
      }
    }
    return Appointment(
      startTime: DateTime.fromMillisecondsSinceEpoch(aSch.startPeriodTimestamp),
      endTime: DateTime.fromMillisecondsSinceEpoch(aSch.endPeriodTimestamp),
      subject: 'Book',
      id: aSch.id,
    );
  }

  _AppointmentDataSource _getCalendarDataSource() {
    List<Appointment> appointments = <Appointment>[];
    for (var element in scheList) {
      appointments.add(makeAppoint(element));
    }
    return _AppointmentDataSource(appointments);
  }

  void bookClass(String id, String note) async {
    var url = Uri.https('sandbox.api.lettutor.com', 'booking');
    var response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          'Authorization': "Bearer ${context.read<UserProvider>().thisTokens.access.token}"
        },
        body: jsonEncode({"scheduleDetailIds": [id], "note": note})
    );
    if (response.statusCode != 200) {
      final Map parsed = json.decode(response.body);
      final String err = parsed["message"];
      showDialog(
        context: context,
        builder: (BuildContext context) {
          double width = MediaQuery.of(context).size.width;
          double height = MediaQuery.of(context).size.height;
          return AlertDialog(
            title: Text('Booking details'.tr),
            content: Container(
              constraints: BoxConstraints(
                maxHeight: height/2,
              ),
              width: width - 30,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 60,
                      height: 100,
                      child: Image.asset('assets/images/icons/close.png'),
                    ),
                    Container(
                        margin: EdgeInsets.only(bottom: 10),
                        alignment: Alignment.center,
                        child: Text('Booking failed'.tr, style: TextStyle(
                          fontSize: 20,
                        ),)
                    ),
                    Text(err, style: TextStyle(
                      fontWeight: FontWeight.w300,
                    ),),
                  ],
                ),
              ),
            ),
            actions: [
              OutlinedButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  backgroundColor: Colors.white,
                  side: BorderSide(color: Colors.blue, width: 2),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                child: Text(
                  'Done',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          );
        }
      );
    }
    else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            double width = MediaQuery.of(context).size.width;
            double height = MediaQuery.of(context).size.height;
            return AlertDialog(
              title: Text('Boogking details'.tr),
              content: Container(
                constraints: BoxConstraints(
                  maxHeight: height/2,
                ),
                width: width - 30,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 70,
                        height: 100,
                        child: Icon(Icons.check_circle, color: Colors.green, size: 70,),
                      ),
                      Container(
                          margin: EdgeInsets.only(bottom: 10),
                          alignment: Alignment.center,
                          child: Text('Booking success'.tr, style: TextStyle(
                            fontSize: 20,
                          ),)
                      ),
                      Text('Check your Schedule to see class detail'.tr, style: TextStyle(
                        fontWeight: FontWeight.w300,
                      ),),
                    ],
                  ),
                ),
              ),
              actions: [
                OutlinedButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Colors.blue, width: 2),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  child: Text(
                    'Done',
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            );
          }
      );

      getTimeSheet();
    }
  }

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
    }
    else {
      final Map parsed = json.decode(response.body);
      var tutorProv = Provider.of<TutorProvider>(context, listen: false);
      tutorProv.fromSearchJson(parsed);

      setState(() {
        _errorController.text = "";
      });
    }
  }
  void sendReport(String id, String content) async {
    var url = Uri.https('sandbox.api.lettutor.com', 'report', );
    var response = await http.post(url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': "Bearer ${context.read<UserProvider>().thisTokens.access.token}"
      },
      body: jsonEncode({"tutorId": id, "content": content})
    );
    if (response.statusCode != 200) {
      final Map parsed = json.decode(response.body);
      final String err = parsed["message"];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(err, style: TextStyle(color: Colors.red),),
          duration: Duration(seconds: 3),
        ),
      );
    }
    else {
      final Map parsed = json.decode(response.body);
      final String err = parsed["message"];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(err, style: TextStyle(color: Colors.green),),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
  void getFeedBack({Map<String, String> query = const {'perPage': '12', 'page': '1'}}) async {
    var url = Uri.https('sandbox.api.lettutor.com', 'feedback/v2/${widget.theArg.id}', query);
    var response = await http.get(url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': "Bearer ${context.read<UserProvider>().thisTokens.access.token}"
      },
    );
    if (response.statusCode != 200) {
      final Map parsed = json.decode(response.body);
      final String err = parsed["message"];
      setState(() {
        _fbError.text = err;
      });
    }
    else {
      final Map<String, dynamic> parsed = json.decode(response.body);
      setState(() {
        _maxFbPage = parsed['data']['count'];
        fbList = List.from(parsed['data']['rows']).map((e) => FeedbackItem.fromJson(e)).toList();
      });
    }

    setState(() {
      _isFbLoading = false;
      if (_maxFbPage~/12 < _maxFbPage/12) {
        _maxFbPage = _maxFbPage~/12 + 1;
      }
      else {
        _maxFbPage = _maxFbPage~/12;
      }

      if (_maxFbPage < 1) _maxFbPage = 1;
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? tempBody = widget.theArg.postBody;

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
                    Text('Engilish'.tr)
                  ],
                ),
                onTap: () => {
                  print("Eng"),
                  Get.updateLocale(Locale('en', 'US')),
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
                  print("Vi"),
                  Get.updateLocale(Locale('vi', 'VN')),
                }, //
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
                Navigator.of(context).pushNamedAndRemoveUntil('/tutor', (Route route) => false);
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
        padding: EdgeInsets.all(20),
        child: _isLoading == true
        ? Center(
          child: CircularProgressIndicator(),
        )
        : _errorController.text.isEmpty
        ? Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 120,
                width: 100,
                child: thisTutor.avatar != null
                ? ImageProfile(Image.network(thisTutor.avatar!).image)
                : ImageProfile(Image.network("").image),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: SizedBox(
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 10),
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Text(
                          thisTutor.name,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        margin: EdgeInsets.only(bottom: 10),
                        child: thisTutor.country != null
                            ? Country.tryParse(thisTutor.country!) != null
                            ? Row(
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: Text(Country.tryParse(thisTutor.country!)!.flagEmoji),
                            ),
                            SizedBox(width: 10),
                            Text(Country.tryParse(thisTutor.country!)!.name),
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
                            Text("Not set country"),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        margin: EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            thisTutor.rating != null
                                ? Row(
                                children: []..addAll(List.generate(thisTutor.rating!.toInt(), (index) {
                                  return Tooltip(
                                    message: tooltipMsg[index].tr,
                                    child: Icon(Icons.star, color: Colors.yellow,),
                                  );
                                }))
                                  ..addAll(List.generate((5-thisTutor.rating!.toInt()), (index) {
                                    return Tooltip(
                                      message: tooltipMsg[4-index].tr,
                                      child: Icon(Icons.star, color: Colors.grey,),
                                    );
                                  }).reversed)..add(
                                    thisTutor.totalFeedback != null
                                    ? Text("(${thisTutor.totalFeedback})", style: TextStyle(fontStyle: FontStyle.italic),)
                                    : Container(),
                                  )
                            )
                                : Text('No review yet'.tr, style:  TextStyle(
                              fontStyle: FontStyle.italic,
                            ),),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
            child: ReadMoreText(
              thisTutor.bio,
              style: TextStyle(
                fontSize: 15,
              ),
              trimLines: 2,
              trimMode: TrimMode.Line,
              trimCollapsedText: 'More',
              trimExpandedText: 'Less',
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: InkWell(
                      onTap: ()  async {
                        var url = Uri.https('sandbox.api.lettutor.com', 'user/manageFavoriteTutor');
                        var response = await http.post(url,
                            headers: {
                              'Content-Type': 'application/json',
                              'Authorization': 'Bearer ${context.read<UserProvider>().thisTokens.access.token}',
                            },
                            body: jsonEncode({'tutorId': thisTutor.userId})
                        );

                        if (response.statusCode != 200) {
                          final Map parsed = json.decode(response.body);
                          final String err = parsed["message"];
                          setState(() {
                            _errorController.text = err;
                          });
                        }
                        else {
                          if (tempBody != null) searchTutorList(postBody: tempBody!);
                          else searchTutorList();
                          setState(() {
                            _errorController.text = "";
                            thisTutor.isFavorite = !thisTutor.isFavorite!;
                          });
                        }
                        // var doFavRes = await Provider.of<TutorProvider>(context, listen: false).doFav(thisTutor.userId, context.read<UserProvider>().thisTokens.access.token);
                        // if (doFavRes != "Success") {
                        //   setState(() {
                        //     _errorController.text = doFavRes;
                        //   });
                        // }
                        // else {
                        //   setState(() {
                        //     _errorController.text = "";
                        //   });
                        // }
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 30,
                            height: 30,
                            child: thisTutor.isFavorite == true
                                ? Image.asset('assets/images/icons/Heart.png', color: Colors.red, width: 35, height: 35,)
                                : Image.asset('assets/images/icons/Heart_outline.png', color: Colors.blue,),
                          ),
                          SizedBox(height: 10,),
                          Text('Favorite'.tr, style: TextStyle(
                              color: thisTutor.isFavorite == true ? Colors.red : Colors.blue
                          ),),
                        ],
                      )
                  ),
                ),
                Expanded(
                  child: InkWell(
                      onTap: () {
                        _rpController.text = "";
                        firstVal = false;
                        secondVal = false;
                        thirdVal = false;
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => StatefulBuilder(
                            builder: (context, setState) {
                              double width = MediaQuery.of(context).size.width;
                              double height = MediaQuery.of(context).size.height;
                              return Focus(
                                focusNode: _dialogFocus,
                                child: AlertDialog(
                                  title: Text('Report'.tr +' ${thisTutor.name}'),
                                  content: GestureDetector(
                                    onTap: () {
                                      _dialogFocus.requestFocus();
                                    },
                                    child: Container(
                                      constraints: BoxConstraints(
                                        maxHeight: height/2,
                                      ),
                                      width: width - 30,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            Container(
                                                margin: EdgeInsets.only(bottom: 10),
                                                alignment: Alignment.centerLeft,
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.info, color: Colors.blue,),
                                                    SizedBox(width: 10,),
                                                    Expanded(child: Text(
                                                      'Help us understand what\'s happening'.tr,
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),),
                                                  ],
                                                )
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Checkbox(
                                                  value: firstVal,
                                                  onChanged: (bool? newValue) {
                                                    setState(() {
                                                      firstVal = !firstVal;
                                                      if(firstVal == true) {
                                                        _rpController.text = "${"This tutor is annoying me".tr}\n${_rpController.text}";
                                                      }
                                                      else {
                                                        _rpController.text = _rpController.text.replaceAll("${"This tutor is annoying me".tr}\n", "")
                                                            .replaceAll("This tutor is annoying me".tr, "");
                                                      }
                                                    });
                                                  },
                                                ),
                                                Expanded(child: Text("This tutor is annoying me".tr)),
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Checkbox(
                                                  value: secondVal,
                                                  onChanged: (bool? newValue) {
                                                    setState(() {
                                                      secondVal = !secondVal;
                                                      if(secondVal == true) {
                                                        _rpController.text = "${"This profile is pretending be someone or is fake".tr}\n${_rpController.text}";
                                                      }
                                                      else {
                                                        _rpController.text = _rpController.text.replaceAll("${"This profile is pretending be someone or is fake".tr}\n", "")
                                                            .replaceAll("This profile is pretending be someone or is fake".tr, "");
                                                      }
                                                    });
                                                  },
                                                ),
                                                Expanded(child: Text("This profile is pretending be someone or is fake".tr)),
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Checkbox(
                                                  value: thirdVal,
                                                  onChanged: (bool? newValue) {
                                                    setState(() {
                                                      thirdVal = !thirdVal;
                                                      if(thirdVal == true) {
                                                        _rpController.text = "${"Inappropriate profile photo".tr}\n${_rpController.text}";
                                                      }
                                                      else {
                                                        _rpController.text = _rpController.text.replaceAll("${"Inappropriate profile photo".tr}\n", "")
                                                            .replaceAll("Inappropriate profile photo".tr, "");
                                                      }
                                                    });
                                                  },
                                                ),
                                                Expanded(child: Text("Inappropriate profile photo".tr)),
                                              ],
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(bottom: 10),
                                              child: TextFormField(
                                                keyboardType: TextInputType.multiline,
                                                controller: _rpController,
                                                minLines: 3,
                                                maxLines: 8,
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
                                                  hintText: "Please let us know details about your problem".tr,
                                                  isCollapsed: true,
                                                ),
                                                onChanged: (val) {
                                                  if (val.contains('This tutor is annoying me'.tr)) {
                                                    setState(() {
                                                      firstVal = true;
                                                    });
                                                  }
                                                  if (val.contains('This profile is pretending be someone or is fake'.tr)) {
                                                    setState(() {
                                                      secondVal = true;
                                                    });
                                                  }
                                                  if (val.contains('Inappropriate profile photo'.tr)) {
                                                    setState(() {
                                                      thirdVal = true;
                                                    });
                                                  }
                                                  setState((){});
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  actions: [
                                    OutlinedButton(
                                      onPressed: () => Navigator.pop(context, 'Cancel'),
                                      style: OutlinedButton.styleFrom(
                                        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                        backgroundColor: Colors.white,
                                        side: BorderSide(color: Colors.blue, width: 2),
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                        ),
                                      ),
                                      child: Text(
                                        'Cancel'.tr,
                                        style: TextStyle(
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                    OutlinedButton(
                                      onPressed: () => _rpController.text.isNotEmpty ? Navigator.pop(context, 'OK') : null,
                                      style: OutlinedButton.styleFrom(
                                        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                        backgroundColor: _rpController.text.isNotEmpty ? Colors.blue : Colors.grey,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                        ),
                                      ),
                                      child: Text(
                                        'Submit'.tr,
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          ),
                        ).then((value) {
                          if(value == "OK") {
                            sendReport(thisTutor.userId, _rpController.text);
                          }
                        });
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 30,
                            height: 30,
                            child: Icon(Icons.info_outline, color: Colors.blue, size: 35,),
                          ),
                          SizedBox(height: 10,),
                          Text('Report'.tr, style: TextStyle(
                            color: Colors.blue,
                          ),),
                        ],
                      )
                  ),
                ),
                Expanded(
                  child: InkWell(
                      onTap: () async {
                        setState(() {
                          _isFbLoading = true;
                        });
                        Future<void> fetchFb() async{return getFeedBack();}
                        await fetchFb();
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              double width = MediaQuery.of(context).size.width;
                              double height = MediaQuery.of(context).size.height;
                              final NumberPaginatorController pagiController = NumberPaginatorController();
                              Map<String, String> query = {'perPage': '12','page': '1'};
                                return StatefulBuilder(
                                  builder: (context, setState) {
                                    setState(() {});
                                    return AlertDialog(
                                      title: Text('Others review'.tr),
                                      content: GestureDetector(
                                        onTap: () {
                                          FocusScope.of(context).requestFocus(_dialogFocus);
                                        },
                                        child: SizedBox(
                                          width: width - 30,
                                          height: height/2,
                                          child: _isFbLoading == true
                                          ? Center(
                                            child: SizedBox(width: 80, height: 80, child: CircularProgressIndicator(),),
                                          )
                                          : _fbError.text.isNotEmpty
                                          ? Text(_fbError.text)
                                          : fbList.isNotEmpty
                                          ? ListView(
                                            children: fbList.map((e) {
                                              return SizedBox(
                                                height: 100,
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: 50,
                                                      height: 50,
                                                      child: CircleAvatar(
                                                        radius: 80.0,
                                                        backgroundImage: e.avatar != null ? Image.network(e.avatar!).image : Image.network("").image,
                                                      )
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Expanded(
                                                      child: SizedBox(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  e.name,
                                                                  maxLines: 1,
                                                                  overflow: TextOverflow.ellipsis ,
                                                                  style: TextStyle(
                                                                    fontSize: 15,
                                                                    fontWeight: FontWeight.w300,
                                                                  ),
                                                                ),
                                                                SizedBox(width: 15,),
                                                                Text(
                                                                  timeago.format(DateTime.parse(e.createdAt), locale: appLocal?.languageCode),
                                                                  style: TextStyle(
                                                                    fontWeight: FontWeight.w400,
                                                                    fontSize: 15,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Container(
                                                              margin: EdgeInsets.only(bottom: 10),
                                                              child: Row(
                                                                children: [
                                                                  e.rating != null
                                                                      ? Row(
                                                                      children: []..addAll(List.generate(e.rating!.toInt(), (index) {
                                                                        return Icon(Icons.star, color: Colors.yellow, size: 15,);
                                                                      }))
                                                                        ..addAll(List.generate((5-e.rating!.toInt()), (index) {
                                                                          return Icon(Icons.star, color: Colors.grey, size: 15,);
                                                                        }))
                                                                  )
                                                                      : Text('No review yet'.tr, style:  TextStyle(
                                                                    fontStyle: FontStyle.italic,
                                                                  ),),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 30,
                                                              child: SingleChildScrollView(
                                                                child: Text(e.content),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }).toList(),
                                          )
                                          : Center(
                                            child: Text("No Review found."),
                                          ),
                                        ),
                                      ),
                                      actions: [
                                        NumberPaginator(
                                          controller: pagiController,
                                          // by default, the paginator shows numbers as center content
                                          config: NumberPaginatorUIConfig(
                                            mode: ContentDisplayMode.dropdown,
                                          ),
                                          numberPages: _maxFbPage,
                                          initialPage: 0,
                                          onPageChange: (int index) async {
                                            setState((){
                                              _isFbLoading = true;
                                            });
                                            query['page'] = (pagiController.currentPage + 1).toString();
                                            Future<void> fetchFb() async {
                                              return getFeedBack(query: query);
                                            }
                                            await fetchFb();
                                            setState(() {
                                              //print(DateFormat('HH:mm EEEE, dd, MMM, yy').format(DateTime.parse(fbList.first.createdAt)));
                                              print("In Dialog load: $_isFbLoading");
                                            });
                                          },
                                        )
                                      ],
                                    );
                                  }
                              );
                            }
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 30,
                            height: 30,
                            child: Icon(Icons.star_border_purple500_sharp, color: Colors.blue, size: 35,),
                          ),
                          SizedBox(height: 10,),
                          Text('Reviews'.tr, style: TextStyle(
                            color: Colors.blue,
                          ),),
                        ],
                      )
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 200,
            child: _chewieController != null
                ? Container(
              child: Chewie(
                controller: _chewieController!,
              ),
            )
                : Center(
              child: Text(_videoErr),
            ),),
          Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 15),
            alignment: Alignment.centerLeft,
            child: Text(
              'Languages'.tr,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 20),
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            height: 50,
            width: double.infinity,
            child: SingleChildScrollView(
              child: Wrap(
                runSpacing: 5,
                spacing: 5,
                crossAxisAlignment: WrapCrossAlignment.start,
                verticalDirection: VerticalDirection.down,
                children: thisTutor.languages.split(',').map((value) => Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.blue,
                  ),
                  child: LocaleNames.of(context)!.nameOf(value) != null
                      ? Text(LocaleNames.of(context)!.nameOf(value)!)
                      : Text(value.toUpperCase()),
                )).toList(),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 15),
            alignment: Alignment.centerLeft,
            child: Text(
              'Specialties'.tr,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 20),
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            height: 50,
            width: double.infinity,
            child: SingleChildScrollView(
              child: Wrap(
                runSpacing: 5,
                spacing: 5,
                crossAxisAlignment: WrapCrossAlignment.start,
                verticalDirection: VerticalDirection.down,
                children: thisTutor.specialties.split(',').map((value) => Container(
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
          thisTutor.courses.isNotEmpty
              ? Container(
            margin: EdgeInsets.only(bottom: 10),
            alignment: Alignment.centerLeft,
            child: Text(
              'Suggested courses'.tr,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
              : Container(),
          thisTutor.courses.isNotEmpty
          ? Column(
            children: thisTutor.courses.map((value) => Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 17,
                  ),
                  children: [
                    TextSpan(
                      text: value.name + ': ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    TextSpan(
                      text: "Link".tr,
                      style: TextStyle(
                          fontSize: 17,
                          color: Colors.blue
                      ),
                      recognizer: TapGestureRecognizer()..onTap = () => Navigator.pushNamed(context, '/course_detail', arguments: value.id),//_launchUrl(value.courseLink), //sửa sau
                    ),
                  ],
                ),
              ),
            )).toList(),
          )
          : Container(),
          Container(
            margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
            alignment: Alignment.centerLeft,
            child: Text(
              'Interests'.tr,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            margin: EdgeInsets.only(bottom: 20),
            alignment: Alignment.centerLeft,
            child: Text(thisTutor.interests,
              style: TextStyle(
                fontSize: 15,
              ),),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 15),
            alignment: Alignment.centerLeft,
            child: Text(
              'Teaching experience'.tr,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            margin: EdgeInsets.only(bottom: 20),
            alignment: Alignment.centerLeft,
            child: Text(thisTutor.experience,
              style: TextStyle(
                fontSize: 15,
              ),),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 15),
            alignment: Alignment.centerLeft,
            child: Text(
              'Timesheet'.tr,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            alignment: Alignment.centerLeft,
            child: Text('${"Each class lasts 25 minutes.".tr}\n${'Please wait for loading after each navigation.'.tr}',
              style: TextStyle(
                fontSize: 15,
              ),),
          ),
          SfCalendar(
            view: CalendarView.week,
            controller: _calendarController,
            minDate: DateTime.now(),
            initialDisplayDate: DateTime.now(),
            initialSelectedDate: DateTime.now(),
            showNavigationArrow: true,
            showDatePickerButton: true,
            showCurrentTimeIndicator: false,
            dataSource: _getCalendarDataSource(),
            cellEndPadding: 0,
            firstDayOfWeek: now.weekday,
            timeSlotViewSettings: TimeSlotViewSettings(
              timeInterval: Duration(minutes: 30),
              timeFormat: "HH:mm",
            ),
            appointmentBuilder: (BuildContext context, CalendarAppointmentDetails details) {
              final Appointment meeting = details.appointments.first;
              if (meeting.subject == "Reserved") {
                return Container(
                  color: Theme.of(context).backgroundColor,
                  child: Center(
                    child: Text(
                        "Reserved".tr,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 9,
                        ),
                    ),
                  )
                );
              }
              if (meeting.subject == "Booked") {
                return Container(
                    color: Theme.of(context).backgroundColor,
                    child: Center(
                      child: Text(
                        "Booked".tr,
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 9,
                        ),
                      ),
                    )
                );
              }
              if (meeting.startTime.difference(now).compareTo(Duration(hours: 2)) <= 0) {
                return OutlinedButton(
                  onPressed: null,
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Colors.grey, width: 2),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  child: Text(
                    'Book'.tr,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 9,
                    ),
                  ),
                );
              }
              return OutlinedButton(
                onPressed: () {
                  _noteController.clear();
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        double width = MediaQuery.of(context).size.width;
                        double height = MediaQuery.of(context).size.height;
                        return Focus(
                          focusNode: _dialogFocus,
                          child: AlertDialog(
                            title: Text("Booking details".tr),
                            content: GestureDetector(
                              onTap: () {
                                _dialogFocus.requestFocus();
                              },
                              child: Container(
                                constraints: BoxConstraints(
                                  maxHeight: height/2,
                                ),
                                width: width - 30,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Container(
                                          margin: EdgeInsets.only(bottom: 10),
                                          alignment: Alignment.centerLeft,
                                          child: Text('Booking Time'.tr)
                                      ),
                                      Container(
                                          margin: EdgeInsets.only(bottom: 10),
                                          alignment: Alignment.center,
                                          child: Text('${DateFormat('HH:mm', appLocal?.languageCode).format(meeting.startTime)}-${DateFormat('HH:mm EEEE, dd MM yyyy', appLocal?.languageCode).format(meeting.endTime)}')
                                      ),
                                      Container(
                                          margin: EdgeInsets.only(bottom: 10),
                                          alignment: Alignment.centerLeft,
                                          child: Text('Notes'.tr)
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(bottom: 10),
                                        child: TextFormField(
                                          keyboardType: TextInputType.multiline,
                                          controller: _noteController,
                                          minLines: 3,
                                          maxLines: 8,
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
                                            isCollapsed: true,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            actions: [
                              OutlinedButton(
                                onPressed: () => Navigator.pop(context, 'Cancel'),
                                style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  backgroundColor: Colors.white,
                                  side: BorderSide(color: Colors.blue, width: 2),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                ),
                                child: Text(
                                  'Cancel'.tr,
                                  style: TextStyle(
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                              OutlinedButton(
                                onPressed: () => Navigator.pop(context, 'OK'),
                                style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  backgroundColor: Colors.blue,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                ),
                                child: Text(
                                  'Book'.tr,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                  ).then((value) {
                    if(value == "OK") {
                      bookClass(meeting.id.toString(), _noteController.text);
                    }
                  });
                },
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: Colors.white,
                  side: BorderSide(color: Colors.blue, width: 2),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                child: Text(
                  'Book'.tr,
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 9,
                  ),
                ),
              );
            },
            onViewChanged: (ViewChangedDetails details) {
              List<DateTime> dates = details.visibleDates;
              var tempStart = dates[0].millisecondsSinceEpoch;
              var tempEnd = dates[dates.length-1].add(Duration(days: 1)).millisecondsSinceEpoch-1;
              print(tempStart);
              print(tempEnd);
              query['startTimestamp'] = tempStart.toString();
              query['endTimestamp'] = tempEnd.toString();
              getTimeSheet();
            },
          ),
          SizedBox(
            height: 50,
          ),
        ],
      )
        : Center(
          child: Text(_errorController.text),
        ),
      ),
      /*floatingActionButton: FloatingActionButton(
        onPressed: () {
          getTimeSheet();
          // Add your onPressed code here!
        },
        backgroundColor: Colors.grey,
        child: const Icon(Icons.message_outlined),
      ),*/
    );
  }

  Widget ImageProfile(ImageProvider input) {
    return CircleAvatar(
      radius: 80.0,
      backgroundImage: input,
    );
  }
}

class courseItem {
  final String courseName;
  final String courseLink;

  courseItem({
    required this.courseName,
    required this.courseLink,
  });
}

class ProfileArg {
  final String id;
  final Map<String, dynamic>? postBody;

  ProfileArg(this.id, this.postBody);
}

class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source){
    appointments = source;
  }
}