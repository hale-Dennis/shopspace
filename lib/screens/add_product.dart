import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../components/custom_button.dart';
import '../utils/storage_service.dart';
import '../models/product.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AddProductScreenState();
  }
}

class AddProductScreenState extends State<AddProductScreen> {
  late String _productName;
  late double _price;
  late String _description;
  late String _category;
  String _imageURL = '';
  bool isLoading =  true;
  bool notLoading = true;




  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildName() {
    return TextFormField(
      validator: (String? value){
        return (value != null && value.isEmpty ) ? 'Enter a title for the product/service' : null;
      },
      onSaved: (String? value){
        _productName = value!;
      },
      decoration: const InputDecoration(
        labelText: 'Name of Product/Service',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))
        ),
    ),
      maxLength: 10,
          );
  }

  Widget _buildPrice() {
    return TextFormField(
      keyboardType: TextInputType.number,
      validator: (String? value){
        return (value != null && value.isEmpty ) ? 'Enter price for the product/service' : null;
      },
      onSaved: (String? value){
        _price = double.parse(value!);
      },
      decoration: const InputDecoration(
          labelText: 'Price (\$)',
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))
        ),
      ),
    );
  }

  Widget _buildDescription() {
    return TextFormField(
      validator: (String? value){
        return (value != null && value.isEmpty ) ? 'Enter product/service description' : null;
      },
      onSaved: (String? value){
        _description = value!;
      },
      decoration: const InputDecoration(
          labelText: 'Description',
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))
        ),
      ),
      maxLength: 300,
      maxLines: 5,
    );
  }

  Widget _buildCategory() {
    return TextFormField(
      validator: (String? value){
        return (value != null && value.isEmpty ) ? 'Enter product/service category' : null;
      },
      onSaved: (String? value){
        _category = value!;
      },
      decoration: const InputDecoration(
          labelText: 'Category',
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))
        ),
      ),
      maxLength: 10,
    );
  }

  //close add product screen
  void _close(){
    Navigator.pop(context);
  }

  //get id of current user
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String getCurrentUserId(){
    final User? user = _auth.currentUser;
    final uid = user?.uid;
    print(uid);
    return uid.toString();
    //print(uemail);
  }

  //get email of current user
  String getCurrentUserEmail(){
    final User? user = _auth.currentUser;
    final uemail = user?.email;
    print(uemail);
    return uemail.toString();
    //print(uemail);
  }

  /*Future<String> getImage() async{
    _formKey.currentState?.save();
    final Storage storage = Storage();
    final results = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg'],
    );

    if (results == null){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No file selected")),
      );
      return "1";
    }

    final path = results.files.single.path!;
    final fileName = _productName;

    print(path);
    print(fileName);

    await storage
        .uplaodFile(path, fileName)
        .then((value) => print('Done'));

    String url = await storage.downloadURL(fileName);
    return url;
    print(url);
  }*/
  void getImage() async{
    _formKey.currentState?.save();
    final Storage storage = Storage();
    final results = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg'],
    );

    if (results == null){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No file selected")),
      );
    }else {
      final path = results?.files.single.path!;
      final fileName = _productName;

      print(path);
      print(fileName);

      await storage
          .uplaodFile(path!, fileName)
          .then((value) => print('Done'));

      _imageURL= await storage.downloadURL(fileName);
      print(_imageURL);
    }
  }

  //add product to database
  void addProduct() async{

    //_formKey.currentState?.save();
    //String image = 'https://images.unsplash.com/photo-1605170439002-90845e8c0137?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8OXx8cGhvbmVzfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60';
    if(_imageURL != null && _imageURL.isNotEmpty){
      setState((){
        isLoading = false;
      });
      DocumentSnapshot snapshot;
      var date = DateFormat('yyyy-MM-dd').format(DateTime.now());
      print(date);

      final docUser = FirebaseFirestore.instance.collection('users').doc(getCurrentUserId()).collection('properties').doc('products').collection('products posted').doc();
      final allProducts = FirebaseFirestore.instance.collection('product').doc(docUser.id);

      //getting username
      final data =  await FirebaseFirestore.instance.collection('users').doc(getCurrentUserId()).collection('properties').doc('private information').get();
      snapshot = data;
      print(snapshot);
      print(snapshot['name'].toString());


      final Product product = Product(_productName, _price, docUser.id, _description, _imageURL, _category,userid: getCurrentUserId(), views: 0, datePosted: date.toString(), location: 'location', username: snapshot['name'].toString(), );


      final json = {
        'category': product.category,
        'description' : product.description,
        'id' : product.id,
        'image' : product.image,
        'price' : product.price,
        'title' : product.title,
        'userid' : product.userid,
        'username' : product.username,
        'views' : product.views,
        'datePosted' : product.datePosted,
        'location' : product.location,
      };

      await docUser.set(json);
      await allProducts.set(json);
      // print(_productName);
      // print(_price);
      // print(_description);
      // print(_category);
      _close();
    }else if(_imageURL == ''){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Select image or wait for image to upload")),
      );
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Product/Service", style: TextStyle(fontSize: 14.0)),),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildName(),
                _buildPrice(),
                SizedBox(height: 15.0,),
                _buildDescription(),
                _buildCategory(),
                //add image button
                // ElevatedButton(onPressed: ()async{
                //   await _formKey.currentState?.validate() == true ? _imageURL = getImage() as String : print('input all fields');
                //      },
                //     child: Text("upload image")),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomButton( text: "upload image", onPress: ()async{
                    await _formKey.currentState?.validate() == true ? _imageURL = getImage() as String : print('input all fields');
                  },),
                ),

                SizedBox(height: 50),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                     isLoading ? CustomButton(text: "Add Product/Service", onPress: () async{
                        _formKey.currentState?.validate() == true ? addProduct() : print('input all fields');
                      },
                        loading: false,)
                         : Center(child: CircularProgressIndicator(),),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

