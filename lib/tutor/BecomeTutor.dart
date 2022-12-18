import 'package:flutter/material.dart';

class BecomeTutor extends StatefulWidget {
  const BecomeTutor({Key? key}) : super(key: key);

  @override
  State<BecomeTutor> createState() => _BecomeTutorState();
}

class _BecomeTutorState extends State<BecomeTutor> {
  FocusNode _screenFocus = new FocusNode();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          FocusScope.of(context).requestFocus(_screenFocus);
        });
      },
    );
  }
}
