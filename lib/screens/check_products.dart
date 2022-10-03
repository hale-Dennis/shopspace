import 'package:flutter/material.dart';
import 'package:shopspace/screens/edit_post.dart';

import '../components/grid_card.dart';
import '../components/loader.dart';
import '../models/product.dart';
import '../utils/firestore.dart';

class CheckProductScreen extends StatefulWidget {
  const CheckProductScreen({Key? key}) : super(key: key);

  @override
  State<CheckProductScreen> createState() => _CheckProductScreenState();
}

class _CheckProductScreenState extends State<CheckProductScreen> {
  Future<List<Product>>? products;

  @override
  void initState(){
    super.initState();
    products = FirestoreUtil.getUserProducts([]);
  }

  @override
  Widget build(BuildContext context) {
    onCardPress(Product product){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>EditPostScreen(product: product,)));
    }
    return Scaffold(
      appBar: AppBar(title: const Text("My Posts"),),
      body: FutureBuilder<List<Product>>(future: products, builder: (context, AsyncSnapshot<List<Product>> snapshot){
        if(snapshot.hasData && snapshot.data != null){
          return GridView.builder(
              itemCount: snapshot.data?.length,
              padding: const EdgeInsets.symmetric(vertical: 30),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 15, crossAxisSpacing: 14),
              itemBuilder: (BuildContext context, int index){
                return GridCard(
                    product: snapshot.data![index],
                    index: 0,
                    onPress: (){
                      onCardPress(snapshot.data![index]);
                    }
                );
              }
          );
        }else{
          return const Center(child: Loader());
        }
      }),
    );
  }
}
