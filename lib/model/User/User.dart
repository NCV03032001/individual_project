class User {
  late String id;
  late String email;
  late String name;
  late String avatar;
  late String? country;
  late String phone;
  late List<String> roles;
  //late String language;
  late String? birthday;
  late bool isActivated;
  //late WalletInfo walletInfo;
  //late List<Null> courses;
  //late Null requireNote;
  late String? level;
  late List<LearnTopics>? learnTopics;
  late List<TestPreparations>? testPreparations;
  late bool isPhoneActivated;
  //late int? timezone;
  late String? studySchedule;
  //bool canSendMessage;

  User({required this.id,
        required this.email,
        required this.name,
        required this.avatar,
        this.country,
        required this.phone,
        required this.roles,
        //this.language,
        this.birthday,
        required this.isActivated,
        //this.walletInfo,
        //this.courses,
        //this.requireNote,
        this.level,
        this.learnTopics,
        this.testPreparations,
        required this.isPhoneActivated,
        //required this.timezone,
        this.studySchedule,
        //this.canSendMessage
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    name = json['name'];
    avatar = json['avatar'];
    country = json['country'];
    phone = json['phone'];
    roles = json['roles'].cast<String>();
    //language = json['language'];
    birthday = json['birthday'];
    isActivated = json['isActivated'];
    /*walletInfo = json['walletInfo'] != null
        ? new WalletInfo.fromJson(json['walletInfo'])
        : null;*/
    /*if (json['courses'] != null) {
      courses = new List<Null>();
      json['courses'].forEach((v) {
        courses.add(new Null.fromJson(v));
      });
    }*/
    //requireNote = json['requireNote'];
    level = json['level'];
    if (json['learnTopics'] != null) {
      learnTopics = <LearnTopics>[];
      json['learnTopics'].forEach((v) {
        learnTopics?.add(LearnTopics.fromJson(v));
      });
    }
    if (json['testPreparations'] != null) {
      testPreparations = <TestPreparations>[];
      json['testPreparations'].forEach((v) {
        testPreparations?.add(TestPreparations.fromJson(v));
      });
    }
    isPhoneActivated = json['isPhoneActivated'];
    //timezone = json['timezone'];
    studySchedule = json['studySchedule'];
    //canSendMessage = json['canSendMessage'];
  }

  fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    name = json['name'];
    avatar = json['avatar'];
    country = json['country'];
    phone = json['phone'];
    roles = json['roles'].cast<String>();
    //language = json['language'];
    birthday = json['birthday'];
    isActivated = json['isActivated'];
    /*walletInfo = json['walletInfo'] != null
        ? new WalletInfo.fromJson(json['walletInfo'])
        : null;*/
    /*if (json['courses'] != null) {
      courses = new List<Null>();
      json['courses'].forEach((v) {
        courses.add(new Null.fromJson(v));
      });
    }*/
    //requireNote = json['requireNote'];
    level = json['level'];
    if (json['learnTopics'] != null) {
      learnTopics = <LearnTopics>[];
      json['learnTopics'].forEach((v) {
        learnTopics?.add(new LearnTopics.fromJson(v));
      });
    }
    if (json['testPreparations'] != null) {
      testPreparations = <TestPreparations>[];
      json['testPreparations'].forEach((v) {
        testPreparations?.add(new TestPreparations.fromJson(v));
      });
    }
    isPhoneActivated = json['isPhoneActivated'];
    //timezone = json['timezone'];
    studySchedule = json['studySchedule'];
    //canSendMessage = json['canSendMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['name'] = this.name;
    data['avatar'] = this.avatar;
    data['country'] = this.country;
    data['phone'] = this.phone;
    data['roles'] = this.roles;
    //data['language'] = this.language;
    data['birthday'] = this.birthday;
    data['isActivated'] = this.isActivated;
    /*if (this.walletInfo != null) {
      data['walletInfo'] = this.walletInfo.toJson();
    }*/
    /*if (this.courses != null) {
      data['courses'] = this.courses.map((v) => v.toJson()).toList();
    }*/
    //data['requireNote']: this.requireNote;
    data['level'] = this.level;
    if (this.learnTopics != null) {
      data['learnTopics'] = this.learnTopics?.map((v) => v.id).toList();
    }
    if (this.testPreparations != null) {
      data['testPreparations'] =
          this.testPreparations?.map((v) => v.id).toList();
    }
    data['isPhoneActivated'] = this.isPhoneActivated;
    //data['timezone'] = this.timezone;
    data['studySchedule'] = this.studySchedule;
    //data['canSendMessage'] = this.canSendMessage;
    return data;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}

/*class WalletInfo {
  String id;
  String userId;
  String amount;
  bool isBlocked;
  String createdAt;
  String updatedAt;
  int bonus;

  WalletInfo(
      {this.id,
        this.userId,
        this.amount,
        this.isBlocked,
        this.createdAt,
        this.updatedAt,
        this.bonus});

  WalletInfo.fromJson(Map<String, dynamic> json) {
    id: json['id'];
    userId: json['userId'];
    amount: json['amount'];
    isBlocked: json['isBlocked'];
    createdAt: json['createdAt'];
    updatedAt: json['updatedAt'];
    bonus: json['bonus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data: new Map<String, dynamic>();
    data['id']: this.id;
    data['userId']: this.userId;
    data['amount']: this.amount;
    data['isBlocked']: this.isBlocked;
    data['createdAt']: this.createdAt;
    data['updatedAt']: this.updatedAt;
    data['bonus']: this.bonus;
    return data;
  }
}*/

class LearnTopics {
  LearnTopics({
    required this.id,
    required this.key,
    required this.name,
  });
  late final int id;
  late final String key;
  late final String name;

  LearnTopics.fromJson(Map<String, dynamic> json){
    id = json['id'];
    key = json['key'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['key'] = key;
    _data['name'] = name;
    return _data;
  }
}

class TestPreparations {
  TestPreparations({
    required this.id,
    required this.key,
    required this.name,
  });
  late final int id;
  late final String key;
  late final String name;

  TestPreparations.fromJson(Map<String, dynamic> json){
    id = json['id'];
    key = json['key'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['key'] = key;
    data['name'] = name;
    return data;
  }
}