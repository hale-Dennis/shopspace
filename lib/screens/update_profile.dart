import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shopspace/utils/eco_button.dart';
import 'package:shopspace/utils/ecotextfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/storage_service.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({Key? key}) : super(key: key);

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  // const UpdateProfileScreen({Key? key}) : super(key: key);
  String? profilePic;
  TextEditingController nameC = TextEditingController();
  TextEditingController phoneC = TextEditingController();
  TextEditingController dobC = TextEditingController();
  TextEditingController genderC = TextEditingController();
  TextEditingController instaC = TextEditingController();
  TextEditingController locationC = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String? downloadUrl;
  bool selection = false;


  // String? buttonText;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (FirebaseAuth.instance.currentUser!.displayName == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('please complete profile firstly')));
      } else {
        FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('properties')
            .doc('private information')
            .get()
            .then((DocumentSnapshot<Map<String, dynamic>> snapshot) {
          nameC.text = snapshot['name'];
          phoneC.text = snapshot['phone'];
          dobC.text = snapshot['dob'];
          instaC.text = snapshot['insta'];
          genderC.text = snapshot['gender'];
          locationC.text = snapshot['location'];
          profilePic = snapshot['profilePic'];
        });
      }
    });
    super.initState();
  }

  bool isSaving = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String getCurrentUserId(){
    final User? user = _auth.currentUser;
    final uid = user?.uid;
    print(uid);
    return uid.toString();
    //print(uemail);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Text(
                    "PROFILE",
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: profilePic == null
                          ? CircleAvatar(
                              radius: 70,
                              backgroundColor: Colors.deepPurple,
                              child: Image.asset(
                                'assets/images/add_pic.png',
                                height: 80,
                                width: 80,
                              ),
                            )
                          : profilePic!.contains('http')
                              ? CircleAvatar(
                                  radius: 70,
                                  backgroundImage: NetworkImage(profilePic!),
                                )
                              : CircleAvatar(
                                  radius: 70,
                                  backgroundImage:
                                      FileImage(File(profilePic!)),
                                ),
                    ),
                  ),
                  EcoTextField(
                    hintText: "enter complete name",
                    controller: nameC,
                    validate: (v) {
                      if (v!.isEmpty) {
                        return "should not be empty";
                      }
                      return null;
                    },
                  ),
                  EcoTextField(
                    hintText: "enter phone number",
                    controller: phoneC,
                    validate: (v) {
                      if (v!.isEmpty) {
                        return "should not be empty";
                      }
                      return null;
                    },
                  ),
                  EcoTextField(
                    hintText: "enter date of birth",
                    controller: dobC,
                    validate: (v) {
                      if (v!.isEmpty) {
                        return "should not be empty";
                      }
                      return null;
                    },
                  ),
                  EcoTextField(
                    hintText: "enter gender",
                    controller: genderC,
                    validate: (v) {
                      if (v!.isEmpty) {
                        return "should not be empty";
                      }
                      return null;
                    },
                  ),
                  EcoTextField(
                    hintText: "enter business instagram handle",
                    controller: instaC,
                    validate: (v) {
                      if (v!.isEmpty) {
                        return "should not be empty";
                      }
                      return null;
                    },
                  ),
                  EcoTextField(
                    hintText: "enter location",
                    controller: locationC,
                    validate: (v) {
                      if (v!.isEmpty) {
                        return "should not be empty";
                      }
                      return null;
                    },
                  ),
                  /*EcoButton(
                    title: nameC.text.isEmpty ? 'SAVE' : 'Update',
                    isLoginButton: true,
                    isLoading: isSaving,
                    onPress: () {
                      if (formKey.currentState!.validate()) {
                        SystemChannels.textInput.invokeMapMethod(
                            'TextInput.hide'); // hides keyboard
                        profilePic == null
                            ? ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('select profile pic')))
                            :     saveInfo();
                              // nameC.text.isEmpty
                            //     ? saveInfo()
                            //     : update();
                      }
                    },
                  ),*/
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: ElevatedButton(onPressed: ()async{
                      setState(() async{
                        profilePic = await getImage();
                      });

                    }, child: Text("upload profile image")),
                  ),
                  ElevatedButton(onPressed: (){
                    save();
                    Navigator.pop(context);
                  }, child: Text("Save details")),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  /*Future<String?> uploadImage(File filepath, String? reference) async {
    // try {
    //   final finalName =
    //       '${FirebaseAuth.instance.currentUser!.uid}${DateTime.now().second}';
    //   final Reference fbStorage =
    //       FirebaseStorage.instance.ref(reference).child(finalName);
    //   final UploadTask uploadTask = fbStorage.putFile(filepath);
    //   await uploadTask.whenComplete(() async {
    //     downloadUrl = await fbStorage.getDownloadURL();
    //   });
    //
    //   return downloadUrl;
    // } catch (e) {
    //   print(e.toString());
    //   return null;
    // }
    String _imageURL;
    final Storage storage = Storage();
    final results = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg'],
    );

    if (results == null){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No file selected")),
      );
    }else {
      final path = results?.files.single.path!;
      final fileName = getCurrentUserId() + "profile pic";

      print(path);
      print(fileName);

      await storage
          .uplaodFile(path!, fileName)
          .then((value) => print('Done'));

      _imageURL= await storage.downloadURL(fileName);
      print(_imageURL);
    }
  }*/

  Future getImage() async{
    final Storage storage = Storage();
    final results = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg'],
    );

    if (results == null){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No file selected")),
      );
    }else {
      final path = results?.files.single.path!;
      final fileName = getCurrentUserId() + "profile pic";

      print(path);
      print(fileName);

      await storage
          .uplaodFile(path!, fileName)
          .then((value) => print('Done'));

      downloadUrl = await storage.downloadURL(fileName);
      print(downloadUrl);
      return downloadUrl;
    }
  }

  void save() async{
    //profilePic = await getImage();
    final json = {
      'name': nameC.text,
      'phone': phoneC.text,
      'dob': dobC.text,
      'gender': genderC.text,
      'insta': instaC.text,
      'location': locationC.text,
      'profilePic': profilePic,
    };

    print(nameC.text);
    print(phoneC.text);
    final docUser =  await FirebaseFirestore.instance.collection('users').doc(getCurrentUserId()).collection('properties').doc('private information');
    await docUser.update(json);
  }

