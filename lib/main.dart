import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:getwidget/getwidget.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.white,
        accentColor: Colors.black,
        scaffoldBackgroundColor: Colors.white,
        toggleableActiveColor: Colors.black,
        inputDecorationTheme: InputDecorationTheme(
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black.withOpacity(0.1)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          labelStyle: const TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      home: MyHomePage(title: 'QuoteImager'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Use temp variable to only update color when press dialog 'submit' button
  Color? _tempShadeColor;
  Color? _shadeColor = Colors.blue[800];
  Color _textShadeColor = Colors.black26;

  ScreenshotController screenshotController = ScreenshotController();

  int _counter = 0;

  final GlobalKey genKey = GlobalKey();


  @override
  void initState() {
    super.initState();

    _requestPermission();

  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  _read() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString("color") ?? "";
    if (value.isNotEmpty) {
      setState(() {
        _shadeColor = Color(int.parse(value));
      });
    }
  }

  _save(Color color) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("color", color.value.toString());
  }

  @override
  Widget build(BuildContext context) {
    _read();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(children: <Widget>[
        Center(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: _shadeColor,
                      radius: 32.0,
                      child: Text("text",
                          style: TextStyle(
                              color: _textShadeColor,
                              shadows: <Shadow>[
                                Shadow(
                                  offset: Offset(0.3, 0.3),
                                  blurRadius: 3.0,
                                  color: _textShadeColor,
                                ),
                              ])),
                    ),
                    const SizedBox(width: 16.0),
                    OutlinedButton(
                      onPressed: _openColorPicker,
                      child: const Text('choose color',
                          style: TextStyle(color: Colors.black)),
                    ),
                  ],
                ),
                getForm(),
              ],
            ),
          ),
        )
      ]), // auto-formatting nicer for build methods.
    );
  }

  String quote = "";
  String translation = "";
  String author = "";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget getForm() {
    final node = FocusScope.of(context);
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 12.0),
          TextFormField(
            keyboardType: TextInputType.multiline,
            maxLines: null,
            textInputAction: TextInputAction.newline,
            onEditingComplete: () => node.nextFocus(),
            decoration: const InputDecoration(
              labelText: 'quote',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'quote is required!';
              }
              quote = value;
              return null;
            },
          ),
          const SizedBox(height: 12.0),
          TextFormField(
            keyboardType: TextInputType.multiline,
            maxLines: null,
            textInputAction: TextInputAction.newline,
            onEditingComplete: () => node.nextFocus(),
            decoration: const InputDecoration(
              labelText: '(translation)',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                translation = "";
              } else {
                translation = value;
              }
              return null;
            },
          ),
          SizedBox(height: 12.0),
          TextFormField(
            keyboardType: TextInputType.multiline,
            maxLines: null,
            textInputAction: TextInputAction.done,
            onEditingComplete: () => node.nextFocus(),
            decoration: const InputDecoration(
              labelText: '(author)',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                author = "";
              } else {
                author = value;
              }
              return null;
            },
          ),
          const SizedBox(height: 12.0),
          Screenshot(
            controller: screenshotController,
            child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return getImage(constraints.maxWidth);
                }),
          ),
          const SizedBox(height: 12.0),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <
              Widget>[
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                primary: Colors.black,
              ),
              onPressed: () {
                setState(() {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content:
                        Text('image is being generated, please wait.')));
                  }
                });
              },
              child: const Text('generate preview'),
            ),
            SizedBox(width: 12.0),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                primary: Colors.black,
              ),
              onPressed: () {
                setState(() {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content:
                        Text('image is being downloaded, please wait.')));
                  }
                  screenshotController
                      .capture(delay: Duration(milliseconds: 10), pixelRatio: 6.0)
                      .then((capturedImage) async {
                    ImageGallerySaver.saveImage(capturedImage!, quality: 100);
                  }).catchError((onError) {
                    print(onError);
                  });
                });
              },
              child: const Text('download image'),
            )
          ]),
        ],
      ),
    );
  }

  Widget getImage(double maxWidth) {
    return Container(
        color: _shadeColor,
        height: maxWidth,
        width: maxWidth,
        child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(
                    child: Text(quote,
                        style: GoogleFonts.cormorantGaramond(
                            color: _textShadeColor,
                            shadows: <Shadow>[
                              Shadow(
                                offset: Offset(0.3, 0.3),
                                blurRadius: 3.0,
                                color: _textShadeColor,
                              )
                            ]))),
                const SizedBox(height: 24.0),
                translation.isEmpty
                    ? Container()
                    : Container(
                    child: Flexible(
                        child: Text(translation,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.cormorantGaramond(
                                color: _textShadeColor,
                                shadows: <Shadow>[
                                  Shadow(
                                    offset: Offset(0.3, 0.3),
                                    blurRadius: 3.0,
                                    color: _textShadeColor,
                                  )
                                ])))),
                const SizedBox(height: 24.0),
                author.isEmpty
                    ? Container()
                    : Container(
                    child: Flexible(
                        child: Text(author,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.cormorantGaramond(
                                color: _textShadeColor,
                                shadows: <Shadow>[
                                  Shadow(
                                    offset: Offset(0.3, 0.3),
                                    blurRadius: 3.0,
                                    color: _textShadeColor,
                                  )
                                ])))),
              ],
            )));
  }
  _requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();
  }


  void _openDialog(String title, Widget content) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(6.0),
          title: Text(title),
          content: content,
          actions: [
            TextButton(
              child: Text('cancel', style: TextStyle(color: Colors.black)),
              onPressed: Navigator
                  .of(context)
                  .pop,
            ),
            TextButton(
              child: Text('submit', style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _shadeColor = _tempShadeColor;
                  _save(_shadeColor!);
                  _textShadeColor = _shadeColor!.computeLuminance() > 0.5
                      ? Colors.black26.withOpacity(0.5)
                      : Colors.white24.withOpacity(0.8);
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _openColorPicker({bool isBackground = true}) async {
    _openDialog(
      "color menu",
      MaterialColorPicker(
        selectedColor: _shadeColor,
        onColorChange: (color) => setState(() => _tempShadeColor = color),
      ),
    );
  }

}
