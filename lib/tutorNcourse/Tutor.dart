import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:invidual_project/data/choice_chips.dart';
import 'package:invidual_project/model/choice_chip.dart';
import 'package:time_range_picker/time_range_picker.dart';

class Tutor extends StatefulWidget {
  const Tutor({Key? key}) : super(key: key);

  @override
  State<Tutor> createState() => _TutorState();
}

class _TutorState extends State<Tutor> {
  String _firstSelected ='assets/images/usaFlag.svg';
  PickedFile? _imageFile;

  Timer? countdownTimer;
  Duration myDuration = Duration(days: 1);

  @override
  void initState() {
    super.initState();
    startTimer();
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

  final List<String> items = [
    'Item1',
    'Item2',
    'Item3',
    'Item4',
  ];

  final TextEditingController _nController = TextEditingController();
  final FocusNode _nFocus = FocusNode();

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
    else if (picked == selectedDate) {
      return;
    }
    else {
      setState(() {
        _dController.clear();
        selectedDate = DateTime.now();
      });
    }
  }

  TimeOfDay initS = TimeOfDay(hour: 7, minute: 0);
  TimeOfDay initE = TimeOfDay(hour: 8, minute: 0);

  final TextEditingController _tController = TextEditingController();
  final FocusNode _tFocus = FocusNode();

  List<ChoiceChipData> choiceChips = ChoiceChips.all;
  final FocusNode _tgFocus = FocusNode();

  final FocusNode _rsFocus = FocusNode();

  List<String> FTutorTags = ['English for Business', 'Conversational', 'English for kids', 'IELTS', 'TOEIC'];
  List<String> STutorTags = ['English for Business', 'IELTS', 'PET', 'KET'];

