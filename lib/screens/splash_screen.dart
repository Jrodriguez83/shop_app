import 'dart:math';

import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: EdgeInsets.only(bottom: 20),
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 94),
          transform: Matrix4.rotationZ(-8 * pi / 180)..translate(-10.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.deepOrange.shade900,
              boxShadow: [
                BoxShadow(
                  blurRadius: 8,
                  color: Colors.black26,
                  offset: Offset(0, 2),
                )
              ]),
          child: Text(
            'My shop',
            style: TextStyle(
              color: Theme.of(context).accentTextTheme.title.color,
              fontSize: 50,
              fontFamily: 'Anton',
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
