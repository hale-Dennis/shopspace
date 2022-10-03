
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shopspace/components/profile_list_button.dart';
import 'package:shopspace/screens/add_product.dart';
import 'package:shopspace/screens/check_products.dart';
import 'package:shopspace/screens/favourite.dart';
import 'package:shopspace/screens/search_product.dart';
import 'package:shopspace/screens/update_profile.dart';

import '../components/custom_button.dart';

import '../utils/application_state.dart';
import 'favorites_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _loadingButton = false;

  void signOutButtonPressed() {
    setState(() {
      _loadingButton = true;
    });
    Provider.of<ApplicationState>(context, listen: false).signOut();
  }
  


  @override
  Widget build(BuildContext context) {
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
                                          'Test Test',
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14,),
                                        ),
                                        Text(
                                          'test@gmail.com',
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
                  ProfileListButton(icon: Icons.history, text: "Update Profile".toString(), onPress: (

                      ){}),
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