class Tutor {
  Tutor({
    this.level,
    required this.email,
    //this.google,
    //this.facebook,
    //this.apple,
    required this.avatar,
    required this.name,
    required this.country,
    required this.phone,
    required this.language,
    required this.birthday,
    required this.requestPassword,
    required this.isActivated,
    this.isPhoneActivated,
    //this.requireNote,
    this.timezone,
    this.phoneAuth,
    required this.isPhoneAuthActivated,
    this.studySchedule,
    //required this.canSendMessage,
    required this.isPublicRecord,
    //this.caredByStaffId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    //this.studentGroupId,
    //required this.feedbacks,
    required this.id,
    required this.userId,
    required this.video,
    required this.bio,
    required this.education,
    required this.experience,
    required this.profession,
    required this.accent,
    required this.targetStudent,
    required this.interests,
    required this.languages,
    required this.specialties,
    required this.resume,
    this.rating,
    this.isNative,
    required this.price,
    required this.isOnline,
  });
  late String? level;
  late String email;
  //late String google;
  //late String facebook;
  //late String apple;
  late String avatar;
  late String name;
  late String country;
  late String phone;
  late String language;
  late String birthday;
  late bool requestPassword;
  late bool isActivated;
  late bool? isPhoneActivated;
  //late bool? requireNote;
  late int? timezone;
  late String? phoneAuth;
  late bool isPhoneAuthActivated;
  late String? studySchedule;
  //late bool canSendMessage;
  late bool isPublicRecord;
  //late String caredByStaffId;
  late String createdAt;
  late String updatedAt;
  late String? deletedAt;
  //late String? studentGroupId;
  //** late List<dynamic> feedbacks; **
  late String id;
  late String userId;
  late String video;
  late String bio;
  late String education;
  late String experience;
  late String profession;
  late String accent;
  late String targetStudent;
  late String interests;
  late String languages;
  late String specialties;
  late String resume;
  late double? rating;
  late bool? isNative;
  late int price;
  late bool isOnline;

  Tutor.fromJson(Map<String, dynamic> json){
    level = null;
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
    price = json['price'];
    isOnline = json['isOnline'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['level'] = level;
    _data['email'] = email;
    //_data['google'] = google;
    //_data['facebook'] = facebook;
    //_data['apple'] = apple;
    _data['avatar'] = avatar;
    _data['name'] = name;
    _data['country'] = country;
    _data['phone'] = phone;
    _data['language'] = language;
    _data['birthday'] = birthday;
    _data['requestPassword'] = requestPassword;
    _data['isActivated'] = isActivated;
    _data['isPhoneActivated'] = isPhoneActivated;
    //_data['requireNote'] = requireNote;
    _data['timezone'] = timezone;
    _data['phoneAuth'] = phoneAuth;
    _data['isPhoneAuthActivated'] = isPhoneAuthActivated;
    _data['studySchedule'] = studySchedule;
    //_data['canSendMessage'] = canSendMessage;
    _data['isPublicRecord'] = isPublicRecord;
    //_data['caredByStaffId'] = caredByStaffId;
    _data['createdAt'] = createdAt;
    _data['updatedAt'] = updatedAt;
    _data['deletedAt'] = deletedAt;
    //_data['studentGroupId'] = studentGroupId;
    //** _data['feedbacks'] = feedbacks; **
    _data['id'] = id;
    _data['userId'] = userId;
    _data['video'] = video;
    _data['bio'] = bio;
    _data['education'] = education;
    _data['experience'] = experience;
    _data['profession'] = profession;
    _data['accent'] = accent;
    _data['targetStudent'] = targetStudent;
    _data['interests'] = interests;
    _data['languages'] = languages;
    _data['specialties'] = specialties;
    _data['resume'] = resume;
    _data['rating'] = rating;
    _data['isNative'] = isNative;
    _data['price'] = price;
    _data['isOnline'] = isOnline;
    return _data;
  }
}