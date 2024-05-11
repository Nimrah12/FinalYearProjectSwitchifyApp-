// switch_page.dart
import 'dart:async';

import 'package:firebasebutton/aboutus.dart';
import 'package:firebasebutton/analytics.dart';
import 'package:firebasebutton/login_page.dart';
import 'package:firebasebutton/pinout.dart';
import 'package:firebasebutton/pointer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:web_socket_channel/io.dart';

class WebSocketLed extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WebSocketLed();
  }
}

class _WebSocketLed extends State<WebSocketLed> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  late bool D0status; //boolean value to track LED status, if its ON or OFF
  late bool D1status;
  late bool D2status;
  late bool D4status;
  late bool D5status;

  late bool D2modeA = false;
  late String D2level = "";

  late IOWebSocketChannel channel;
  late bool connected; //boolean value to track if WebSocket is connected
  bool d0 = false;
  bool d1 = false;
  bool d2 = false;
  bool d4 = false;
  bool d5 = false;
  final D0Controller = TextEditingController();
  final D1Controller = TextEditingController();
  final D2Controller = TextEditingController();
  final D4Controller = TextEditingController();
  final D5Controller = TextEditingController();

  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  void _updateFirebase(String device, int state) {
    _databaseReference.child(device).update({
      'timestamp': DateTime.now().toString(),
      'Status': state,
    });
  }

  void updateTime(String device) async {
    DatabaseReference dbRef =
        FirebaseDatabase.instance.ref().child(device).child('Status');
    DatabaseReference dbRef2 =
        FirebaseDatabase.instance.ref().child(device).child('time');

    DatabaseEvent dataSnapshot = await dbRef.once();
    DatabaseEvent dataSnapshot2 = await dbRef2.once();

    int statusdata = int.parse(dataSnapshot.snapshot.value.toString());
    int timedata = int.parse(dataSnapshot2.snapshot.value.toString());

    print('Status: $statusdata' + ' - Time: $timedata');

    if (statusdata == 1) {
      timedata += 1;
    } else if (statusdata == 0) {
      timedata += 0;
    }
    if (timedata >= 1440) {
      timedata = 0;
    }
    _databaseReference.child(device).update({
      'time': timedata,
    });
    print(timedata);
  }

  void periodic(String device) {
    Timer.periodic(Duration(minutes: 1), (timer) {
      updateTime(device);
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    D0Controller.dispose();
    D1Controller.dispose();
    D2Controller.dispose();
    D4Controller.dispose();
    D5Controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    D0status = false; //initially leadstatus is off so its FALSE
    D1status = false;
    D2status = false;
    D4status = false; //initially leadstatus is off so its FALSE
    D5status = false;

    if (D0Controller.text == "") {
      D0Controller.text = "D0";
    }
    if (D1Controller.text == "") {
      D1Controller.text = "D1";
    }
    if (D2Controller.text == "") {
      D2Controller.text = "D2";
    }
    if (D4Controller.text == "") {
      D4Controller.text = "D4";
    }
    if (D5Controller.text == "") {
      D5Controller.text = "D5";
    }

    super.initState();
  }

  bool fanState = false;
  bool tvState = false;
  bool bulbState = false;
  bool ledState = false;
  bool lightState = false;

  void buttonpressd0() {
    setState(() {
      fanState = !fanState;
      int a = fanState ? 1 : 0;
      _updateFirebase('D0', a);
      periodic('D0');
    });
    if (D0status) {
      // Turn off the LED
      sendcmd("D0off");
      D0status = false;
    } else {
      // Turn on the LED
      sendcmd("D0on");
      D0status = true;
    }
  }

  void buttonpressd1() {
    setState(() {
      tvState = !tvState;
      var a;
      if (tvState) {
        a = 1;
      } else {
        a = 0;
      }
      tvState ? true : a = 1;
      tvState ? false : a = 0;
      _updateFirebase('D1', a);
      periodic('D1');
    });
    if (D1status) {
      sendcmd("D1off");
      D1status = false;
    } else {
      sendcmd("D1on");
      D1status = true;
    }
  }

  void buttonpressd2() {
    // on button press
    setState(() {
      bulbState = !bulbState;
      var a;
      if (bulbState) {
        a = 1;
      } else {
        a = 0;
      }
      bulbState ? true : a = 1;
      bulbState ? false : a = 0;
      _updateFirebase('D2', a);
      periodic('D2');
    });
    if (D2status) {
      sendcmd("D2off");
      D2status = false;
    } else {
      sendcmd("D2on");
      D2status = true;
    }
  }

  void buttonpressd4() {
    // on button press
    setState(() {
      ledState = !ledState;
      var a;
      if (ledState) {
        a = 1;
      } else {
        a = 0;
      }
      ledState ? true : a = 1;
      ledState ? false : a = 0;
      _updateFirebase('D4', a);
      periodic('D4');
    });
    if (D4status) {
      sendcmd("D4off");
      D4status = false;
    } else {
      sendcmd("D4on");
      D4status = true;
    }
  }

  void buttonpressd5() {
    // on button press
    setState(() {
      lightState = !lightState;
      var a;
      if (lightState) {
        a = 1;
      } else {
        a = 0;
      }
      lightState ? true : a = 1;
      lightState ? false : a = 0;
      _updateFirebase('D5', a);
      periodic('D5');
    });
    if (D5status) {
      sendcmd("D5off");
      D5status = false;
    } else {
      sendcmd("D5on");
      D5status = true;
    }
  }

  Future<void> sendcmd(String cmd) async {
    if (connected == true) {
      if (D0status == false &&
          cmd != "D0on" &&
          cmd != "D0off" &&
          D1status == false &&
          cmd != "D1on" &&
          cmd != "D1off" &&
          D2status == false &&
          cmd != "D2on" &&
          cmd != "D2off" &&
          D4status == false &&
          cmd != "D4on" &&
          cmd != "D4off" &&
          D5status == false &&
          cmd != "D5on" &&
          cmd != "D5off") {
        print("Send the valid command");
      } else {
        channel.sink.add(cmd);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          leading: IconButton(
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            icon: const Icon(
              Icons.menu,
              color: Colors.yellow,
            ),
          ),
          title: const Text("Button Switch",
              style: TextStyle(
                color: Colors.yellow,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              )),
          backgroundColor: Color.fromARGB(255, 0, 0, 0)),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 32, 22, 22),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      height: 120,
                      width: 100,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/switchifylogo.png"),
                          opacity: 1,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: const Text('ESP 8266 Pinout'),
              onTap: () {
                Navigator.of(context).push(_createRoute());
              },
            ),
            ListTile(
              title: const Text('Switch Analysis'),
              onTap: () {
                Navigator.of(context).push(_createRoutePointer());
              },
            ),
            ListTile(
              title: const Text('Graph Analysis for Switches'),
              onTap: () {
                Navigator.of(context).push(_createRouteAnalytics());
              },
            ),
            ListTile(
              title: const Text('About Us'),
              onTap: () {
                Navigator.of(context).push(_createRouteAboutus());
              },
            ),
            ListTile(
              title: const Text('Sign Out'),
              onTap: () {
                Navigator.of(context).push(_createRouteSignout());
              },
            ),
          ],
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 32, 22, 22),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Image.asset(
                'assets/images/switchifylogo.png',
                width: 200,
                height: 250,
              ),
              Stack(
                children: [
                  Container(
                      alignment: Alignment.topCenter,
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Column(
                                children: [
                                  const SizedBox(height: 10),
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          d0button(
                                              context), // Pass the context to d0button
                                          const SizedBox(width: 30.0),
                                          d1button(
                                              context), // Pass the context to d1button
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          d2button(context),
                                          const SizedBox(width: 30.0),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          d4button(
                                              context), // Pass the context to d4button
                                          const SizedBox(width: 30.0),
                                          d5button(
                                              context), // Pass the context to d5button
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row d0button(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Column(
            children: [
              Text(
                'D0',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.yellow,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Colors.blue,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        content: Container(
                          height: 200,
                          width: 250,
                          child: Column(
                            children: [
                              Text(
                                'Enter the name of the button here',
                                style: TextStyle(color: Colors.grey),
                              ),
                              SizedBox(height: 10),
                              TextField(
                                controller: D0Controller,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Button Name',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  'Save',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
        Column(
          children: [
            Container(
              height: 70,
              width: 128,
              margin: const EdgeInsets.only(top: 30),
              child: TextButton(
                onPressed: () {
                  buttonpressd0();
                },
                style: TextButton.styleFrom(
                  backgroundColor: D0status ? Colors.green : Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      D0status ? Icons.check_circle : Icons.error,
                      color: Colors.white,
                    ),
                    SizedBox(width: 5),
                    Text(
                      D0Controller.text,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 5.0),
            Text(
              D0status ? 'ON' : 'OFF',
              style: TextStyle(
                color: D0status ? Colors.green : Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Row d1button(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Column(
            children: [
              Text(
                'D1',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.yellow,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Colors.blue,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        content: Container(
                          height: 200,
                          width: 250,
                          child: Column(
                            children: [
                              Text(
                                'Enter the name of the button here',
                                style: TextStyle(color: Colors.black),
                              ),
                              SizedBox(height: 10),
                              TextField(
                                controller: D1Controller,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Button Name',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  'Save',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
        Column(
          children: [
            Container(
              height: 70,
              width: 128,
              margin: const EdgeInsets.only(top: 30),
              child: TextButton(
                onPressed: () {
                  buttonpressd1();
                },
                style: TextButton.styleFrom(
                  backgroundColor: D1status ? Colors.green : Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      D1status ? Icons.check_circle : Icons.error,
                      color: Colors.white,
                    ),
                    SizedBox(width: 5),
                    Text(
                      D1Controller.text,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 5.0),
            Text(
              D1status ? 'ON' : 'OFF',
              style: TextStyle(
                color: D1status ? Colors.green : Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Row d2button(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Column(
            children: [
              Text(
                'D2',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.yellow,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Colors.blue,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        content: Container(
                          height: 200,
                          width: 250,
                          child: Column(
                            children: [
                              Text(
                                'Enter the name of the button here',
                                style: TextStyle(color: Colors.black),
                              ),
                              SizedBox(height: 10),
                              TextField(
                                controller: D2Controller,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Button Name',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  'Save',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
        Column(
          children: [
            Container(
              height: 70,
              width: 130,
              margin: const EdgeInsets.only(top: 30),
              child: TextButton(
                onPressed: () {
                  buttonpressd2();
                },
                style: TextButton.styleFrom(
                  backgroundColor: D2status ? Colors.green : Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      D2status ? Icons.check_circle : Icons.error,
                      color: Colors.white,
                    ),
                    SizedBox(width: 5),
                    Text(
                      D2Controller.text,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 5.0),
            Text(
              D2status ? 'ON' : 'OFF',
              style: TextStyle(
                color: D2status ? Colors.green : Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Row d4button(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Column(
            children: [
              Text(
                'D4',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.yellow,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Colors.blue,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        content: Container(
                          height: 200,
                          width: 250,
                          child: Column(
                            children: [
                              Text(
                                'Enter the name of the button here',
                                style: TextStyle(color: Colors.black),
                              ),
                              SizedBox(height: 10),
                              TextField(
                                controller: D4Controller,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Button Name',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  'Save',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
        Column(
          children: [
            Container(
              height: 70,
              width: 130,
              margin: const EdgeInsets.only(top: 30),
              child: TextButton(
                onPressed: () {
                  buttonpressd4();
                },
                style: TextButton.styleFrom(
                  backgroundColor: D4status ? Colors.green : Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      D4status ? Icons.check_circle : Icons.error,
                      color: Colors.white,
                    ),
                    SizedBox(width: 5),
                    Text(
                      D4Controller.text,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 5.0),
            Text(
              D4status ? 'ON' : 'OFF',
              style: TextStyle(
                color: D4status ? Colors.green : Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Row d5button(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Column(
            children: [
              Text(
                'D5',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.yellow,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Colors.blue,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        content: Container(
                          height: 200,
                          width: 250,
                          child: Column(
                            children: [
                              Text(
                                'Enter the name of the button here',
                                style: TextStyle(color: Colors.black),
                              ),
                              SizedBox(height: 10),
                              TextField(
                                controller: D5Controller,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Button Name',
                                  hintStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  'Save',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
        Column(
          children: [
            Container(
              height: 70,
              width: 130,
              margin: const EdgeInsets.only(top: 30),
              child: TextButton(
                onPressed: () {
                  buttonpressd5();
                },
                style: TextButton.styleFrom(
                  backgroundColor: D5status ? Colors.green : Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      D5status ? Icons.check_circle : Icons.error,
                      color: Colors.white,
                    ),
                    SizedBox(width: 5),
                    Text(
                      D5Controller.text,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 5.0),
            Text(
              D5status ? 'ON' : 'OFF',
              style: TextStyle(
                color: D5status ? Colors.green : Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => Pinout(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.fastOutSlowIn;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  Route _createRouteAnalytics() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const Analytics(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.fastOutSlowIn;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  Route _createRoutePointer() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const Pointer(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.fastOutSlowIn;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  Route _createRouteAboutus() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => Aboutus(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.fastOutSlowIn;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  Route _createRouteSignout() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => LoginPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.fastOutSlowIn;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
