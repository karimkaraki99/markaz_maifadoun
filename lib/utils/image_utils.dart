import 'package:flutter/material.dart';
import 'colors_util.dart';

Image LogoWidget(String imageName , double width, double height){
  return Image.asset(
    imageName,
    fit: BoxFit.fitWidth,
    width: width,
    height: height,
    color: yellow,
  );
}
