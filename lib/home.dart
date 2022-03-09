import 'package:flutter/material.dart';
import './home.dart';
import './register.dart';
import './api.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import './dash.dart';

class Home extends StatefulWidget {
  // name({Key key}) : super(key: key);

  LoginState createState() => LoginState();
}

class LoginState extends State<Home> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  var uname = '';
  var studid = '';
  var upas = '';
  var uid = '';
  var mess = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              child: Container(
                child: Image.asset(
                  'assets/images/logo1.png',
                ),
                width: 150,
                height: 150,
              ),
            ),

            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.all(Radius.circular(10)),
            // ),
            // color: Colors.blue,
          ),
          Expanded(
            flex: 2,
            child: Container(
              child: ListView(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 10),
                    child: Column(
                      children: [
                        Container(
                          child: TextField(
                            // obscureText: true,
                            controller: emailController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Student ID",
                              fillColor: Colors.amberAccent,
                            ),

                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          width: 250,
                          height: 40,
                          margin: EdgeInsets.only(
                            top: 20,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          child: TextField(
                            // obscureText: true,
                            controller: passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Password',
                              fillColor: Colors.amberAccent,
                            ),

                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          width: 250,
                          height: 40,
                          margin: EdgeInsets.only(
                            top: 20,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          child: RaisedButton(
                            onPressed: () async {
                              var resp = await login(emailController.text,
                                  passwordController.text);
                              print(resp);
                              if (resp == "enter student id") {
                                print(resp);
                                mess = "enter valid student id";
                              } else if (resp ==
                                  "Please enter correct password") {
                                print(resp);
                                setState(() {
                                  mess = "enter valid password";
                                });
                              } else if (resp == "wrong") {
                                print(resp);
                                setState(() {
                                  mess = "Wrong login details";
                                });
                              } else {
                                setState(() {
                                  uname = resp[0]['studname'];
                                  studid = resp[0]['studid'];
                                  upas = passwordController.text;
                                  uid = resp[0]['id'];
                                  mess = "login successfull";
                                });

                                var box = Hive.box('ugbox');

                                box.put('username', '$uname');
                                box.put('studentid', '$studid');
                                box.put('userpassword', '$upas');
                                box.put('myid', '$uid');
                                box.put('islog', '1');

                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return Dash();
                                }));
                              }

                              // Navigator.push(context, MaterialPageRoute(builder: (context){
                              //    return Dash();
                              //   }));
                            },
                            textColor: Colors.white,
                            padding: const EdgeInsets.all(0.0),
                            child: Container(
                              width: 250,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: <Color>[
                                    Color(0xFFFFA726),
                                    Color(0xFFFFCC80),
                                    Color(0xFFFF3E0),
                                  ],
                                ),
                              ),
                              padding: const EdgeInsets.all(10.0),
                              child: const Text('Login',
                                  style: TextStyle(
                                    fontSize: 18,
                                  )),
                            ),
                          ),
                          width: 250,
                          height: 40,
                          margin: EdgeInsets.only(
                            top: 20,
                          ),
                          // decoration: BoxDecoration(
                          //   borderRadius: BorderRadius.circular(10),
                          //   color: Colors.white,
                          // ),
                        ),
                        Container(
                          child: Row(
                            children: [
                              Text(
                                "Don\'t have account?",
                                style: TextStyle(color: Colors.white),
                              ),
                              RaisedButton(
                                child: Container(
                                  child: Text(
                                    "Register",
                                    style: TextStyle(
                                        color: Colors.white,
                                        backgroundColor: Colors.orange[200]),
                                  ),
                                  // color: Colors.indigo,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Register()));
                                },
                                color: Colors.orange[200],
                              ),
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                          ),
                          width: 280,
                          height: 40,
                          margin: EdgeInsets.only(
                            top: 20,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            // color: Colors.white,
                          ),
                          padding: EdgeInsets.only(top: 10),
                        ),
                        Container(
                          // color: Colors.lightGreen,
                          width: double.infinity,
                          height: 70,
                          child: Card(
                            elevation: 15,
                            color: Colors.transparent,
                            shadowColor: Colors.transparent,
                            child: Center(
                              child: Text(
                                mess,
                                style: TextStyle(),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],

                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                color: Colors.orange[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
