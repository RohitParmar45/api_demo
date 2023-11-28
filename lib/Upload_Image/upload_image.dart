import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:http/http.dart' as http;

class UploadImage extends StatefulWidget {
  UploadImage({super.key});

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  File? image;

  final _picker = ImagePicker();

  bool showSpinner = false;

  Future getImage() async {
    final pickedFile =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

    if (pickedFile != null) {
      image = File(pickedFile.path);
      setState(() {
        showSpinner = false;
      });
    } else {
      print("no image selected");
    }
  }

  Future<void> uploadImage() async {
    setState(() {
      showSpinner = true;
    });
    var stream = http.ByteStream(image!.openRead());
    stream.cast();

    var length = await image!.length();
    var uri = Uri.parse("https://fakestoreapi.com/products");
    var request = http.MultipartRequest('POST', uri);
    request.fields['title'] = "static title";

    var multipart = http.MultipartFile('image', stream, length);
    request.files.add(multipart);
    var response = await request.send();

    if (response.statusCode == 200) {
      setState(() {
        showSpinner = false;
      });
      print('image uploaded ' + response.stream.toString());
    } else {
      setState(() {
        showSpinner = false;
      });
      print("failed " + response.statusCode.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Upload Image'),
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    getImage();
                  },
                  child: Container(
                      child: image == null
                          ? const Center(
                              child: Text("Pick Image"),
                            )
                          : Container(
                              child: Center(
                                  child: Image.file(
                                File(image!.path).absolute,
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              )),
                            )),
                ),
                SizedBox(
                  height: 23,
                ),
                GestureDetector(
                  onTap: () {
                    uploadImage();
                  },
                  child: Container(
                    width: 100,
                    height: 50,
                    color: Colors.green,
                    child: Center(
                      child: Text(
                        'Upload Image',
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


/**
 * Get Image 
      - create ImagePicker object 
      - pickImage source and reference it to file
      - file set absolute path
      - 
 */

/**
 * Upload Image 
      - convert Image to byteStream if its open to read
      - cast the Stream
      - create MultipartRequest or MultipartFile object
         * having parameter ('POST' Uri )  & ('Image', Stream, Length) respectively
         * add fields( like 'title' , multiparts) accordingly
         * and send finally

 */

