class Tutor {
  Tutor({
    this.level,
    this.email,
    //this.google,
    //this.facebook,
    //this.apple,
    this.avatar,
    required this.name,
    this.country,
    this.phone,
    this.language,
    this.birthday,
    this.requestPassword,
    this.isActivated,
    this.isPhoneActivated,
    //this.requireNote,
    this.timezone,
    this.phoneAuth,
    this.isPhoneAuthActivated,
    this.studySchedule,
    //required this.canSendMessage,
    required this.isPublicRecord,
    //this.caredByStaffId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    //this.studentGroupId,
    required this.courses,
    //required this.feedbacks,
    this.id,
    required this.userId,
    required this.video,
    required this.bio,
    required this.education,
    required this.experience,
    required this.profession,
    this.accent,
    required this.targetStudent,
    required this.interests,
    required this.languages,
    required this.specialties,
    this.resume,
    this.rating,
    this.isNative,
    //required this.price,
    this.isOnline,
    this.isFavorite,
    this.avgRating,
    this.totalFeedback,
    required this.toShow,
  });

  late String? level;
  late String? email;
  //late String google;
  //late String facebook;
  //late String apple;
  late String? avatar;
  late String name;
  late String? country;
  late String? phone;
  late String? language;
  late String? birthday;
  late bool? requestPassword;
  late bool? isActivated;
  late bool? isPhoneActivated;
  //late bool? requireNote;
  late int? timezone;
  late String? phoneAuth;
  late bool? isPhoneAuthActivated;
  late String? studySchedule;
  //late bool canSendMessage;
  late bool isPublicRecord;
  //late String caredByStaffId;
  late String? createdAt;
  late String? updatedAt;
  late String? deletedAt;
  //late String? studentGroupId;
  late List<TempCourse> courses;
  //** late List<dynamic> feedbacks; **
  late String? id;
  late String userId;
  late String video;
  late String bio;
  late String education;
  late String experience;
  late String profession;
  late String? accent;
  late String targetStudent;
  late String interests;
  late String languages;
  late String specialties;
  late String? resume;
  late double? rating;
  late bool? isNative;
  //late int price;
  late bool? isOnline;
  late bool? isFavorite;
  late double? avgRating;
  late int? totalFeedback;
  late bool toShow;

  Tutor.fromPreListJson(Map<String, dynamic> json){
    toShow = true;
    isFavorite = false;
    level = json['level'];
    email = json['email'];
    // google = null;
    // facebook = null;
    // apple = null;
    avatar = json['avatar'];
    name = json['name'];
    country = json['country'];
    phone = json['phone'];
    language = json['language'];
    birthday = json['birthday'];
    requestPassword = json['requestPassword'];
    isActivated = json['isActivated'];
    isPhoneActivated = json['isActivated'];
    //requireNote = null;
    timezone = json['timezone'];
    phoneAuth = json['phoneAuth'];
    isPhoneAuthActivated = json['isPhoneAuthActivated'];
    studySchedule = json['studySchedule'];
    //canSendMessage = json['canSendMessage'];
    isPublicRecord = json['isPublicRecord'];
    //caredByStaffId = null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
    //studentGroupId = null;
    /*if (json['courses'] != null) {
      courses = new List<Null>();
      json['courses'].forEach((v) {
        courses.add(new Null.fromJson(v));
      });
    }*/
    //** feedbacks = List.castFrom<dynamic, dynamic>(json['feedbacks']); **
    id = json['id'];
    userId = json['userId'];
    video = json['video'];
    bio = json['bio'];
    education = json['education'];
    experience = json['experience'];
    profession = json['profession'];
    accent = json['accent'];
    targetStudent = json['targetStudent'];
    interests = json['interests'];
    languages = json['languages'];
    specialties = json['specialties'];
    resume = json['resume'];
    rating = json['rating'];
    isNative = json['isNative'];
    //price = json['price'];
    isOnline = json['isOnline'];
  }

