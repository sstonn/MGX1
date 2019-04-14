import 'package:firebase_database/firebase_database.dart';

class user{
  String key;
  String name;
  String email;
  String password;
  String confirmpass;
  String userId;

  user(this.name,this.email,this.password,this.confirmpass,this.userId);

  user.fromSnapshot(DataSnapshot snapshot):
    key=snapshot.key,
    userId=snapshot.value["userId"],
    name=snapshot.value["name"],
    email=snapshot.value["email"],
    password=snapshot.value["password"],
    confirmpass=snapshot.value["confirmpass"];
  toJson(){
    return {
      "userId": userId,
      "name":name,
      "email":email,
      "password":password,
      "confirmpass":confirmpass,
    };
  }
}