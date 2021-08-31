import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

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
          accentColor: Colors.white,
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: _shadeColor,
                  radius: 35.0,
                  child: Text("shade", style: TextStyle(color: _textShadeColor, shadows: <Shadow>[
                  Shadow(
                  offset: Offset(0.3, 0.3),
                    blurRadius: 3.0,
                    color: _textShadeColor,
                  ),])),
                ),
              ],
            ),
            const SizedBox(height: 32.0),
            OutlinedButton(
              onPressed: _openColorPicker,
              child: const Text('choose background color'),
            ),
          ],
        ),
      ),// auto-formatting nicer for build methods.
    );
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
              child: Text('cancel'),
              onPressed: Navigator.of(context).pop,
            ),
            TextButton(
              child: Text('submit'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(()  {
                  _shadeColor = _tempShadeColor;
                  _textShadeColor = _shadeColor!.computeLuminance() > 0.5 ? Colors.black26.withOpacity(0.5) : Colors.white24.withOpacity(0.7);
                } );
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
