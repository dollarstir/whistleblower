import 'package:flutter/material.dart';
import './home.dart';
import './register.dart';
import './api.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Register extends StatefulWidget {
  // name({Key key}) : super(key: key);

  LoginState createState() => LoginState();
}

class LoginState extends State<Register> {
  final emailController = TextEditingController();
  final nameController =TextEditingController();
  final passwordController = TextEditingController();


  @override
  void dispose(){
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }


  var uname = '';
  var umail ='';
  var upas = '';
  var uid = '';
  var mess = "";
  bool _visible = true;
  var mycolor = Colors.red;
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
                            controller: nameController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Full Name",
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
                          onPressed: () async{
                            var resp = await register(nameController.text,emailController.text,passwordController.text);
                            print(resp);
                            if(resp=="Enter Name"){

                              setState(() {
                                mess = "Enter name ";
                              _visible = !_visible;
                              mycolor = Colors.red;
                              });

                            }
                            else if(resp=="Enter student Id"){
                                setState(() {
                                  mess = "Enter Student Id ";
                                _visible = !_visible;
                                 mycolor = Colors.red;
                                });

                            }

                            else if(resp=="Enter password"){
                              setState(() {
                                mess = "Enter Password ";
                              _visible = !_visible;
                               mycolor = Colors.red;
                              });

                            }

                            else if(resp=="Failed to add user"){
                              setState(() {
                                 mess = "Failed to create account  ";
                              _visible = !_visible;
                               mycolor = Colors.red;

                              });
                            }
                            else if(resp=="User already exist"){
                              setState(() {
                                mess = "You already have account ";
                              _visible = !_visible;
                               mycolor = Colors.red;
                              });

                            }

                            else{
                              print(resp);
                              // setState(() {
                              //   uname =resp[0]['Name'];
                              //   umail = resp[0]['Email'];
                              //   upas = passwordController.text;
                              //   uid = resp[0]['UserId'];
                              // });

                              // var box = Hive.box('cbox');

                              // box.put('username', '$uname');
                              // box.put('usermail', '$umail');
                              // box.put('userpassword', '$upas');
                              // box.put('myid','$uid');
                              // box.put('islog','1');

                             setState(() {
                                mess = "Registration successful ";
                              _visible = !_visible;
                               mycolor = Colors.green;
                             });


                              


                              Navigator.push(context, MaterialPageRoute(builder: (context){
                                return Home();
                              }));


                            }
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
                            child: const Text(
                              'Register',
                              style: TextStyle(fontSize: 18,)
                            ),
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
                                "Already have account?",
                                style: TextStyle(color: Colors.white),
                              ),
                              RaisedButton(
                                child: Container(
                                  child: Text(
                                    "Login",
                                    style: TextStyle(color: Colors.white,backgroundColor: Colors.orange[200]),
                                  ),
                                  // color: Colors.indigo,
                                ),
                                onPressed: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) =>Home()
                                  ));
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

                        Center(
              child: AnimatedOpacity(
                opacity: _visible ? 0.0 : 1.0,
                duration: Duration(milliseconds: 500),
                child: Container(
                  width: double.infinity,
                  height: 100,
                  //  color: Colors.blue,c

                  child: Card(
                    elevation: 15,
                    color: mycolor,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            RaisedButton(
                              onPressed: (){
                                setState(() {
                                  _visible= true;
                                });

                              },
                          
                          color: Colors.transparent,
                          textColor: Colors.red,
                          child: Icon(Icons.close),
                        ),
                          ],
                        ),
                        Center(
                          child: Text(
                            mess,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
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