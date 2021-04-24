import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

class MyTranslatePage extends StatefulWidget{

  @override
  _MyTranslatePageState createState() => _MyTranslatePageState();
}

class _MyTranslatePageState extends State<MyTranslatePage> {
  TextEditingController textEditingController = TextEditingController();
  GoogleTranslator translator = new GoogleTranslator();

  var output;
  String dropdownValue;

  static const Map<String, String> lang = {
    "English": "en",
    "French": "fr",
    "Gujarati": "gu",
    "Hindi": "hi",
    "Tamil": "ta",
  };

  void trans() {
    translator
        .translate(textEditingController.text, to: "$dropdownValue")
        .then((value) {
      setState(() {
        output = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[700],
        appBar: AppBar(
          backgroundColor: Colors.grey[900],
          title: Text("Transify"),
          textTheme: TextTheme(
            title: TextStyle(fontSize: 30.0,fontWeight: FontWeight.bold,color: Colors.grey),
            //headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic)
          ),
        ),
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: TextFormField(
                style: TextStyle(fontSize: 24),
                controller: textEditingController,
                onTap: () {
                  trans();
                },
                decoration: InputDecoration(
                    labelText: 'Type Here\n',
                    labelStyle: TextStyle(fontSize: 20,color: Colors.black)),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("Select language for Translation : "),
                DropdownButton<String>(
                  value: dropdownValue,
                  icon: Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  //style: TextStyle(color: Colors.cyanAccent),
                  underline: Container(
                    height: 2,
                    color: Colors.cyan[500],
                  ),
                  onChanged: (String newValue) {
                    setState(() {
                      dropdownValue = newValue;
                      trans();
                    }
                    );
                  },

                  items: lang
                      .map((string, value) {
                    return MapEntry(
                      string,
                      DropdownMenuItem<String>(
                        value: value,
                        child: Text(string),
                      ),
                    );
                  }
                  )
                      .values
                      .toList(),
                ),
              ],
            ),
            SizedBox(height: 50),
            Text('Translated Text is : ',
              style: TextStyle(fontSize: 25.0,color: Colors.grey[400]),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              output == null ? "" : output.toString(),
              style: TextStyle(
                  fontSize: 25,color: Colors.grey[400]),
            ),
          ],
        )
    );
  }

}