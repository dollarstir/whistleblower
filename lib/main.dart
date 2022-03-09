import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart' as path;
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import './home.dart';
import './dash.dart';

void main() async{ 
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await path.getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  await Hive.openBox("ugbox");
  

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.



  Widget checker() {
    var box = Hive.box('ugbox');
    // var firstTime = box.get("firstTime");
    var islogin = box.get("islog");

   if (islogin == "1") {
      return Dash();
    }

    return Home();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UG Whistle Blower',
      debugShowCheckedModeBanner: false,

      home: checker(),
    );
  }
}


