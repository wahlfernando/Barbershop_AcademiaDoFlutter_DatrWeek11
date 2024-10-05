import 'package:flutter/material.dart';

class BarbershopNavGlobalkey {
  static BarbershopNavGlobalkey? _instance;
  
  final navKey = GlobalKey<NavigatorState>();

  BarbershopNavGlobalkey._();
  
  static BarbershopNavGlobalkey get instance =>
    _instance ??= BarbershopNavGlobalkey._();
}