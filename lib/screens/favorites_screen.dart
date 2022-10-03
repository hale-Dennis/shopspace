import 'package:flutter/material.dart';

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
    onCardPress(Product product){
      //route to product screen
      Navigator.push(context, MaterialPageRoute(builder: (context)=>EditPostScreen(product: product,)));
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
                return Column(
                  children: [
                    GridCard(
                        product: snapshot.data![index],
                        index: 0,
                        onPress: (){
                          onCardPress(snapshot.data![index]);
                        }
                    ),

                    IconButton(onPressed: (){}, icon: Icon(Icons.delete), tooltip: "Delete from favorites",),
                  ],
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
