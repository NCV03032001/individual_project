import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class Profile extends StatefulWidget {
  static const keyDarkMode = 'key-darkmode';
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String _firstSelected ='assets/images/usaFlag.svg';
  PickedFile? _imageFile;
  final ImagePicker _picker = ImagePicker();
  String _nameErrMsg = '';
  String _bdErrMsg = '';
  String _lvErrMsg = '';
  String _wtlErrMsg = '';

  DateTime selectedDate = DateTime.now();

  final List<String> items = [
    'Item1',
    'Item2',
    'Item3',
    'Item4',
  ];
  String? selectedValue;
  List<String> selectedItems = [];

  _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/authenBG.png'),
          fit: BoxFit.cover,
        ),
        color: Theme.of(context).backgroundColor,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(backgroundColor: Theme.of(context).backgroundColor,
          title: GestureDetector(
            onTap: null, //sửa sau
            child: SizedBox(
              height: 30,
              child: SvgPicture.asset('assets/images/logo.svg'),
            )
          ),
          centerTitle: true,
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
              onSelected: null,
            ),
          ],
        //automaticallyImplyLeading: false,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(30),
              padding: EdgeInsets.all(35),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.circular(50),
                color: Theme.of(context).backgroundColor,
              ),
              child: Column(
                children: [
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.only(bottom: 5),
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
                            padding:EdgeInsets.fromLTRB(10, 0, 10, 0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: _nameErrMsg == '' ? Colors.grey : Colors.red,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              initialValue: "Account Name",
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                              onChanged: (val){
                                validateName(val); //sửa sau
                              },
                            ),
                          ),
                        ),
                      ],
                    )
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 70),
                    margin: EdgeInsets.only(bottom: 5),
                    alignment: Alignment.centerLeft,
                    child: Text(_nameErrMsg, style: TextStyle(color: Colors.red),),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                            flex: 1,
                            child: Container(
                              padding: EdgeInsets.only(bottom: 5),
                              child: Text('Email Address:'),
                            ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            margin: EdgeInsets.only(bottom: 10),
                            padding:EdgeInsets.fromLTRB(10, 0, 10, 0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey
                            ),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              initialValue: 'student@lettutor.com',
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                              enabled: false,
                            ),
                          ),
                        ),
                      ],
                    )
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.only(bottom: 5),
                            child: Text('Phone Number:'),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            margin: EdgeInsets.only(bottom: 10),
                            padding:EdgeInsets.fromLTRB(10, 0, 10, 0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey,
                            ),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              initialValue: '842499996508',
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                              enabled: false,
                            ),
                          ),
                        ),
                      ],
                    )
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 70),
                    margin: EdgeInsets.only(bottom: 5),
                    alignment: Alignment.centerLeft,
                    child: Text('Verified', style: TextStyle(color: Colors.green),),
                  ),
                  Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              padding: EdgeInsets.only(bottom: 5),
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
                              padding:EdgeInsets.fromLTRB(10, 0, 10, 0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: _bdErrMsg == '' ? Colors.grey : Colors.red,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                initialValue: "${selectedDate.toLocal()}".split(' ')[0],
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  suffixIcon: Icon(Icons.calendar_month_outlined),
                                ),
                                readOnly: true,
                                onTap: () => _selectDate(context),
                                onChanged: validateBirthday,
                              ),
                            ),
                          ),
                        ],
                      )
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 70),
                    margin: EdgeInsets.only(bottom: 5),
                    alignment: Alignment.centerLeft,
                    child: Text(_bdErrMsg, style: TextStyle(color: Colors.red),),
                  ),
                  Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              padding: EdgeInsets.only(bottom: 5),
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
                              padding:EdgeInsets.fromLTRB(10, 0, 10, 0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: _lvErrMsg == '' ? Colors.grey : Colors.red,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton2(
                                  hint: Text(
                                    'Select Item',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Theme
                                          .of(context)
                                          .hintColor,
                                    ),
                                  ),
                                  items: items
                                      .map((item) =>
                                      DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ))
                                      .toList(),
                                  value: selectedValue,
                                  onChanged: (value) {
                                    //validateLevel(selectedValue!);
                                    setState(() {
                                      selectedValue = value as String;
                                    });
                                  },
                                  buttonHeight: 40,
                                  buttonWidth: 140,
                                  itemHeight: 40,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 70),
                    margin: EdgeInsets.only(bottom: 5),
                    alignment: Alignment.centerLeft,
                    child: Text(_lvErrMsg, style: TextStyle(color: Colors.red),),
                  ),
                  Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              padding: EdgeInsets.only(bottom: 5),
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
                              padding:EdgeInsets.fromLTRB(10, 0, 10, 0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: _wtlErrMsg == '' ? Colors.grey : Colors.red,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton2(
                                  isExpanded: true,
                                  hint: Align(
                                    alignment: AlignmentDirectional.center,
                                    child: Text(
                                      'Select Items',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Theme.of(context).hintColor,
                                      ),
                                    ),
                                  ),
                                  items: items.map((item) {
                                    return DropdownMenuItem<String>(
                                      value: item,
                                      //disable default onTap to avoid closing menu when selecting an item
                                      enabled: false,
                                      child: StatefulBuilder(
                                        builder: (context, menuSetState) {
                                          final _isSelected = selectedItems.contains(item);
                                          return InkWell(
                                            onTap: () {
                                              _isSelected
                                                  ? selectedItems.remove(item)
                                                  : selectedItems.add(item);
                                              //This rebuilds the StatefulWidget to update the button's text
                                              setState(() {});
                                              //This rebuilds the dropdownMenu Widget to update the check mark
                                              menuSetState(() {});
                                            },
                                            child: Container(
                                              height: double.infinity,
                                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                              child: Row(
                                                children: [
                                                  _isSelected
                                                      ? const Icon(Icons.check_box_outlined)
                                                      : const Icon(Icons.check_box_outline_blank),
                                                  const SizedBox(width: 16),
                                                  Text(
                                                    item,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  }).toList(),
                                  //Use last selected item as the current value so if we've limited menu height, it scroll to last item.
                                  value: selectedItems.isEmpty ? null : selectedItems.last,
                                  onChanged: (value) {},
                                  buttonHeight: 40,
                                  buttonWidth: 140,
                                  itemHeight: 40,
                                  itemPadding: EdgeInsets.zero,
                                  selectedItemBuilder: (context) {
                                    return items.map(
                                          (item) {
                                        return Container(
                                          alignment: AlignmentDirectional.center,
                                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                          child: Text(
                                            selectedItems.join(', '),
                                            style: const TextStyle(
                                              fontSize: 14,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            maxLines: 1,
                                          ),
                                        );
                                      },
                                    ).toList();
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 70),
                    margin: EdgeInsets.only(bottom: 5),
                    alignment: Alignment.centerLeft,
                    child: Text(_lvErrMsg, style: TextStyle(color: Colors.red),),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                      child: Row(
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
                              padding:EdgeInsets.fromLTRB(10, 0, 10, 0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextFormField(
                                keyboardType: TextInputType.multiline,
                                minLines: 2,
                                maxLines: null,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
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
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Add your onPressed code here!
          },
          backgroundColor: Colors.grey,
          child: const Icon(Icons.message_outlined),
        ),
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
  void validateName(String val) {
    if(val.isEmpty){
      setState(() {
        _nameErrMsg = "Please input your Name!";
      });
    }else{
      setState(() {
        _nameErrMsg = "";
      });
    }
  }
  void validateBirthday(String val) {
    if(val.isEmpty){
      setState(() {
        _bdErrMsg = "Please input your Name!";
      });
    }else{
      setState(() {
        _bdErrMsg = "";
      });
    }
  }
  void validateLevel(String val) {
    if(val.isEmpty){
      setState(() {
        _lvErrMsg = "Please input your Name!";
      });
    }else{
      setState(() {
        _lvErrMsg = "";
      });
    }
  }
  void validateWtL(String val) {
    if(val.isEmpty){
      setState(() {
        _wtlErrMsg = "Please input your Name!";
      });
    }else{
      setState(() {
        _wtlErrMsg = "";
      });
    }
  }
}
