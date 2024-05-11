import 'package:flutter/material.dart';

class Pinout extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          title: const Text(
            "ESP Button Pinouts",
            style: TextStyle(
              color: Colors.yellow,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          backgroundColor: Color.fromARGB(255, 0, 0, 0)),
      backgroundColor:
          const Color.fromARGB(255, 32, 22, 22), // Set background color here

      body: Center(
        child: InteractiveViewer(
          panEnabled: false, // Set it to false
          boundaryMargin: EdgeInsets.all(10),
          minScale: 0.5,
          maxScale: 3,
          child: Image.asset(
            'assets/images/pin.png',
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
