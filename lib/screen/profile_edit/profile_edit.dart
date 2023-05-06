import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firabase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';

class ProfileEdit extends StatefulWidget {
  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  bool showPassword = false;

  String selctFile = '';

  XFile? file;

  Uint8List? selectedImageInBytes;

  List<Uint8List> pickedImagesInBytes = [];

  int imageCounts = 0;

  TextEditingController name = TextEditingController();

  TextEditingController phone = TextEditingController();
  bool isMale = false;
  bool isFemale = false;
  String? gender;

  @override
  void initState() {
    print(FirebaseAuth.instance.currentUser!.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.green,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.green,
            ),
            onPressed: () {
              // Navigator.of(context).push(MaterialPageRoute(
              //     builder: (BuildContext context) => SettingsPage()));
            },
          ),
        ],
      ),
      body: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = snapshot.data;
              name = TextEditingController(text: data['name']);
              phone = TextEditingController();
              data['gender'] == 'female' ? isFemale = true : isMale = true;
              return Container(
                padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Edit Profile",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Center(
                        child: Stack(
                          children: [
                            selctFile.isEmpty
                                ? data['image'] == 'null'
                                    ? Container(
                                        width: 130,
                                        height: 130,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 4,
                                                color: Theme.of(context)
                                                    .scaffoldBackgroundColor),
                                            boxShadow: [
                                              BoxShadow(
                                                  spreadRadius: 2,
                                                  blurRadius: 10,
                                                  color: Colors.black
                                                      .withOpacity(0.1),
                                                  offset: const Offset(0, 10))
                                            ],
                                            shape: BoxShape.circle,
                                            image: const DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(
                                                  "https://images.pexels.com/photos/3307758/pexels-photo-3307758.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=250",
                                                ))),
                                      )
                                    : Container(
                                        width: 130,
                                        height: 130,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 4,
                                                color: Theme.of(context)
                                                    .scaffoldBackgroundColor),
                                            boxShadow: [
                                              BoxShadow(
                                                  spreadRadius: 2,
                                                  blurRadius: 10,
                                                  color: Colors.black
                                                      .withOpacity(0.1),
                                                  offset: const Offset(0, 10))
                                            ],
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(
                                                  data['image'],
                                                ))),
                                      )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.memory(
                                      selectedImageInBytes!,
                                      width: 150,
                                      height: 150,
                                    ),
                                  ),
                            Align(
                                alignment: Alignment.bottomLeft,
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      width: 4,
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                    ),
                                    color: Colors.green,
                                  ),
                                  child: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  ),
                                )).onTap(() {
                              selectFile(true);
                            }),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 35,
                      ),
                      buildTextField("Full Name", data['name'], false, name),
                      buildTextField("phone", data['phone'], false, phone),
                      LayoutBuilder(
                        builder:
                            (BuildContext context, BoxConstraints constraints) {
                          return Row(
                            children: <Widget>[
                              const SizedBox(
                                width: 50,
                                child: Text(
                                  "Gender",
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              const SizedBox(
                                width: 20.0,
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    isMale = true;
                                    isFemale = false;
                                    gender = 'male';
                                  });
                                },
                                child: CircleAvatar(
                                  backgroundColor: Colors.blue[50],
                                  child: Icon(Icons.face,
                                      color: isMale
                                          ? Colors.greenAccent
                                          : Colors.grey),
                                ),
                              ),
                              const SizedBox(
                                width: 30.0,
                              ),
                              const SizedBox(
                                width: 50.0,
                                child: Text(
                                  "Male",
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    isFemale = true;
                                    isMale = false;
                                    gender = 'female';
                                  });
                                },
                                child: CircleAvatar(
                                  backgroundColor: Colors.blue[50],
                                  child: Icon(
                                    Icons.face,
                                    color: isFemale
                                        ? Colors.greenAccent
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 30.0,
                              ),
                              const SizedBox(
                                width: 100.0,
                                child: Text(
                                  "Female",
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      // buildTextField("National I", data['national_id'], false,
                      //     nationalId),
                      // buildTextField("Password", "********", true),
                      // buildTextField("Location", "TLV, Israel", false),
                      const SizedBox(
                        height: 35,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MaterialButton(
                            padding: const EdgeInsets.symmetric(horizontal: 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("CANCEL",
                                style: TextStyle(
                                    fontSize: 14,
                                    letterSpacing: 2.2,
                                    color: Colors.black)),
                          ),
                          MaterialButton(
                            onPressed: () {
                              uploadFile();
                            },
                            color: Colors.green,
                            padding: const EdgeInsets.symmetric(horizontal: 50),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: const Text(
                              "SAVE",
                              style: TextStyle(
                                  fontSize: 14,
                                  letterSpacing: 2.2,
                                  color: Colors.white),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  Future getData() async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
  }

  selectFile(bool imageFrom) async {
    FilePickerResult? fileResult =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (fileResult != null) {
      setState(() {
        selctFile = fileResult.files.first.name;
        selectedImageInBytes = fileResult.files.first.bytes;
      });

      fileResult.files.forEach((element) {
        setState(() {
          pickedImagesInBytes.add(element.bytes!);

          imageCounts += 1;
        });
      });
    }
    print(selctFile);
  }


  Future<String> uploadFile() async {
    String imageUrl = '';
    try {
      firabase_storage.UploadTask uploadTask;

      firabase_storage.Reference ref = firabase_storage.FirebaseStorage.instance
          .ref()
          .child('users')
          .child('/$selctFile');
      final metadata =
          firabase_storage.SettableMetadata(contentType: 'image/jpeg');

      // uploadTask = ref.putFile(File(file!.path));
      uploadTask = ref.putData(selectedImageInBytes!, metadata);

      await uploadTask.whenComplete(() => null);
      imageUrl = await ref.getDownloadURL();
      print(imageUrl);
      print(FirebaseAuth.instance.currentUser!.uid);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        'image': imageUrl,
        "name": name.text,
        "gender": gender,
        "phone": phone.text,
      }, SetOptions(merge: true));
    } catch (e) {
      print(e);
    }
    return imageUrl;
  }

  Widget buildTextField(String labelText, String placeholder,
      bool isPasswordTextField, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        controller: controller,
        obscureText: isPasswordTextField ? showPassword : false,
        decoration: InputDecoration(
            suffixIcon: isPasswordTextField
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                    icon: const Icon(
                      Icons.remove_red_eye,
                      color: Colors.grey,
                    ),
                  )
                : null,
            contentPadding: const EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
      ),
    );
  }
}
