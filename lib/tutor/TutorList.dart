import 'dart:async';
import 'dart:convert';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:individual_project/model/TutorProvider.dart';
import 'package:individual_project/model/UserProvider.dart';
import 'package:provider/provider.dart';
import 'package:time_range_picker/time_range_picker.dart';
import 'package:http/http.dart' as http;
import 'package:number_paginator/number_paginator.dart';
import 'package:intl/intl.dart';

class Tutor extends StatefulWidget {
  const Tutor({Key? key}) : super(key: key);

  @override
  State<Tutor> createState() => _TutorState();
}

class _TutorState extends State<Tutor> {
  final FocusNode _screenFocus = FocusNode();
  bool _isLoading = false;
  bool _upcommingLoading = false;
  bool _hasUpcomming = false;

  int _maxPage = 1;
  final NumberPaginatorController _pagiController = NumberPaginatorController();

  TextEditingController _errorController = TextEditingController();
  TextEditingController _upErrController = TextEditingController();
  String dateFormat = "";

  String _firstSelected ='assets/images/usaFlag.svg';

  Timer? countdownTimer;
  Duration myDuration = Duration(days: 1);

  @override
  void initState() {
    super.initState();
    setState(() {
      _errorController.text = "";
      _upErrController.text = "";
      tags = ['All', 'English for kids', 'English for Business', 'Conversational', 'STARTERS', 'MOVERS', 'FLYERS', 'KET', 'PET', 'IELTS', 'TOEFL', 'TOEIC'];
      isSelectedTag = List.generate(tags.length, (index) => false);
      isSelectedTag[0] = true;
      _isLoading = true;
      _upcommingLoading = true;
    });
    // Provider.of<UserProvider>(context, listen: false).thisTokens = Tokens(
    //   access: Access(
    //     token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJkZTZhMGViZS1lOGNkLTRhODQtYTc0Yi0yOWZlNTM5NjRjNDciLCJpYXQiOjE2NzExMTUyMTYsImV4cCI6MTY3MTIwMTYxNiwidHlwZSI6ImFjY2VzcyJ9._HCnjzYOgzilLAmEhehvEAcgtkBIh9dgYnNUvKkAqBk",
    //     expires: "2022-12-08T05:35:46.286Z"
    //   ),
    //   refresh: Refresh(
    //     token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJkZTZhMGViZS1lOGNkLTRhODQtYTc0Yi0yOWZlNTM5NjRjNDciLCJpYXQiOjE2NzAzOTEzNDYsImV4cCI6MTY3Mjk4MzM0NiwidHlwZSI6InJlZnJlc2gifQ.5DiiDFVhCFUnlHFosgDn7EvWUwWBGy5kcADSR9opstE",
    //     expires: "2023-01-06T05:35:46.286Z"
    //   )
    // );
    //startTimer();
    //searchTutorList();
    getUpcommingLession();
    getPreTutorList();
  }
  /// Timer related methods ///
  void startTimer() {
    countdownTimer =
        Timer.periodic(Duration(seconds: 1), (_) => setCountDown());
  }
  void stopTimer() {
    setState(() => countdownTimer!.cancel());
  }
  void resetTimer() {
    stopTimer();
    setState(() => myDuration = Duration(days: 5));
  }
  void setCountDown() {
    final reduceSecondsBy = 1;
    setState(() {
      final seconds = myDuration.inSeconds - reduceSecondsBy;
      if (seconds < 0) {
        countdownTimer!.cancel();
      } else {
        myDuration = Duration(seconds: seconds);
      }
    });
  }

  final TextEditingController _nController = TextEditingController();
  final FocusNode _nFocus = FocusNode();

  List<String> selectedNation = [];
  final _ntKey = GlobalKey<DropdownSearchState<String>>();
  final List<String> items = [
    'Foreign Tutor',
    'Vietnamese Tutor',
    'Native English Tutor',
  ];
  final FocusNode _ntFocus = FocusNode();

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

  final FocusNode _tgFocus = FocusNode();

