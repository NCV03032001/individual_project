import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:individual_project/model/Course/CourseList.dart';
import 'package:individual_project/model/User/UserProvider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';

import '../main.dart';

class CourseDiscover extends StatefulWidget {
  final CourseClass thisCourse;
  final int index;
  const CourseDiscover({Key? key, required this.thisCourse, required this.index}) : super(key: key);

  @override
  State<CourseDiscover> createState() => _CourseDiscoverState();
}

class _CourseDiscoverState extends State<CourseDiscover> {
  final theGetController c = Get.put(theGetController());

  bool _isLoading = false;

  final List<Map<String, String>> lvMap = [
    {"level": "0", "levelName": "Any Level",},
    {"level": "1", "levelName": "Beginner",},
    {"level": "2", "levelName": "Upper-Beginner",},
    {"level": "3", "levelName": "Pre-Intermediate",},
    {"level": "4", "levelName": "Intermediate",},
    {"level": "5", "levelName": "Upper-Intermediate",},
    {"level": "6", "levelName": "Pre-Advanced",},
    {"level": "7", "levelName": "Advanced",},
    {"level": "8", "levelName": "Very Advanced",},
  ];

  String _dropdownValue = "";
  String _downloadLink = "";
  PdfViewerController _pdfViewerController = PdfViewerController();

  void initState() {
    super.initState();
    _dropdownValue = widget.thisCourse.topics[widget.index].nameFile;
    _downloadLink = _dropdownValue;
  }

  @override
  Widget build(BuildContext context) {
    CourseClass thisCourse = widget.thisCourse;
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
        child: Column(
          children: [
            Card(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Image.network(thisCourse.imageUrl),
                  Container(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 15),
                          alignment: Alignment.centerLeft,
                          child: Text(thisCourse.name, style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis
                          ), maxLines: 2,),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 25),
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          alignment: Alignment.centerLeft,
                          child: Text(thisCourse.description, style: TextStyle(
                              fontSize: 17,
                              overflow: TextOverflow.ellipsis
                          ), maxLines: 3,),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 15),
                          alignment: Alignment.centerLeft,
                          child: Text("List Topics".tr, style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis
                          ), maxLines: 2,),
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                          child: DropdownButton(
                            isExpanded: true,
                            items: List.generate(thisCourse.topics.length ,(i) =>
                                DropdownMenuItem<String>(
                                  child: Text(
                                    "${i+1}.  ${thisCourse.topics[i].name}",
                                    style: TextStyle(
                                      fontSize: 17,
                                    ),
                                  ),
                                  value: thisCourse.topics[i].nameFile,
                                ),
                            ),
                            value: _dropdownValue,
                            onChanged: (val) {
                              if (val is String) {
                                setState(() {
                                  _isLoading = true;
                                  _dropdownValue = val;
                                });
                                // _pdfViewerKey.currentState!.setState(() {
                                //   _pdfViewerController.firstPage();
                                //   _pdfViewerController.zoomLevel = 1;
                                //   _pdfViewerController.notifyListeners();
                                // });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            _isLoading == true
            ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Changing PDF...'.tr),
            SizedBox(width: 10,),
            CircularProgressIndicator(),
          ],
        )
            : Container(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.zoom_out,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    _pdfViewerController.zoomLevel = 1;
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.zoom_in,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    _pdfViewerController.zoomLevel = 2;
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.download_outlined,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () async {
                    Map<Permission, PermissionStatus> statuses = await [
                      Permission.storage,
                    ].request();

                    if(statuses[Permission.storage]!.isGranted){
                      var dir = Directory('/storage/emulated/0/Download');
                      if(dir != null){
                        String savename = "${thisCourse.topics[thisCourse.topics.indexWhere((element) => element.nameFile == _downloadLink)].name}.pdf";
                        String savePath = "${dir.path}/$savename";
                        print(savePath);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Text('Confirm Download'.tr),
                            content: Text('${'Are you sure to download file:'.tr}\n\t\t\t\t$savename\n${'to:'.tr} ${savePath.replaceAll("/$savename", "")}?'),
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
                                  Navigator.pop(context, 'OK');
                                },
                                style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  backgroundColor: Colors.green,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                ),
                                child: Text(
                                  'Download'.tr,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ).then((value) async {
                          if(value == 'OK') {
                            try {
                              await Dio().download(
                                _downloadLink,
                                savePath,
                                /*onReceiveProgress: (received, total) {
                                if (total != -1) {
                                  print((received / total * 100).toStringAsFixed(0) + "%");
                                  //you can build progressbar feature too
                                }
                              }*/
                              );
                              print("File is saved to download folder.");
                              context.read<UserProvider>().getUser(context.read<UserProvider>().thisTokens.access);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('File is saved to download folder.'.tr, style: TextStyle(color: Colors.green),),
                                  duration: Duration(seconds: 3),
                                ),
                              );
                            } on DioError catch (e) {
                              print(e.message);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(e.message, style: TextStyle(color: Colors.red),),
                                  duration: Duration(seconds: 3),
                                ),
                              );
                            }
                          }
                        });
                      }
                    }
                    else{
                      print("No permission to read and write.");
                    }
                  },
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: Colors.grey,
                  )
              ),
              width: size.width,
              height: size.height,
              child: SfPdfViewer.network(
                _dropdownValue,
                controller: _pdfViewerController,
                onDocumentLoaded: (e) {
                  setState(() {
                    print("Loaded PDF");
                    _isLoading = false;
                    _downloadLink = _dropdownValue;
                  });
                },
              ),
            ),
          ],
        ),
      ),
      /*floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
        },
        backgroundColor: Colors.grey,
        child: const Icon(Icons.message_outlined),
      ),*/
    );
  }
}
