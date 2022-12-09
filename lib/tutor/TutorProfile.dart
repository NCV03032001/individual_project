import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:individual_project/model/UserProvider.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:booking_calendar/booking_calendar.dart';

import '../model/User.dart';
//import 'package:url_launcher/url_launcher.dart';

class TutorProfile extends StatefulWidget {
  const TutorProfile({Key? key}) : super(key: key);

  @override
  State<TutorProfile> createState() => _TutorProfileState();
}

class _TutorProfileState extends State<TutorProfile> {
  String _firstSelected ='assets/images/usaFlag.svg';


  List<String> tooltipMsg = ['terrible', 'bad', 'normal', 'good', 'wonderful'];

  bool FhasRvw = true;

  bool isFav = false;

  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    initPlayer();
    mockBookingService = BookingService(
        serviceName: 'Mock Service',
        serviceDuration: 30,
        bookingEnd: DateTime(now.year, now.month, now.day, 23, 59),
        bookingStart: DateTime(now.year, now.month, now.day, 7, 0),);
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }
  
  void initPlayer() async {
    _videoPlayerController = VideoPlayerController.network('https://api.app.lettutor.com/video/4d54d3d7-d2a9-42e5-97a2-5ed38af5789avideo1627913015871.mp4');
    await _videoPlayerController.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
    );
  }

  List<String> FTutorTags = ['English for Business', 'Conversational', 'English for kids', 'IELTS', 'TOEIC'];

  List<courseItem> courseList = [
    courseItem(courseName: 'Basic Conversation Topics', courseLink: 'https://sandbox.app.lettutor.com/courses/46972669-1755-4f27-8a87-dc4dd2630492'),
    courseItem(courseName: 'Life in the Internet Age', courseLink: 'https://sandbox.app.lettutor.com/courses/964bed84-6450-49ee-92d5-e8c565864bd9'),
  ];

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
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 120,
                  width: 100,
                  child: ImageProfile(Image.asset('assets/images/avatars/Ftutoravt.png').image),
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
                            'Keegan',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          margin: EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: SvgPicture.asset('assets/images/frFlag.svg'),
                              ),
                              SizedBox(width: 10),
                              Text('France'),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          margin: EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              FhasRvw
                                  ? Row(
                              children: [Row(
                                children:
                                tooltipMsg.map((value) => Tooltip(
                                  message: value,
                                  child: Icon(Icons.star, color: Colors.yellow,),
                                )).toList(),
                              ), Text('(58)', style: TextStyle(fontStyle: FontStyle.italic),)])
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
                'I am passionate about running and fitness, I often compete in trail/mountain running events and I love pushing myself. I am training to one day take part in ultra-endurance events. I also enjoy watching rugby on the weekends, reading and watching podcasts on Youtube. My most memorable life experience would be living in and traveling around Southeast Asia.',
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
                      onTap: () => setState(() {
                        isFav = !isFav;
                      }),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 30,
                            height: 30,
                            child: isFav
                              ? Image.asset('assets/images/icons/Heart.png', color: Colors.red, width: 35, height: 35,)
                              : Image.asset('assets/images/icons/Heart_outline.png', color: Colors.blue,),
                          ),
                          SizedBox(height: 10,),
                          Text('Favorite', style: TextStyle(
                            color: isFav ? Colors.red : Colors.blue
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
                        onTap: null,
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
              child: CircularProgressIndicator(),
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
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              alignment: Alignment.centerLeft,
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.blue,
                ),
                child: Text('English'),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 20, 0, 15),
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
                  children: FTutorTags.map((value) => Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.blue,
                    ),
                    child: Text(value),
                  )).toList(),
                ),
              ),
            ),
            courseList.isNotEmpty
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
            Column(
              children: courseList.map((value) => Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 17,
                    ),
                    children: [
                      TextSpan(
                        text: value.courseName + ': ',
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
                        recognizer: TapGestureRecognizer()..onTap = () => Navigator.pushNamed(context, '/course_detail'),//_launchUrl(value.courseLink), //sửa sau
                      ),
                    ],
                  ),
                ),
              )).toList(),
            ),
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
              child: Text('I loved the weather, the scenery and the laid-back lifestyle of the locals.',
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
              child: Text('I have more than 10 years of teaching english experience.',
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
            Container(
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
  /*Future<void> _launchUrl(String link) async {Uri _url = Uri.parse(link); if (!await launchUrl(_url)) {throw 'Could not launch $_url';}}*/
}

class courseItem {
  final String courseName;
  final String courseLink;

  courseItem({
    required this.courseName,
    required this.courseLink,
  });
}
