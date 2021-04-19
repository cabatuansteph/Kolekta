// import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kolekta/models/userModel.dart';
import 'package:kolekta/services/authentication.dart';
import 'package:kolekta/services/query.dart';
import 'package:provider/provider.dart';
// import 'package:uuid/uuid.dart';

class RegisterUser extends StatefulWidget {
  @override
  _RegisterUserState createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  TextEditingController nameController,
      emailController,
      fullAddressController,
      city,
      brangay,
      country,
      passwordController,
      confirmPasswordController,
      phoneController;
  final _formKey = GlobalKey<FormState>();
  String mess = '';

  // DatabaseReference _ref;

  bool obs = true;
  var hquery = Hquery();
  var auth = AuthenticationService(FirebaseAuth.instance);

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController();
    emailController = TextEditingController();
    fullAddressController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    phoneController = TextEditingController();

    // _ref = FirebaseDatabase.instance.reference().child('users');
  }

  Widget build(BuildContext context) {
    final userType = Provider.of<UserData>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text('Register'),
        ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: nameController,
                          onSaved: (value) {},
                          decoration: InputDecoration(
                            labelText: "Fullname",
                            icon: Icon(Icons.person),
                          ),
                          // The validator receives the text that the user has entered.
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please Enter Fullname';
                            }
                            return null;
                          },
                        ),

                        TextFormField(
                          controller: fullAddressController,
                          onSaved: (value) {},
                          decoration: InputDecoration(
                            labelText: "Full Address",
                            hintText: 'Full Address',
                            icon: Icon(Icons.location_on),
                          ),
                          // The validator receives the text that the user has entered.
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please Enter Address';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: phoneController,
                          onSaved: (value) {},
                          decoration: InputDecoration(
                            labelText: "Phone Number",
                            hintText: 'Phone Number',
                            icon: Icon(Icons.phone),
                          ),
                          // The validator receives the text that the user has entered.
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please Enter Phone Number';
                            }
                            return null;
                          },
                        ),

                        TextFormField(
                          controller: emailController,
                          onSaved: (value) {},
                          decoration: InputDecoration(
                            labelText: "Email",
                            hintText: 'Email',
                            icon: Icon(Icons.mail),
                          ),
                          // The validator receives the text that the user has entered.
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please Enter Email';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: passwordController,
                          onSaved: (value) {},
                          obscureText: obs,
                          decoration: InputDecoration(
                              labelText: "Password",
                              hintText: 'Password',
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
                          // The validator receives the text that the user has entered.
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please Enter Password';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: confirmPasswordController,
                          onSaved: (value) {},
                          obscureText: obs,
                          decoration: InputDecoration(
                              labelText: "Confirm-Password",
                              hintText: 'Confirm-Password',
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
                          // The validator receives the text that the user has entered.
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please Repeat Password';
                            }
                            return null;
                          },
                        ),
                        Text(
                          mess,
                          style: TextStyle(color: Colors.red, fontSize: 10),
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
                                'SIGN UP',
                                style: TextStyle(fontSize: 14),
                              ),
                              onPressed: () async{
                                if (_formKey.currentState.validate()) {
                                  // CheckNet().check(context);
                                  // var uuid = Uuid();
                                  String name = nameController.text;
                                  String email = emailController.text;
                                  String fulladdress =
                                      fullAddressController.text;
                                  String phone = phoneController.text;

                                  String password = passwordController.text;
                                  String cpassword =
                                      confirmPasswordController.text;
                                  bool checker = true;

                                  if (cpassword != password) {
                                    checker = false;

                                    showDialog(
                                        context: context,
                                        builder: (_) => new AlertDialog(
                                              title: new Text("Registration"),
                                              content: new Text(
                                                  "Password Doesnt Match!"),
                                              actions: <Widget>[
                                                FlatButton(
                                                  child: Text('Ok'),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ],
                                            ));
                                  }

                                  if (checker) {
                                    Map<String, String> user = {
                                      // 'id': uuid.v4(),
                                      'name': name,
                                      'email': email,
                                      'fulladdress': fulladdress,
                                      'phone': phone,
                                      'password': password,
                                      'type': userType.type,
                                      'status': 'alive'
                                    };
                                     
                                    // _ref.push().set(user);
                                    var result = await auth.signUp(
                                        email: email, password: password);

                                    if (result == "Signed up") {
                                      await hquery.push("users",
                                          user); // Save user data to database

                                      showDialog(
                                          context: context,
                                          builder: (_) => new AlertDialog(
                                                title: new Text("Registration"),
                                                content: new Text(
                                                    "You are Successfully Registered!"),
                                                actions: <Widget>[
                                                  FlatButton(
                                                    child: Text('Ok'),
                                                    onPressed: () {
                                                      Navigator.pushNamed(
                                                          context, '/login');
                                                    },
                                                  ),
                                                ],
                                              ));
                                    } else {
                                      showDialog(
                                          context: context,
                                          builder: (_) => new AlertDialog(
                                                title: new Text("Registration"),
                                                content: new Text(result),
                                                actions: <Widget>[
                                                  FlatButton(
                                                    child: Text('Ok'),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ],
                                              ));
                                    }
                                  }
                                }
                              },
                            )),
                        Container(
                            child: Row(
                          children: <Widget>[
                            FlatButton(
                              textColor: Colors.blue,
                              child: Text(
                                'LOGIN',
                                style: TextStyle(fontSize: 20),
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, '/login');
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
            )));
  }
} // choose file
