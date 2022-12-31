class SnHClass {
  SnHClass({
    required this.id,
    required this.userId,
    required this.scheduleDetailId,
    required this.tutorMeetingLink,
    required this.studentMeetingLink,
    this.studentRequest,
    this.tutorReview,
    this.scoreByTutor,
    this.recordUrl,
    required this.isDeleted,
    required this.scheduleDetailInfo,
    required this.showRecordUrl,
    required this.feedbacks,
  });
  late final String id;
  late final String userId;
  late final String scheduleDetailId;
  late final String tutorMeetingLink;
  late final String studentMeetingLink;
  late final String? studentRequest;
  late final String? tutorReview;
  late final int? scoreByTutor;
  late final String? recordUrl;
  late final bool isDeleted;
  late final ScheduleDetailInfo scheduleDetailInfo;
  late final bool showRecordUrl;
  late final List<Feedbacks> feedbacks;

  SnHClass.fromJson(Map<String, dynamic> json){
    id = json['id'];
    userId = json['userId'];
    scheduleDetailId = json['scheduleDetailId'];
    tutorMeetingLink = json['tutorMeetingLink'];
    studentMeetingLink = json['studentMeetingLink'];
    studentRequest = json['studentRequest'];
    tutorReview = json['tutorReview'];
    scoreByTutor = json['scoreByTutor'];
    recordUrl = json['recordUrl'];
    isDeleted = json['isDeleted'];
    scheduleDetailInfo = ScheduleDetailInfo.fromJson(json['scheduleDetailInfo']);
    showRecordUrl = json['showRecordUrl'];
    feedbacks = List.from(json['feedbacks']).map((e)=>Feedbacks.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['userId'] = userId;
    _data['scheduleDetailId'] = scheduleDetailId;
    _data['tutorMeetingLink'] = tutorMeetingLink;
    _data['studentMeetingLink'] = studentMeetingLink;
    _data['studentRequest'] = studentRequest;
    _data['tutorReview'] = tutorReview;
    _data['scoreByTutor'] = scoreByTutor;
    _data['recordUrl'] = recordUrl;
    _data['isDeleted'] = isDeleted;
    _data['scheduleDetailInfo'] = scheduleDetailInfo.toJson();
    _data['showRecordUrl'] = showRecordUrl;
    _data['feedbacks'] = feedbacks.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class ScheduleDetailInfo {
  ScheduleDetailInfo({
    required this.startPeriodTimestamp,
    required this.endPeriodTimestamp,
    required this.id,
    required this.scheduleId,
    required this.scheduleInfo,
  });
  late final int startPeriodTimestamp;
  late final int endPeriodTimestamp;
  late final String id;
  late final String scheduleId;
  late final ScheduleInfo scheduleInfo;

  ScheduleDetailInfo.fromJson(Map<String, dynamic> json){
    startPeriodTimestamp = json['startPeriodTimestamp'];
    endPeriodTimestamp = json['endPeriodTimestamp'];
    id = json['id'];
    scheduleId = json['scheduleId'];
    scheduleInfo = ScheduleInfo.fromJson(json['scheduleInfo']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['startPeriodTimestamp'] = startPeriodTimestamp;
    _data['endPeriodTimestamp'] = endPeriodTimestamp;
    _data['id'] = id;
    _data['scheduleId'] = scheduleId;
    _data['scheduleInfo'] = scheduleInfo.toJson();
    return _data;
  }
}

class ScheduleInfo {
  ScheduleInfo({
    required this.startTimestamp,
    required this.endTimestamp,
    required this.id,
    required this.tutorId,
    required this.isDeleted,
    required this.tutorInfo,
  });
  late final int startTimestamp;
  late final int endTimestamp;
  late final String id;
  late final String tutorId;
  late final bool isDeleted;
  late final TutorInfo tutorInfo;

  ScheduleInfo.fromJson(Map<String, dynamic> json){
    startTimestamp = json['startTimestamp'];
    endTimestamp = json['endTimestamp'];
    id = json['id'];
    tutorId = json['tutorId'];
    isDeleted = json['isDeleted'];
    tutorInfo = TutorInfo.fromJson(json['tutorInfo']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['startTimestamp'] = startTimestamp;
    _data['endTimestamp'] = endTimestamp;
    _data['id'] = id;
    _data['tutorId'] = tutorId;
    _data['isDeleted'] = isDeleted;
    _data['tutorInfo'] = tutorInfo.toJson();
    return _data;
  }
}

class TutorInfo {
  TutorInfo({
    required this.id,
    this.avatar,
    required this.name,
    this.country,
  });
  late final String id;
  late final String? avatar;
  late final String name;
  late final String? country;

  TutorInfo.fromJson(Map<String, dynamic> json){
    id = json['id'];
    avatar = json['avatar'];
    name = json['name'];
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['avatar'] = avatar;
    _data['name'] = name;
    _data['country'] = country;
    return _data;
  }
}

class Feedbacks {
  Feedbacks({
    required this.id,
    required this.bookingId,
    required this.secondId,
    required this.rating,
    required this.content,
  });
  late final String id;
  late final String bookingId;
  late final String secondId;
  late final int rating;
  late final String content;

  Feedbacks.fromJson(Map<String, dynamic> json){
    id = json['id'];
    bookingId = json['bookingId'];
    secondId = json['secondId'];
    rating = json['rating'].toInt();
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['bookingId'] = bookingId;
    _data['secondId'] = secondId;
    _data['rating'] = rating;
    _data['content'] = content;
    return _data;
  }
}