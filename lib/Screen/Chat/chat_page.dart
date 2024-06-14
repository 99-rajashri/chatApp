import 'package:chatt_app/Screen/Chat/message.dart';
import 'package:chatt_app/Screen/Login/LoginScreen.dart';
import 'package:chatt_app/Screen/Services/auth.dart';
import 'package:chatt_app/Screen/user_details_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class CHatPage extends StatefulWidget {
  final String name;
  const CHatPage({super.key, required this.name});

  @override
  State<CHatPage> createState() => _CHatPageState();
}

class _CHatPageState extends State<CHatPage> {
  final TextEditingController msgConroller = TextEditingController();
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();

  Future<void> pickAndUploadFile() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      File file = File(image.path);
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      try {
        await FirebaseStorage.instance.ref('uploads/$fileName').putFile(file);
        String downloadUrl = await FirebaseStorage.instance
            .ref('uploads/$fileName')
            .getDownloadURL();
        firebaseFirestore.collection("Message").doc().set({
          'message': 'Image',
          'fileUrl': downloadUrl,
          'type': 'image',
          'time': DateTime.now(),
          'name': widget.name
        });
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UserDetailsPage(
                          name: widget.name,
                        )));
          },
          child: CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage("images/3135715.png"),
          ),
        ),
        title: Text(widget.name),
        actions: [
          MaterialButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: Colors.blueAccent,
            onPressed: () async {
              await AuthServices().signOut();
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginScreen()));
            },
            child: const Text(
              "Sign Out",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: DisplayMeassage(
                name: widget.name,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.image),
                    onPressed: pickAndUploadFile,
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: msgConroller,
                      decoration: const InputDecoration(
                        filled: true,
                        hintText: "message",
                        enabled: true,
                        contentPadding:
                            EdgeInsets.only(left: 15, bottom: 8, top: 8),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.green,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                      ),
                      validator: (value) {
                        return null;
                      },
                      onSaved: (newValue) {
                        msgConroller.text = newValue!;
                      },
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        if (msgConroller.text.isNotEmpty) {
                          firebaseFirestore.collection("Message").doc().set({
                            'message': msgConroller.text.trim(),
                            'time': DateTime.now(),
                            'name': widget.name
                          });
                          msgConroller.clear();
                        }
                      },
                      icon: Icon(
                        Icons.send,
                        color: Colors.black,
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
