import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class CommonUtil {
  static const String apiUrl = 'my_ip_address';
  static const String stripeUserCreate = '/add/user';
  static const String checkout = "/checkout";

  static backendCall(User user, String endPoint)async{
    String token = await user.getIdToken();
    return http.post(Uri.parse(apiUrl + endPoint), headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer" + token,
    });
  }
}