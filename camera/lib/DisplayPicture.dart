import 'dart:io';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'alert.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase/firebase_io.dart';
import 'package:firebase_core/firebase_core.dart';
import 'AddImage.dart';

class DisplayPicture extends StatelessWidget {
  DisplayPicture({Key key, this.image, this.context}) : super(key: key);
  final File image;
  final BuildContext context;

  uploadImage() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    if (image != null) {
      final fileName = basename(image.path);
      var firebaseStorageRef =
          FirebaseStorage.instance.ref().child('$fileName').putFile(image);

      firebaseStorageRef.then(
        (value) => print("Done: $value"),
      );
    } else {
      showAlert(
          bContext: context,
          title: "Error Uploading!",
          content: "Server Side Error.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 190.0,
              height: 190.0,
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                image: new DecorationImage(
                  fit: BoxFit.fill,
                  image: new FileImage(image),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(30),
              child: Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF00A1F1),
                      padding:
                          EdgeInsets.symmetric(vertical: 30, horizontal: 40),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    child: Text(
                      "Upload Image",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      uploadImage();
                      Route route = MaterialPageRoute(
                          builder: (BuildContext context) => const AddImage());
                      Navigator.push(context, route);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
