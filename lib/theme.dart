// BoxShadow
import 'package:flutter/cupertino.dart';
import 'package:hexcolor/hexcolor.dart';

class theme{
  static List <BoxShadow> Default_boxShadow = [
    BoxShadow(
      color: HexColor("#15191d").withOpacity(0.1),
      spreadRadius: 2,
      blurRadius: 3,
      offset: const Offset(0, 3), // changes position of shadow
    ),
  ];

  static List <Color> Default_gradient =  [HexColor("#D7b3bb4"), HexColor("#19c9c1")];

  static AssetImage Default_BackGround = AssetImage("assets/images/bg.png");
}


