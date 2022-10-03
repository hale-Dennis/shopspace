// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shopspace/components/custom_button.dart';
//
// import '../components/list_card.dart';
// import '../components/loader.dart';
// import '../models/cart.dart';
// import '../utils/application_state.dart';
// import '../utils/custome_theme.dart';
// import '../utils/firestore.dart';
//
// class CheckoutScreen extends StatefulWidget {
//   const CheckoutScreen({Key? key}) : super(key: key);
//
//   @override
//   State<CheckoutScreen> createState() => _CheckoutScreenState();
// }
//
// class _CheckoutScreenState extends State<CheckoutScreen> {
//   //final carts = ["1", "2"];
//   Future<List<Cart>>? carts;
//   bool _checkoutButtonLoading = false;
//
//   @override
//   void initState(){
//     super.initState();
//     carts = FirestoreUtil.getCart(Provider.of<ApplicationState>(context, listen: false).user);
//   }
//
//   void checkout()async{
//     setState((){
//       _checkoutButtonLoading = true;
//     });
//
//     //chekout flow
//     setState((){
//       _checkoutButtonLoading = false;
//     });
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<Cart>>(
//       future: carts,
//       builder: (context, AsyncSnapshot<List<Cart>> snapshot){
//         if(snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty){
//           return SingleChildScrollView(
//             child: Column(
//               children: [
//                 ListView.builder(
//                   scrollDirection: Axis.vertical,
//                   shrinkWrap: true,
//                   physics: NeverScrollableScrollPhysics(),
//                   padding: EdgeInsets.symmetric(vertical: 30),
//                   itemCount: snapshot.data!.length,
//                   itemBuilder: (context, index){
//                     return ListCard(cart: snapshot.data![index]);
//                   },
//                 ),
//                 priceFooter(snapshot.data!),
//                 Container(
//                   padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
//                   child: CustomButton(
//                     text: "CHECKOUT",
//                     onPress: checkout,
//                     loading: false,
//                   ),
//                 ),
//
//               ],
//             ),
//           );
//         }else if(snapshot.data!= null && snapshot.data!.isEmpty){
//           return const Center(
//             child: Icon(
//               Icons.add_shopping_cart_sharp,
//               color: CustomTheme.yellow,
//               size: 150,
//             ),
//           );
//         }
//         return  Center(child: Loader());
//       }
//     );
//   }
//   priceFooter(List<Cart> carts){
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 30),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Divider(
//             height: 2,
//             color: CustomTheme.grey,
//             thickness: 2,
//           ),
//           Padding(padding: const EdgeInsets.only(top: 20),
//           child: Row(
//             children: [
//               Text("Total: ", style: Theme.of(context).textTheme.headlineSmall,),
//               const Spacer(),
//               Text("\$ " + FirestoreUtil.getCartTotal(carts).toString()
//                   , style: Theme.of(context).textTheme.headlineSmall),
//             ],
//           ),
//           ),
//       ],
//       ) ,
//     );
//
//   }
// }
