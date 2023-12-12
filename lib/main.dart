import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:random/component/datalist.dart';
import 'package:random/models/data_model.dart';
import 'package:random/providers/data_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DataProvider>(
          create: (context) => DataProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool list = false;
  String str = "";
  Future<void> _loadAnswer() async {
    String jsonString = await rootBundle.loadString('assets/answer.json');
    Map<String, dynamic> mod = json.decode(jsonString);

    String ans = mod['answer'][DateTime.now().second % 10];
    str = ans;
  }

  addDialog() {
    TextEditingController _new = TextEditingController();
    // TextField(
    //   controller: _new,
    //
    //   style: const TextStyle(fontSize: 20),
    // ),
    var dialog = CupertinoAlertDialog(
      title: const Text("說出你的願望吧"),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CupertinoTextField(controller: _new),
      ),
      actions: <Widget>[
        CupertinoButton(
          child: const Text("確認"),
          onPressed: () {
            DataModel model = DataModel(
              day: DateTime.now().day,
              month: DateTime.now().month,
              year: DateTime.now().year,
              content: _new.text,
              answer: str,
            );
            context.read<DataProvider>().insert.add(model);
            Navigator.pop(context);
            setState(() {});
          },
        ),
        CupertinoButton(
          child: const Text("返回"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
    showDialog(context: context, builder: (_) => dialog);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("籤詩來源自宋尚緯的噗文"),
        leading: IconButton(
          icon: const Icon(Icons.swap_horiz_sharp),
          onPressed: () {
            list = !list;
            setState(() {});
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            key: UniqueKey(),
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              list
                  ? const DataList()
                  : str != ""
                      ? Text(str)
                      : Text(
                          'Good Day',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addDialog();
          _loadAnswer();
        },
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
