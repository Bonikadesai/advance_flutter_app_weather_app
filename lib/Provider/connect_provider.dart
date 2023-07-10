import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';

import '../Modal/conectivity_modal.dart';

class ConnectProvider extends ChangeNotifier {
  Connectivity connectivity = Connectivity();
  ConnectModel connectModel = ConnectModel(connectStatus: "Waiting");

  void checkInternet() {
    connectModel.connectStream = connectivity.onConnectivityChanged
        .listen((ConnectivityResult connectivityResult) {
      switch (connectivityResult) {
        case ConnectivityResult.mobile:
          connectModel.connectStatus = "Mobile";
          notifyListeners();
          break;

        case ConnectivityResult.wifi:
          connectModel.connectStatus = "Wifi";
          notifyListeners();
          break;

        default:
          connectModel.connectStatus = "Waiting";
      }
    });
  }
}
