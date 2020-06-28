import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory document = await getApplicationDocumentsDirectory();
  Hive.init(document.path);
  await Hive.openBox<String>("friends");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: myExample(),
    );
  }
}

class myExample extends StatefulWidget {
  @override
  _myExampleState createState() => _myExampleState();
}

class _myExampleState extends State<myExample> {
  Box<String> friendsBox;

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    friendsBox = Hive.box<String>("friends");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: friendsBox.listenable(),
                builder: (context, Box<String> friends, _) {
                  return ListView.separated(
                      itemBuilder: (context, index) {
                        final key = friends.keys.toList()[index];
                        final value = friends.get(key);

                        return ListTile(
                          title: Text(
                            value,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 22),
                          ),
                          subtitle: Text(key,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18)),
                        );
                      },
                      separatorBuilder: (_, index) => Divider(),
                      itemCount: friends.keys.toList().length);
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    print("Şuan AddNew");
                    showDialog(
                        context: context,
                        builder: (_) {
                          return Dialog(
                            child: Container(
                                padding: EdgeInsets.all(32),
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        controller: _idController,
                                      ),
                                      SizedBox(height: 16),
                                      TextField(
                                        controller: _nameController,
                                      ),
                                      SizedBox(height: 16),
                                      FlatButton(
                                        child: Text("submit"),
                                        onPressed: () {
                                          final key = _idController.text;
                                          final value = _nameController.text;
                                          friendsBox.put(key, value);
                                          Navigator.pop(context);
                                        },
                                      )
                                    ])),
                          );
                        });
                  },
                  child: myButtons("AddNew"),
                ),
                GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return Dialog(
                            child: Container(
                                padding: EdgeInsets.all(32),
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        controller: _idController,
                                      ),
                                      SizedBox(height: 16),
                                      TextField(
                                        controller: _nameController,
                                      ),
                                      SizedBox(height: 16),
                                      FlatButton(
                                        child: Text("submit"),
                                        onPressed: () {
                                          final key = _idController.text;
                                          final value = _nameController.text;

                                          friendsBox.put(key, value);
                                          Navigator.pop(context);
                                        },
                                      )
                                    ])),
                          );
                        });
                  },
                  child: myButtons("Update"),
                ),
                GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return Dialog(
                            child: Container(
                                padding: EdgeInsets.all(32),
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        controller: _idController,
                                      ),
                                      SizedBox(height: 16),
                                      FlatButton(
                                        child: Text("submit"),
                                        onPressed: () {
                                          final key = _idController.text;
                                          friendsBox.delete(key);
                                          Navigator.pop(context);
                                        },
                                      )
                                    ])),
                          );
                        });
                  },
                  child: myButtons("Delete"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget myButtons(String name, {height = 60.0, width = 100.0}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          color: Colors.lightBlue, borderRadius: BorderRadius.circular(18)),
      child: Center(
        child: Text(
          name,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
