import 'package:flutter/foundation.dart';
import 'package:individual_project/model/History/HistoryClass.dart';

class HistoryProvider with ChangeNotifier, Diagnosticable {
  late int count;
  late List<HistoryClass> rows = [];

  void fromJson(Map<String, dynamic> json){
    count = json['count'];
    rows = List.from(json['rows']).map((e)=>HistoryClass.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['count'] = count;
    _data['rows'] = rows.map((e)=>e.toJson()).toList();
    return _data;
  }
}