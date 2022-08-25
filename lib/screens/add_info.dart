import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:zona/login/SignInScreen.dart';
import 'package:zona/screens/HomeScreen.dart';
import '../firebase_options.dart';

class AddInfo extends StatefulWidget {
  const AddInfo({Key? key}) : super(key: key);

  @override
  State<AddInfo> createState() => _AddInfoState();
}

class _AddInfoState extends State<AddInfo> {
  logout() async {
    await FirebaseAuth.instance.signOut();

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignInScreen()),
    );
  }

  Color primary = const Color(0xff41d9a5);

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1800, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  GlobalKey<FormState> key = GlobalKey();
  var _gender = [
    "Male",
    "Female",
  ];
  late final TextEditingController _username;
  late final TextEditingController _birthday;
  late final TextEditingController _Genger;
  late final TextEditingController _address;
  late final TextEditingController _Whatsapp;

  @override
  void initState() {
    _username = TextEditingController();
    _birthday = TextEditingController();
    _Genger = TextEditingController();
    _address = TextEditingController();
    _Whatsapp = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          foregroundColor: primary,
          backgroundColor: Colors.white,
          elevation: 0,
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  logout();
                },
                child: Icon(Icons.logout)),
          ]),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return Form(
            key: key,
            child: ListView(
              children: [
                const SizedBox(height: 25),
                const Padding(
                  padding: EdgeInsets.only(
                    left: 25,
                    right: 25,
                  ),
                  child: Text(
                    'register',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 28, fontFamily: 'Mulish'),
                  ),
                ),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                  child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Field Required';
                        } else {
                          return null;
                        }
                      },
                      controller: _username,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Color(0xffF6FFFC),
                        prefixIcon: Icon(Icons.account_circle_sharp),
                        enabledBorder: OutlineInputBorder(
                            // width: 0.0 produces a thin "hairline" border
                            borderSide: BorderSide(color: Colors.transparent, width: 0.0),
                            borderRadius: BorderRadius.all(Radius.circular(50))),
                        border:
                            OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
                        hintText: "User Name",
                      )),
                ),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Field Required';
                              } else {
                                return null;
                              }
                            },
                            readOnly: true,
                            onTap: () async {
                              await _selectDate(context);
                              _birthday.text = "${selectedDate.toLocal()}".split(' ')[0];
                            },
                            controller: _birthday,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Color(0xffF6FFFC),
                              prefixIcon: Icon(Icons.account_circle_sharp),
                              enabledBorder: OutlineInputBorder(

                                  // width: 0.0 produces a thin "hairline" border

                                  borderSide: BorderSide(color: Colors.transparent, width: 0.0),
                                  borderRadius: BorderRadius.all(Radius.circular(50))),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(50))),
                              hintText: "Birthday",
                            )),
                      ),
                      const SizedBox(width: 25),
                      Expanded(
                        child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Field Required';
                              } else {
                                return null;
                              }
                            },
                            readOnly: true,
                            controller: _Genger,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              suffixIcon: PopupMenuButton<String>(
                                icon: const Icon(Icons.arrow_drop_down),
                                onSelected: (String value) {
                                  _Genger.text = value;
                                },
                                itemBuilder: (BuildContext context) {
                                  return _gender.map<PopupMenuItem<String>>((String value) {
                                    return new PopupMenuItem(child: new Text(value), value: value);
                                  }).toList();
                                },
                              ),
                              filled: true,
                              fillColor: Color(0xffF6FFFC),
                              prefixIcon: Icon(Icons.account_circle_sharp),
                              enabledBorder: OutlineInputBorder(

                                  // width: 0.0 produces a thin "hairline" border

                                  borderSide: BorderSide(color: Colors.transparent, width: 0.0),
                                  borderRadius: BorderRadius.all(Radius.circular(50))),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(50))),
                              hintText: "Gender",
                            )),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                  child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Field Required';
                        } else {
                          return null;
                        }
                      },
                      controller: _address,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Color(0xffF6FFFC),
                        prefixIcon: Icon(Icons.account_circle_sharp),
                        enabledBorder: OutlineInputBorder(
                            // width: 0.0 produces a thin "hairline" border
                            borderSide: BorderSide(color: Colors.transparent, width: 0.0),
                            borderRadius: BorderRadius.all(Radius.circular(50))),
                        border:
                            OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
                        hintText: "Address",
                      )),
                ),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                  child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Field Required';
                        } else {
                          return null;
                        }
                      },
                      controller: _Whatsapp,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Color(0xffF6FFFC),
                        prefixIcon: Icon(Icons.account_circle_sharp),
                        enabledBorder: OutlineInputBorder(
                            // width: 0.0 produces a thin "hairline" border
                            borderSide: BorderSide(color: Colors.transparent, width: 0.0),
                            borderRadius: BorderRadius.all(Radius.circular(50))),
                        border:
                            OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
                        hintText: "WhatsApp Number",
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25, bottom: 25, right: 25, left: 25),
                  child: InkWell(
                      onTap: () async {
                        if (key.currentState!.validate()) {
                          try {
                            CollectionReference users =
                                FirebaseFirestore.instance.collection('users');
                            final FirebaseAuth auth = await FirebaseAuth.instance;

                            final User? user = auth.currentUser;
                            final uid = user?.uid;
                            final email = user?.email != null
                                ? user?.email
                                : "Created from facebook or Google";

                            print(
                                "TTTTTTTTTTTTTRRRRRRRRRRRRRRRTTTTTTTTTTTTRRRRRRRRRRRRRRRRTTTTTTTTTTTTTTTTTTRRRRRRRRRRRRRRRRRRTTTTTTTTTTTTT$email");
                            Future<void> addUser() {
                              // Call the user's CollectionReference to add a new user
                              return users.doc(uid).set({
                                'userid': uid,
                                'username': _username.text, // John Doe
                                'birthday': _birthday.text, // Stokes and Sons
                                'gender': _Genger.text, // 42
                                'address': _address.text,
                                'whatsapp': _Whatsapp.text,
                                'email': email
                              }).then((value) {
                                print("User Added");
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => HomeScreen()),
                                );
                                user?.updateDisplayName(_username.text);
                              }).catchError((error) => print("Failed to add user: $error"));
                            }

                            addUser();
                          } on FirebaseAuthException catch (e) {
                            showAlertDialog(BuildContext context) {
                              // set up the button
                              Widget okButton = TextButton(
                                child: const Text("OK"),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              );

                              // set up the AlertDialog
                              AlertDialog alert = AlertDialog(
                                title: const Text("Login Error"),
                                content: Text(e.code),
                                actions: [
                                  okButton,
                                ],
                              );

                              // show the dialog
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return alert;
                                },
                              );
                            }

                            showAlertDialog(context);
                          }
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 30, right: 30),
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        decoration:
                            BoxDecoration(color: primary, borderRadius: BorderRadius.circular(25)),
                        child: const Center(
                          child: Text(
                            'Complete Register',
                            style: TextStyle(
                                fontFamily: 'Mulish',
                                fontWeight: FontWeight.w900,
                                color: Colors.black),
                          ),
                        ),
                      )),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
