import 'package:flutter/material.dart';
import 'package:whistleblower/api.dart';
import 'package:whistleblower/inbox.dart';
import './dash.dart';
import 'package:video_player/video_player.dart';

class Rcases extends StatefulWidget {
  Rcases({Key key}) : super(key: key);

  _RcasesState createState() => _RcasesState();
}

class _RcasesState extends State<Rcases> {

  var _currentindex =1;

  Widget mylead (mytype,mf){
    if(mytype == "image"  ){
         return Image.network("https://ugwb.dollarstir.com/upload/$mf",width: 100,height: 100,errorBuilder: (context, error, stackTrace) => Icon(Icons.error),);
     }
      else{
         return Icon(Icons.videocam);
      }
                          
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Card(
          elevation: 15,
          child: FutureBuilder(
                future: Recorded(),
                builder: (context, snapshot) {
                  if(snapshot.data == null){
                    return Container(
                      child: Center(child: Text("No report by this user..."),),
                    );
                  }
                  else{
                    return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder:(BuildContext context, int index){
                      return Container(
                      child: Card(
                         elevation: 15,
                         child: ListTile(
                           leading: mylead(snapshot.data[index]['ftype'],snapshot.data[index]['pic']),
                           title: Text("${snapshot.data[index]['title']}"),
                           subtitle: Row(
                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                             children: [
                               Text("${snapshot.data[index]['dateadded']}"),

                               Text("${snapshot.data[index]['status']}")
                             ],
                           ),
                           onTap: () {

                            // navigateToNextActivity(context, snapshot.data[index]);

                           },
                        ),
                      ),
                     );
                    },

                  );
                  }
                } ,
                
                
              ),
          
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentindex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        // iconSize: 10,

        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text(
              "home",
            ),
            backgroundColor: Colors.orange[900],
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            title: Text(
              "Recorded",
            ),
            backgroundColor: Colors.blue,
          ),


          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            title: Text(
              "Inbox",
            ),
            backgroundColor: Colors.blue,
          ),


          // BottomNavigationBarItem(
          //   icon: Icon(Icons.apps),
          //   title: Text(
          //     "More",
          //   ),
          //   backgroundColor: Colors.blue,
          // ),

          // BottomNavigationBarItem(
          //   icon: Icon(Icons.group_work,  ),
          //   title: Text("Services"),
          // ),

          // BottomNavigationBarItem(
          //   icon: Icon(Icons.call,color: Colors.white,),
          //   title: Text("Contact",),
          //   backgroundColor: Colors.blue,

          // ),
        ],
        onTap: (index) {
          setState(() {
            _currentindex = index;
          });

          if (_currentindex == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return Dash() ;
              }),
            );
            
          } else if (_currentindex == 1) {
            
          } else if (_currentindex == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return Inbox();
              }),
            );
          }
        },
      ),
    );
  }
}