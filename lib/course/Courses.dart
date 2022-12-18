import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:individual_project/model/CourseList.dart';
import 'package:individual_project/model/UserProvider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:number_paginator/number_paginator.dart';

class Courses extends StatefulWidget {
  const Courses({Key? key}) : super(key: key);

  @override
  State<Courses> createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {
  String _firstSelected ='assets/images/usaFlag.svg';

  final FocusNode _screenFocus = FocusNode();
  bool _isLoading = false;

  int _maxPage = 1;
  final NumberPaginatorController _pagiController = NumberPaginatorController();

  TextEditingController _errorController = TextEditingController();

  final TextEditingController _nController = TextEditingController();
  final FocusNode _nFocus = FocusNode();

  final _lvKey = GlobalKey<DropdownSearchState<String>>();
  final List<String> lvItems = [
    'Any Level',
    'Beginner',
    'Upper-Beginner',
    'Pre-Intermediate',
    'Intermediate',
    'Upper-Intermediate',
    'Pre-Advanced',
    'Advanced',
    'Very Advanced',
  ];
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
  final FocusNode _lvFocus = FocusNode();

  final _cKey = GlobalKey<DropdownSearchState<String>>();
  final List<String> cItems = [
    'For Study Aboard',
    'English for Traveling',
    'English for Beginners',
    'Business English',
    'Conversational English',
    'English for kids',
    'STARTERS',
    'MOVERS',
    'FLYERS',
    'PET',
    'IELTS',
    'TOEFL',
    'TOEIC',
  ];
  final FocusNode _cFocus = FocusNode();

  final _sKey = GlobalKey<DropdownSearchState<String>>();
  final List<String> sItems = [
    'Level decreasing',
    'Level ascending',
  ];
  final FocusNode _sFocus = FocusNode();

  final FocusNode _rsFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    setState(() {
      _errorController.text = "";
      _isLoading = true;
    });

    getCourseList();
  }

  void getCourseList({Map<String, String> queryParameters = const {'size': '6','page': '1',}}) async {
    var url = Uri.https('sandbox.api.lettutor.com', 'course', queryParameters);

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
      var courseList = Provider.of<CourseList>(context, listen: false);
      courseList.fromJson(parsed["data"]);
      setState(() {
        _errorController.text = "";
      });
    }
    //print(response.body);
    setState(() {
      _isLoading = false;
      _maxPage = context.read<CourseList>().count~/6;
      if (_maxPage < 1) _maxPage = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    var readCourseList = context.read<CourseList>().rows;
    var size = MediaQuery.of(context).size;

    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;

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
                Navigator.pushNamed(context, '/profile');
              }
              else if (value == 'Tutor') {
                Navigator.pushNamed(context, '/tutor');
              }
              else if (value == 'Schedule') {
                Navigator.pushNamed(context, '/schedule');
              }
              else if (value == 'History') {
                Navigator.pushNamed(context, '/history');
              }
              else if (value == 'Courses') {
                Navigator.pushReplacementNamed(context, '/courses');
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
      body: GestureDetector(
        onTap: () {
          setState(() {
            FocusScope.of(context).requestFocus(_screenFocus);
          });
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 20),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Discover Courses',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 60, height: 60, child: SvgPicture.asset('assets/images/Courses.svg'),),
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
                      child: Text('LiveTutor has built the most quality, methodical and scientific courses in the fields of life for those who are in need of improving their knowledge of the fields.',
                        style: TextStyle(fontSize: 15,),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(bottom: 5),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Find desired courses:',
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
                    hintText: 'Enter course name',
                    suffixIcon: Icon(Icons.search_outlined),
                  ),
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
                    focusNode: _lvFocus,
                    child: Listener(
                      onPointerDown: (_) {
                        FocusScope.of(context).requestFocus(_lvFocus);
                      },
                      child: DropdownSearch<String>.multiSelection(
                        key: _lvKey,
                        items: lvItems,
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
                            hintText: 'Select level',
                          ),
                        ),
                        onChanged: (val) {
                          setState(() {
                            _lvFocus.requestFocus();
                          });
                        },
                      ),
                    )
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Focus(
                    focusNode: _cFocus,
                    child: Listener(
                      onPointerDown: (_) {
                        FocusScope.of(context).requestFocus(_cFocus);
                      },
                      child: DropdownSearch<String>.multiSelection(
                        key: _cKey,
                        items: cItems,
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
                            hintText: 'Select category',
                          ),
                        ),
                        onChanged: (val) {
                          setState(() {
                            _cFocus.requestFocus();
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
                  'Sort filter:',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Focus(
                  focusNode: _sFocus,
                  child: Listener(
                    onPointerDown: (_) {
                      FocusScope.of(context).requestFocus(_sFocus);
                    },
                    child: DropdownSearch<String>(
                      items: sItems,
                      key: _sKey,
                      clearButtonProps: ClearButtonProps(
                        isVisible: true,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.zero,
                      ),
                      dropdownButtonProps: DropdownButtonProps(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 12),
                      ),
                      popupProps: PopupProps.menu(
                        showSelectedItems: true,
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
                          hintText: 'Sort by Level',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _rsFocus.requestFocus();
                      _nController.clear();
                      _lvKey.currentState?.popupValidate([]);
                      _cKey.currentState?.popupValidate([]);
                      _sKey.currentState?.popupValidate([]);

                      _isLoading= true;
                    });
                    getCourseList();
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
              _isLoading == true
                  ? CircularProgressIndicator()
                  : _errorController.text.isNotEmpty
                  ? Text(_errorController.text)
                  : GridView.count(
                physics: ScrollPhysics(), // to disable GridView's scrolling
                shrinkWrap: true,
                crossAxisCount: itemWidth < itemHeight ? 2 : 3,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: itemWidth < itemHeight ? (itemWidth / itemHeight) : (itemHeight / itemWidth + 0.3),
                children: List.generate(readCourseList.length, (i) {
                  return CourseGrid(readCourseList[i].id, readCourseList[i].imageUrl, readCourseList[i].name, readCourseList[i].description,
                      lvMap.firstWhere((element) => element['level'] == readCourseList[i].level)["levelName"]!, readCourseList[i].topics.length.toString());
                }),
              ),
              NumberPaginator(
                controller: _pagiController,
                // by default, the paginator shows numbers as center content
                numberPages: _maxPage,
                initialPage: 0,
                onPageChange: (int index) {
                  var queryParameters = {'size': '6','page': (_pagiController.currentPage + 1).toString(),};
                  getCourseList(queryParameters: queryParameters);
                },
              )
            ],
          ),
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

  Widget CourseGrid(String id, String imgAsset, String name, String description, String level, String lessonNum){
    return Card(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () => Navigator.pushNamed(context, '/course_detail', arguments: id),
        child: Column(
          children: [
            Image.network(imgAsset),
            Container(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 15),
                    alignment: Alignment.center,
                    child: Text(name, style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis
                    ), maxLines: 2,),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 25),
                    alignment: Alignment.centerLeft,
                    child: Text(description, style: TextStyle(
                      overflow: TextOverflow.ellipsis
                    ), maxLines: 3,),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(level),
                      Text(lessonNum + ' Lessons'),
                    ],
                  )
                ],
              ),
            )
          ],
        )
      ),
    );
  }
}
