import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;

const double kBasePixel = 0.5;

class YLYSizeAdaptor {
  static final YLYSizeAdaptor _instance = YLYSizeAdaptor._internal();

  factory YLYSizeAdaptor() {
    return _instance;
  }

  YLYSizeAdaptor._internal() {}

  late double sizeScale = 1.0;
  late double screenWidth = 375;
  late double screenHeight = 0;
  // XMTSizeAdaptor() {
  //   prepareConfiguration();
  // }

  static prepareConfiguration(MediaQueryData mediaQuery) {
    // MediaQueryData mediaQuery = MediaQuery.of(context);
    double width = mediaQuery.size.width;
    double height = mediaQuery.size.height;
    YLYSizeAdaptor().sizeScale = width / 375;
    YLYSizeAdaptor()..screenWidth = width;
    YLYSizeAdaptor()..screenHeight = height;
  }

  double naviHeight() {
    var window = WidgetsBinding.instance?.window ?? ui.window;
    double _statusBarHeight = window.padding.top;
    return _statusBarHeight;
  }

  double statusBarHeight() {
    var window = WidgetsBinding.instance?.window ?? ui.window;
    double _statusBarHeight = MediaQueryData.fromWindow(window).padding.top;
    return _statusBarHeight;
  }

  // ignore: non_constant_identifier_names
  double statusBarHeight_safe() {
    var window = WidgetsBinding.instance?.window ?? ui.window;
    double _statusBarHeight = MediaQueryData.fromWindow(window).padding.top;

    //
    if (_statusBarHeight == 0) {
      if (Platform.isAndroid) {
        // assign value of 40
        _statusBarHeight = YLYAdaptor375(40);
      }
    }

    return _statusBarHeight;
  }
}

/// 375 adapter
// ignore: non_constant_identifier_names
double YLYAdaptor375(double value) {
  return YLYAdaptorWithStandard(value, 375);
}

// ignore: non_constant_identifier_names
double YLYAdaptorWithStandard(double value, double standard) {
  return value * YLYSizeAdaptor().screenWidth / standard;
}

// ignore: non_constant_identifier_names
double YLYScreenWidth() {
  return YLYSizeAdaptor().screenWidth;
}

// ignore: non_constant_identifier_names
double YLYScreenHeight() {
  return YLYSizeAdaptor().screenHeight;
}

TextStyle YLYNormalFont(double size, Color color) {
  var fontSize = sizeRectofy(YLYAdaptor375(size));
  return TextStyle(
      fontSize: fontSize, color: color, fontWeight: FontWeight.normal);
}

double sizeRectofy(double size) {
  double rs = size.truncateToDouble();
  if (rs == size) {
    return rs;
  }
  double delta = size - rs;
  if (delta < kBasePixel * 0.5) {
    return rs;
  }
  if (delta < kBasePixel * 1.5) {
    return rs + kBasePixel;
  }
  if (delta < kBasePixel * 2.5) {
    return rs + kBasePixel * 2;
  }
  if (delta < kBasePixel * 3.5) {
    return rs + kBasePixel * 3.0;
  }
  return rs + kBasePixel * (delta / kBasePixel).round();
}
