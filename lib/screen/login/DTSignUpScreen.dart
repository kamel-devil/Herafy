import 'package:awesome_dialog/awesome_dialog.dart' as dialog;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:herafy/screen/DTDashboardScreen.dart';
import 'package:herafy/screen/login/component/menu.dart';
import 'package:herafy/screen/login/login.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../utils/AppWidget.dart';
import '../DTDrawerWidget.dart';

class DTSignUpScreen extends StatefulWidget {
  static String tag = '/DTSignUpScreen';

  @override
  DTSignUpScreenState createState() => DTSignUpScreenState();
}

class DTSignUpScreenState extends State<DTSignUpScreen> {
  bool obscureText = true;
  bool autoValidate = false;
  var formKey = GlobalKey<FormState>();

  TextEditingController nameCont = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController naID = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf5f5f5),
      resizeToAvoidBottomInset: false,
      appBar: appBar(context, 'Sign Up', color: const Color(0xFFf5f5f5)),
      drawer: DTDrawerWidget(),
      body: ListView(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 8),
        children: [
          MediaQuery.of(context).size.width >= 980
              ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,

              children: [
                Row(
                  children: [
                    GestureDetector(
                        onTap: (){
                          // Navigator.push(context, route)
                          LoginPage().launch(context);
                        },
                        child: _menuItem(title: 'Sign IN', isActive: false)

                    ),
                    SizedBox(width: 20,),
                    _menuItem(title: 'Register', isActive: true),
                  ],
                ),
              ],
            ),
          )
              : const SizedBox(), // Responsive
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MediaQuery.of(context).size.width >= 1300 //Responsive
                        ? Text(
                            'Sign UP to \nMy Application',
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width / 30,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : const SizedBox(),
                    const SizedBox(
                      height: 30,
                    ),
                    MediaQuery.of(context).size.width >= 1300 //Responsive
                        ? Image.asset(
                            'images/illustration-2.png',
                            width: 300,
                          )
                        : const SizedBox(),
                    // Image.asset(
                    //   'images/illustration-2.png',
                    //   width: 300,
                    // ),
                  ],
                ),
              ),

              // Image.asset(
              //   'images/illustration-1.png',
              //   width: 300,
              // ),
              MediaQuery.of(context).size.width >= 1300 //Responsive
                  ? Image.asset(
                      'images/illustration-1.png',
                      width: 300,
                    )
                  : const SizedBox(),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height / 6),
                child: SizedBox(
                  width: 320,
                  child: _formLogin(context),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _formLogin(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: nameCont,
          decoration: InputDecoration(
            hintText: 'Enter Name',
            filled: true,
            fillColor: Colors.blueGrey[50],
            labelStyle: const TextStyle(fontSize: 12),
            contentPadding: const EdgeInsets.only(left: 30),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueGrey.shade50),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueGrey.shade50),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        const SizedBox(height: 30),
        TextField(
          controller: email,
          decoration: InputDecoration(
            hintText: 'Enter email or Phone number',
            filled: true,
            fillColor: Colors.blueGrey[50],
            labelStyle: const TextStyle(fontSize: 12),
            contentPadding: const EdgeInsets.only(left: 30),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueGrey.shade50),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueGrey.shade50),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        const SizedBox(height: 30),
        TextField(
          controller: pass,
          decoration: InputDecoration(
            hintText: 'Password',
            suffixIcon: const Icon(
              Icons.visibility_off_outlined,
              color: Colors.grey,
            ),
            filled: true,
            fillColor: Colors.blueGrey[50],
            labelStyle: const TextStyle(fontSize: 12),
            contentPadding: const EdgeInsets.only(left: 30),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.blueGrey.shade50,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueGrey.shade50),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        const SizedBox(height: 30),
        TextField(
          controller: naID,
          decoration: InputDecoration(
            hintText: 'National ID',
            filled: true,
            fillColor: Colors.blueGrey[50],
            labelStyle: const TextStyle(fontSize: 12),
            contentPadding: const EdgeInsets.only(left: 30),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueGrey.shade50),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueGrey.shade50),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        const SizedBox(height: 40),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurple.shade100,
                spreadRadius: 10,
                blurRadius: 20,
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () {
              finish(context);
              signUp().then((value) {
                DTDashboardScreen().launch(context);
                addDataEmail();
              });

              /// Remove comment if you want enable validation
              // if (formKey.currentState!.validate()) {
              // formKey.currentState!.save();
              // DTDashboardScreen().launch(context);
              // } else {
              // autoValidate = true;
              // }
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.deepPurple,
              onPrimary: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: const SizedBox(
                width: double.infinity,
                height: 50,
                child: Center(child: Text("Sign UP"))),
          ),
        ),
        const SizedBox(height: 40),
        Row(children: [
          Expanded(
            child: Divider(
              color: Colors.grey[300],
              height: 50,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text("Or continue with"),
          ),
          Expanded(
            child: Divider(
              color: Colors.grey[400],
              height: 50,
            ),
          ),
        ]),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _loginWithButton(image: 'images/google.png'),
            _loginWithButton(image: 'images/github.png', isActive: true),
            _loginWithButton(image: 'images/facebook.png'),
          ],
        ),
      ],
    );
  }

  Widget _loginWithButton({required String image, bool isActive = false}) {
    return Container(
      width: 90,
      height: 70,
      decoration: isActive
          ? BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade100,
                  spreadRadius: 10,
                  blurRadius: 30,
                )
              ],
              borderRadius: BorderRadius.circular(15),
            )
          : BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey.shade400),
            ),
      child: Center(
          child: Container(
        decoration: isActive
            ? BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(35),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade400,
                    spreadRadius: 2,
                    blurRadius: 15,
                  )
                ],
              )
            : const BoxDecoration(),
        child: Image.asset(
          image,
          width: 35,
        ),
      )),
    );
  }

  Future signUp() async {
    try {
      if (email.text.isNotEmpty &&
          pass.text.isNotEmpty &&
          nameCont.text.isNotEmpty &&
          naID.text.isNotEmpty) {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: email.text, password: pass.text);
        return userCredential;
      } else {}
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        dialog.AwesomeDialog(
          context: context,
          dialogType: dialog.DialogType.INFO,
          animType: dialog.AnimType.BOTTOMSLIDE,
          title: 'Attend  !',
          desc: 'The password is weak',
          btnCancelOnPress: () {},
          btnOkOnPress: () {},
        ).show();
      } else if (e.code == 'email-already-in-use') {
        dialog.AwesomeDialog(
          context: context,
          dialogType: dialog.DialogType.INFO,
          animType: dialog.AnimType.BOTTOMSLIDE,
          title: 'Attend  !',
          desc: 'This Account is Already Exist',
          btnOkOnPress: () {},
        ).show();
      }
    } catch (e) {
      print(e);
    }
  }

  addDataEmail() async {
    CollectionReference? addUser;
    User? user = FirebaseAuth.instance.currentUser;
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    addUser = FirebaseFirestore.instance.collection('users');
    addUser?.doc('${user?.uid}').set({
      'email': email.text,
      'name': nameCont.text,
      'national_id': naID.text,
      'id': user?.uid,
      'image': 'null',
      'created_at': time,
      'is_online': false,
      'last_active': time,
      'push_token': '',
      'about': 'Hallo'
    });
  }
  Widget _menuItem({String title = 'Title Menu', isActive = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 75),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Column(
          children: [
            Text(
              '$title',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isActive ? Colors.deepPurple : Colors.grey,
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            isActive
                ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(30),
              ),
            )
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  Widget _registerButton() {
    return GestureDetector(
      onTap: (){
        // Navigator.push(context, route)
        LoginPage().launch(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              spreadRadius: 10,
              blurRadius: 12,
            ),
          ],
        ),
        child: const Text(
          'Sign IN',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }
}
