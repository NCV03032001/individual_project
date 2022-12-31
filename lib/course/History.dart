import 'dart:convert';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:individual_project/model/ScheduleNHistory/HistoryProvider.dart';
import 'package:individual_project/model/User/UserProvider.dart';
import 'package:individual_project/tutor/TutorProfile.dart';
import 'package:intl/intl.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';


class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  String _firstSelected ='assets/images/usaFlag.svg';

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
      _errorController.text = "";
    });

    getHistoryList(queryParameters);
  }

  bool _isLoading = false;
  TextEditingController _errorController = TextEditingController();

  List<String> tooltipMsg = ['terrible', 'bad', 'normal', 'good', 'wonderful'];
  List<String> list = <String>['One', 'Two', 'Three', 'Four'];
  List<Map<String, String>> reasonList = [
    {"id": '1', "value": "Tutor was late"},
    {"id": '2', "value": "Tutor was absent"},
    {"id": '3', "value": "Network unstable"},
    {"id": '4', "value": "Other"},
  ];

  int _maxPage = 1;
  final NumberPaginatorController _pagiController = NumberPaginatorController();
  Map<String, dynamic> queryParameters = {
    "page": '1',
    "perPage": '20',
    "dateTimeLte": DateTime.now().millisecondsSinceEpoch.toString(),
    "orderBy": 'meeting',
    "sortBy": 'desc'
  };

  DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);
  
  void getHistoryList(Map<String, dynamic>queryParameters) async {
    var url = Uri.https('sandbox.api.lettutor.com', 'booking/list/student', queryParameters);

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
      var historyList = Provider.of<HistoryProvider>(context, listen: false);
      historyList.fromJson(parsed["data"]);
      setState(() {
        _errorController.text = "";
      });
    }

    setState(() {
      _isLoading = false;
      var maxCount = context.read<HistoryProvider>().count;
      if (maxCount~/20 < maxCount/20) {
        _maxPage = maxCount~/20 + 1;
      }
      else {
        _maxPage = maxCount~/20;
      }

      if (_maxPage < 1) _maxPage = 1;
    });
  }
  void sendFeedback(String userId, int rating, String content, String bookingID) async {
    var url = Uri.https('sandbox.api.lettutor.com', 'user/feedbackTutor', );
    var response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          'Authorization': "Bearer ${context.read<UserProvider>().thisTokens.access.token}"
        },
        body: jsonEncode({"content": content, "rating": rating, "userId": userId, "bookingId":bookingID})
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
  void editFeedback(String fbId, int rating, String content) async {
    var url = Uri.https('sandbox.api.lettutor.com', 'user/feedbackTutor', );
    var response = await http.put(url,
        headers: {
          "Content-Type": "application/json",
          'Authorization': "Bearer ${context.read<UserProvider>().thisTokens.access.token}"
        },
        body: jsonEncode({"content": content, "rating": rating, "id": fbId})
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
  void saveReport(String reasonId, String? note, String bookingID) async {
    var url = Uri.https('sandbox.api.lettutor.com', 'lesson-report/save-report', );
    var response = await http.put(url,
        headers: {
          "Content-Type": "application/json",
          'Authorization': "Bearer ${context.read<UserProvider>().thisTokens.access.token}"
        },
        body: jsonEncode({"reasonId": reasonId, "note": note, "bookingId":bookingID})
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Thank you! Your report was sent.', style: TextStyle(color: Colors.green),),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  final FocusNode _dialogFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    var readHistoryList = context.read<HistoryProvider>().rows;
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).backgroundColor,
        title: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  "/tutor",
                      (route) => route.isCurrent && route.settings.name == "/tutor"
                      ? false
                      : true);
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
                Navigator.pushNamed(context, '/tutor');
              }
              else if (value == 'Schedule') {
                Navigator.pushNamed(context, '/schedule');
              }
              else if (value == 'History') {
                Navigator.pushReplacementNamed(context, '/history');
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
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 20),
              alignment: Alignment.centerLeft,
              child: Text(
                'History',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 60, height: 60, child: SvgPicture.asset('assets/images/History.svg'),),
                SizedBox(width: 10,),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
                    padding: EdgeInsets.only(left: 10),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(color: Colors.grey, width: 5),
                        )
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('The following is a list of lessons you have attended',
                          style: TextStyle(fontSize: 15,),
                        ),
                        Text('You can review the details of the lessons you have attended', style: TextStyle(fontSize: 15),),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            _isLoading == true
            ? CircularProgressIndicator()
            : _errorController.text.isNotEmpty
            ? Text(_errorController.text)
            : readHistoryList.isEmpty
            ? Text("No History Found")
            : Container(
              margin: EdgeInsets.fromLTRB(0,20, 0, 15),
              height: size.height/1.75,
              child: ListView(
                children: readHistoryList.map((e) {
                  var startStamp = e.scheduleDetailInfo.startPeriodTimestamp;
                  var endStamp = e.scheduleDetailInfo.endPeriodTimestamp;
                  var startDateTime = DateTime.fromMillisecondsSinceEpoch(startStamp);
                  var endDateTime = DateTime.fromMillisecondsSinceEpoch(endStamp);

                  var tutorInfo = e.scheduleDetailInfo.scheduleInfo.tutorInfo;

                  return Container(
                    width: size.width,
                    margin: EdgeInsets.only(bottom: 10),
                    padding: EdgeInsets.all(15),
                    color: Color.fromRGBO(192, 192, 192, 1),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(DateFormat('E, dd, MMM, yy').format(startDateTime), style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),),
                                  Text(timeago.format(endDateTime)),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Row(
                                children: [
                                  SizedBox(
                                    height: 60,
                                    width: 60,
                                    child: tutorInfo.avatar != null
                                    ? ImageProfile(Image.network(tutorInfo.avatar!).image, ProfileArg(tutorInfo.id, null))
                                    : ImageProfile(Image.network("").image, ProfileArg(tutorInfo.id, null)),
                                  ),
                                  SizedBox(width: 10,),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () => Navigator.pushNamed(context, '/tutor_profile', arguments: ProfileArg(tutorInfo.id, null)),
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            margin: EdgeInsets.only(bottom: 5),
                                            child: Text(
                                              tutorInfo.name,
                                              style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis ,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(bottom: 5),
                                          child: e.scheduleDetailInfo.scheduleInfo.tutorInfo.country != null
                                          ? Country.tryParse(tutorInfo.country!) != null
                                          ? Row(
                                            children: [
                                              SizedBox(
                                                width: 15,
                                                height: 15,
                                                child: Text(Country.tryParse(tutorInfo.country!)!.flagEmoji),
                                              ),
                                              SizedBox(width: 5),
                                              Text(Country.tryParse(tutorInfo.country!)!.name),
                                            ],
                                          )
                                          : Row(
                                            children: [
                                              SizedBox(
                                                width: 15,
                                                height: 15,
                                                child: Image.asset('assets/images/icons/close.png'),
                                              ),
                                              SizedBox(width: 5),
                                              Text("Invalid country"),
                                            ],
                                          )
                                          : Row(
                                              children: [
                                                SizedBox(
                                                  width: 15,
                                                  height: 15,
                                                  child: Image.asset('assets/images/icons/close.png'),
                                                ),
                                                SizedBox(width: 5),
                                                Text("Not set country"),
                                              ],
                                              ),
                                        ),
                                        /*GestureDetector(
                                            onTap: null,
                                            child: Row(
                                              children: [
                                                Icon(Icons.message_outlined, color: Colors.blue, size: 15,),
                                                SizedBox(width: 3,),
                                                Text('Derect Message', style: TextStyle(
                                                  color: Colors.blue,
                                                ),),
                                              ],
                                            )
                                        )*/
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
                          padding: EdgeInsets.all(10),
                          color: Theme.of(context).backgroundColor,
                          height: 50,
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              Text('Lesson Time: ${DateFormat('HH:mm').format(startDateTime)} - ${DateFormat('HH:mm').format(endDateTime)}', style: TextStyle(
                                  fontSize: 17
                              ),),
                              e.recordUrl != null && e.showRecordUrl == true
                              ? Expanded(
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  child: ElevatedButton.icon(
                                    onPressed: () async {
                                      Uri url = Uri.parse(e.recordUrl!);
                                      if (!await launchUrl(url)) {
                                        throw 'Could not launch $url';
                                      }
                                    },
                                    style: OutlinedButton.styleFrom(
                                      padding: EdgeInsets.all(5),
                                      backgroundColor: Colors.blue,
                                    ),
                                    icon: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: Image.asset('assets/images/icons/Ytb.png', color: Colors.white,),
                                    ),
                                    label: Text(
                                      'Record',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              : Container(),
                            ],
                          ),
                        ),
                        e.studentRequest != null
                          ? ExpansionTile(
                        title: Text('Request for lesson'),
                        collapsedBackgroundColor: Theme.of(context).backgroundColor,
                        backgroundColor: Theme.of(context).backgroundColor,
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
                            alignment: Alignment.centerLeft,
                            child: Text(e.studentRequest!),
                          ),
                        ],
                      )
                          : Container(
                        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                        height: 50,
                        color: Theme.of(context).backgroundColor,
                        alignment: Alignment.centerLeft,
                        child: Text('No request for lesson', style: TextStyle(fontSize: 16),),
                      ),
                        Container(
                          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                          height: 50,
                          color: Theme.of(context).backgroundColor,
                          alignment: Alignment.centerLeft,
                          child: e.scoreByTutor != null
                          ? Text('Mark: ${e.scoreByTutor}', style: TextStyle(fontSize: 16),)
                          : Text('Tutor haven\'t marked yet', style: TextStyle(fontSize: 16),),
                        ),
                        e.tutorReview != null
                          ? ExpansionTile(
                        title: Text('Review from tutor'),
                        collapsedBackgroundColor: Theme.of(context).backgroundColor,
                        backgroundColor: Theme.of(context).backgroundColor,
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
                            alignment: Alignment.centerLeft,
                            child: Text(e.tutorReview!),
                          ),
                        ],

                      )
                          : Container(
                            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                            height: 50,
                            color: Theme.of(context).backgroundColor,
                            alignment: Alignment.centerLeft,
                            child: Text('Tutor haven\'t reviewed yet', style: TextStyle(fontSize: 16),),
                          ),
                        e.feedbacks.isEmpty
                        ? Container(
                            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                            alignment: Alignment.centerLeft,
                            height: 50,
                            color: Theme.of(context).backgroundColor,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: GestureDetector(
                                      onTap: () {
                                        TextEditingController contentController = TextEditingController();
                                        int rating = 5;
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            double width = MediaQuery.of(context).size.width;
                                            double height = MediaQuery.of(context).size.height;
                                            return Focus(
                                              focusNode: _dialogFocus,
                                              child: AlertDialog(
                                                title: Text('Rating'),
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
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          SizedBox(
                                                            height: 80,
                                                            width: 80,
                                                            child: CircleAvatar(
                                                              radius: 80.0,
                                                              backgroundImage: tutorInfo.avatar != null
                                                              ? Image.network(tutorInfo.avatar!).image
                                                              : Image.network("").image,
                                                            ),
                                                          ),
                                                          Text(tutorInfo.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),),
                                                          Container(
                                                              margin: EdgeInsets.only(top: 10),
                                                              child: Text('Lesson Time')
                                                          ),
                                                          Container(
                                                              margin: EdgeInsets.only(bottom: 10),
                                                              child: Text(
                                                                '${DateFormat('E, dd MMM yy, HH:mm').format(startDateTime)} - ${DateFormat('HH:mm').format(endDateTime)}',
                                                                style: TextStyle(
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                              )
                                                          ),
                                                          Divider(thickness: 2,),
                                                          Container(
                                                            margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                                            child: Text(
                                                              'What is your rating for ${tutorInfo.name}?',
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 17,
                                                              ),
                                                            )
                                                          ),
                                                          RatingBar.builder(
                                                            initialRating: 5,
                                                            minRating: 1,
                                                            direction: Axis.horizontal,
                                                            itemCount: 5,
                                                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                                            itemBuilder: (context, _) => Tooltip(
                                                              message: tooltipMsg[_],
                                                              child: Icon(Icons.star, color: Colors.amber,),
                                                            ),
                                                            onRatingUpdate: (r) {
                                                              rating = r.toInt();
                                                            },
                                                          ),
                                                          Container(
                                                            margin: EdgeInsets.only(top: 15),
                                                            child: TextFormField(
                                                              keyboardType: TextInputType.multiline,
                                                              minLines: 3,
                                                              maxLines: 8,
                                                              controller: contentController,
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
                                                                hintText: "Content Review",
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
                                                      'Later',
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
                                                      'Submit',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                        ).then((value) async {
                                          if(value == "OK") {
                                            Future<void> edit() async{return sendFeedback(tutorInfo.id, rating, contentController.text, e.id);};
                                            await edit();

                                            getHistoryList(queryParameters);
                                          }
                                        });
                                      },
                                      child: Text('Add a Rating', style: TextStyle(color: Colors.blue),),
                                    ),
                                  )
                                ),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.centerRight,
                                    child: GestureDetector(
                                      onTap: () {
                                        String reasonId = '1';
                                        TextEditingController noteController = TextEditingController();
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              double width = MediaQuery.of(context).size.width;
                                              double height = MediaQuery.of(context).size.height;
                                              return StatefulBuilder(
                                                  builder: (context, setState) {
                                                    return Focus(
                                                      focusNode: _dialogFocus,
                                                      child: AlertDialog(
                                                        title: Text('Reporting'),
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
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  SizedBox(
                                                                    height: 80,
                                                                    width: 80,
                                                                    child: CircleAvatar(
                                                                      radius: 80.0,
                                                                      backgroundImage: tutorInfo.avatar != null
                                                                          ? Image.network(tutorInfo.avatar!).image
                                                                          : Image.network("").image,
                                                                    ),
                                                                  ),
                                                                  Text(tutorInfo.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),),
                                                                  Container(
                                                                      margin: EdgeInsets.only(top: 10),
                                                                      child: Text('Lesson Time')
                                                                  ),
                                                                  Container(
                                                                      margin: EdgeInsets.only(bottom: 10),
                                                                      child: Text(
                                                                        '${DateFormat('E, dd MMM yy, HH:mm').format(startDateTime)} - ${DateFormat('HH:mm').format(endDateTime)}',
                                                                        style: TextStyle(
                                                                          fontWeight: FontWeight.bold,
                                                                        ),
                                                                      )
                                                                  ),
                                                                  Divider(thickness: 2,),
                                                                  Container(
                                                                    margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                                                    child: RichText(
                                                                      text: TextSpan(
                                                                          text: "*",
                                                                          style: TextStyle(
                                                                            color: Colors.red,
                                                                          ),
                                                                          children: [
                                                                            TextSpan(
                                                                              text: ' What was the reason you reported on the lesson?',
                                                                              style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Theme.of(context).primaryColor,
                                                                                fontSize: 17,
                                                                              ),
                                                                            )
                                                                          ]
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  DropdownButton<String>(
                                                                    value: reasonId,
                                                                    icon: const Icon(Icons.arrow_downward),
                                                                    elevation: 16,
                                                                    style: TextStyle(
                                                                      color: Theme.of(context).primaryColor,
                                                                    ),
                                                                    onChanged: (String? value) {
                                                                      // This is called when the user selects an item.
                                                                      setState(() {
                                                                        reasonId = value!;
                                                                      });
                                                                    },
                                                                    items: List.generate(reasonList.length, (index) {
                                                                      return DropdownMenuItem(
                                                                        value: reasonList[index]['id'],
                                                                        child: Text(reasonList[index]['value']!),
                                                                      );
                                                                    }),
                                                                  ),
                                                                  Container(
                                                                    margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                                                    child: TextFormField(
                                                                      controller: noteController,
                                                                      keyboardType: TextInputType.multiline,
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
                                                                        hintText: "Additional Notes",
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
                                                              'Later',
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
                                                              'Submit',
                                                              style: TextStyle(
                                                                color: Colors.white,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }
                                              );
                                            }
                                        ).then((value) {
                                          if(value == "OK") {
                                            String? tempNote;
                                            if (noteController.text.isNotEmpty) tempNote = noteController.text;

                                            saveReport(reasonId, tempNote, e.id);
                                          }
                                        });
                                      },
                                      child: Text('Report', style: TextStyle(color: Colors.blue),),
                                    ),
                                  )
                                ),
                              ],
                            )
                        )
                        : Column(
                          children: e.feedbacks.map((fb) {
                            return Container(
                              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                              alignment: Alignment.centerLeft,
                              height: 50,
                              color: Theme.of(context).backgroundColor,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Row(
                                      children: []
                                        ..add(Text('Rating: '))
                                        ..addAll(List.generate(fb.rating.toInt(), (index) {
                                          return Tooltip(
                                            message: tooltipMsg[index],
                                            child: Icon(Icons.star, color: Colors.yellow,),
                                          );
                                        })
                                        ..addAll(List.generate((5-fb.rating.toInt()), (index) {
                                          return Tooltip(
                                            message: tooltipMsg[4-index],
                                            child: Icon(Icons.star, color: Colors.grey,),
                                          );
                                        }).reversed)
                                        ..add(Expanded(
                                          child: Container(
                                          alignment: Alignment.centerRight,
                                            child: GestureDetector(
                                              onTap: () {
                                                TextEditingController contentController = TextEditingController();
                                                contentController.text = fb.content;
                                                int rating = 5;
                                                showDialog(
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      double width = MediaQuery.of(context).size.width;
                                                      double height = MediaQuery.of(context).size.height;
                                                      return Focus(
                                                        focusNode: _dialogFocus,
                                                        child: AlertDialog(
                                                          title: Text('Edit Rating'),
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
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    SizedBox(
                                                                      height: 80,
                                                                      width: 80,
                                                                      child: CircleAvatar(
                                                                        radius: 80.0,
                                                                        backgroundImage: tutorInfo.avatar != null
                                                                            ? Image.network(tutorInfo.avatar!).image
                                                                            : Image.network("").image,
                                                                      ),
                                                                    ),
                                                                    Text(tutorInfo.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),),
                                                                    Container(
                                                                        margin: EdgeInsets.only(top: 10),
                                                                        child: Text('Lesson Time')
                                                                    ),
                                                                    Container(
                                                                        margin: EdgeInsets.only(bottom: 10),
                                                                        child: Text(
                                                                          '${DateFormat('E, dd MMM yy, HH:mm').format(startDateTime)} - ${DateFormat('HH:mm').format(endDateTime)}',
                                                                          style: TextStyle(
                                                                            fontWeight: FontWeight.bold,
                                                                          ),
                                                                        )
                                                                    ),
                                                                    Divider(thickness: 2,),
                                                                    Container(
                                                                        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                                                        child: Text(
                                                                          'What is your rating for ${tutorInfo.name}?',
                                                                          style: TextStyle(
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 17,
                                                                          ),
                                                                        )
                                                                    ),
                                                                    RatingBar.builder(
                                                                      initialRating: fb.rating.toDouble(),
                                                                      minRating: 1,
                                                                      direction: Axis.horizontal,
                                                                      itemCount: 5,
                                                                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                                                      itemBuilder: (context, _) => Tooltip(
                                                                        message: tooltipMsg[_],
                                                                        child: Icon(Icons.star, color: Colors.amber,),
                                                                      ),
                                                                      onRatingUpdate: (r) {
                                                                        rating = r.toInt();
                                                                      },
                                                                    ),
                                                                    Container(
                                                                      margin: EdgeInsets.only(top: 15),
                                                                      child: TextFormField(
                                                                        keyboardType: TextInputType.multiline,
                                                                        minLines: 3,
                                                                        maxLines: 8,
                                                                        controller: contentController,
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
                                                                          hintText: "Content Review",
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
                                                                'Later',
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
                                                                'Submit',
                                                                style: TextStyle(
                                                                  color: Colors.white,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    }
                                                ).then((value) async {
                                                  if(value == "OK") {
                                                    Future<void> edit() async{editFeedback(fb.id, rating, contentController.text);}
                                                    await edit();

                                                    getHistoryList(queryParameters);
                                                  }
                                                });
                                              },
                                              child: Text('Edit', style: TextStyle(color: Colors.blue),),
                                            ),
                                          )
                                        )),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      child: Container(
                                        alignment: Alignment.centerRight,
                                        child: GestureDetector(
                                          onTap: () {
                                            String reasonId = '1';
                                            TextEditingController noteController = TextEditingController();
                                            showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  double width = MediaQuery.of(context).size.width;
                                                  double height = MediaQuery.of(context).size.height;
                                                  return StatefulBuilder(
                                                      builder: (context, setState) {
                                                        return Focus(
                                                          focusNode: _dialogFocus,
                                                          child: AlertDialog(
                                                            title: Text('Reporting'),
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
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    children: [
                                                                      SizedBox(
                                                                        height: 80,
                                                                        width: 80,
                                                                        child: CircleAvatar(
                                                                          radius: 80.0,
                                                                          backgroundImage: tutorInfo.avatar != null
                                                                              ? Image.network(tutorInfo.avatar!).image
                                                                              : Image.network("").image,
                                                                        ),
                                                                      ),
                                                                      Text(tutorInfo.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),),
                                                                      Container(
                                                                          margin: EdgeInsets.only(top: 10),
                                                                          child: Text('Lesson Time')
                                                                      ),
                                                                      Container(
                                                                          margin: EdgeInsets.only(bottom: 10),
                                                                          child: Text(
                                                                            '${DateFormat('E, dd MMM yy, HH:mm').format(startDateTime)} - ${DateFormat('HH:mm').format(endDateTime)}',
                                                                            style: TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                          )
                                                                      ),
                                                                      Divider(thickness: 2,),
                                                                      Container(
                                                                        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                                                        child: RichText(
                                                                          text: TextSpan(
                                                                              text: "*",
                                                                              style: TextStyle(
                                                                                color: Colors.red,
                                                                              ),
                                                                              children: [
                                                                                TextSpan(
                                                                                  text: ' What was the reason you reported on the lesson?',
                                                                                  style: TextStyle(
                                                                                    fontWeight: FontWeight.bold,
                                                                                    color: Theme.of(context).primaryColor,
                                                                                    fontSize: 17,
                                                                                  ),
                                                                                )
                                                                              ]
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      DropdownButton<String>(
                                                                        value: reasonId,
                                                                        icon: const Icon(Icons.arrow_downward),
                                                                        elevation: 16,
                                                                        style: TextStyle(
                                                                          color: Theme.of(context).primaryColor,
                                                                        ),
                                                                        onChanged: (String? value) {
                                                                          // This is called when the user selects an item.
                                                                          setState(() {
                                                                            reasonId = value!;
                                                                          });
                                                                        },
                                                                        items: List.generate(reasonList.length, (index) {
                                                                          return DropdownMenuItem(
                                                                            value: reasonList[index]['id'],
                                                                            child: Text(reasonList[index]['value']!),
                                                                          );
                                                                        }),
                                                                      ),
                                                                      Container(
                                                                        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                                                        child: TextFormField(
                                                                          controller: noteController,
                                                                          keyboardType: TextInputType.multiline,
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
                                                                            hintText: "Additional Notes",
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
                                                                  'Later',
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
                                                                  'Submit',
                                                                  style: TextStyle(
                                                                    color: Colors.white,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      }
                                                  );
                                                }
                                            ).then((value) {
                                              if(value == "OK") {
                                                String? tempNote;
                                                if (noteController.text.isNotEmpty) tempNote = noteController.text;

                                                saveReport(reasonId, tempNote, e.id);
                                              }
                                            });
                                          },
                                          child: Text('Report', style: TextStyle(color: Colors.blue),),
                                        ),
                                      )
                                  ),
                                ],
                              )
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 15,),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            NumberPaginator(
              controller: _pagiController,
              numberPages: _maxPage,
              initialPage: 0,
              onPageChange: (int index) {
                queryParameters['page'] = (_pagiController.currentPage + 1).toString();
                getHistoryList(queryParameters);
              },
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
    );
  }

  Widget ImageProfile(ImageProvider input, ProfileArg arg) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/tutor_profile' , arguments: arg),
      child: CircleAvatar(
        radius: 80.0,
        backgroundImage: input,
      ),
    );
  }
}
