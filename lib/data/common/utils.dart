import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const defaultScrolPhisic = BouncingScrollPhysics();

extension PriceLabel on int {
  String get withPriceLabel => this > 0 ? '$separateByComa تومان' : 'رایگان';

  String get separateByComa {
    final numberForamt = NumberFormat.decimalPattern();
    return numberForamt.format(this);
  }
}