  @override
  Widget build(BuildContext context) {
    String strDigits(int n) => n.toString().padLeft(2, '0');
    final hours = strDigits(myDuration.inHours.remainder(2));
    final minutes = strDigits(myDuration.inMinutes.remainder(60));
    final seconds = strDigits(myDuration.inSeconds.remainder(60));

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
              Navigator.pushNamed(context, '/profile');
              }
              else if (value == 'Tutor') {
                Navigator.pushReplacementNamed(context, '/tutor');
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
                child: Column(
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Wed, 19 Oct 22 00:00 - 00:25 ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            '(starts in $hours:$minutes:$seconds)',
                            style: TextStyle(
                              color: Colors.yellow,
                              fontSize: 15,
                            ),
                          ),
                        ],
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
                        'Total lesson time is 154 hours 10 minutes',
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
              padding: EdgeInsets.all(30),
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
                      focusNode: _ntFocus,
                      child: Listener(
                        onPointerDown: (_) {
                          FocusScope.of(context).requestFocus(_ntFocus);
                        },
                        child: DropdownSearch<String>.multiSelection(
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
                          selectedItems: ['Item1', 'Item2'],
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
                            else if (result == null) setState(() {
                              _tController.clear();
                              initS = TimeOfDay(hour: 7, minute: 0);
                              initE = TimeOfDay(hour: 8, minute: 0);
                              _tFocus.requestFocus();
                            });
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
                    children: choiceChips.map((value) => ChoiceChip(
                      label: Text(value.label),
                      selected: value.isSelected,
                      selectedColor: Colors.blue,
                      focusNode: _tgFocus,
                      labelStyle: TextStyle(
                        fontSize: 15,
                      ),
                      onSelected: (isSltd) => setState(() {
                        _tgFocus.requestFocus();
                        choiceChips = choiceChips.map((other) {
                          if (value == other && value.isSelected == true) {
                            return value;
                          }
                          final newChip = other.copy(isSelected: false);

                          return value == newChip
                              ? newChip.copy(isSelected: isSltd)
                              : newChip;
                        }).toList();
                      }),
                    )).toList(),
                  ),
                  OutlinedButton(
                    onPressed: () => setState(() {
                      _rsFocus.requestFocus();
                      _nController.clear();
                      _dController.clear();
                      _tController.clear();
                    }),
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
                  Divider(
                    thickness: 2,
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 30, 0, 30),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Recommended Tutors',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        width: double.infinity,
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
                                  child: ImageProfile(Image.asset('assets/images/avatars/Ftutoravt.png').image, true),
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
                                              InkWell(
                                                child: Icon(Icons.star, color: Colors.yellow,),
                                                onHover: null,
                                              ),
                                              InkWell(
                                                child: Icon(Icons.star, color: Colors.yellow,),
                                                onHover: null,
                                              ),
                                              InkWell(
                                                child: Icon(Icons.star, color: Colors.yellow,),
                                                onHover: null,
                                              ),
                                              InkWell(
                                                child: Icon(Icons.star, color: Colors.yellow,),
                                                onHover: null,
                                              ),
                                              InkWell(
                                                child: Icon(Icons.star, color: Colors.yellow,),
                                                onHover: null,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                IconButton(
                                    onPressed: null,
                                    icon: Image.asset('assets/images/icons/Heart_outline.png', color: Colors.blue,)
                                ),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
                              constraints: BoxConstraints(minHeight: 50, maxHeight: 50),
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
                            Container(
                              constraints: BoxConstraints(minHeight: 70),
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.only(bottom: 15),
                              child: Text(
                                'I am passionate about running and fitness, I often compete in trail/mountain running events and I love pushing myself. I am training to one day take part in ultra-endurance events. I also enjoy watching rugby on the weekends, reading and watching podcasts on Youtube. My most memorable life experience would be living in and traveling around Southeast Asia.',
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              alignment: Alignment.centerRight,
                              child: ElevatedButton.icon(
                                onPressed: () => Navigator.pushNamed(context, '/tutor_profile'),
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
                      Container(
                        width: double.infinity,
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
                                  child: ImageProfile(Image.asset('assets/images/avatars/Stutoravt.jpg').image, false),
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
                                                child: SvgPicture.asset('assets/images/phFlag.svg'),
                                              ),
                                              SizedBox(width: 10),
                                              Text('Philippines (the)'),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(left: 10),
                                          margin: EdgeInsets.only(bottom: 10),
                                          child: Row(
                                            children: [
                                              Text('No reviews yet', style:  TextStyle(
                                                fontStyle: FontStyle.italic,
                                              ),),
                                              /*
                                              InkWell(
                                                child: Icon(Icons.star, color: Colors.yellow,),
                                                onHover: null,
                                              ),
                                              InkWell(
                                                child: Icon(Icons.star, color: Colors.yellow,),
                                                onHover: null,
                                              ),
                                              InkWell(
                                                child: Icon(Icons.star, color: Colors.yellow,),
                                                onHover: null,
                                              ),
                                              InkWell(
                                                child: Icon(Icons.star, color: Colors.yellow,),
                                                onHover: null,
                                              ),
                                              InkWell(
                                                child: Icon(Icons.star, color: Colors.yellow,),
                                                onHover: null,
                                              ),
                                              */
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                IconButton(
                                    onPressed: null,
                                    icon: Image.asset('assets/images/icons/Heart.png', color: Colors.red,),
                                ),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
                              constraints: BoxConstraints(minHeight: 50, maxHeight: 50),
                              width: double.infinity,
                              child: SingleChildScrollView(
                                child: Wrap(
                                  runSpacing: 5,
                                  spacing: 5,
                                  crossAxisAlignment: WrapCrossAlignment.start,
                                  verticalDirection: VerticalDirection.down,
                                  children: STutorTags.map((value) => Container(
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
                            Container(
                              constraints: BoxConstraints(minHeight: 70),
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.only(bottom: 15),
                              child: Text(
                                'Hello! My name is April Baldo, you can just call me Teacher April. I am an English teacher and currently teaching in senior high school. I have been teaching grammar and literature for almost 10 years. I am fond of reading and teaching literature as one way of knowing one’s beliefs and culture. I am friendly and full of positivity. I love teaching because I know each student has something to bring on. Molding them to become an individual is a great success.',
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              alignment: Alignment.centerRight,
                              child: ElevatedButton.icon(
                                onPressed: () => Navigator.pushNamed(context, '/tutor_profile'),
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
                    ],
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
    );
  }

  Widget ImageProfile(ImageProvider input, bool online) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/tutor_profile'),
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