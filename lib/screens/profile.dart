
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shopspace/components/profile_list_button.dart';
import 'package:shopspace/screens/add_product.dart';
import 'package:shopspace/screens/check_products.dart';

import 'package:shopspace/screens/search_product.dart';
import 'package:shopspace/screens/update_profile.dart';
import 'package:shopspace/screens/update_test.dart';

import '../components/custom_button.dart';

import '../utils/application_state.dart';
import 'favorites_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late DocumentSnapshot snapshot;
   String? profilePic;
   String? email;
   String? name;

  void getProfilePic()async{
    final data = await FirebaseFirestore.instance.collection('users').doc(getCurrentUserId()).collection('properties').doc('private information').get();
    snapshot = data;
    print(snapshot);
    print(snapshot['name'].toString());
    print(snapshot['location'].toString());
  }

  @override
  void initState(){
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (FirebaseAuth.instance.currentUser!.displayName == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('dfg')));
      } else {
        FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('properties')
            .doc('private information')
            .get()
            .then((DocumentSnapshot<Map<String, dynamic>> snapshot) {
          name = snapshot['name'];
          email = snapshot['user_email'];
          profilePic = snapshot['profilePic'];
        });
      }
    });
    super.initState();
  }


  bool _loadingButton = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String getCurrentUserId(){
    final User? user = _auth.currentUser;
    final uid = user?.uid;
    print(uid);
    return uid.toString();
    //print(uemail);
  }

  void signOutButtonPressed() {
    setState(() {
      _loadingButton = true;
    });
    Provider.of<ApplicationState>(context, listen: false).signOut();
  }
  


  @override
  Widget build(BuildContext context) {
    //getProfilePic();
    final currentUser = FirebaseAuth.instance.currentUser?.displayName;
    final currentEmail = FirebaseAuth.instance.currentUser?.email;
    print("name ${FirebaseAuth.instance.currentUser?.displayName}");
    return Center(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(30),
              child: Column(
                children: [
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'MY ACCOUNT',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0,0,0,20),
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.grey[200],
                          ),
                          //color: Colors.grey[200],
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(children: [
                                  CircleAvatar(
                                    radius: 40,
                                    backgroundColor: Theme.of(context).primaryColor,
                                    // child: CachedNetworkImage(
                                    //   fit: BoxFit.cover,
                                    //   imageUrl: snapshot['profilepic'].toString(),
                                    // ),
                                    child: Text(
                                      'J',
                                      style: TextStyle(fontSize: 50, color: Colors.white),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Container(
                                    height: 70,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Update Your Details',
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,),
                                        ),
                                        Text(
                                          currentUser!,
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14,),
                                        ),
                                        Text(
                                          currentEmail!,
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14,),
                                        ),
                                      ],
                                    ),
                                  ),
                                ]),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          right: 5.0,
                          top: 2.0,
                          child: IconButton(
                            icon: Icon(
                              Icons.edit_outlined,
                            ),
                            onPressed:(){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UpdateProfileScreen()));
                            } ,
                          ),
                        )
                      ],
                    ),
                  ),
                  ProfileListButton(icon: Icons.post_add, text: "Post Product/Service", onPress: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const AddProductScreen()));
                  }),
                  ProfileListButton(icon: Icons.image_search, text: "Check Posts", onPress: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const CheckProductScreen()));
                  }),
                  //navigate  to favorite screen
                  ProfileListButton(icon: Icons.help_center_outlined, text: "Favourites", onPress: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const FavoriteScreen()));
                  }),
                  ProfileListButton(icon: Icons.history, text: "Update Profile".toString(), onPress: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const UpdateTest()));
                  }),
                  //ProfileListButton(icon: Icons.settings, text: "Help & Support", onPress: (){}),
                  //ProfileListButton(icon: Icons.share, text: "Invite a friend", onPress: (){}),
                  ProfileListButton(icon: Icons.logout, text: "Log out", onPress: signOutButtonPressed),
                ],
              ),
            ),
          ),
        );
  }

}