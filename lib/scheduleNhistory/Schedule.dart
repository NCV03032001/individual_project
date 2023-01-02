import 'dart:convert';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:individual_project/model/ScheduleNHistory/ScheduleProvider.dart';
import 'package:individual_project/model/User/UserProvider.dart';
import 'package:intl/intl.dart';
import 'package:jitsi_meet_wrapper/jitsi_meet_wrapper.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../main.dart';


class Schedule extends StatefulWidget {
  const Schedule({Key? key}) : super(key: key);

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  final Controller c = Get.put(Controller());

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
      _errorController.text = "";
    });

    getScheduleList(queryParameters);
  }

  bool _isLoading = false;
  TextEditingController _errorController = TextEditingController();

  List<Map<String, String>> reasonList = [
    {"id": '1', "value": "Reschedule at another time"},
    {"id": '2', "value": "Busy at that time"},
    {"id": '3', "value": "Asked by the tutor"},
    {"id": '4', "value": "Other"},
  ];

  int _maxPage = 1;
  final NumberPaginatorController _pagiController = NumberPaginatorController();
  Map<String, dynamic> queryParameters = {
    "page": '1',
    "perPage": '20',
    "dateTimeGte": DateTime.now().millisecondsSinceEpoch.toString(),
    "orderBy": 'meeting',
    "sortBy": 'asc'
  };

  DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);
  DateTime now =DateTime.now();

  void getScheduleList(Map<String, dynamic>queryParameters) async {
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
      var scheduleList = Provider.of<ScheduleProvider>(context, listen: false);
      scheduleList.fromJson(parsed["data"]);
      setState(() {
        _errorController.text = "";
      });
    }

    setState(() {
      _isLoading = false;
      var maxCount = context.read<ScheduleProvider>().count;
      if (maxCount~/20 < maxCount/20) {
        _maxPage = maxCount~/20 + 1;
      }
      else {
        _maxPage = maxCount~/20;
      }

      if (_maxPage < 1) _maxPage = 1;
    });
  }
  void editRequest(String content, String bookingID) async {
    var url = Uri.https('sandbox.api.lettutor.com', 'booking/student-request/$bookingID');
    var response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          'Authorization': "Bearer ${context.read<UserProvider>().thisTokens.access.token}"
        },
        body: jsonEncode({"studentRequest": content})
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
          content: Text("Edit success".tr, style: TextStyle(color: Colors.green),),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
  void cancelSchedule(String reasonId, String? note, String bookingID) async {
    var url = Uri.https('sandbox.api.lettutor.com', 'booking/schedule-detail', );

    Map<String, dynamic> body = {
      "scheduleDetailId": bookingID,
      "cancelInfo": {
        "cancelReasonId": reasonId,
        "note": note
      }
    };

    var response = await http.delete(url,
        headers: {
          "Content-Type": "application/json",
          'Authorization': "Bearer ${context.read<UserProvider>().thisTokens.access.token}"
        },
        body: jsonEncode(body)
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

  final FocusNode _dialogFocus = FocusNode();

  final _editRequestKey = GlobalKey<FormState>();

  

  @override
  Widget build(BuildContext context) {
    var readScheduleList = context.read<ScheduleProvider>().rows;
    var size = MediaQuery.of(context).size;

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
                Navigator.pushNamed(context, '/tutor');
              }
              else if (value == 'Schedule') {
                Navigator.pushReplacementNamed(context, '/schedule');
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
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 20),
              alignment: Alignment.centerLeft,
              child: Text(
                'Schedule'.tr,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 60, height: 60, child: SvgPicture.asset('assets/images/Schedule.svg'),),
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
                        Text('Here is a list of the sessions you have booked'.tr,
                          style: TextStyle(fontSize: 15,),
                        ),
                        Text('You can track when the meeting starts, join the meeting with one click or can cancel the meeting before 2 hours'.tr, style: TextStyle(fontSize: 15),),
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
            : readScheduleList.isEmpty
            ? Text("No Schedule Found.".tr)
            :Container(
              margin: EdgeInsets.fromLTRB(0,20, 0, 15),
              height: size.height/1.75,
              child: ListView(
                children: readScheduleList.map((e) {
                  var startStamp = e.scheduleDetailInfo.startPeriodTimestamp;
                  var endStamp = e.scheduleDetailInfo.endPeriodTimestamp;
                  var startDateTime = DateTime.fromMillisecondsSinceEpoch(startStamp);
                  var endDateTime = DateTime.fromMillisecondsSinceEpoch(endStamp);

                  var tutorInfo = e.scheduleDetailInfo.scheduleInfo.tutorInfo;

                  var startTimeCompare = startDateTime.difference(now).compareTo(Duration(hours: 2));
                  var endTimeCompare = endDateTime.compareTo(now);

                  var userInfo = context.read<UserProvider>().thisUser;

                  return Container(
                    width: double.infinity,
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
                                  Text(DateFormat('E, dd, MMM, yy', c.testLocale.value.languageCode).format(startDateTime), style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),),
                                  Text('1 ${'lesson'.tr}'),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Container(
                                padding: EdgeInsets.all(10),
                                color: Theme.of(context).backgroundColor,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      height: 60,
                                      width: 60,
                                      child: tutorInfo.avatar != null
                                          ? ImageProfile(Image.network(tutorInfo.avatar!).image)
                                          : ImageProfile(Image.network("").image),
                                    ),
                                    SizedBox(width: 10,),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Container(
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
                                          ),
                                        ),*/
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
                          width: double.infinity,
                          margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
                          padding: EdgeInsets.all(10),
                          color: Theme.of(context).backgroundColor,
                          child: Column(
                            children: [
                              Container(
                                height: 50,
                                margin: EdgeInsets.only(bottom: 15),
                                child: Row(
                                  children: [
                                    Text('${'Lesson Time:'.tr} ${DateFormat('HH:mm').format(startDateTime)} - ${DateFormat('HH:mm').format(endDateTime)}', style: TextStyle(
                                        fontSize: 17
                                    ),),
                                    startTimeCompare > 0
                                    ? Expanded(
                                      child: Container(
                                        width: double.infinity,
                                        alignment: Alignment.centerRight,
                                        child: ElevatedButton.icon(
                                          onPressed: () {
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
                                                            title: Text('Cancel Schedule'.tr),
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
                                                                            '${DateFormat('E, dd MMM yy, HH:mm', c.testLocale.value.languageCode).format(startDateTime)} - ${DateFormat('HH:mm').format(endDateTime)}',
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
                                                                              text: "* ",
                                                                              style: TextStyle(
                                                                                color: Colors.red,
                                                                              ),
                                                                              children: [
                                                                                TextSpan(
                                                                                  text: 'What was the reason you cancel this booking?'.tr,
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
                                                                            hintText: "Additional Notes".tr,
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
                                                                  'Later'.tr,
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
                                                                  'Submit Cancel'.tr,
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
                                            ).then((value) async {
                                              if(value == "OK") {
                                                String? tempNote;
                                                if (noteController.text.isNotEmpty) tempNote = noteController.text;

                                                Future<void> cancel() async{return cancelSchedule(reasonId, tempNote, e.id);};
                                                await cancel();

                                                getScheduleList(queryParameters);
                                              }
                                            });
                                          },
                                          style: OutlinedButton.styleFrom(
                                            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                            backgroundColor: Colors.white,
                                            side: BorderSide(color: Colors.red, width: 1),
                                          ),
                                          icon: Icon(Icons.cancel_outlined, color: Colors.red, size: 15,),
                                          label: Text(
                                            'Cancel'.tr,
                                            style: TextStyle(
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                    : Container(),
                                  ],
                                ),
                              ),
                              ExpansionTile(
                                title: Container(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text('Request for lesson'.tr),
                                        Expanded(child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                TextEditingController contentController = TextEditingController();
                                                if (e.studentRequest != null) contentController.text = e.studentRequest!;

                                                showDialog(
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      double width = MediaQuery.of(context).size.width;
                                                      double height = MediaQuery.of(context).size.height;
                                                      return Focus(
                                                        focusNode: _dialogFocus,
                                                        child: AlertDialog(
                                                          title: Text('Special Request'.tr),
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
                                                                child: Form(
                                                                  key: _editRequestKey,
                                                                  child: Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Container(
                                                                        margin: EdgeInsets.only(bottom: 10),
                                                                        child: RichText(
                                                                          text: TextSpan(
                                                                              text: "* ",
                                                                              style: TextStyle(
                                                                                color: Colors.red,
                                                                              ),
                                                                              children: [
                                                                                TextSpan(
                                                                                  text: 'Note'.tr,
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
                                                                      Container(
                                                                        margin: EdgeInsets.only(bottom: 10),
                                                                        child: TextFormField(
                                                                          keyboardType: TextInputType.multiline,
                                                                          minLines: 5,
                                                                          maxLines: 10,
                                                                          maxLength: 200,
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
                                                                            errorBorder: OutlineInputBorder(
                                                                              borderSide: BorderSide(width: 1, color: Colors.red),
                                                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                            ),
                                                                            focusedErrorBorder: OutlineInputBorder(
                                                                              borderSide: BorderSide(width: 1, color: Colors.orange),
                                                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                            ),
                                                                            hintText: "Wish topic (optional)".tr,
                                                                            isCollapsed: true,
                                                                            errorStyle: TextStyle(fontSize: 15),
                                                                          ),
                                                                          autovalidateMode: AutovalidateMode.always,
                                                                          validator: (val) {
                                                                            if(val == null || val.isEmpty){
                                                                              return "Notes cannot be empty!".tr;
                                                                            }
                                                                            return null;
                                                                          }
                                                                        ),
                                                                      ),
                                                                      Text('You can write in English or Vietnamese (Maximum 200 letters)',
                                                                        style: TextStyle(
                                                                          fontSize: 15,
                                                                          fontWeight: FontWeight.w300,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
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
                                                              onPressed: () {
                                                                if(_editRequestKey.currentState!.validate()) {
                                                                  Navigator.pop(context, 'OK');
                                                                }
                                                              },
                                                              style: OutlinedButton.styleFrom(
                                                                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                                                backgroundColor: Colors.blue,
                                                                shape: const RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                ),
                                                              ),
                                                              child: Text(
                                                                'Save'.tr,
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
                                                    editRequest(contentController.text, e.id);
                                                    getScheduleList(queryParameters);
                                                  }
                                                });
                                              },
                                              child: Text('Edit request'.tr, style: TextStyle(color: Colors.blue),),
                                            ),
                                          ],
                                        )),
                                      ],
                                    )
                                  ),

                                  collapsedBackgroundColor: Color.fromRGBO(192, 192, 192, 1),
                                  backgroundColor: Color.fromRGBO(192, 192, 192, 1),
                                  children: [
                                    Container(
                                        padding: EdgeInsets.all(15),
                                        alignment: Alignment.centerLeft,
                                        color: Theme.of(context).backgroundColor,
                                        child: e.studentRequest != null
                                        ? Text(e.studentRequest!)
                                        : Text('Currently there are no requests for this class. Please write down any requests for the teacher.'.tr, style: TextStyle(fontWeight: FontWeight.w300),),
                                    ),
                                  ]
                              ),
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.all(15),
                              backgroundColor: startTimeCompare <= 0 && endTimeCompare >0 ?Colors.blue :Colors.grey,
                            ),
                            child: Text(
                              'Go to meeting'.tr,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                            onPressed: startTimeCompare <= 0 ? () async{
                              var options = JitsiMeetingOptions(
                                roomNameOrUrl: "${e.userId}-${tutorInfo.id}",
                                serverUrl: "https://meet.lettutor.com",
                                isAudioMuted: true,
                                isVideoMuted: true,
                                userDisplayName: "${userInfo.name}",
                                userEmail: "${userInfo.email}",
                              );

                              await JitsiMeetWrapper.joinMeeting(
                                options: options,
                                listener: JitsiMeetingListener(
                                  onConferenceWillJoin: (url) => print("onConferenceWillJoin: url: $url"),
                                  onConferenceJoined: (url) => print("onConferenceJoined: url: $url"),
                                  onConferenceTerminated: (url, error) => print("onConferenceTerminated: url: $url, error: $error"),
                                ),
                              );
                            }
                            : null, //sửa sau
                          ),
                        ),
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
                getScheduleList(queryParameters);
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
  Widget ImageProfile(ImageProvider input) {
    return CircleAvatar(
      radius: 80.0,
      backgroundImage: input,
    );
  }
}