import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sql_todo_app/databses/helper.dart';

class Itemchecking extends ChangeNotifier {
  bool visible = false;
  Future<void> checkcounter(String category) async {
    await Sqlhelper.countchecked(category).then((value) {
      print(value[0]['count']);
      if (value[0]['count'] > 0) {
        visible = true;
      } else {
        visible = false;
      }
    });
    notifyListeners();
  }

  void deleteitems(String category) {
    Sqlhelper.delete(category);
    notifyListeners();
  }

}
