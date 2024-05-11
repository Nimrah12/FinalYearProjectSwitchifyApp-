import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasebutton/main.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebasebutton/form_container_widget.dart';
import 'package:firebasebutton/login_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    nametextEditingController.dispose();
    emailtextEditingController.dispose();
    passwordtextEditingController.dispose();
    mobiletextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          title: const Text(
            "Sign UP",
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
        child: SingleChildScrollView(
          child: Container(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/switchifylogo.png',
                      width: 200,
                      height: 250,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    FormContainerWidget(
                      controller: nametextEditingController,
                      hintText: "Name",
                      isPasswordField: false,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    FormContainerWidget(
                      controller: mobiletextEditingController,
                      hintText: "Mobile Number",
                      isPasswordField: false,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    FormContainerWidget(
                      controller: emailtextEditingController,
                      hintText: "Email",
                      isPasswordField: false,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    FormContainerWidget(
                      controller: passwordtextEditingController,
                      hintText: "Password",
                      isPasswordField: true,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: () => registerNewUser(context),
                      child: Container(
                        width: 90,
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Sign Up",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account?",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const LoginPage()),
                                  (route) => false);
                            },
                            child: const Text(
                              "Login Here",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic),
                            ))
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextEditingController nametextEditingController = TextEditingController();
  TextEditingController emailtextEditingController = TextEditingController();
  TextEditingController passwordtextEditingController = TextEditingController();
  TextEditingController mobiletextEditingController = TextEditingController();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void registerNewUser(BuildContext context) async {
    final User? firebaseUser = (await _firebaseAuth
            .createUserWithEmailAndPassword(
                email: emailtextEditingController.text,
                password: passwordtextEditingController.text)
            // ignore: body_might_complete_normally_catch_error
            .catchError((errMsg) {
      displayToastMessage("Error:$errMsg", context);
    }))
        .user;
    if (firebaseUser != null) {
      //save data to firebase real time database
      Map userDataMap = {
        "name": nametextEditingController.text,
        "email": emailtextEditingController,
        "mobile": mobiletextEditingController,
        "password": passwordtextEditingController,
      };
      usersRef.child(firebaseUser.uid).set(userDataMap);
      displayToastMessage(
          "Congratulation, your account has been created", context);
      Navigator.of(context).push(_createRoute());
    } else {
      // display error toast
      displayToastMessage("New user has NOT been created", context);
    }
  }

  displayToastMessage(String message, BuildContext context) {
    Fluttertoast.showToast(msg: message);
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const LoginPage(),
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