  final FocusNode _rsFocus = FocusNode();

  void getPreTutorList({Map<String, String> queryParameters = const {'perPage': '99999999','page': '1',}}) async {
    var url = Uri.https('sandbox.api.lettutor.com', 'tutor/more', queryParameters);
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
      final Map parsed = json.decode(response.body);
      //print(parsed);
      var tutorProv = Provider.of<TutorProvider>(context, listen: false);
      tutorProv.fromJson(parsed);
      var readTutorProv = context.read<TutorProvider>();

      print(readTutorProv.theList.length);
      // for (var aTutor in readTutorProv.theList) {
      //
      // }

      print(readTutorProv.favList.length);
      // for (var aTutor in readTutorProv.favList) {
      //   print(aTutor.avatar);
      // }
      //int? perPage = int.tryParse(queryParameters['perPage']!);
      readTutorProv.makeList();
      setState(() {
        _errorController.text = "";
      });
    }
    //print(response.body);
    setState(() {
      _isLoading = false;
      _maxPage = context.read<TutorProvider>().count~/9;
      if (_maxPage < 1) _maxPage = 1;
    });
  }

  void searchTutorList({Map<String, dynamic> postBody = const {
    "filter": {
      "date": null,
      "nationality": {},
      "specialties": [],
      "tutoringTimeAvailable": [null, null]
    },
    "page": 1,
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
      print(err);
    }
    else {
      final Map parsed = json.decode(response.body);
      //print(parsed);
      var tutorProv = Provider.of<TutorProvider>(context, listen: false);
      tutorProv.fromSearchJson(parsed);
      var readTutorProv = context.read<TutorProvider>();

      print(tutorProv.crrList.length);
      for (var aTutor in readTutorProv.theList) {
        print(aTutor.isFavorite);
      }
      // tutorProv.makeList();
      setState(() {
        _errorController.text = "";
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  void getUpcommingLession() async{
    var timeStampNow = DateTime.now().millisecondsSinceEpoch.toString();

    Map<String, dynamic> queryParameters = {"dateTime": timeStampNow};
    var url = Uri.https('sandbox.api.lettutor.com', 'booking/next', queryParameters);
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
        _upErrController.text = err;
      });
    }
    else {
      final Map parsed = json.decode(response.body);
      if (parsed["data"].length == 1) {
        int timeNow = DateTime.now().millisecondsSinceEpoch;
        int startTime = parsed['data'][0]['scheduleDetailInfo']['startPeriodTimestamp'];
        int endTime = parsed['data'][0]['scheduleDetailInfo']['endPeriodTimestamp'];
        setState(() {
          dateFormat = DateFormat('EEEE, d MMM, yyyy, hh:mm').format(DateTime.fromMillisecondsSinceEpoch(startTime))
          + " - " + DateFormat('hh:mm').format(DateTime.fromMillisecondsSinceEpoch(endTime));
          myDuration = Duration(milliseconds: startTime - timeNow);
          _hasUpcomming = true;
        });
        startTimer();
      }
      else {
        setState(() {
          _hasUpcomming = false;
        });
      }
    }

    setState(() {
      _upErrController.text = "";
      _upcommingLoading = false;
    });
  }

  @override
  void dispose() {
    stopTimer();
    super.dispose();
  }

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
  List<String> tooltipMsg = ['terrible', 'bad', 'normal', 'good', 'wonderful'];

  @override
  Widget build(BuildContext context) {
    var readTutorProv = context.read<TutorProvider>();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    
    String strDigits(int n) => n.toString().padLeft(2, '0');
    final hours = strDigits(myDuration.inHours.remainder(24));
    final minutes = strDigits(myDuration.inMinutes.remainder(60));
    final seconds = strDigits(myDuration.inSeconds.remainder(60));

    Map<String, bool> nation = {};

    Map<String, dynamic> postBody = {
      "filter": {
        "date": null,
        "nationality": {},
        "specialties": [],
        "tutoringTimeAvailable": [null, null]
      },
      "page": 1,
      "perPage": 9
    };

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
                  child: _upcommingLoading == true
                    ? CircularProgressIndicator(color: Colors.white,)
                    : _upErrController.text.isNotEmpty
                    ? Text(_upErrController.text)
                    : _hasUpcomming == false
                    ? Container()
                    : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.only(bottom: 15),
                          child: Text(
                            'Upcoming lesson',
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
                          child: Text(
                            '  (starts in $hours:$minutes:$seconds)',
                            style: TextStyle(
                              color: Colors.yellow,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        OutlinedButton(
                          onPressed: null,
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
                                      text: '  Enter lesson room',
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
                          child: Text(
                            'Welcome to LetTutor!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        )
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
                        'Find a tutor',
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
                        'Specify tutor detail:',
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
                          hintText: 'Enter tutor name',
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
                              items: items,
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
                                  hintText: 'Select tutor nationnality',
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
                        'Select available tutoring time:',
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
                                hintText: 'Day',
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
                                hintText: 'Time range',
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
                        'Select a tag:',
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
                          label: Text(tags[i]),
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
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: OutlinedButton(
                        onPressed: () {
                          // nation.addAll({"isVietNamese": true}); làm sau
                          // print(nation);
                          // print("Name: " + _nController.text);
                          // print("Name: " + _nController.text);
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
                            //_isLoading = true; làm sau
                            //_errorController.text = "";
                          });
                          //getPreTutorList();
                          //searchTutorList(); làm sau
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
                          'Reset Filters',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      thickness: 2,
                    ),
                    /*Container(
                      margin: EdgeInsets.fromLTRB(0, 15, 0, 30),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Recommened Tutors',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    _isLoading == true
                        ? CircularProgressIndicator()
                        : _errorController.text.isEmpty
                        ? readTutorProv.crrList.isNotEmpty
                        ? SizedBox(
                      height: 375,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: List.generate(readTutorProv.crrList.length, (i) {
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
                                          child: readTutorProv.crrList[i].avatar != null
                                              ? ImageProfile(Image.network(readTutorProv.crrList[i].avatar!).image, readTutorProv.crrList[i].isOnline!, readTutorProv.crrList[i].userId)
                                              : ImageProfile(Image.network("").image, readTutorProv.crrList[i].isOnline!, readTutorProv.crrList[i].userId),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: SizedBox(
                                            child: Column(
                                              children: [
                                                GestureDetector(
                                                  onTap: () => Navigator.pushNamed(context, '/tutor_profile', arguments: readTutorProv.crrList[i].userId),
                                                  child: Container(
                                                    alignment: Alignment.centerLeft,
                                                    padding: EdgeInsets.only(left: 10),
                                                    margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                                    child: Text(
                                                      readTutorProv.crrList[i].name,
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
                                                  child: readTutorProv.crrList[i].country != null
                                                      ? Country.tryParse(readTutorProv.crrList[i].country!) != null
                                                      ? Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 20,
                                                        height: 20,
                                                        child: Text(Country.tryParse(readTutorProv.crrList[i].country!)!.flagEmoji),
                                                      ),
                                                      SizedBox(width: 10),
                                                      Text(Country.tryParse(readTutorProv.crrList[i].country!)!.name),
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
                                                      readTutorProv.crrList[i].rating != null
                                                          ? Row(
                                                          children: []..addAll(List.generate(readTutorProv.crrList[i].rating!.toInt(), (index) {
                                                            return Tooltip(
                                                              message: tooltipMsg[index],
                                                              child: Icon(Icons.star, color: Colors.yellow,),
                                                            );
                                                          }))
                                                            ..addAll(List.generate((5-readTutorProv.crrList[i].rating!.toInt()), (index) {
                                                              return Tooltip(
                                                                message: tooltipMsg[4-index],
                                                                child: Icon(Icons.star, color: Colors.grey,),
                                                              );
                                                            }).reversed)
                                                      )
                                                          : Text('No reviews yet', style:  TextStyle(
                                                        fontStyle: FontStyle.italic,
                                                      ),),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            var doFavRes = await Provider.of<TutorProvider>(context, listen: false).doFav(readTutorProv.crrList[i].userId, context.read<UserProvider>().thisTokens.access.token);
                                            if (doFavRes != "Success") {
                                              setState(() {
                                                _errorController.text = doFavRes;
                                              });
                                            }
                                            else {
                                              setState(() {
                                                _errorController.text = "";
                                              });
                                            }
                                          },
                                          icon: context.read<TutorProvider>().crrList[i].isFavorite!
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
                                          children: readTutorProv.crrList[i].specialties.split(',').map((value) => Container(
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
                                                ? Text(specList.firstWhere((sl) => sl['inJson'] == value)['toShow']!)
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
                                        readTutorProv.crrList[i].bio,
                                        maxLines: 4,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      alignment: Alignment.centerRight,
                                      child: ElevatedButton.icon(
                                        onPressed: () => Navigator.pushNamed(context, '/tutor_profile', arguments: readTutorProv.crrList[i].userId),
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
                                          'Book',
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
                    ) : Text("No Tutor found.")
                        : Text(_errorController.text),*/
                    Divider(
                      thickness: 2,
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 15, 0, 30),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Favourite Tutors',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    _isLoading == true
                    ? CircularProgressIndicator()
                    : _errorController.text.isEmpty
                    ? readTutorProv.favList.isNotEmpty
                    ? SizedBox(
                      height: 375,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: List.generate(readTutorProv.favList.length, (i) {
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
                                          child: readTutorProv.favList[i].avatar != null
                                              ? ImageProfile(Image.network(readTutorProv.favList[i].avatar!).image, readTutorProv.favList[i].isOnline!, readTutorProv.favList[i].userId)
                                              : ImageProfile(Image.network("").image, readTutorProv.favList[i].isOnline!, readTutorProv.favList[i].userId),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: SizedBox(
                                            child: Column(
                                              children: [
                                                GestureDetector(
                                                  onTap: () => Navigator.pushNamed(context, '/tutor_profile', arguments: readTutorProv.favList[i].userId),
                                                  child: Container(
                                                    alignment: Alignment.centerLeft,
                                                    padding: EdgeInsets.only(left: 10),
                                                    margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                                    child: Text(
                                                      readTutorProv.favList[i].name,
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
                                                  child: readTutorProv.favList[i].country != null
                                                    ? Country.tryParse(readTutorProv.favList[i].country!) != null
                                                      ? Row(
                                                        children: [
                                                          SizedBox(
                                                            width: 20,
                                                            height: 20,
                                                            child: Text(Country.tryParse(readTutorProv.favList[i].country!)!.flagEmoji),
                                                          ),
                                                          SizedBox(width: 10),
                                                          Text(Country.tryParse(readTutorProv.favList[i].country!)!.name),
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
                                                      readTutorProv.favList[i].rating != null
                                                          ? Row(
                                                        children: []..addAll(List.generate(readTutorProv.favList[i].rating!.toInt(), (index) {
                                                            return Tooltip(
                                                              message: tooltipMsg[index],
                                                              child: Icon(Icons.star, color: Colors.yellow,),
                                                            );
                                                          }))
                                                          ..addAll(List.generate((5-readTutorProv.favList[i].rating!.toInt()), (index) {
                                                            return Tooltip(
                                                              message: tooltipMsg[4-index],
                                                              child: Icon(Icons.star, color: Colors.grey,),
                                                            );
                                                          }).reversed)
                                                      )
                                                          : Text('No reviews yet', style:  TextStyle(
                                                        fontStyle: FontStyle.italic,
                                                      ),),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            var doFavRes = await Provider.of<TutorProvider>(context, listen: false).doFav(readTutorProv.favList[i].userId, context.read<UserProvider>().thisTokens.access.token);
                                            if (doFavRes != "Success") {
                                              setState(() {
                                                _errorController.text = doFavRes;
                                              });
                                            }
                                            else {
                                              setState(() {
                                                _errorController.text = "";
                                              });
                                            }
                                          },
                                          icon: context.read<TutorProvider>().favList[i].isFavorite!
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
                                          children: readTutorProv.favList[i].specialties.split(',').map((value) => Container(
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
                                            ? Text(specList.firstWhere((sl) => sl['inJson'] == value)['toShow']!)
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
                                        readTutorProv.favList[i].bio,
                                        maxLines: 4,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      alignment: Alignment.centerRight,
                                      child: ElevatedButton.icon(
                                        onPressed: () => Navigator.pushNamed(context, '/tutor_profile', arguments: readTutorProv.favList[i].userId),
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
                                          'Book',
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
                    ) : Text("No Favorite Tutor.")
                    : Text(_errorController.text),
                    Divider(
                      thickness: 2,
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 15, 0, 30),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Filtered Tutors',
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
                          if (readTutorProv.theList[i].toShow == false) {
                            return Container();
                          }
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
                                              ? ImageProfile(Image.network(readTutorProv.theList[i].avatar!).image, readTutorProv.theList[i].isOnline!, readTutorProv.theList[i].userId)
                                              : ImageProfile(Image.network("").image, readTutorProv.theList[i].isOnline!, readTutorProv.theList[i].userId),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: SizedBox(
                                            child: Column(
                                              children: [
                                                GestureDetector(
                                                  onTap: () => Navigator.pushNamed(context, '/tutor_profile', arguments: readTutorProv.theList[i].userId),
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
                                                      Text("Not set country"),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.only(left: 10),
                                                  margin: EdgeInsets.only(bottom: 10),
                                                  child: Row(
                                                    children: [
                                                      readTutorProv.theList[i].rating != null
                                                          ? Row(
                                                          children: []..addAll(List.generate(readTutorProv.theList[i].rating!.toInt(), (index) {
                                                            return Tooltip(
                                                              message: tooltipMsg[index],
                                                              child: Icon(Icons.star, color: Colors.yellow,),
                                                            );
                                                          }))
                                                            ..addAll(List.generate((5-readTutorProv.theList[i].rating!.toInt()), (index) {
                                                              return Tooltip(
                                                                message: tooltipMsg[4-index],
                                                                child: Icon(Icons.star, color: Colors.grey,),
                                                              );
                                                            }).reversed)
                                                      )
                                                          : Text('No reviews yet', style:  TextStyle(
                                                        fontStyle: FontStyle.italic,
                                                      ),),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            var doFavRes = await Provider.of<TutorProvider>(context, listen: false).doFav(readTutorProv.theList[i].userId, context.read<UserProvider>().thisTokens.access.token);
                                            if (doFavRes != "Success") {
                                              setState(() {
                                                _errorController.text = doFavRes;
                                              });
                                            }
                                            else {
                                              setState(() {
                                                _errorController.text = "";
                                              });
                                            }
                                          },
                                          icon: context.read<TutorProvider>().theList[i].isFavorite!
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
                                                ? Text(specList.firstWhere((sl) => sl['inJson'] == value)['toShow']!)
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
                                        onPressed: () => Navigator.pushNamed(context, '/tutor_profile', arguments: readTutorProv.theList[i].userId),
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
                                          'Book',
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
                    ) : Text("No Tutor in this page. They may all be on the \"Favorite Tutors\" section.")
                    : Text(_errorController.text),
                    NumberPaginator(
                      controller: _pagiController,
                      // by default, the paginator shows numbers as center content
                      numberPages: _maxPage,
                      initialPage: 0,
                      onPageChange: (int index) {
                        var queryParameters = {'perPage': '9','page': (_pagiController.currentPage + 1).toString(),};
                        getPreTutorList(queryParameters: queryParameters);
                      },
                    )
                  ],
                ),
              )
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
    );
  }

  Widget ImageProfile(ImageProvider input, bool online, String id) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/tutor_profile' , arguments: id),
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