//   update() {
//     setState(() {
//       isSaving = true;
//     });
//     if (selection == true) {
//       uploadImage(File(profilePic!), 'profile').whenComplete(() {
//         Map<String, dynamic> data = {
//           'name': nameC.text,
//           'phone': phoneC.text,
//           'dob': dobC.text,
//           'gender': genderC.text,
//           'insta': instaC.text,
//           'location': locationC.text,
//           'profilePic': downloadUrl,
//         };
//         FirebaseFirestore.instance
//             .collection('users')
//             .doc(FirebaseAuth.instance.currentUser!.uid)
//             .update(data)
//             .whenComplete(() {
//           FirebaseAuth.instance.currentUser!.updateDisplayName(nameC.text);
//           setState(() {
//             isSaving = false;
//           });
//         });
//       });
//     } else {
//       Map<String, dynamic> data = {
//         'name': nameC.text,
//         'phone': phoneC.text,
//         'dob': dobC.text,
//         'gender': genderC.text,
//         'insta': instaC.text,
//         'location': locationC.text,
//         'profilePic': profilePic,
//       };
//       FirebaseFirestore.instance
//           .collection('users')
//           .doc(FirebaseAuth.instance.currentUser!.uid)
//           .update(data)
//           .whenComplete(() {
//         FirebaseAuth.instance.currentUser!.updateDisplayName(nameC.text);
//         setState(() {
//           isSaving = false;
//         });
//       });
//     }
//   }
//
//   saveInfo() async{
//     setState(() {
//       isSaving = true;
//     });
//     uploadImage(File(profilePic!), 'profile').whenComplete(() async {
//       final json = {
//         'name': nameC.text,
//         'phone': phoneC.text,
//         'dob': dobC.text,
//         'gender': genderC.text,
//         'insta': instaC.text,
//         'location': locationC.text,
//         'profilePic': downloadUrl,
//       };
//
//       print(nameC.text);
//       print(phoneC.text);
//       final docUser =  await FirebaseFirestore.instance.collection('users').doc(getCurrentUserId()).collection('properties').doc('private information');
//       await docUser.update(json);
//       // FirebaseFirestore.instance
//       //     .collection('users')
//       //     .doc(FirebaseAuth.instance.currentUser!.uid)
//       //     .collection('properties')
//       //     .doc('private information')
//       //     .set(data)
//       //     .whenComplete(() {
//       //   FirebaseAuth.instance.currentUser!.updateDisplayName(nameC.text);
//       //   setState(() {
//       //     isSaving = false;
//       //   });
//       // });
//     });
//   }
 }
