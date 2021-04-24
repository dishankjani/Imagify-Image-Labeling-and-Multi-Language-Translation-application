import 'dart:io';
//import 'package:translator/translator.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'translate.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Imagify',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Imagifier(),
    );
  }
}

class Imagifier extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[700],
        appBar: AppBar(
          backgroundColor: Colors.grey[900],
        title: Text('Imagifier: Language Translation & Image Labeling'),
          //centerTitle: true,
          textTheme: TextTheme(
            title: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold,color: Colors.grey),
            //headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic)
          ),
    ),
body: Center(

    child: Container(

      padding: EdgeInsets.fromLTRB(10, 20, 20, 20),


      child: Column(
          children: <Widget>[

            Image(image: NetworkImage('https://cdn.magecube.com/pub/media/catalog/product//l/g/lgo-mag-lng-05-a_website.png'),height: 350,width: 350),
            Padding(padding: EdgeInsets.fromLTRB(10, 10, 20, 10)),
       ElevatedButton(

      child: Text('Image Labeler'),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage()),
        );
      },
         style: ElevatedButton.styleFrom(
           shape: new RoundedRectangleBorder(
             borderRadius: new BorderRadius.circular(20.0),
           ),
         ),

         //style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey)),

       ),
            Padding(padding: EdgeInsets.fromLTRB(10, 20, 20, 20)),



             ElevatedButton(
child: Text('Multi Language Translator'),
        onPressed: (){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyTranslatePage()),
      );
    },


              style: ElevatedButton.styleFrom(
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(20.0),
                ),
              ),

              //style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey)),
    ),

    ],
      ),

    ),
),
    );
  }
}


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final picker = ImagePicker();

  File _image;
  List<ImageLabel> _labels;

  Future<void> _getImageAndDetectLabels() async {

    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File image = File(pickedFile.path);

      final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(image);
      final ImageLabeler labeler = FirebaseVision.instance.imageLabeler();
      final List<ImageLabel> labels = await labeler.processImage(visionImage);

      setState(() {
        _image = image;
        _labels = labels;
      });
    }
  }

  Future<void> pickImage() async {

    final pickedFile = await picker.getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      File image = File(pickedFile.path);

      final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(image);
      final ImageLabeler labeler = FirebaseVision.instance.imageLabeler();
      final List<ImageLabel> labels = await labeler.processImage(visionImage);

      setState(() {
        _image = image;
        _labels = labels;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[700],
      //backgroundColor: Colors.grey[850],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text('Welcome to Imagify'),
        textTheme: TextTheme(
          title: TextStyle(fontSize: 30.0,fontWeight: FontWeight.bold,color: Colors.grey),
          //headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic)
        ),

      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            (_image == null || _labels == null)
                ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Capture or insert image',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18.0,color: Colors.grey[400]),
                ),
              ],
            )
                : Column(
              children: [
                Image.file(
                  _image,
                  height: 170.0,
                ),
                SizedBox(height: 16.0),
                Text(
                  'Detected Objects in the image are : \n',
                  style: TextStyle(fontSize: 18.0,color: Colors.grey[400]),
                ),
                SizedBox(height: 8.0),
                Text(
                  _labels
                      .map((label) => 'Detected Object : ${label.text} '
                      '  : ${label.confidence.toStringAsFixed(2)} ')
                      .join('\n'),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15.0,color: Colors.grey[400]),
                ),
                SizedBox(height: 16.0),
                Text('Insert or capture new image :',
                    style: TextStyle(fontSize: 15.0,color: Colors.grey[400]),
                ),

              ],
            ),
            SizedBox(height: 16.0),

            RaisedButton(
              onPressed: _getImageAndDetectLabels,
              child: Icon(
                Icons.add_photo_alternate,
              ),
              //backgroundColor: Colors.blue[500],
            ),

            RaisedButton(
              onPressed: pickImage,
              child: Icon(
                Icons.add_a_photo,
              ),

            ),

          ],

          


        ),


      ),




    );
  }
}










