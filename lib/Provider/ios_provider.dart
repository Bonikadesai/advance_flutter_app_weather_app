import 'package:flutter/cupertino.dart';

class IosProvider extends ChangeNotifier {
  bool isIos = true;

  void changePlatform(bool n) {
    isIos = n;
    notifyListeners();
  }
}
