import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final Widget? child;
  const SplashScreen({super.key, this.child});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Color shinyGoldColor = Color.fromRGBO(255, 215, 0, 1);

  @override
  void initState() {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => widget.child!),
          (route) => false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color.fromARGB(255, 32, 22, 22),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/switchifylogo.png',
              width: 230,
              height: 230,
            ),
            const SizedBox(height: 20), // Add spacing between image and text
            const Text(
              "Empower you to reach for  the sky",
              style: TextStyle(
                color: Colors.yellow,
                fontWeight: FontWeight.normal,
                fontSize: 18,
                fontFamily: 'Georgia',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
