import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kolekta/components/input.dart';
import 'package:kolekta/models/userModel.dart';
import 'package:kolekta/services/query.dart';
import 'package:provider/provider.dart';

class Schedule extends StatefulWidget {
  final date;
  final garbageType;
  Schedule({this.date, this.garbageType});

  @override
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  var date = TextEditingController();
  var _scaffold = GlobalKey<ScaffoldState>();
  var _form = GlobalKey<FormState>();
  var garbageTypes = ["Recyclable waste", "None recyclable waste"];
  var garbageType = "Recyclable waste";
  var hquery = Hquery();

  @override
  void initState() {
    if (widget.date == "") {
      var now = new DateTime.now();
      var dateNow = new DateTime(now.year, now.month, now.day);

      date.text = dateNow.toString().replaceAll(" 00:00:00.000", "");
    } else {
      date.text = widget.date;
      garbageType = widget.garbageType;
    }

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    date.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var widgetSize = size.width * 0.7;

    return Scaffold(
        key: _scaffold,
        appBar:
            AppBar(title: Text("Kolekta"), backgroundColor: Colors.green[500]),
        body: Container(
          width: size.width,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _form,
              child: Column(children: [
                GestureDetector(
                  child: disabledField(
                      controller: date,
                      validator: (v) {
                        if (v.length == 0) return "Please provide date";
                        return null;
                      },
                      icon: Icon(Icons.date_range),
                      hint: "Date"),
                  onTap: () {
                    showDatePicker(
                            context: context,
                            initialDate: date.text == ""
                                ? DateTime.now()
                                : DateTime.parse(date.text + " " + "00:00:00"),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2030))
                        .then((value) {
                      if (value != null) {
                        date.text = DateFormat('yyyy-MM-dd').format(value);
                      }
                    });
                  },
                ),
                SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                      border: Border.all(width: 1, color: Colors.grey[300])),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButton(
                      value: garbageType,
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 36,
                      elevation: 8,
                      onChanged: (newvalue) {
                        setState(() {
                          garbageType = newvalue;
                        });
                      },
                      items: garbageTypes
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Container(
                    width: double.infinity,
                    child: RaisedButton(
                        color: Colors.green[500],
                        onPressed: () async {
                          if (_form.currentState.validate()) {
                            _form.currentState.save();

                            var formData = {
                              "type": garbageType,
                              "date": date.text,
                              "status": "active"
                            };

                            var isExist = false;
                            var schedules = await hquery.getIDs("schedules");
                            var message = "";
                            var key = "";

                            for (var schedule in schedules) {
                              var sched = await hquery.getDataByID(
                                  "schedules", schedule);
                              if (sched['date'] == formData['date']) {
                                isExist = true;
                                key = schedule;
                              }
                            }

                            // Update schedule
                            if (isExist) {
                              await hquery.update(
                                  "schedules", key, {"type": formData['type']});
                              message = "Schedule successfuly updated !!";
                            }
                            // Push schedule
                            else {
                              await hquery.push("schedules", formData);
                              message = "New schedule successfuly added !!";
                            }

                            _scaffold.currentState.showSnackBar(SnackBar(
                              duration: Duration(seconds: 5),
                              content: Text(message,
                                  style: TextStyle(color: Colors.white)),
                            ));
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("SAVE",
                              style: TextStyle(color: Colors.white)),
                        )))
              ]),
            ),
          ),
        ));
  }
}
