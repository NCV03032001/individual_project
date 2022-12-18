import 'package:flutter/foundation.dart';

class CourseList with ChangeNotifier, Diagnosticable {
  late int count;
  late List<CourseClass> rows;

  void fromJson(Map<String, dynamic> json){
    count = json['count'];
    rows = List.from(json['rows']).map((e)=>CourseClass.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['count'] = count;
    _data['rows'] = rows.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class CourseClass {
  CourseClass({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.level,
    required this.reason,
    required this.purpose,
    required this.otherDetails,
    required this.defaultPrice,
    required this.coursePrice,
    this.courseType,
    this.sectionType,
    required this.visible,
    this.displayOrder,
    required this.createdAt,
    required this.updatedAt,
    required this.topics,
    required this.categories,
    required this.users,
  });
  late final String id;
  late final String name;
  late final String description;
  late final String imageUrl;
  late final String level;
  late final String reason;
  late final String purpose;
  late final String otherDetails;
  late final int defaultPrice;
  late final int coursePrice;
  late final Null courseType;
  late final Null sectionType;
  late final bool visible;
  late final Null displayOrder;
  late final String createdAt;
  late final String updatedAt;
  late final List<Topics> topics;
  late final List<Categories> categories;
  late final List<TempTutor> users;

  CourseClass.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    description = json['description'];
    imageUrl = json['imageUrl'];
    level = json['level'];
    reason = json['reason'];
    purpose = json['purpose'];
    otherDetails = json['other_details'];
    defaultPrice = json['default_price'];
    coursePrice = json['course_price'];
    courseType = null;
    sectionType = null;
    visible = json['visible'];
    displayOrder = null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    topics = List.from(json['topics']).map((e)=>Topics.fromJson(e)).toList();
    if (json['categories'] != null)
      categories = List.from(json['categories']).map((e)=>Categories.fromJson(e)).toList();
    else categories = [];
    if (json['users'] != null)
      users = List.from(json['users']).map((e)=>TempTutor.fromJson(e)).toList();
    else users = [];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['description'] = description;
    _data['imageUrl'] = imageUrl;
    _data['level'] = level;
    _data['reason'] = reason;
    _data['purpose'] = purpose;
    _data['other_details'] = otherDetails;
    _data['default_price'] = defaultPrice;
    _data['course_price'] = coursePrice;
    _data['courseType'] = courseType;
    _data['sectionType'] = sectionType;
    _data['visible'] = visible;
    _data['displayOrder'] = displayOrder;
    _data['createdAt'] = createdAt;
    _data['updatedAt'] = updatedAt;
    _data['topics'] = topics.map((e)=>e.toJson()).toList();
    _data['categories'] = categories.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Topics {
  Topics({
    required this.id,
    required this.courseId,
    required this.orderCourse,
    required this.name,
    required this.nameFile,
    this.numberOfPages,
    required this.description,
    this.videoUrl,
    this.type,
    required this.createdAt,
    required this.updatedAt,
  });
  late final String id;
  late final String courseId;
  late final int orderCourse;
  late final String name;
  late final String nameFile;
  late final Null numberOfPages;
  late final String description;
  late final Null videoUrl;
  late final Null type;
  late final String createdAt;
  late final String updatedAt;

  Topics.fromJson(Map<String, dynamic> json){
    id = json['id'];
    courseId = json['courseId'];
    orderCourse = json['orderCourse'];
    name = json['name'];
    nameFile = json['nameFile'];
    numberOfPages = null;
    description = json['description'];
    videoUrl = null;
    type = null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['courseId'] = courseId;
    _data['orderCourse'] = orderCourse;
    _data['name'] = name;
    _data['nameFile'] = nameFile;
    _data['numberOfPages'] = numberOfPages;
    _data['description'] = description;
    _data['videoUrl'] = videoUrl;
    _data['type'] = type;
    _data['createdAt'] = createdAt;
    _data['updatedAt'] = updatedAt;
    return _data;
  }
}

class Categories {
  Categories({
    required this.id,
    required this.title,
    this.description,
    required this.key,
    this.displayOrder,
    required this.createdAt,
    required this.updatedAt,
  });
  late final String id;
  late final String title;
  late final Null description;
  late final String key;
  late final Null displayOrder;
  late final String createdAt;
  late final String updatedAt;

  Categories.fromJson(Map<String, dynamic> json){
    id = json['id'];
    title = json['title'];
    description = null;
    key = json['key'];
    displayOrder = null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['title'] = title;
    _data['description'] = description;
    _data['key'] = key;
    _data['displayOrder'] = displayOrder;
    _data['createdAt'] = createdAt;
    _data['updatedAt'] = updatedAt;
    return _data;
  }
}

class TempTutor {
  TempTutor({
    required this.id,
    required this.level,
    required this.email,
    this.google,
    this.facebook,
    this.apple,
    required this.password,
    required this.avatar,
    required this.name,
    required this.country,
    required this.phone,
    required this.language,
    required this.birthday,
    required this.requestPassword,
    required this.isActivated,
    this.isPhoneActivated,
    this.requireNote,
    required this.timezone,
    this.phoneAuth,
    required this.isPhoneAuthActivated,
    this.studySchedule,
    required this.canSendMessage,
    required this.isPublicRecord,
    this.caredByStaffId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.studentGroupId,
  });
  late final String id;
  late final String level;
  late final String email;
  late final Null google;
  late final Null facebook;
  late final Null apple;
  late final String password;
  late final String avatar;
  late final String name;
  late final String country;
  late final String phone;
  late final String language;
  late final String birthday;
  late final bool requestPassword;
  late final bool isActivated;
  late final Null isPhoneActivated;
  late final Null requireNote;
  late final int timezone;
  late final Null phoneAuth;
  late final bool isPhoneAuthActivated;
  late final Null studySchedule;
  late final bool canSendMessage;
  late final bool isPublicRecord;
  late final Null caredByStaffId;
  late final String createdAt;
  late final String updatedAt;
  late final Null deletedAt;
  late final Null studentGroupId;

  TempTutor.fromJson(Map<String, dynamic> json){
    id = json['id'];
    level = json['level'];
    email = json['email'];
    google = null;
    facebook = null;
    apple = null;
    password = json['password'];
    avatar = json['avatar'];
    name = json['name'];
    country = json['country'];
    phone = json['phone'];
    language = json['language'];
    birthday = json['birthday'];
    requestPassword = json['requestPassword'];
    isActivated = json['isActivated'];
    isPhoneActivated = null;
    requireNote = null;
    timezone = json['timezone'];
    phoneAuth = null;
    isPhoneAuthActivated = json['isPhoneAuthActivated'];
    studySchedule = null;
    canSendMessage = json['canSendMessage'];
    isPublicRecord = json['isPublicRecord'];
    caredByStaffId = null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = null;
    studentGroupId = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['level'] = level;
    _data['email'] = email;
    _data['google'] = google;
    _data['facebook'] = facebook;
    _data['apple'] = apple;
    _data['password'] = password;
    _data['avatar'] = avatar;
    _data['name'] = name;
    _data['country'] = country;
    _data['phone'] = phone;
    _data['language'] = language;
    _data['birthday'] = birthday;
    _data['requestPassword'] = requestPassword;
    _data['isActivated'] = isActivated;
    _data['isPhoneActivated'] = isPhoneActivated;
    _data['requireNote'] = requireNote;
    _data['timezone'] = timezone;
    _data['phoneAuth'] = phoneAuth;
    _data['isPhoneAuthActivated'] = isPhoneAuthActivated;
    _data['studySchedule'] = studySchedule;
    _data['canSendMessage'] = canSendMessage;
    _data['isPublicRecord'] = isPublicRecord;
    _data['caredByStaffId'] = caredByStaffId;
    _data['createdAt'] = createdAt;
    _data['updatedAt'] = updatedAt;
    _data['deletedAt'] = deletedAt;
    _data['studentGroupId'] = studentGroupId;
    return _data;
  }
}