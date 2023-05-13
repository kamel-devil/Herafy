import 'package:awesome_dialog/awesome_dialog.dart' as dialog;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:herafy/screen/DTDashboardScreen.dart';
import 'package:nb_utils/nb_utils.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  TextEditingController email = TextEditingController();

  TextEditingController pass = TextEditingController();

  TextEditingController naID = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        MediaQuery.of(context).size.width >= 1300 //Responsive
            ? Image.asset(
                'images/login.jpg',
                width: 500,
                height: 500,
              )
            : const SizedBox(),
        const SizedBox(
          width: 40,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height / 6),
          child: SizedBox(
            width: 320,
            child: _formLogin(context),
          ),
        )
      ],
    );
  }

  Widget _formLogin(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            controller: email,
            validator: (val) {
              if (!val!.contains('@')) {
                return 'Enter Valid Email';
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
              hintText: 'Enter email',
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
          TextFormField(
            controller: pass,
            obscureText: true,
            validator: (val) {
              if (val!.length < 8) {
                return 'Short Password';
              } else {
                return null;
              }
            },
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
              onPressed: () async {
                await login();
                if (FirebaseAuth.instance.currentUser != null) {
                  const DTDashboardScreen().launch(context);
                }

                /// Remove comment if you want enable validation
                // if (formKey.currentState!.validate()) {
                // formKey.currentState!.save();
                // DTDashboardScreen().launch(context);
                // } else {
                // autoValidate = true;
                // }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: Center(child: Text("Sign In"))),
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
        ],
      ),
    );
  }

  Future login() async {
    if (formKey.currentState!.validate()) {
      try {
        if (email.text.isNotEmpty && pass.text.isNotEmpty) {
          UserCredential userCredential = await FirebaseAuth.instance
              .signInWithEmailAndPassword(
                  email: email.text, password: pass.text);
          return userCredential;
        } else {
          print('isEmpty');
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          dialog.AwesomeDialog(
            context: context,
            dialogType: dialog.DialogType.info,
            animType: dialog.AnimType.bottomSlide,
            title: 'Attend  !',
            desc: 'This Account IsNot Exist',
            btnCancelOnPress: () {},
            btnOkOnPress: () {},
          ).show();
        } else if (e.code == 'wrong-password') {
          dialog.AwesomeDialog(
            context: context,
            dialogType: dialog.DialogType.info,
            animType: dialog.AnimType.bottomSlide,
            title: 'Attend  !',
            desc: 'The password is Wrong',
            btnOkOnPress: () {},
          ).show();
        }
      } catch (e) {
        print(e);
      }
    }
  }
}
