import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';

class ForgetScreen extends StatelessWidget {
  static const routeName = '/forgetScreen';
  String email;
  String newPassword;
  String oobCode;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reset Your password')),
      body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
        children: [
            TextField(
              decoration: InputDecoration(hintText: 'Email'),
              onChanged: (val) {
                email = val;
              },
            ),
            SizedBox(height: 20),
            FlatButton(
              //color: email!=null? Colors.blue : Colors.white,
              child: Text('Reset Password',
              style: TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                Provider.of<Auth>(context, listen: false)
                    .sendPasswordResetEmail(email).then((value) => showDialog(
          context: context, builder: (ctx) => AlertDialog(
            title: Text('Check your email'),
            content: Text('Password reset email has been sent'),
            actions: <Widget>[
              // FlatButton(onPressed: (){
              //   Navigator.of(ctx).pop(false);
              // }, child: Text('No')),
              FlatButton(onPressed: (){
                Navigator.of(ctx).pop();
              }, child: Text('Okey'))
            ],
          )
        ));
              },
            ),
        ],
      ),
          )),
    );
  }
}
