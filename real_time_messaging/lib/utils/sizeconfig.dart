import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SizeConfig {
  static SizeConfig _sizeConfig;
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double blockSizeHorizontal;
  static double blockSizeVertical;

  void init (BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
  }

  SizeConfig._createInstance();

  factory SizeConfig() {
    if(_sizeConfig == null) {
      _sizeConfig = SizeConfig._createInstance();
    }
    return _sizeConfig;
  }
}