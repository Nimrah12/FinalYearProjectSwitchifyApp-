import 'package:firebasebutton/home_page.dart';
import 'package:firebasebutton/login_page.dart';
import 'package:firebasebutton/sign_up_page.dart';
import 'package:firebasebutton/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebasebutton/switchpage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    // await Firebase.initializeApp();
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyB_G8FCIQdkj_hZbEKd0gzNyYbVadrQHP4",
          // apiKey:
          //     "BKmg_24Phw5IEtMp5mNca8iNik0ZgkQLqwm2AXwr1EG5vyj4wcmnL89aMoh5TMz45msRmVed1MX7Ae01SYTEzy0",
          appId: "1:385161216420:android:b7df1482df404758a0c131",
          messagingSenderId: "385161216420",
          projectId: "fir-button-5ddf8",
          databaseURL:
              "https://fir-button-5ddf8-default-rtdb.europe-west1.firebasedatabase.app/"),
    );
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
  runApp(MyApp());
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       routes: {
//         '/': (context) => const SplashScreen(
//               // Here, you can decide whether to show the LoginPage or HomePage based on user authentication
//               child: LoginPage(),
//             ),
//         '/login': (context) => const LoginPage(),
//         '/signUp': (context) => const SignUpPage(),
//         '/home': (context) => const HomePage(),
//       },
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

DatabaseReference usersRef = FirebaseDatabase.instance.ref().child("users");

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Switchify',
      theme: ThemeData(
        fontFamily: 'Georgia',
      ),
      routes: {
        '/': (context) => SplashScreen(
              // Here, you can decide whether to show the LoginPage or HomePage based on user authentication
              child: LoginPage(),
            ),
        '/login': (context) => LoginPage(),
        '/signUp': (context) => SignUpPage(),
        '/home': (context) => HomePage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  final databaseReference = FirebaseDatabase.instance.ref();
  // Function to add data to Firebase on button press
  void sendDataToFirebase() {
    databaseReference.child("chat_messages").push().set({
      'timestamp': DateTime.now().toIso8601String(),
      'message': 'Hello from Flutter!',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: sendDataToFirebase,
          child: const Text('Send Data to Firebase'),
          tooltip: 'Increment',
        ), // This trailing comma makes auto-formatting nicer for build methods.

        //navigation bar switch page
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          onTap: (index) {
            if (index == 0) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (context) => const MyHomePage(title: 'Home Page')),
              );
            } else if (index == 1) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => WebSocketLed()),
              );
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.toggle_on),
              label: 'Switch',
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
