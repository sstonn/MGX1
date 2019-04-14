import 'package:loginandsignup/pages/homeandothers/menu_screen.dart';
import 'package:loginandsignup/pages/homeandothers/other_screen.dart';
import 'package:loginandsignup/pages/homeandothers/restaurant_screen.dart';
import 'package:loginandsignup/pages/homeandothers/zoom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:loginandsignup/services/authentication.dart';
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.auth, this.userId, this.onSignedOut})
      : super(key: key);
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;
  @override
  State<StatefulWidget> createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool _isEmailVerified = false;
  @override
  void initState() {
    super.initState();

    _checkEmailVerification();
  }
  void _checkEmailVerification() async {
    _isEmailVerified = await widget.auth.isEmailVerified();
    if (!_isEmailVerified) {
      _showVerifyEmailSentDialog();
    }
  }
  void _resentVerifyEmail(){
    widget.auth.sendEmailVerification();
  }


  void _showVerifyEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.only(right: 16.0),
            height: 250,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(75),
                    bottomLeft: Radius.circular(75),
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10)
                )
            ),
            child: Row(
              children: <Widget>[
                SizedBox(width: 20.0),
                CircleAvatar(radius: 55, backgroundColor: Colors.grey.shade200, child: Image.asset('assets/email.png', width: 60,),),
                SizedBox(width: 20.0),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Vui lòng xác nhận tài khoản", style: TextStyle(fontFamily: "bebas-neue"),),
                      SizedBox(height: 10.0),
                      Flexible(
                        child: Text(
                          "Một email với đường link xác nhận tài khoản đã được gửi tới hòm thư của bạn, vui lòng kiểm tra hòm thư, trong trường hợp bạn chưa nhận được email xin vui lòng ấn 'Gửi lại'"
                          ,style: TextStyle(fontFamily: "bebas-neue"),),
                      ),
                      SizedBox(height: 10.0),
                      Row(children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                            child: Text("Bỏ qua"),
                            color: Colors.red,
                            colorBrightness: Brightness.dark,
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Expanded(
                          child: RaisedButton(
                            child: Text("Gửi lại"),
                            color: Color(0xFF212121),
                            colorBrightness: Brightness.dark,
                            onPressed: (){
                              _resentVerifyEmail();
                            },
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                          ),
                        ),
                      ],)
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
  @override
  void dispose() {
    super.dispose();
  }
  final menu = new Menu(
    items: [
      new MenuItem(
        id: 'restaurant',
        title: 'THE PADDOCK',
      ),
      new MenuItem(
        id: 'logout',
        title: 'LOG OUT',
      ),
    ],
  );

  var selectedMenuItemId = 'restaurant';
  var activeScreen = restaurantScreen;
  _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return new ZoomScaffold(
      menuScreen: new MenuScreen(
        menu: menu,
        selectedItemId: selectedMenuItemId,
        onMenuItemSelected: (String itemId) {
          selectedMenuItemId = itemId;
          switch(itemId){
            case 'restaurant':
              setState(() {
                activeScreen = restaurantScreen;
              });
              break;
            case 'logout':
              setState(() {
                _signOut();
              });
          }
        },
      ),
      contentScreen: activeScreen,
    );
  }
}