  Tutor.fromListJson(Map<String, dynamic> json){
    level = json['level'];
    email = json['email'];
    // google = null;
    // facebook = null;
    // apple = null;
    avatar = json['avatar'];
    name = json['name'];
    country = json['country'];
    phone = json['phone'];
    language = json['language'];
    birthday = json['birthday'];
    requestPassword = json['requestPassword'];
    isActivated = json['isActivated'];
    isPhoneActivated = json['isActivated'];
    //requireNote = null;
    timezone = json['timezone'];
    phoneAuth = json['phoneAuth'];
    isPhoneAuthActivated = json['isPhoneAuthActivated'];
    studySchedule = json['studySchedule'];
    //canSendMessage = json['canSendMessage'];
    isPublicRecord = json['isPublicRecord'];
    //caredByStaffId = null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
    //studentGroupId = null;
    courses = [];
    //** feedbacks = List.castFrom<dynamic, dynamic>(json['feedbacks']); **
    id = json['id'];
    userId = json['userId'];
    video = json['video'];
    bio = json['bio'];
    education = json['education'];
    experience = json['experience'];
    profession = json['profession'];
    accent = json['accent'];
    targetStudent = json['targetStudent'];
    interests = json['interests'];
    languages = json['languages'];
    specialties = json['specialties'];
    resume = json['resume'];
    rating = json['rating'];
    isNative = json['isNative'];
    //price = json['price'];
    //isOnline = json['isOnline'];
    isOnline = false;
    if (json['isfavoritetutor'] == null)
      isFavorite = false;
    else isFavorite = true;
    toShow = true;
  }

  Tutor.fromFavJson(Map<String, dynamic> json){
    toShow = true;
    isOnline = false;
    isFavorite = true;
    level = json["secondInfo"]['level'];
    email = json["secondInfo"]['email'];
    // google = null;
    // facebook = null;
    // apple = null;
    avatar = json["secondInfo"]['avatar'];
    name = json["secondInfo"]['name'];
    country = json["secondInfo"]['country'];
    phone = json["secondInfo"]['phone'];
    language = json["secondInfo"]['language'];
    birthday = json["secondInfo"]['birthday'];
    requestPassword = json["secondInfo"]['requestPassword'];
    isActivated = json["secondInfo"]['isActivated'];
    isPhoneActivated = json["secondInfo"]['isActivated'];
    //requireNote = null;
    timezone = json["secondInfo"]['timezone'];
    phoneAuth = json["secondInfo"]['phoneAuth'];
    isPhoneAuthActivated = json["secondInfo"]['isPhoneAuthActivated'];
    studySchedule = json["secondInfo"]['studySchedule'];
    //canSendMessage = json['canSendMessage'];
    isPublicRecord = json["secondInfo"]['isPublicRecord'];
    //caredByStaffId = null;
    createdAt = json["secondInfo"]['tutorInfo']['createdAt'];
    updatedAt = json["secondInfo"]['tutorInfo']['updatedAt'];
    deletedAt = json["secondInfo"]['deletedAt'];
    //studentGroupId = null;
    courses = [];
    //** feedbacks = List.castFrom<dynamic, dynamic>(json['feedbacks']); **
    id = json['secondInfo']["tutorInfo"]['id'];
    userId = json["secondInfo"]['tutorInfo']['userId'];
    video = json["secondInfo"]['tutorInfo']['video'];
    bio = json["secondInfo"]['tutorInfo']['bio'];
    education = json["secondInfo"]['tutorInfo']['education'];
    experience = json["secondInfo"]['tutorInfo']['experience'];
    profession = json["secondInfo"]['tutorInfo']['profession'];
    accent = json["secondInfo"]['tutorInfo']['accent'];
    targetStudent = json["secondInfo"]['tutorInfo']['targetStudent'];
    interests = json["secondInfo"]['tutorInfo']['interests'];
    languages = json["secondInfo"]['tutorInfo']['languages'];
    specialties = json["secondInfo"]['tutorInfo']['specialties'];
    resume = json["secondInfo"]['tutorInfo']['resume'];
    rating = json["secondInfo"]['tutorInfo']['rating'];
    isNative = json["secondInfo"]['tutorInfo']['isNative'];
    //price = json['price'];
    //isOnline = json["secondInfo"]['tutorInfo']['isOnline'];
  }

