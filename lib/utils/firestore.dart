import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/cart.dart';

import '../models/product.dart';

class FirestoreUtil{
  static const String productCollection = 'product';
  static const String customerCollection = 'customers';
  static const String cartCollection = 'cart';

  //get id of current user
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static String getCurrentUserId(){
    final User? user = _auth.currentUser;
    final uid = user?.uid;
    print(uid);
    return uid.toString();
    //print(uemail);
  }
  //static var userId = getCurrentUserId();

  static Future<List<Product>> getUserProducts(List<String>? ids)async{
    try{
      final productRef = FirebaseFirestore.instance.collection('users')
          .doc(getCurrentUserId())
          .collection('properties')
          .doc('products')
          .collection('products posted')
          .withConverter<Product>(fromFirestore: (snapshot, _) =>Product.fromJson(snapshot.data()!) ,
          toFirestore: (product, _) => product.toJson());
      QuerySnapshot<Product> productDoc;
      if (ids != null && ids.isNotEmpty){
        productDoc = await productRef.where('id',whereIn: ids).get();
      }else {
        productDoc = await productRef.get();
      }
      return productDoc.docs.map((e)=> e.data()).toList();
    }on FirebaseException catch (e, stacktrace){
      log("Error getting products", stackTrace: stacktrace,  error: e);
    }
    return [];
  }

  static Future<List<Product>> getUserFavorites(List<String>? ids)async{
    try{
      final productRef = FirebaseFirestore.instance.collection('users')
          .doc(getCurrentUserId())
          .collection('properties')
          .doc('favorites')
          .collection('favorite products')
          .withConverter<Product>(fromFirestore: (snapshot, _) =>Product.fromJson(snapshot.data()!) ,
          toFirestore: (product, _) => product.toJson());
      QuerySnapshot<Product> productDoc;
      if (ids != null && ids.isNotEmpty){
        productDoc = await productRef.where('id',whereIn: ids).get();
      }else {
        productDoc = await productRef.get();
      }
      return productDoc.docs.map((e)=> e.data()).toList();
    }on FirebaseException catch (e, stacktrace){
      log("Error getting products", stackTrace: stacktrace,  error: e);
    }
    return [];
  }

  static Future<List<Product>> getProducts(List<String>? ids)async{
    try{
      final productRef = FirebaseFirestore.instance
          .collection(productCollection)
          .withConverter<Product>(fromFirestore: (snapshot, _) =>Product.fromJson(snapshot.data()!) ,
          toFirestore: (product, _) => product.toJson());
      QuerySnapshot<Product> productDoc;
      if (ids != null && ids.isNotEmpty){
        productDoc = await productRef.where('id',whereIn: ids).get();
      }else {
        productDoc = await productRef.get();
      }
      return productDoc.docs.map((e)=> e.data()).toList();
    }on FirebaseException catch (e, stacktrace){
      log("Error getting products", stackTrace: stacktrace,  error: e);
    }
    return [];
  }

  // static addToCart(User? user, String productId) async{
  //   if(user == null) return;
  //   try{
  //     DocumentReference<Map<String, dynamic>> product = FirebaseFirestore.instance
  //         .collection(customerCollection)
  //         .doc(user.uid)
  //         .collection(cartCollection)
  //         .doc(productId);
  //     if ((await product.get()).exists){
  //       product.update({"count": FieldValue.increment(1)});
  //     }else {
  //       product.set({"id": productId, "count": 1});
  //     }
  //   }on FirebaseException catch (e, stackTrace){
  //     log("Error adding to cart", stackTrace: stackTrace, error: e);
  //   }
  // }

  // static Future<List<Cart>> getCart(User? user)async {
  //   List<Cart> carts = [];
  //   try{
  //     final cartRef = await FirebaseFirestore.instance
  //         .collection(customerCollection)
  //         .doc(user?.uid)
  //         .collection(cartCollection)
  //         .get();
  //     List<String> productIds = [];
  //     for(var element in cartRef.docs){
  //       productIds.add(element['id']);
  //     }
  //     List<Product> products = await getProducts(productIds);
  //     for (var element in cartRef.docs){
  //       Product product = products.firstWhere((prod) => prod.id == element.id);
  //       var json = product.toJson();
  //       json['count'] = element['count'];
  //       carts.add(Cart.fromJson(json));
  //     }
  //   }on FirebaseException catch (e, stackTrace) {
  //     log("Error getting cart", stackTrace: stackTrace, error: e);
  //   }
  //   return carts;
  // }
  //
  // static double getCartTotal(List<Cart> carts){
  //   double total = 0;
  //   for(Cart cart in carts){
  //     total += cart.price + cart.count;
  //   }
  //   return total;
  // }
}