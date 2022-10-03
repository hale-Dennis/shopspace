import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopspace/components/custom_button.dart';
import 'package:shopspace/screens/edit_details.dart';
import '../main.dart';
import '../utils/storage_service.dart';

import '../models/product.dart';
import '../utils/application_state.dart';
import '../utils/custome_theme.dart';
import '../utils/firestore.dart';

class EditPostScreen extends StatefulWidget {
  final Product product;

  const EditPostScreen({Key? key, required this.product}) : super(key: key);

  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  // bool addButtonLoad = false;
  //
  // void onAddToCart() async{
  //   setState((){
  //     addButtonLoad = true;
  //   });
  //
  //   await FirestoreUtil.addToCart(Provider.of<ApplicationState>(context, listen: false).user, widget.product.id);
  //   setState((){
  //     addButtonLoad = false;
  //   });
  // }
  bool notLoading = true;
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
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        height: 500,
                        width: double.infinity,
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: widget.product.image,
                        ),
                      ),
                      Positioned(
                        top: 35,
                        right: 35,
                        child: Container(
                          decoration: const ShapeDecoration(
                            color: CustomTheme.yellow,
                            shape: CircleBorder(),
                            shadows: [BoxShadow(color: CustomTheme.grey, blurRadius: 3, offset: Offset(1,3))],
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.share),
                            onPressed: (){},
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: DefaultTextStyle(
                      style: Theme.of(context).textTheme.headlineLarge!,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 22),
                              child: Text(widget.product.title.toUpperCase()),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Row(
                                children: [
                                  Text("Price: "), Text("\$" + widget.product.price.toString())
                                ],
                              ),
                            ),
                            // CustomButton(text: "Add to Cart",
                            //   onPress: onAddToCart,
                            //   loading: addButtonLoad,
                            // ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Text(
                                "About the items",
                                style: Theme.of(context).textTheme.headlineMedium,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Text(widget.product.description, style: Theme.of(context).textTheme.bodySmall),
                            ),
                          ]
                      ),
                    ),
                  ),
                  //insert edit and delete button
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(onPressed: () async {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> UpdateDetailScreen(product: widget.product,)));

                        },
                            style: ElevatedButton.styleFrom(primary: CustomTheme.yellow,
                            shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12), // <-- Radius
                          ),
                        ),
                            child: Text("Update Product",
                              style: Theme.of(context).textTheme.titleSmall,),
                        ),
                        notLoading ?
                        ElevatedButton(onPressed: () async{
                          setState((){
                            notLoading =  false;
                          });
                          final _storage = FirebaseStorage.instanceFor(
                              bucket: 'gs://firstfirebase-37b96.appspot.com');


                          final docUser = FirebaseFirestore.instance.collection('users').doc(getCurrentUserId()).collection('properties').doc('products').collection('products posted').doc(widget.product.id);
                          final allProducts = FirebaseFirestore.instance.collection('product').doc(widget.product.id);

                          await docUser.delete();
                          await allProducts.delete();
                          //delete product image
                          var photo = _storage.refFromURL(widget.product.image);
                          await photo.delete();
                          //route user back to home screen
                          print("Done");
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const MyApp()), (route) => false);
                        },
                          style: ElevatedButton.styleFrom(primary: CustomTheme.yellow,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12), // <-- Radius
                          ),
                        ),
                          child: Text("Delete Product",
                            style: Theme.of(context).textTheme.titleSmall,), ) : CircularProgressIndicator(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 35,
              left: 30,
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    boxShadow: [BoxShadow(blurRadius: 3, offset: Offset(1, 3), color: CustomTheme.grey)]
                ),
                child:IconButton(
                  icon: const Icon(Icons.arrow_back),
                  color: Colors.black,
                  onPressed: (){
                    Navigator.of(context).pop(true);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

