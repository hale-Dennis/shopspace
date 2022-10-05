import 'package:flutter/material.dart';
import 'package:shopspace/screens/product.dart';

import '../components/grid_card.dart';
import '../components/loader.dart';
import '../models/product.dart';
import '../utils/firestore.dart';
import 'edit_post.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  Future<List<Product>>? products;

  @override
  void initState(){
    super.initState();
    products = FirestoreUtil.getUserFavorites([]);
  }

  @override
  Widget build(BuildContext context) {
    onCardPress(Product product, String userid){
      //route to product screen
      Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductScreen(product: product, userid: userid, homeOrFave: 1,)));
    }
    return Scaffold(
      appBar: AppBar(title: const Text("Favourites"),),
      body: FutureBuilder<List<Product>>(future: products, builder: (context, AsyncSnapshot<List<Product>> snapshot){
        if(snapshot.hasData && snapshot.data != null){
          return GridView.builder(
              itemCount: snapshot.data?.length,
              padding: const EdgeInsets.symmetric(vertical: 30),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 15, crossAxisSpacing: 14),
              itemBuilder: (BuildContext context, int index){
                return
                    GridCard(
                        product: snapshot.data![index],
                        index: 0,
                        onPress: (){
                          onCardPress(snapshot.data![index], snapshot.data![index].userid.toString(),);
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
