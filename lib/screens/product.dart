import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopspace/chat/chat_details.dart';
import 'package:shopspace/components/custom_button.dart';
import 'package:shopspace/components/view_date.dart';

import '../models/product.dart';
import '../utils/application_state.dart';
import '../utils/custome_theme.dart';
import '../utils/firestore.dart';

class ProductScreen extends StatefulWidget {
  final Product product;
  final String userid;
  const ProductScreen({Key? key, required this.product, required this.userid}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {

  @override
  initState() {
    super.initState();
    itIsMe = getCurrentUserId() == widget.userid;
    print(getCurrentUserId());
    print(widget.userid);

    print(itIsMe);
  }

  bool addButtonLoad = false;
  late bool itIsMe;

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

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String getCurrentUserId(){
    final User? user = _auth.currentUser;
    final uid = user?.uid;
    return uid.toString();
    //print(uemail);
  }

  Future<String> productUserID() async {
    DocumentSnapshot snapshot;
    final data =  await FirebaseFirestore.instance.collection('product').doc(widget.product.id).get();
    snapshot = data;
    String uid = snapshot['userid'].toString();
    return uid;
  }

  void updateProductViews()async{
    int views;
    DocumentSnapshot snapshot;
    String vendorId = await productUserID();

    final dataVendor =  await FirebaseFirestore.instance.collection('users').doc(vendorId).collection('properties').doc('products').collection('products posted').doc(widget.product.id).get();
    snapshot = dataVendor;
    print(snapshot['views']);
    views = snapshot['views'] as int;
    views = views + 1;

    print(views);

    final docUser = FirebaseFirestore.instance.collection('users').doc(vendorId).collection('properties').doc('products').collection('products posted').doc(widget.product.id);
    final allProducts = FirebaseFirestore.instance.collection('product').doc(widget.product.id);

    final json = {

      'views' : views
    };

    //await docUser.set(json);
    await allProducts.update(json);
    await docUser.update(json);

  }

  void addToFavorites()async{
    final docUser = FirebaseFirestore.instance.collection('users').doc(getCurrentUserId()).collection('properties').doc('favorites').collection('favorite products').doc();

    final json = {
      'category': widget.product.category,
      'description' : widget.product.description,
      'id' : widget.product.id,
      'image' : widget.product.image,
      'price' : widget.product.price,
      'title' : widget.product.title,
      'userid' : widget.product.userid,
      'username' : widget.product.username,
      'views' : widget.product.views,
      'datePosted' : widget.product.datePosted,
      'location' : widget.product.location,
    };

    await docUser.set(json);
    setState((){
      addButtonLoad = false;
    });
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

                      // Positioned(
                      //   bottom: 0,
                      //   left: 10,
                      //   child: Container(
                      //     padding: EdgeInsets.all(8),
                      //     decoration: BoxDecoration(
                      //       shape: BoxShape.rectangle,
                      //       color: Color(0x26FFD847),//Color(0x40ffffff) ,
                      //       borderRadius: BorderRadius.all(Radius.circular(10)),
                      //     ),
                      //     height: 50,
                      //     width: 300,
                      //     child: ViewDate(date: widget.product.datePosted.toString(), views: widget.product.views),
                      //     /*child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //       children: [
                      //         SizedBox(
                      //           width: 50,
                      //           child: ListTile(
                      //               leading: Icon(Icons.timelapse),
                      //               title: Text("Posted:" + widget.product.datePosted.toString()),
                      //             ),
                      //         ),
                      //
                      //
                      //         // SizedBox(
                      //         //   width: 50,
                      //         //   child: ListTile(
                      //         //     leading: Icon(Icons.remove_red_eye_outlined),
                      //         //     title: Text("views" + widget.product.views.toString()),
                      //         //     ),
                      //         // ),
                      //
                      //       ],
                      //     ),*/
                      //   ),
                      // ),
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
                            child: Text(widget.product.title),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Row(
                              children: [
                                Text("PRICE: "), Text("\$" + widget.product.price.toString())
                              ],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8.0),

                            child: itIsMe ? SizedBox(height: 1,) : Column(
                              children: [
                                //message button
                                CustomButton(text: "Message Vendor",
                                  onPress: () async {
                                    updateProductViews();
                                    DocumentSnapshot snapshot;
                                    final data =  await FirebaseFirestore.instance.collection('product').doc(widget.product.id).get();
                                    snapshot = data;
                                    var uid = snapshot['userid'].toString();
                                    var name = snapshot['username'].toString();
                                    print("userid: $uid");
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=> ChatDetail(friendUid: uid, friendName: name,)));
                                  },
                                  loading: false,
                                ),
                                //add to cart button
                                SizedBox(height: 10,),
                                CustomButton(text: "Add to Favorites",
                                  onPress: (){
                                    setState(() {
                                      addButtonLoad = true;
                                    });
                                    //call add to favorites function
                                    addToFavorites();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text("Added to favorites")));

                                  },
                                  loading: addButtonLoad,
                                ),
                              ],
                            ),
                          ),

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

