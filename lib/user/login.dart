// import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kolekta/models/userModel.dart';
import 'package:kolekta/services/authentication.dart';
import 'package:kolekta/services/query.dart';
import 'package:provider/provider.dart';
// import 'package:provider/provider.dart';

class LoginUser extends StatefulWidget {
  @override
  _LoginUserState createState() => _LoginUserState();
}

class _LoginUserState extends State<LoginUser> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  final _formKey = GlobalKey<FormState>();

  // final fb = FirebaseDatabase.instance
  //     .reference()
  //     .child("users")
  //     .orderByChild("status")
  //     .equalTo("alive");
  // List<UserModel> list = List();
  bool obs = true;
  var hquery = Hquery();
  var auth = AuthenticationService(FirebaseAuth.instance);

  @override
  void initState() {
    super.initState();

    // fb.once().then((DataSnapshot snap) {
    //   var data = snap.value;
    //   // list.clear();
    //   data.forEach((key, value) {
    //     // UserModel service = new UserModel(
    //     //     id: value['id'],
    //     //     name: value['name'],
    //     //     email: value['email'],
    //     //     password: value['password'],
    //     //     fulladdress: value['fulladdress'],
    //     //     phone: value['phone'],
    //     //     key: key);
    //     // print(key);
    //     // print('ok');
    //     // list.add(service);
    //   });
    //   setState(() {});
    // });
  }

  @override
  Widget build(BuildContext context) {
    final userType = Provider.of<UserData>(context);

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Garbage Notifier'),
        ),
        body: Container(
            padding: EdgeInsets.all(10),
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
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Container(
                  padding: EdgeInsets.all(10),
                  child: ListView(
                    children: <Widget>[
                      SizedBox(
                        height: 50,
                        width: 20,
                      ),

                      SizedBox(
                        height: 30,
                        width: 20,
                      ),
                      Form(
                        key: _formKey,
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                controller: emailController,
                                onSaved: (value) {},
                                decoration: InputDecoration(
                                  labelText: "Email",
                                  icon: Icon(Icons.person),
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please Enter Email';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 40,
                                width: 20,
                              ),
                              Container(),
                              TextFormField(
                                obscureText: obs,
                                controller: passwordController,
                                onSaved: (value) {},
                                decoration: InputDecoration(
                                    labelText: "Password",
                                    icon: Icon(Icons.security),
                                    suffixIcon: IconButton(
                                        icon: Icon(obs
                                            ? Icons.visibility
                                            : Icons.visibility_off),
                                        onPressed: () {
                                          setState(() {
                                            obs = !obs;
                                          });
                                        })),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please Enter Password';
                                  }
                                  return null;
                                },
                              ),

                              FlatButton(
                                onPressed: () {},
                                textColor: Colors.blue,
                                child: Text(
                                  'Forgot Password ?',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                              SizedBox(
                                height: 40,
                                width: 20,
                              ),

                              Container(
                                height: 50,
                                width: 300,
                                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: RaisedButton(
                                    textColor: Colors.white,
                                    color: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    child: Text(
                                      'LOGIN',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    onPressed: () async {
                                      if (_formKey.currentState.validate()) {
                                        // CheckNet().check(context);
                                        // bool forSnack = true;

                                        // for (int i = 0; i < list.length; i++) {
                                        //   if (passwordController.text ==
                                        //           list[i].password &&
                                        //       emailController.text ==
                                        //           list[i].email) {
                                        //     print("=====================");
                                        //     print(emailController.text);
                                        //     print(passwordController.text);

                                        //     print("=====================");
                                        //     print(list[i].email);
                                        //     print(list[i].password);

                                        //     print("=====================");

                                        //     Provider.of<UserProvider>(context,
                                        //             listen: false)
                                        //         .addItem(list[i]);

                                        //     Navigator.pushNamed(
                                        //         context, '/dashboard');
                                        //     forSnack = false;
                                        //   }
                                        // }
                                        var result = await auth.signIn(
                                            email: emailController.text,
                                            password: passwordController.text);

                                        if (result == "Signed in") {
                                          await userType.setupSavedData();
                                          if(userType.type == "resident"){
                                            Navigator.pushNamed(context, "/home");
                                          } else if(userType.type == "collector"){
                                            Navigator.pushNamed(context, "/collector");
                                          }
                                        } else {
                                          showDialog(
                                              context: context,
                                              builder: (_) => new AlertDialog(
                                                    title: new Text("Acount"),
                                                    content: new Text(result),
                                                    actions: <Widget>[
                                                      FlatButton(
                                                        child: Text('Ok'),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                      FlatButton(
                                                        child: Text('Register'),
                                                        onPressed: () {
                                                          Navigator.pushNamed(
                                                              context,
                                                              '/register');
                                                        },
                                                      )
                                                    ],
                                                  ));
                                        }
                                      }
                                    }),
                              ),
                              Container(
                                  child: Row(
                                children: <Widget>[
                                  FlatButton(
                                    color: Colors.white,
                                    textColor: Colors.blue,
                                    child: Text(
                                      'REGISTER',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/userType');
                                    },
                                  )
                                ],
                                mainAxisAlignment: MainAxisAlignment.center,
                              )),
//==========================================================
                            ],
                          ),
                        ),
                      ),

                      ///============================================================================
                    ],
                  )),
            )));
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
} // choose file
