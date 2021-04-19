import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kolekta/services/authentication.dart';
import 'package:kolekta/services/query.dart';

var hquery = Hquery();

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var auth = AuthenticationService(FirebaseAuth.instance);
  var defaultMessage = "No garbage collection scheduled for today.";
  var isNoCollector = true;
  var message = "";
  var type = "";

  @override
  void initState() {
    super.initState();
    checkCollection();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        child: Column(children: [
          Expanded(
              child: Container(
                  color: Colors.blue,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Positioned(
                          bottom: 0,
                          child: Container(
                            width: size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Text(
                                    "Kolekta",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 21,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ))),
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: isNoCollector
                      ? Text("$defaultMessage")
                      : Column(children: [
                          Text("Garbage type: $type",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 15),
                          Text(
                            "Message: $message",
                            style: TextStyle(),
                            textAlign: TextAlign.center,
                          )
                        ]))),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: Icon(Icons.logout),
        onPressed: () {
          showDialog(
              context: context,
              builder: (_) => new AlertDialog(
                    title: new Text("Kolekta"),
                    content: new Text("Do you really want to logout?"),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      FlatButton(
                        child: Text('Exit'),
                        onPressed: () async {
                          await auth.signOut();
                          Navigator.pushNamed(context, '/login');
                        },
                      )
                    ],
                  ));
        },
      ),
    );
  }

  Future checkCollection() async {
    var schedIDs = await hquery.getIDs("schedules");
    var now = new DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);

    for (var id in schedIDs) {
      var sched = await hquery.getDataByID("schedules", id);

      if (formattedDate == sched['date']) {
        isNoCollector = false;
        type = sched['type'];
        if (sched['status'] == "active") {
          message = "The garbage collection for this day is ongoing.";
        } else {
          message =
              "The sheduled garbage collection for this day has been cancelled.";
        }
        setState(() {});
      }
    }
  }
}
