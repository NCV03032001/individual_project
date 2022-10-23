import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dropdown_search/dropdown_search.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String _firstSelected ='assets/images/usaFlag.svg';
  PickedFile? _imageFile;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _bdController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  final FocusNode _bdFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _bdController.text = "${selectedDate.toLocal()}".split(' ')[0];
  }

  _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      setState(() {
        _bdController.text = "${selectedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  String? selectedValue;
  List<String> selectedItems = [];

  final List<String> levelItems = [
    'Pre A1 (Beginner)',
    'A1 (Higher Beginner)',
    'A2 (Pre-Intermediate)'
    'B1 (Intermediate)',
    'B2 (Upper-Intermediate)',
    'C1 (Advance)',
    'C2 (Proficiency)',
  ];

  final List<String> items = ['Subjects:', 'Foreign Tutor', 'Vietnamese Tutor', 'Native English Tutor', 'Test Preparation:', 'STARTERS', 'MOVERS', 'FLYERS', 'KET', 'PET', 'IELTS', 'TOEFL', 'TOEIC'];

  @override
  Widget build(BuildContext context) {
    selectedValue = levelItems[0];
    selectedItems = [items[1], items[2]];

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
                Navigator.pushReplacementNamed(context, '/profile');
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
                'Proflie',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: ImageProfile(),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: SizedBox(
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.all(10),
                            child: Text(
                              'Account Name',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            'Account ID: f569c202-7bbf-4620-af77-ecc1419a6b28',
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          TextButton(
                            onPressed: null,
                            child: Text(
                              'Others review you',
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.only(top: 15),
                        child: RichText(
                          text: TextSpan(
                            text: '*',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                            children: [
                              TextSpan(
                                  text: 'Name:',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                  )
                              ),
                            ],
                          ),
                        ),
                      )
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        autovalidateMode: AutovalidateMode.always,
                        initialValue: "Account Name",
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
                            errorStyle: TextStyle(
                              fontSize: 15,
                            )
                        ),
                        validator: (val) {
                          if(val == null || val.isEmpty){
                            return "Please input your Name!";
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.only(top: 15),
                        child: Text('Email Address:'),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          initialValue: 'student@lettutor.com',
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(10, 15, 10, 0),
                            disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 1, color: Colors.grey),
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            filled: true,
                            fillColor: Color(0xffd9d9d9),
                          ),
                          enabled: false,
                        ),
                      ),
                    ),
                  ],
                )
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.only(top: 15),
                    child: Text('Phone Number:'),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      initialValue: '842499996508',
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(10, 15, 10, 0),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        filled: true,
                        fillColor: Color(0xffd9d9d9),
                      ),
                      enabled: false,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.only(left: 100),
              margin: EdgeInsets.only(bottom: 5),
              alignment: Alignment.centerLeft,
              child: Text('Verified', style: TextStyle(color: Colors.green),),
            ),
            Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.only(top: 15),
                        child: RichText(
                          text: TextSpan(
                            text: '*',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                            children: [
                              TextSpan(
                                  text: 'Birthday:',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                  )
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          focusNode: _bdFocus,
                          controller: _bdController,
                          autovalidateMode: AutovalidateMode.always,
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
                              borderSide: BorderSide(width: 1, color: Colors.orange),
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 1, color: Colors.red),
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            errorStyle: TextStyle(
                              fontSize: 15,
                            ),
                            suffixIcon: Container(
                              width: 84,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  _bdController.text.isNotEmpty ?
                                  IconButton(onPressed: () {setState(() {
                                    _bdController.clear();
                                    selectedDate = DateTime.now();
                                    _bdFocus.unfocus();
                                  });}, icon: Icon(Icons.clear)) : Container(),
                                  Container(
                                    margin: EdgeInsets.only(right: 12),
                                    child: Icon(Icons.calendar_month_outlined),
                                  )
                                ],
                              ),
                            ),
                          ),
                          readOnly: true,
                          onTap: () => _selectDate(context),
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return "Please select your Birthday!";
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ],
                )
            ),
            Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.only(top: 15),
                        child: RichText(
                          text: TextSpan(
                            text: '*',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                            children: [
                              TextSpan(
                                  text: 'My Level:',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                  )
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: DropdownSearch<String>(
                          items: levelItems,
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
                            showSearchBox: true,
                          ),
                          dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(10, 15, 10, 0),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 1, color: Colors.grey),
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 1, color: Colors.blue),
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 1, color: Colors.orange),
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 1, color: Colors.red),
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                              errorStyle: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                          selectedItem: selectedValue,
                          autoValidateMode: AutovalidateMode.always,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return "Please select your Level!";
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ],
                )
            ),
            Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.only(top: 10),
                        child: RichText(
                          text: TextSpan(
                            text: '*',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                            children: [
                              TextSpan(
                                  text: 'Want to learn:',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                  )
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: DropdownSearch<String>.multiSelection(
                            items: items,
                            popupProps: PopupPropsMultiSelection.menu(
                              showSelectedItems: true,
                              showSearchBox: true,
                              disabledItemFn: (String s) => s == 'Subjects:' || s == 'Test Preparation:',
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
                                contentPadding: EdgeInsets.fromLTRB(10, 15, 10, 0),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1, color: Colors.grey),
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1, color: Colors.blue),
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1, color: Colors.orange),
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1, color: Colors.red),
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                errorStyle: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            selectedItems: selectedItems,
                            autoValidateMode: AutovalidateMode.always,
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return "Please select at least one subject!";
                              }
                              return null;
                            },
                          )
                      ),
                    ),
                  ],
                )
            ),
            Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.only(top: 10),
                        child: Text('Study Schedule:'),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: TextFormField(
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
                            hintText: 'Note the time of the week you want to study on LetTutor.',
                            isCollapsed: true,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
            ),
            Container(
              alignment: Alignment.centerRight,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.all(15),
                  backgroundColor: Colors.blue,
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
                child: Text(
                  'Save changes',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
                onPressed: null, //sửa sau
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
  Widget ImageProfile() {
    return Stack(
      children: [
        CircleAvatar(
          radius: 80.0,
          backgroundImage: _imageFile == null
              ? Image.asset('assets/images/avatars/testavt.webp').image
              : FileImage(File(_imageFile!.path)),
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: ((builder) => bottomSheet()),
              );
            },
            child: Icon(
              Icons.camera_alt,
              color: Colors.blue,
              size: 25,
            ),
          ),
        ),
      ],
    );
  }
  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "Choose Profile photo",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <Widget>[
            ElevatedButton.icon(
              icon: Icon(Icons.camera),
              onPressed: () {
                takePhoto(ImageSource.camera);
              },
              label: Text("Camera"),
            ),
            ElevatedButton.icon(
              icon: Icon(Icons.image),
              onPressed: () {
                takePhoto(ImageSource.gallery);
              },
              label: Text("Gallery"),
            ),
          ])
        ],
      ),
    );
  }
  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(
      source: source,
    );
    setState(() {
      _imageFile = pickedFile!;
    });
  }
}