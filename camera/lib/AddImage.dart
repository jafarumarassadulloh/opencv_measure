import 'dart:io';
import 'alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'DisplayPicture.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:advanced_icon/advanced_icon.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class AddImage extends StatefulWidget {
  const AddImage({Key key}) : super(key: key);
  @override
  _AddImageState createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ActionImage(),
    );
  }
}

class ActionImage extends StatefulWidget {
  ActionImage({Key key}) : super(key: key);

  @override
  _ActionImageState createState() => _ActionImageState();
}

class _ActionImageState extends State<ActionImage> {
  FirebaseStorage storage = FirebaseStorage.instance;
  File _image;
  ImagePicker imagePicker = ImagePicker();
  _imageFromCamera() async {
    try {
      PickedFile capturedImage =
          await imagePicker.getImage(source: ImageSource.camera);
      final File imagePath = File(capturedImage.path);
      if (capturedImage == null) {
        showAlert(
            bContext: context,
            title: "Error choosing file",
            content: "No file was selected");
      } else {
        setState(() {
          _image = imagePath;
        });
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DisplayPicture(
                      image: _image,
                      context: context,
                    )));
      }
    } catch (e) {
      showAlert(
          bContext: context, title: "Error capturing image file", content: e);
    }
  }

  _imageFromGallery() async {
    PickedFile uploadedImage =
        await imagePicker.getImage(source: ImageSource.gallery);
    final File imagePath = File(uploadedImage.path);

    if (uploadedImage == null) {
      showAlert(
          bContext: context,
          title: "Error choosing file",
          content: "No file was selected");
    } else {
      setState(() {
        _image = imagePath;
      });
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DisplayPicture(
                    image: _image,
                    context: context,
                  )));
    }
  }

  // Retriew the uploaded images
  // This function is called when the app launches for the first time or when an image is uploaded or deleted
  Future<List<Map<String, dynamic>>> _loadImages() async {
    List<Map<String, dynamic>> files = [];

    final ListResult result = await storage.ref().listAll();
    final List<Reference> allFiles = result.items;

    await Future.forEach<Reference>(allFiles, (file) async {
      final String fileUrl = await file.getDownloadURL();
      final FullMetadata fileMeta = await file.getMetadata();
      files.add({
        "url": fileUrl,
        "path": file.fullPath,
        "uploaded_by": fileMeta.customMetadata['uploaded_by'] ?? 'Nobody',
        "description":
            fileMeta.customMetadata['description'] ?? 'No description'
      });
    });

    return files;
  }

  // Delete the selected image
  // This function is called when a trash icon is pressed
  Future<void> _delete(String ref) async {
    await storage.ref(ref).delete();
    // Rebuild the UI
    setState(() {});
  }

  bool typing = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: typing ? TextBox() : Text("Title"),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            color: Colors.black,
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.refresh_rounded),
            color: Colors.black,
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: <Widget>[
          Expanded(
            child: FutureBuilder(
                future: _loadImages(),
                builder: (context,
                    AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return ListView.builder(
                        itemCount: snapshot.data?.length ?? 0,
                        itemBuilder: (context, index) {
                          final Map<String, dynamic> image =
                              snapshot.data[index];

                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: ListTile(
                              dense: false,
                              leading: Image.network(image['url']),
                              title: Text(image['uploaded_by']),
                              subtitle: Text(image['description']),
                              trailing: IconButton(
                                onPressed: () => _delete(image['path']),
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          );
                        });
                  }
                }),
          ),
        ]),
      ),
      floatingActionButton: SpeedDial(
        // both default to 16
        buttonSize: Size(64.0, 64.0),
        elevation: 10,

        animatedIconTheme: IconThemeData(size: 50.0),
        // this is ignored if animatedIcon is non null
        icon: Icons.add,
        activeChild: AdvancedIcon(
          icon: Icons.cancel,
          size: 56, //change this icon as per your requirement.
          secondaryIcon: Icons.add, //change this icon as per your requirement.
          effect: AdvancedIconEffect.spin,
        ),
        visible: true,
        // If true user is forced to close dial manually
        // by tapping main button and overlay is not rendered.
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.grey,
        overlayOpacity: 0.5,
        onOpen: () => print('OPENING DIAL'),
        onClose: () => print('DIAL CLOSED'),
        tooltip: 'Speed Dial',
        heroTag: 'speed-dial-hero-tag',
        backgroundColor: Color(0xFF00A1F1),
        foregroundColor: Colors.white,
        shape: CircleBorder(),
        children: [
          SpeedDialChild(
              child: Icon(Icons.add_photo_alternate_rounded),
              backgroundColor: Color(0xFF00A1F1),
              foregroundColor: Colors.white,
              label: 'Open Image from Galery',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () => _imageFromGallery()),
          SpeedDialChild(
            child: Icon(Icons.add_a_photo_rounded),
            backgroundColor: Color(0xFF00A1F1),
            foregroundColor: Colors.white,
            label: 'Take a Photo',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () => _imageFromCamera(),
          ),
        ],
      ),
    );
  }
}

class TextBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      color: Colors.black,
      child: TextField(
        decoration:
            InputDecoration(border: InputBorder.none, hintText: 'Search'),
      ),
    );
  }
}
