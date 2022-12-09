class Tokens {
  Tokens({
    this.access,
    this.refresh,
  });
  late Access? access;
  late Refresh? refresh;

  fromJson(Map<String, dynamic> json){
    access = Access.fromJson(json['access']);
    refresh = Refresh.fromJson(json['refresh']);
  }

  Tokens.fromJson(Map<String, dynamic> json){
    access = Access.fromJson(json['access']);
    refresh = Refresh.fromJson(json['refresh']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['access'] = access?.toJson();
    _data['refresh'] = refresh?.toJson();
    return _data;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}

class Access {
  Access({
    required this.token,
    required this.expires,
  });
  late final String token;
  late final String expires;

  Access.fromJson(Map<String, dynamic> json){
    token = json['token'];
    expires = json['expires'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['token'] = token;
    _data['expires'] = expires;
    return _data;
  }
}

class Refresh {
  Refresh({
    required this.token,
    required this.expires,
  });
  late final String token;
  late final String expires;

  Refresh.fromJson(Map<String, dynamic> json){
    token = json['token'];
    expires = json['expires'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['token'] = token;
    _data['expires'] = expires;
    return _data;
  }
}