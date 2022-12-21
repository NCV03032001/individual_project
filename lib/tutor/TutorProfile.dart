import 'dart:convert';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:individual_project/model/Tutor.dart';
import 'package:individual_project/model/UserProvider.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:booking_calendar/booking_calendar.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../model/TutorProvider.dart';

class TutorProfile extends StatefulWidget {
  final ProfileArg theArg;

  const TutorProfile({Key? key, required this.theArg}) : super(key: key);

  @override
  State<TutorProfile> createState() => _TutorProfileState();
}

class _TutorProfileState extends State<TutorProfile> {
  String _firstSelected ='assets/images/usaFlag.svg';
  bool _isLoading = false;

  Tutor thisTutor = Tutor(
      name: "", isPublicRecord: false, courses: [],
      userId: "", video: "", bio: "", education: "", experience: "", profession: "",
      targetStudent: "", interests: "", languages: "", specialties: "", toShow: false);

  final FocusNode _dialogFocus = FocusNode();
  bool _isFbLoading = false;
  List<FeedbackItem> fbList = [];
  TextEditingController _fbError = TextEditingController();
  int _maxFbPage = 1;

  TextEditingController _errorController = TextEditingController();
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

  @override
  void initState() {
    super.initState();
    mockBookingService = BookingService(
        serviceName: 'Mock Service',
        serviceDuration: 30,
        bookingEnd: DateTime(now.year, now.month, now.day, 23, 59),
        bookingStart: DateTime(now.year, now.month, now.day, 7, 0),);
    setState(() {
      _isLoading = true;
      _errorController.text = "";
    });
    getATutor();
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
      print(err);
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
        //print(parsed);
        _maxFbPage = parsed['data']['count'];
        //print(_maxFbPage);
        fbList = List.from(parsed['data']['rows']).map((e) => FeedbackItem.fromJson(e)).toList();
        fbList.forEach((element) {
          print(element.content);
        });
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

  final now = DateTime.now();
  late BookingService mockBookingService;

  Stream<dynamic>? getBookingStreamMock({required DateTime end, required DateTime start}) {
    return Stream.value([]);
  }

  Future<dynamic> uploadBookingMock({ required BookingService newBooking}) async {
    await Future.delayed(const Duration(seconds: 1));
    converted.add(DateTimeRange(
        start: newBooking.bookingStart, end: newBooking.bookingEnd));
    print('${newBooking.toJson()} has been uploaded');
  }

  List<DateTimeRange> converted = [];

  List<DateTimeRange> convertStreamResultMock({dynamic streamResult}) {
    ///here you can parse the streamresult and convert to [List<DateTimeRange>]
    DateTime firstCall = DateTime(now.year, now.month, now.day, 8);
    DateTime secondCall = DateTime(now.year, now.month, now.day, 10, 30);
    DateTime thirdCall = DateTime(now.year, now.month, now.day, 14, 30);
    DateTime fourthCall = DateTime(now.year, now.month, now.day, 16, 00);
    DateTime fifthCall = DateTime(now.year, now.month, now.day, 20, 30);
    DateTime sixthCall = DateTime(now.year, now.month, now.day, 22, 00);
    converted.add(DateTimeRange(start: firstCall, end: firstCall.add(Duration(minutes: 25))));
    //converted.add(DateTimeRange(start: secondCall, end: secondCall.add(Duration(minutes: 25))));
    converted.add(DateTimeRange(start: thirdCall, end: thirdCall.add(Duration(minutes: 25))));
    //converted.add(DateTimeRange(start: fourthCall, end: fourthCall.add(Duration(minutes: 25))));
    converted.add(DateTimeRange(start: fifthCall, end: fifthCall.add(Duration(minutes: 25))));
    converted.add(DateTimeRange(start: sixthCall, end: sixthCall.add(Duration(minutes: 25))));
    return converted;
  }

  List<DateTimeRange> generatePauseSlots() {
    return [
      DateTimeRange(
          start: DateTime(now.year, now.month, now.day, 0, 0),
          end: DateTime(now.year, now.month, now.day, 8, 0)),
      DateTimeRange(
          start: DateTime(now.year, now.month, now.day, 8, 30),
          end: DateTime(now.year, now.month, now.day, 10, 30)),
      DateTimeRange(
          start: DateTime(now.year, now.month, now.day, 11, 0),
          end: DateTime(now.year, now.month, now.day, 14, 30)),
      DateTimeRange(
          start: DateTime(now.year, now.month, now.day, 15, 0),
          end: DateTime(now.year, now.month, now.day, 16, 0)),
      DateTimeRange(
          start: DateTime(now.year, now.month, now.day, 16, 30),
          end: DateTime(now.year, now.month, now.day, 20, 0)),
      DateTimeRange(
          start: DateTime(now.year, now.month, now.day, 21, 00),
          end: DateTime(now.year, now.month, now.day, 22, 0)),
      DateTimeRange(
          start: DateTime(now.year, now.month, now.day, 22, 30),
          end: DateTime(now.year, now.month, now.day, 23, 59)),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                Navigator.popAndPushNamed(context, '/profile');
              }
              else if (value == 'Tutor') {
                Navigator.popAndPushNamed(context, '/tutor');
              }
              else if (value == 'Schedule') {
                Navigator.popAndPushNamed(context, '/schedule');
              }
              else if (value == 'History') {
                Navigator.popAndPushNamed(context, '/history');
              }
              else if (value == 'Courses') {
                Navigator.popAndPushNamed(context, '/courses');
              }
              else if (value == 'BecomeTutor') {
                Navigator.popAndPushNamed(context, '/become_tutor');
              }
              else if (value == 'Setting') {
                Navigator.popAndPushNamed(context, '/setting');
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
                                    message: tooltipMsg[index],
                                    child: Icon(Icons.star, color: Colors.yellow,),
                                  );
                                }))
                                  ..addAll(List.generate((5-thisTutor.rating!.toInt()), (index) {
                                    return Tooltip(
                                      message: tooltipMsg[4-index],
                                      child: Icon(Icons.star, color: Colors.grey,),
                                    );
                                  }).reversed)..add(
                                    thisTutor.totalFeedback != null
                                    ? Text("(${thisTutor.totalFeedback})", style: TextStyle(fontStyle: FontStyle.italic),)
                                    : Container(),
                                  )
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
                          searchTutorList(postBody: widget.theArg.postBody);
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
                          Text('Favorite', style: TextStyle(
                              color: thisTutor.isFavorite == true ? Colors.red : Colors.blue
                          ),),
                        ],
                      )
                  ),
                ),
                Expanded(
                  child: InkWell(
                      onTap: null,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 30,
                            height: 30,
                            child: Icon(Icons.info_outline, color: Colors.blue, size: 35,),
                          ),
                          SizedBox(height: 10,),
                          Text('Report', style: TextStyle(
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
                                      title: Text('Others review'),
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
                                                                  timeago.format(DateTime.parse(e.createdAt)),
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
                                                                      : Text('No reviews yet', style:  TextStyle(
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
                                            print(pagiController.currentPage + 1);
                                            query['page'] = (pagiController.currentPage + 1).toString();
                                            Future<void> fetchFb() async {
                                              return getFeedBack(query: query);
                                            }
                                            await fetchFb();
                                            setState(() {
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
                          Text('Reviews', style: TextStyle(
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
              'Languages',
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
              'Specialties',
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
                      ? Text(specList.firstWhere((sl) => sl['inJson'] == value)['toShow']!)
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
              'Suggested courses',
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
                      text: "Link",
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
              'Interests',
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
              'Teaching experience',
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
              'Schedule',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            alignment: Alignment.centerLeft,
            child: Text('Choose start time of classes to book.\nEach class lasts 25 minutes.',
              style: TextStyle(
                fontSize: 15,
              ),),
          ),
          SizedBox(
            width: double.infinity,
            height: 800,
            child: BookingCalendar(
              bookingService: mockBookingService,
              convertStreamResultToDateTimeRanges: convertStreamResultMock,
              getBookingStream: getBookingStreamMock,
              uploadBooking: uploadBookingMock,
              pauseSlots: generatePauseSlots(),
              pauseSlotText: 'Not have Class',
              hideBreakTime: false,
              loadingWidget: SizedBox(height: 50, width: 50, child: Text('Fetching data...'),),
              uploadingWidget: SizedBox(height: 50, width: 50, child: CircularProgressIndicator(),),
              startingDayOfWeek: StartingDayOfWeek.monday,
              //disabledDays: const [1, 2, 3, 4, 5],
            ),
          ),
        ],
      )
        : Center(
          child: Text(_errorController.text),
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
  final Map<String, dynamic> postBody;

  ProfileArg(this.id, this.postBody);
}