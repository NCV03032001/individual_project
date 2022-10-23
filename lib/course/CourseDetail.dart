import 'dart:io';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

class CourseDetail extends StatefulWidget {
  const CourseDetail({Key? key}) : super(key: key);

  @override
  State<CourseDetail> createState() => _CourseDetailState();
}

class _CourseDetailState extends State<CourseDetail> {
  String _firstSelected ='assets/images/usaFlag.svg';
  PickedFile? _imageFile;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    /*24 is for notification bar on Android*/
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
        child: Column(
          children: [
            Card(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Image.asset('assets/images/CourseExample1.png'),
                  Container(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 15),
                          alignment: Alignment.center,
                          child: Text('Life in the Internet Age', style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis
                          ), maxLines: 2,),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 25),
                          alignment: Alignment.centerLeft,
                          child: Text('Let\'s discuss how technology is changing the way we live', style: TextStyle(
                              fontSize: 15,
                              overflow: TextOverflow.ellipsis
                          ), maxLines: 3,),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 20),
                          width: double.infinity,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                              backgroundColor: Colors.blue,
                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                            ),
                            child: Text(
                              'Discover',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                            onPressed: null, //sửa sau
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 20,),
            Row(
              children: [
                Container(
                  width: 20,
                  child: Divider(
                    thickness: 2,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text('Overview', style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),),
                ),
                Expanded(child: Divider(thickness: 2,)),
              ],
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.fromLTRB(0, 10, 0, 5),
              child: Text.rich(
                  TextSpan(
                      children: <InlineSpan>[
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Image.asset('assets/images/icons/Question.png', color: Colors.red, width: 20, height: 20,),
                        ),
                        TextSpan(text: ' Why take this course', style: TextStyle(
                          fontSize: 17,
                        )),
                      ]
                  )
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
              margin: EdgeInsets.only(bottom: 15),
              child: Text('Our world is rapidly changing thanks to new technology, and the vocabulary needed to discuss modern life is evolving almost daily. In this course you will learn the most up-to-date terminology from expertly crafted lessons as well from your native-speaking tutor.'),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.fromLTRB(0, 10, 0, 5),
              child: Text.rich(
                  TextSpan(
                      children: <InlineSpan>[
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Image.asset('assets/images/icons/Question.png', color: Colors.red, width: 20, height: 20,),
                        ),
                        TextSpan(text: ' What will you be able to do', style: TextStyle(
                          fontSize: 17,
                        )),
                      ]
                  )
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
              margin: EdgeInsets.only(bottom: 15),
              child: Text('You will learn vocabulary related to timely topics like remote work, artificial intelligence, online privacy, and more. In addition to discussion questions, you will practice intermediate level speaking tasks such as using data to describe trends.'),
            ),
            Row(
              children: [
                Container(
                  width: 20,
                  child: Divider(
                    thickness: 2,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text('Experience Level', style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),),
                ),
                Expanded(child: Divider(thickness: 2,)),
              ],
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.fromLTRB(0, 10, 0, 5),
              child: Text.rich(
                  TextSpan(
                      children: <InlineSpan>[
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Icon(Icons.people_alt_sharp, color: Colors.deepPurple, size: 20,),
                        ),
                        TextSpan(text: ' Intermediate', style: TextStyle(
                          fontSize: 17,
                        )),
                      ]
                  )
              ),
            ),
            Row(
              children: [
                Container(
                  width: 20,
                  child: Divider(
                    thickness: 2,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text('Course Length', style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),),
                ),
                Expanded(child: Divider(thickness: 2,)),
              ],
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.fromLTRB(0, 10, 0, 5),
              child: Text.rich(
                  TextSpan(
                      children: <InlineSpan>[
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Icon(Icons.book, color: Colors.deepPurple, size: 20,),
                        ),
                        TextSpan(text: ' 9 topics', style: TextStyle(
                          fontSize: 17,
                        )),
                      ]
                  )
              ),
            ),
            Row(
              children: [
                Container(
                  width: 20,
                  child: Divider(
                    thickness: 2,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text('List Topics', style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),),
                ),
                Expanded(child: Divider(thickness: 2,)),
              ],
            ),
            Row(
              children: [
                Container(
                  width: 20,
                  child: Divider(
                    thickness: 2,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text('Suggested Tutors', style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),),
                ),
                Expanded(child: Divider(thickness: 2,)),
              ],
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.fromLTRB(0, 10, 0, 5),
              child: RichText(
                text: TextSpan(
                    style: TextStyle(
                      fontSize: 17,
                    ),
                    children: [
                      TextSpan(
                        text: 'Keegan ',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      TextSpan(
                        text: "More info",
                        style: TextStyle(
                            color: Colors.blue
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () {
                          Navigator.pushNamed(context, '/tutor_profile');
                        }, //sửa sau
                      ),
                    ]
                ),
              ),
            ),
            GridView.count(
              physics: ScrollPhysics(), // to disable GridView's scrolling
              shrinkWrap: true,
              crossAxisCount: itemWidth < itemHeight ? 2 : 3,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              childAspectRatio: itemWidth < itemHeight ? (itemHeight / itemWidth - 0.4) : (itemWidth / itemHeight - 0.4),
              children: <Widget>[
                TopicGrid(1, 'The Internet'),
                TopicGrid(2, 'Artificial Intelligence (AI)'),
                TopicGrid(3, 'Social Media'),
                TopicGrid(4, 'Internet Privacy'),
                TopicGrid(5, 'Live Streaming'),
                TopicGrid(6, 'Coding'),
                TopicGrid(7, 'Technology Transforming Healthcare'),
                TopicGrid(8, 'Smart Home Technology'),
                TopicGrid(9, 'Remote Work - A Dream Job?'),

              ],
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

  Widget TopicGrid(int index, String name, ){
    return Card(
      child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: null,
          child: Container(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(index.toString() + '.'),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  alignment: Alignment.centerLeft,
                  child: Text(name, style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis
                  ), maxLines: 2,),
                ),
              ],
            ),
          )
      ),
    );
  }
}
