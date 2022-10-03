import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopspace/components/loader.dart';
import 'package:shopspace/screens/checkout.dart';
import 'package:shopspace/screens/login.dart';
import 'package:shopspace/screens/product.dart';
import 'package:shopspace/screens/search_product.dart';

import '../components/grid_card.dart';
import '../models/product.dart';
import '../utils/custome_theme.dart';
import '../utils/firestore.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final data = ["1", "2"];
  Future<List<Product>>? products;

  @override
  void initState(){
    super.initState();
    products = FirestoreUtil.getProducts([]);
  }

  // Future<String> productUserID(String userid) async {
  //   DocumentSnapshot snapshot;
  //   final data =  await FirebaseFirestore.instance.collection('product').doc(userid).get();
  //   snapshot = data;
  //   String uid = snapshot['userid'].toString();
  //   return uid;
  // }

  @override
  Widget build(BuildContext context) {

    onCardPress(Product product, String userid){
      print("useridOncard: " + product.userid);
      print("title: " + product.title);
      Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductScreen(product: product, userid: userid)));
    }

    return Stack(
      children: [

        FutureBuilder<List<Product>>(future: products, builder: (context, AsyncSnapshot<List<Product>> snapshot){
        if(snapshot.hasData && snapshot.data != null){
          return GridView.builder(
              itemCount: snapshot.data?.length,
              padding: const EdgeInsets.symmetric(vertical: 30),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 15, crossAxisSpacing: 10),
              itemBuilder: (BuildContext context, int index){
                return GridCard(
                  product: snapshot.data![index],
                  index: 0,
                  onPress: (){
                    onCardPress(snapshot.data![index], snapshot.data![index].userid.toString());
                  }
                );
              }
          );
        }else{
          return const Center(child: Loader());
        }
      }),
        Positioned(
          top: 8,
          left: 20,
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0x80FFD847),
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            child:IconButton(
              icon: const Icon(Icons.search),
              color: Colors.black,
              onPressed: (){
                showSearch(context: context, delegate: SearchProductScreen(hintText:"enter name"));
              },
            ),
          ),
        ),
      ]
    );
  }
}
