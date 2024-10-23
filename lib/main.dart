import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:your_app_name/hivedatabase.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox("Box");
  runApp(const MyApp());
}
 
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, home: HiveDatabaseFlutter());
  }
}

// import 'package:flutter/material.dart';
// import 'package:your_app_name/homeScreen.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: "Image picker app",
//       theme: ThemeData(
//         primarySwatch: Colors.indigo,
//       ),
//       home: HomeScreen(),
//     );
//   }
// }
