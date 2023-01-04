import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:individual_project/model/User/Tokens.dart';
import 'package:individual_project/model/User/User.dart';
import 'package:http/http.dart' as http;

class UserProvider  with ChangeNotifier, Diagnosticable {
  late User _thisUser;
  late Tokens _thisTokens;

  get thisUser => _thisUser;
  get thisTokens => _thisTokens;

  set thisUser(newValue) {
    _thisUser = newValue;
    notifyListeners();
  }

  void getUser(Access aToken) async {
    var url = Uri.https('sandbox.api.lettutor.com', 'user/info');
    var response = await http.get(url, headers: {'Authorization': "Bearer ${aToken.token}"});
    if (response.statusCode != 200) {
      final Map parsed = json.decode(response.body);
      final String err = parsed["message"];
      print(err);
    }
    else {
      final Map parsed = json.decode(response.body);
      thisUser = User.fromJson(parsed["user"]);
      notifyListeners();
    }
  }

  set thisTokens(newValue) {
    _thisTokens = newValue;
    notifyListeners();
  }
}