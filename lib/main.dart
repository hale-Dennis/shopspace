// import 'dart:convert';
// import 'dart:js';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:shopspace/screens/checkout.dart';
import 'package:shopspace/screens/home.dart';
import 'package:shopspace/screens/login.dart';
import 'package:shopspace/screens/profile.dart';
import 'package:shopspace/screens/search_product.dart';
import 'package:shopspace/utils/application_state.dart';
import 'package:shopspace/utils/custome_theme.dart';

import 'chat/chat_screen.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // Replace with actual values
    options: FirebaseOptions(
      apiKey: "AIzaSyCYM695qYm07wB4yFDM63aktqT7t-DDORg",
      appId: "1:1007125331564:android:43ace576ec17c187cea249",
      messagingSenderId: "1007125331564",
      projectId: "firstfirebase-37b96",
    ),
  );

  //setup stripe
  /*final String response = await rootBundle.loadString("assets/config/stripe.json");
  final data = await json.decode(response);
  Stripe.publishableKey = data["publishableKey"];*/
  runApp(
    ChangeNotifierProvider(create: (context) => ApplicationState(), builder:
    (context, _) => Consumer<ApplicationState>(builder: (context, applicationState, child){
      Widget child;
      switch(applicationState.loginState){
        case ApplicationLoginState.loggedOut:
          child = const LoginScreen();
          //child = const StorageTestScreen();    //testing the profile screen
          break;
        case ApplicationLoginState.loggedIn:
          child = const MyApp();
          break;
        default:
          child = const LoginScreen();
      }

      return MaterialApp(theme: CustomTheme.getTheme(),home: child, debugShowCheckedModeBanner: false,);
    },), )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of application.
  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
        length: 3,
        //length: 4,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text("SHOPSPACE"),
            // actions: [
            //   IconButton(onPressed: (){
            //     showSearch(context: context, delegate: SearchProductScreen(hintText: "enter name"));
            //   }, icon: const Icon(Icons.search)),
            // ],
          ),
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(35), topRight: Radius.circular(35)),
              boxShadow: CustomTheme.cardShadow,
            ),
            child: const TabBar(padding: EdgeInsets.symmetric(vertical: 10),
                indicatorColor: Colors.transparent,
                tabs: [
              Tab(icon: Icon(Icons.home),),
              Tab(icon: Icon(Icons.person),),
              //Tab(icon: Icon(Icons.search),),
              Tab(icon: Icon(Icons.chat),),
            ]),
          ),
          body: const TabBarView(

            children: [
              HomeScreen(),
              ProfileScreen(),
              //CheckoutScreen(),
              ChatScreen(),
            ],
          ),
        ),
    );
  }
}



