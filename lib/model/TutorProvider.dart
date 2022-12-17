import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:individual_project/model/Tutor.dart';
import 'package:http/http.dart' as http;


class TutorProvider  with ChangeNotifier, Diagnosticable {
  late int count;
  late List<Tutor> theList;
  late List<Tutor> favList;

  void fromJson(Map<dynamic, dynamic> json){
    count = json['tutors']['count'];
    theList = List.from(json['tutors']['rows']).map((e)=>Tutor.fromListJson(e)).toList();
    favList = List.from(json['favoriteTutor']).map((e)=>Tutor.fromFavJson(e)).toList();
    notifyListeners();
  }

  void makeList() {
    //var toRemove = [];
    for (var aFav in favList) {
      for(var aNor in theList) {
        if (aFav.userId == aNor.userId) {
          aNor.toShow = false;
          aFav.isOnline = aNor.isOnline;
          //toRemove.add(aNor);
          print(aFav.userId + "is in Fav");
        }
      }
    }
    //theList.removeWhere( (e) => toRemove.contains(e));

    print("Nor length: " + theList.length.toString());
    print("Fav length: " + favList.length.toString());

    //pint("Per Page: " + perPage.toString());

    favList.sort((a, b) => getRatingScore(b.rating).compareTo(getRatingScore(a.rating)));
    theList.sort((a, b) => getRatingScore(b.rating).compareTo(getRatingScore(a.rating)));
    notifyListeners();
  }

  Future<String> doFav(String id, String token) async {
    var url = Uri.https('sandbox.api.lettutor.com', 'user/manageFavoriteTutor');
    var response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'tutorId': id})
    );

    if (response.statusCode != 200) {
      final Map parsed = json.decode(response.body);
      final String err = parsed["message"];
      return err;
    }
    else {
      //var tutorProvListItem = theList[index];
      //tutorProvListItem.isFavorite = !tutorProvListItem.isFavorite!;
      //notifyListeners();
      final Map parsed = json.decode(response.body);
      var res = parsed['result'];
      if (res == 1) {
        favList.removeWhere((element) => element.userId == id);
        var iToChange = theList.indexWhere((element) => element.userId == id);
        if (iToChange != -1) {
          theList[iToChange].toShow = true;
        }
      }
      else {
        var newFav = Tutor.fromFavJson(parsed['result']);
        favList.add(newFav);
        var iToChange = theList.indexWhere((element) => element.userId == newFav.userId);
        if (iToChange != -1) {
          theList[iToChange].toShow = false;
        }
        makeList();
      }
      notifyListeners();
      return "Success";
    }
  }

  double getRatingScore(double? rating) {
    if (rating == null) {
      return -1;
    }
    return rating;
  }
}