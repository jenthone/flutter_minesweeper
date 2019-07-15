import 'dart:async';

import 'package:flutter/material.dart';

abstract class BusState<T extends StatefulWidget> extends State<T> {
  @protected
  StreamSubscription eventBusSubscription;

  @override
  void dispose() {
    eventBusSubscription?.cancel();
    super.dispose();
  }
}
