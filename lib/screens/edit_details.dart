import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shopspace/screens/home.dart';
import '../components/loader.dart';
import '../utils/custome_theme.dart';
import '../main.dart';
import '../utils/storage_service.dart';
import '../models/product.dart';

class UpdateDetailScreen extends StatefulWidget {
  final Product product;
  const UpdateDetailScreen({Key? key, required this.product}) : super(key: key);

  @override
  State<UpdateDetailScreen> createState() => _UpdateDetailScreenState();
}

class _UpdateDetailScreenState extends State<UpdateDetailScreen> {
  final _title = TextEditingController();
  final _price = TextEditingController();
  final _description = TextEditingController();
  final _category = TextEditingController();
  bool notLoading = true;
  String _imageURL = '';
  bool loading = false;

  void getImage() async{

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
      final fileName = widget.product.title;

      print(path);
      print(fileName);

      await storage
          .uplaodFile(path!, fileName)
          .then((value) => print('Done'));

      _imageURL= await storage.downloadURL(fileName);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("image uploaded")),
      );
      print(_imageURL);
    }
  }


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
      appBar: AppBar(
        title: const Text('Update Details'),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: TextField(
                    controller: _title,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0))
                      ),
                      label: Text('Title'),
                      hintText: widget.product.title,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom:20.0),
                  child: TextField(
                    controller: _price,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0))
                      ),
                      label: Text('Price'),
                      hintText: widget.product.price.toString(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: TextField(
                    controller: _description,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0))
                      ),
                      label: Text('Description'),
                      hintText: widget.product.description,
                    ),
                    maxLines: 3,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: TextField(
                    controller: _category,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0))
                      ),
                      label: Text('Category'),
                      hintText: widget.product.category,
                    ),
                  ),
                ),
                ElevatedButton(onPressed: () async{
                  setState((){
                    loading = true;
                  });
                  getImage();

                  // final storage = FirebaseStorage.instanceFor(
                  //     bucket: 'gs://firstfirebase-37b96.appspot.com');
                  //
                  // //delete product image
                  // var photo = storage.refFromURL(widget.product.image);
                  // await photo.delete();
                  setState((){
                    loading = false;
                  });
                },//update image
                    style: ElevatedButton.styleFrom(primary: CustomTheme.yellow,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // <-- Radius
                      ),
                    ),
                    child: loading ? const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Loader(),
                    ) :  Text('update product image', style: Theme.of(context).textTheme.titleSmall,)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    notLoading ?
                    ElevatedButton(onPressed: () async {
                      setState((){
                        notLoading = false;
                      });
                      //double price = _price.text as double;
                      double? price = double.tryParse(_price.text);
                      Product update = Product(
                          _title.text.toString() == '' ? widget.product.title : _title.text.toString(),
                          _price.text.toString() == '' ? widget.product.price : price!,
                          widget.product.id,
                          _description.text.toString() == '' ? widget.product.description : _description.text.toString(),
                          _imageURL != '' ? _imageURL : widget.product.image,
                          _category.text.toString() == '' ? widget.product.category : _category.text.toString(),
                      );
                      if(_imageURL != ''){
                        final storage = FirebaseStorage.instanceFor(
                            bucket: 'gs://firstfirebase-37b96.appspot.com');

                        //delete product image
                        var photo = storage.refFromURL(widget.product.image);
                        await photo.delete();
                      }
                      final docUser = FirebaseFirestore.instance.collection('users').doc(getCurrentUserId()).collection('properties').doc('products').collection('products posted').doc(widget.product.id);
                      final allProducts = FirebaseFirestore.instance.collection('product').doc(widget.product.id);

                      await docUser.update({
                        'title': update.title,
                        'price': update.price,
                        'description': update.description,
                        'category' : update.category,
                        'image' : update.image,
                      });

                      await allProducts.update({
                        'title': update.title,
                        'price': update.price,
                        'description': update.description,
                        'category' : update.category,
                        'image' : update.image,
                      });

                      print("Done");
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const MyApp()), (route) => false);

                    },
                        style: ElevatedButton.styleFrom(primary: CustomTheme.yellow,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12), // <-- Radius
                          ),
                        ),
                        child: const Text('Save changes', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14), )) : CircularProgressIndicator(),
                    ElevatedButton(onPressed: (){
                      print(_title.text == '' ? "empty" : "got value");
                      print(_price.text.toString() == ''  ? "empty" : "got value");
                      print(_category.text == '' ? "empty" : "got value");
                      Navigator.pop(context);
                    },
                        style: ElevatedButton.styleFrom(primary: CustomTheme.yellow,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12), // <-- Radius
                          ),
                        ),
                        child: const Text('Discard changes', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14), )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
