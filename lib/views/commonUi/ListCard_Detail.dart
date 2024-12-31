import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../theme.dart';

class ListCard_Detail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: theme.theme_color_Lightest,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: theme.theme_color_Lightest,
        ),
        child: Text("aaaaaa"),
      ),
       
    );
  }
  
  
}