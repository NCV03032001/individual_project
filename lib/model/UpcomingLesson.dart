import 'package:flutter/foundation.dart';

class UpcomingLesson with ChangeNotifier {
  late bool hasUp;
  late String? startTime;
  late String? endTime;
  late int? total;
}