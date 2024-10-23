// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   File? _image;
//   final picker = ImagePicker();

//   Future<void> getImageGallery() async {
//     final XFile? pickedFile = await picker.pickImage(
//       source: ImageSource.gallery,
//       imageQuality: 80,
//     );
//     setState(() {
//       if (pickedFile != null) {
//         _image = File(pickedFile.path);
//       } else {
//         print("No Image picked");
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             SizedBox(height: 20),
//             InkWell(
//               onTap: getImageGallery,
//               child: Container(
//                 height: 200,
//                 width: 300,
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.grey),
//                 ),
//                 child: _image != null
//                     ? Image.file(
//                         _image!.absolute,
//                         fit: BoxFit.cover,
//                       )
//                     : Center(
//                         child: Icon(
//                           Icons.add_photo_alternate_outlined,
//                           size: 30,
//                         ),
//                       ),
//               ),
//             ),
//             SizedBox(height: 20),
//             InkWell(
//               onTap: getImageGallery,
//               child: Container(
//                 padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
//                 decoration: BoxDecoration(
//                   color: Colors.grey,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Text(
//                   "Upload",
//                   style: TextStyle(color: Colors.white, fontSize: 16),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
