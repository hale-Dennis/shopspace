
class Users{
  String? uid;
  String? username;
  //String? imageUrl;

  Users();


  Map<String, dynamic> toJson() =>{'uid': uid,  'username': username};

  Users.fromSnapshot(snapshot)
  : uid = snapshot.data()['uid'],
    username = snapshot.data()['username'];
}