  Tutor.fromDetailJson(Map<String, dynamic> json){
    toShow = true;
    isFavorite = json['isFavorite'];
    totalFeedback = json['totalFeedback'];
    level = json['User']['level'];
    //email = json['User']['email'];
    // google = null;
    // facebook = null;
    // apple = null;
    avatar = json['User']['avatar'];
    name = json['User']['name'];
    country = json['User']['country'];
    language = json['User']['language'];
    //isPhoneActivated = json['isActivated'];
    //requireNote = null;
    //timezone = json['timezone'];
    //phoneAuth = json['phoneAuth'];
    //isPhoneAuthActivated = json['isPhoneAuthActivated'];
    //studySchedule = json['studySchedule'];
    //canSendMessage = json['canSendMessage'];
    isPublicRecord = json['User']['isPublicRecord'];
    //caredByStaffId = null;
    //createdAt = json['createdAt'];
    //updatedAt = json['updatedAt'];
    //deletedAt = json['deletedAt'];
    //studentGroupId = null;
    if (json['User']['courses'] != null) {
      courses = List.from(json['User']['courses']).map((e) => TempCourse.fromJson(e)).toList();
    }
    else courses = [];
    //** feedbacks = List.castFrom<dynamic, dynamic>(json['feedbacks']); **
    //id = json['id'];
    userId = json['User']['id'];
    video = json['video'];
    bio = json['bio'];
    education = json['education'];
    experience = json['experience'];
    profession = json['profession'];
    accent = json['accent'];
    targetStudent = json['targetStudent'];
    interests = json['interests'];
    languages = json['languages'];
    specialties = json['specialties'];
    rating = json['rating'];
    isNative = json['isNative'];
    //price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['level'] = level;
    data['email'] = email;
    //_data['google'] = google;
    //_data['facebook'] = facebook;
    //_data['apple'] = apple;
    data['avatar'] = avatar;
    data['name'] = name;
    data['country'] = country;
    data['phone'] = phone;
    data['language'] = language;
    data['birthday'] = birthday;
    data['requestPassword'] = requestPassword;
    data['isActivated'] = isActivated;
    data['isPhoneActivated'] = isPhoneActivated;
    //_data['requireNote'] = requireNote;
    data['timezone'] = timezone;
    data['phoneAuth'] = phoneAuth;
    data['isPhoneAuthActivated'] = isPhoneAuthActivated;
    data['studySchedule'] = studySchedule;
    //_data['canSendMessage'] = canSendMessage;
    data['isPublicRecord'] = isPublicRecord;
    //_data['caredByStaffId'] = caredByStaffId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['deletedAt'] = deletedAt;
    //_data['studentGroupId'] = studentGroupId;
    /*if (json['courses'] != null) {
      courses = new List<Null>();
      json['courses'].forEach((v) {
        courses.add(new Null.fromJson(v));
      });
    }*/
    //** _data['feedbacks'] = feedbacks; **
    data['id'] = id;
    data['userId'] = userId;
    data['video'] = video;
    data['bio'] = bio;
    data['education'] = education;
    data['experience'] = experience;
    data['profession'] = profession;
    data['accent'] = accent;
    data['targetStudent'] = targetStudent;
    data['interests'] = interests;
    data['languages'] = languages;
    data['specialties'] = specialties;
    data['resume'] = resume;
    data['rating'] = rating;
    data['isNative'] = isNative;
    //data['price'] = price;
    data['isOnline'] = isOnline;
    //data['isFavorite'] = isFavorite;
    //data['avgRating'] = avgRating;
    //data['totalFeedback'] = totalFeedback;
    return data;
  }
}

class FeedbackItem {
  FeedbackItem({
    required this.id,
    required this.firstId,
    required this.secondId,
    required this.rating,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.name,
    required this.avatar,

  });
  late final String id;
  late final String firstId;
  late final String secondId;
  late final int? rating;
  late final String content;
  late final String createdAt;
  late final String updatedAt;
  late final String name;
  late final String? avatar;

  FeedbackItem.fromJson(Map<String, dynamic> json){
    id = json['id'];
    firstId = json['firstId'];
    secondId = json['secondId'];
    rating = json['rating'];
    content = json['content'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    name = json['firstInfo']['name'];
    avatar = json['firstInfo']['avatar'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['firstId'] = firstId;
    _data['secondId'] = secondId;
    _data['rating'] = rating;
    _data['content'] = content;
    _data['createdAt'] = createdAt;
    _data['updatedAt'] = updatedAt;
    _data['firstInfo']['name'] = name;
    _data['firstInfo']['avatar'] = avatar;
    return _data;
  }
}

class TempCourse{
  TempCourse({
    required this.id,
    required this.name,
  });
  late final String id;
  late final String name;

  TempCourse.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
  }
}