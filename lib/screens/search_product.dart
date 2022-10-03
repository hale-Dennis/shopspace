
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchProductScreen extends SearchDelegate{

  SearchProductScreen({
    required String hintText,
  }) : super(
    searchFieldLabel: hintText,
    keyboardType: TextInputType.text,
    textInputAction: TextInputAction.search,
  );


  CollectionReference _firebaseFirestore = FirebaseFirestore.instance.collection('product');
  @override
  List<Widget> buildActions(BuildContext context){
    return <Widget>[
      IconButton(
        icon: const Icon(Icons.close),
        onPressed: (){
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context){
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: (){
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget buildResults(BuildContext context){
    return StreamBuilder<QuerySnapshot>(
      stream: _firebaseFirestore.snapshots().asBroadcastStream(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        if(!snapshot.hasData){
          return const Center(child: CircularProgressIndicator());
        }else {
          if( snapshot.data!.docs.where((QueryDocumentSnapshot<Object?> element) => element['title']
              .toString().toLowerCase()
              .contains(query.toLowerCase()))
              .isEmpty){
            return const Center(child: Text("No product found"));
          }else {
            print(snapshot.data);
            return ListView(children: [
              ...snapshot.data!.docs.where((QueryDocumentSnapshot<Object?> element) => element['title']
                  .toString().toLowerCase()
                  .contains(query.toLowerCase()))
                  .map((QueryDocumentSnapshot<Object?> data){

                    print(data);

                  final String title = data.get('title');
                  final String image = data['image'];
                  final String price = data['price'].toString();

                return ListTile(
                  onTap: (){},
                  title: Text(title),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(image),
                  ),
                  subtitle: Text(price),
                );

              })
            ]
          );
            }
        }
      }
    );
  }

  @override
  Widget buildSuggestions(BuildContext context){
    return Center(
      child: Text("Search anything here"),
    );
  }
}