import 'package:flutter/material.dart';

class Aboutus extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(
          "About Us",
          style: TextStyle(
            color: Colors.yellow,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
      ),
      backgroundColor: const Color.fromARGB(255, 32, 22, 22),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/switchifylogo.png',
                width: 200,
                height: 250,
              ),
              const SizedBox(height: 40),
              const Text(
                'Welcome to ESP Switchify - Your Smart Home Automation Solution!',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20.0),
              const Text(
                'ESP Switchify is a revolutionary smart home automation system designed to bring convenience, efficiency, and control to your fingertips. With ESP Switchify, you can transform your ordinary home into a modern, intelligent space where every device is connected and easily managed.',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20.0),
              const Text(
                'Key Features:',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10.0),
              _buildFeature(
                'Switch Button Control',
                'Control various devices with the touch of a button.',
              ),
              _buildFeature(
                'Secure Login and Sign-in',
                'Ensure privacy and security with robust authentication.',
              ),
              _buildFeature(
                'Real-time Analytics in Graphs',
                'Gain insights into energy usage and device activity.',
              ),
              _buildFeature(
                'Integration with Firebase and ESP',
                'Seamlessly connect with Firebase and ESP microcontrollers.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeature(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 5.0),
        Text(
          description,
          style: TextStyle(
            fontSize: 14.0,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 10.0),
      ],
    );
  }
}
