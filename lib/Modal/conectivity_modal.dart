import 'dart:async';

class ConnectModel {
  String connectStatus;
  StreamSubscription? connectStream;

  ConnectModel({
    required this.connectStatus,
    this.connectStream,
  });
}
