import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:google_fonts/google_fonts.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(children: <Widget>[
        Center(
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
                        style:
                            TextStyle(color: _textShadeColor, shadows: <Shadow>[
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
      child: Padding(
        padding: const EdgeInsets.all(25),
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
            const SizedBox(height: 12.0),
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
                    // generateImage()
                  }
                });
              },
              child: const Text('generate image'),
            ),
            new LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              return getImage(constraints.maxWidth);
            }),
          ],
        ),
      ),
    );
  }

  Widget getImage(double maxWidth) {
    return new Container(
        color: _shadeColor,
        height: maxWidth,
        child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
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
                translation.isEmpty
                    ? Container()
                    : Row(
                        children: <Widget>[
                          const SizedBox(height: 12.0),
                          Flexible(
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
                                      ]))),
                        ],
                      ),
                author.isEmpty
                    ? Container()
                    : Row(
                        children: <Widget>[
                          const SizedBox(height: 12.0),
                          Flexible(
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
                                      ]))),
                        ],
                      )
              ],
            )));
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
              onPressed: Navigator.of(context).pop,
            ),
            TextButton(
              child: Text('submit', style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _shadeColor = _tempShadeColor;
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
