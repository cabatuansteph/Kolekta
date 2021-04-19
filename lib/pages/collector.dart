import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kolekta/models/schedules.dart';
import 'package:kolekta/pages/schedule.dart';
import 'package:kolekta/services/authentication.dart';
import 'package:kolekta/services/query.dart';

var hquery = Hquery();

class Collector extends StatefulWidget {
  @override
  _CollectorState createState() => _CollectorState();
}

class _CollectorState extends State<Collector> {
  var auth = AuthenticationService(FirebaseAuth.instance);
  var _scaffold = GlobalKey<ScaffoldState>();

  List<String> tabs = ["Schedules", "Cancelled"];

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 50), () {
      _scaffold.currentState.showSnackBar(SnackBar(
        duration: Duration(seconds: 5),
        content: Text(
            "Warning: Only authorized user are allowed to view this page.",
            style: TextStyle(color: Colors.white)),
      ));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        key: _scaffold,
        appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.green[500],
            bottom: TabBar(
              isScrollable: true,
              indicatorColor: Colors.white,
              tabs: [
                for (final tab in tabs)
                  Container(
                    child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "$tab",
                          style: TextStyle(color: Colors.white),
                        )),
                  )
              ],
            ),
            title: Row(
              children: [
                Text("Kolekta"),
                Spacer(),
                GestureDetector(
                  child: Icon(Icons.logout),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (_) => new AlertDialog(
                              title: new Text("Kolekta"),
                              content:
                                  new Text("Do you really want to logout?"),
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
                )
              ],
            )),
        body: TabBarView(children: [
          StreamBuilder(
              stream: hquery.getSnap("schedules"),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var schedules = [];
                  var d = snapshot.data.documents;
                  var now = new DateTime.now();

                  for (var i in d) {
                    var schedDate = DateTime.parse(i['date']);
                    var diff = schedDate.difference(now).inDays;

                    if (i['status'] == "active" && diff >= 0) {
                      schedules.add(GarbageSchedule(
                          date: i['date'], type: i['type'], key: i.documentID));
                    }
                  }

                  return ListView.builder(
                    itemBuilder: (context, idx) {
                      return Card(
                          shape: Border(
                              left: BorderSide(
                                  width: 5.0, color: Colors.cyan[700])),
                          child: ListTile(
                            title: Row(children: [
                              Text("${schedules[idx].date}"),
                              Spacer(),
                              GestureDetector(
                                  onTap: () {
                                    var route = MaterialPageRoute(
                                        builder: (_) => Schedule(
                                            date: "${schedules[idx].date}",
                                            garbageType: "${schedules[idx].type}"));
                                    Navigator.push(context, route);
                                  },
                                  child: Icon(Icons.edit, color: Colors.blue)),
                              SizedBox(width: 8),
                              GestureDetector(
                                  onTap: () async {
                                    await hquery.update(
                                        "schedules",
                                        "${schedules[idx].key}",
                                        {"status": "cancelled"});
                                    _scaffold.currentState
                                        .showSnackBar(SnackBar(
                                      duration: Duration(seconds: 5),
                                      content: Text(
                                          "Schedule has been cancelled",
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ));
                                  },
                                  child: Icon(Icons.delete, color: Colors.red))
                            ]),
                            subtitle: Text("${schedules[idx].type}"),
                          ));
                    },
                    itemCount: schedules.length,
                  );
                } else {
                  return SizedBox();
                }
              }),
          StreamBuilder(
              stream: hquery.getSnap("schedules"),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var schedules = [];
                  var d = snapshot.data.documents;
                  var now = new DateTime.now();

                  for (var i in d) {
                    var schedDate = DateTime.parse(i['date']);
                    var diff = schedDate.difference(now).inDays;

                    if (i['status'] == "cancelled" && diff >= 0) {
                      schedules.add(GarbageSchedule(
                          date: i['date'], type: i['type'], key: i.documentID));
                    }
                  }

                  return ListView.builder(
                    itemBuilder: (context, idx) {
                      return Card(
                          shape: Border(
                              left: BorderSide(
                                  width: 5.0, color: Colors.red[700])),
                          child: ListTile(
                            title: Row(children: [
                              Text("${schedules[idx].date}"),
                              Spacer(),
                              GestureDetector(
                                  onTap: () async {
                                    await hquery.update(
                                        "schedules",
                                        "${schedules[idx].key}",
                                        {"status": "active"});
                                    _scaffold.currentState
                                        .showSnackBar(SnackBar(
                                      duration: Duration(seconds: 5),
                                      content: Text(
                                          "Schedule has been restored",
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ));
                                  },
                                  child:
                                      Icon(Icons.restore, color: Colors.blue))
                            ]),
                            subtitle: Text("${schedules[idx].type}"),
                          ));
                    },
                    itemCount: schedules.length,
                  );
                } else {
                  return SizedBox();
                }
              }),
        ]),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green[500],
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, "/schedule");
          },
        ),
      ),
    ));
  }
}
