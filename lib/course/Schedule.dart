import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

class Schedule extends StatefulWidget {
  const Schedule({Key? key}) : super(key: key);

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  String _firstSelected ='assets/images/usaFlag.svg';
  PickedFile? _imageFile;

  List<String> _requests = ['', 'Lol'];

  @override
  Widget build(BuildContext context) {
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
                        backgroundImage: _imageFile == null
                            ? Image.asset('assets/images/avatars/testavt.webp').image
                            : FileImage(File(_imageFile!.path)),
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
                'Schedule',
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
                        Text('Here is a list of the sessions you have booked',
                          style: TextStyle(fontSize: 15,),
                        ),
                        Text('You can track when the meeting starts, join the meeting with one click or can cancel the meeting before 2 hours', style: TextStyle(fontSize: 15),),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 15, 0, 10),
              alignment: Alignment.centerLeft,
              child: Text(
                'Lastest book',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 15),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 100,
                        height: 40,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1),
                          color: Color.fromRGBO(192, 192, 192, 1),
                        ),
                        child: Text('Name'),
                      ),
                      Expanded(
                        child: Container(
                          height: 40,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1)
                          ),
                        ),
                      ),
                      Container(
                        width: 80,
                        height: 40,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1),
                          color: Color.fromRGBO(192, 192, 192, 1),
                        ),
                        child: Text('Page'),
                      ),
                      Container(
                        width: 60,
                        height: 40,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1)
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: 100,
                        height: 40,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1),
                          color: Color.fromRGBO(192, 192, 192, 1),
                        ),
                        child: Text('Description'),
                      ),
                      Expanded(
                        child: Container(
                          height: 40,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1)
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 2,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0,20, 0, 15),
              child: Column(
                children: [
                  Container(
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
                                  Text('Sun, 23 Oct 22', style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),),
                                  Text('1 lesson'),
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
                                    child: ImageProfile(Image.asset('assets/images/avatars/Ftutoravt.png').image),
                                  ),
                                  SizedBox(width: 10,),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          margin: EdgeInsets.only(bottom: 5),
                                          child: Text(
                                            'Keegan',
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(bottom: 5),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 15,
                                                height: 15,
                                                child: SvgPicture.asset('assets/images/frFlag.svg'),
                                              ),
                                              SizedBox(width: 5),
                                              Text('France'),
                                            ],
                                          ),
                                        ),
                                        GestureDetector(
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
                                        )
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
                          child: Column(
                            children: [
                              Container(
                                height: 50,
                                margin: EdgeInsets.only(bottom: 15),
                                child: Row(
                                  children: [
                                    Text('Lessons Time: 13:00 - 13:25', style: TextStyle(
                                        fontSize: 17
                                    ),),
                                    Expanded(child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          alignment: Alignment.centerRight,
                                          child: ElevatedButton.icon(
                                            onPressed: null,
                                            style: OutlinedButton.styleFrom(
                                              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                              backgroundColor: Colors.white,
                                              side: BorderSide(color: Colors.red, width: 1),
                                            ),
                                            icon: Icon(Icons.cancel_outlined, color: Colors.red, size: 15,),
                                            label: Text(
                                              'Cancel',
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                                  ],
                                ),
                              ),
                              ExpansionTile(
                                  title: Container(
                                      alignment: Alignment.centerLeft,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text('Request for lesson'),
                                          Expanded(child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              GestureDetector(
                                                onTap: null,
                                                child: Text('Edit request', style: TextStyle(color: Colors.blue),),
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
                                        child: _requests[0] != ''
                                        ? Text(_requests[0])
                                        : Text('Currently there are no requests for this class. Please write down any requests for the teacher.'),
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
                              backgroundColor: Colors.blue,
                            ),
                            child: Text(
                              'Go to meeting',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () => Navigator.pushNamed(context, '/video_cfr'), //sửa sau
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
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
                                  Text('Mon, 24 Oct 22', style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),),
                                  Text('2 consecutive lessons'),
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
                                    child: ImageProfile(Image.asset('assets/images/avatars/Ftutoravt.png').image),
                                  ),
                                  SizedBox(width: 10,),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          margin: EdgeInsets.only(bottom: 5),
                                          child: Text(
                                            'Keegan',
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(bottom: 5),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 15,
                                                height: 15,
                                                child: SvgPicture.asset('assets/images/frFlag.svg'),
                                              ),
                                              SizedBox(width: 5),
                                              Text('France'),
                                            ],
                                          ),
                                        ),
                                        GestureDetector(
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
                                        )
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
                          child: Column(
                            children: [
                              Container(
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.only(bottom: 15),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 50,
                                        margin: EdgeInsets.only(bottom: 15),
                                        child: Row(
                                          children: [
                                            Text('Lesson Time: 00:00 - 00:55', style: TextStyle(
                                              fontSize: 17,
                                            ),),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: 50,
                                        child: Row(
                                          children: [
                                            Text('Session 1: 00:00 - 00:25', style: TextStyle(
                                              fontSize: 15
                                            ),),
                                            Expanded(child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Container(
                                                  width: double.infinity,
                                                  alignment: Alignment.centerRight,
                                                  child: ElevatedButton.icon(
                                                    onPressed: null,
                                                    style: OutlinedButton.styleFrom(
                                                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                                      backgroundColor: Colors.white,
                                                      side: BorderSide(color: Colors.red, width: 1),
                                                    ),
                                                    icon: Icon(Icons.cancel_outlined, color: Colors.red, size: 15,),
                                                    label: Text(
                                                      'Cancel',
                                                      style: TextStyle(
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: 50,
                                        child: Row(
                                          children: [
                                            Text('Session 2: 00:30 - 00:55', style: TextStyle(
                                                fontSize: 15
                                            ),),
                                            Expanded(child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Container(
                                                  width: double.infinity,
                                                  alignment: Alignment.centerRight,
                                                  child: ElevatedButton.icon(
                                                    onPressed: null,
                                                    style: OutlinedButton.styleFrom(
                                                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                                      backgroundColor: Colors.white,
                                                      side: BorderSide(color: Colors.red, width: 1),
                                                    ),
                                                    icon: Icon(Icons.cancel_outlined, color: Colors.red, size: 15,),
                                                    label: Text(
                                                      'Cancel',
                                                      style: TextStyle(
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                              ),
                              ExpansionTile(
                                  title: Container(
                                      alignment: Alignment.centerLeft,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text('Request for lesson'),
                                          Expanded(child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              GestureDetector(
                                                onTap: null,
                                                child: Text('Edit request', style: TextStyle(color: Colors.blue),),
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
                                        child: _requests[1] != ''
                                            ? Text(_requests[1])
                                            : Text('Currently there are no requests for this class. Please write down any requests for the teacher.'),
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
                              backgroundColor: Colors.blue,
                            ),
                            child: Text(
                              'Go to meeting',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () => Navigator.pushNamed(context, '/video_cfr'), //sửa sau
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
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
    );
  }
  Widget ImageProfile(ImageProvider input) {
    return CircleAvatar(
      radius: 80.0,
      backgroundImage: input,
    );
  }
}