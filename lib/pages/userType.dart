import 'package:flutter/material.dart';
import 'package:kolekta/models/userModel.dart';
import 'package:provider/provider.dart';

class UserType extends StatefulWidget {
  @override
  _UserTypeState createState() => _UserTypeState();
}

class _UserTypeState extends State<UserType> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userType = Provider.of<UserData>(context);
    var size = MediaQuery.of(context).size;
    var widgetSize = size.width * 0.7;

    return Scaffold(
        body: Container(
      width: size.width,
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [
              0.1,
              0.4,
              0.6,
              0.9
            ],
                colors: [
              Colors.white,
              Colors.lightBlue[100],
              Colors.lightBlue[200],
              Colors.lightBlue[300]
            ])),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: widgetSize,
                child: RaisedButton(
                  color: Colors.blue,
                  onPressed: () {
                    userType.setType("resident");
                    Navigator.pushNamed(context, "/register");
                  },
                  child:
                      Text("Resident", style: TextStyle(color: Colors.white)),
                ),
              ),
              Container(
                width: widgetSize,
                child: RaisedButton(
                  color: Colors.green,
                  onPressed: () {
                    userType.setType("collector");
                    Navigator.pushNamed(context, "/register");
                  },
                  child: Text("Garbage collector",
                      style: TextStyle(color: Colors.white)),
                ),
              )
            ]),
      ),
    ));
  }
}
