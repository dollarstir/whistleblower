import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Img;
import 'package:whistleblower/inbox.dart';

import 'dart:math' as Math;
import './recorded.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import './api.dart';
import './home.dart';
import 'package:video_player/video_player.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:percent_indicator/percent_indicator.dart';
class Dash extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Dash> {


  final GlobalKey<ScaffoldState> _scaffoldstate = new GlobalKey<ScaffoldState>();
   File _file;
  var cpercent=0;
  var ttpercent=0;
  File _image;
  File _video;
  var ftype;
  var myid;
  var myname;
  var mystud;
  TextEditingController cTitle = new TextEditingController();

    Future getFile()async{
      File file = await FilePicker.getFile();

      setState(() {
       
        if (file != null) {
           _file = file;
            ftype="video";
            _image=null;
            
          
          
        } else {
          print('no image selected');
        }
        
      });
      print(_file);
    }



    void _uploadFile(filePath) async {
    String fileName = basename(filePath.path);
    print("file base name:$fileName");
    setState(() {
      _isready= !_isready;
    });

    try {
      FormData formData = new FormData.fromMap({
        "title": cTitle.text,
        "studid": myid,
        "ftype" : ftype,
        "file": await MultipartFile.fromFile(filePath.path, filename: fileName),
      });

      Response response = await Dio().post("https://ugwb.dollarstir.com/fileapp.php",data: formData,onSendProgress: (int sent, int total) {
          print(((sent /total)*100).round());
          setState(() {
            cpercent= ((sent /total)*100).round();
            ttpercent =((total /total)*100).round();
          });
  },);
      print("File upload response: $response");
      // _showSnackBarMsg(response.data['message']);
        setState(() {
           mess = response.data['message'];
           _visible = !_visible;
        });
          } catch (e) {
            print("expectation Caugch: $e");
          }
      

      
       }



      //  void _showSnackBarMsg(String msg){
      //        _scaffoldstate.currentState
      //        .showSnackBar( new SnackBar(content: new Text(msg),));
      //     }

   

  Future getImageGallery() async {
    var imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    print(imageFile);
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;

    int rand = new Math.Random().nextInt(100000);

    Img.Image image = Img.decodeImage(imageFile.readAsBytesSync());
    // Img.Image smallerImg = Img.copyResize(image, 500);

    var compressImg = new File("$path/image_$rand.jpg")
      ..writeAsBytesSync(Img.encodeJpg(image, quality: 85));

    setState(() {


      if (imageFile != null) {
          _image = compressImg;
          ftype = "image";
          _file=null;
          
          
        } else {
          print('no image selected');
        }
      
    });
    print(_image);
  }


  Future getImageCamera() async {
    var imageFile = await ImagePicker.pickImage(source: ImageSource.camera);

    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;

    int rand = new Math.Random().nextInt(100000);

    Img.Image image = Img.decodeImage(imageFile.readAsBytesSync());
    // Img.Image smallerImg = Img.copyResize(image, 500);

    var compressImg = new File("$path/image_$rand.jpg")
      ..writeAsBytesSync(Img.encodeJpg(image, quality: 85));

    setState(() {
      if (imageFile != null) {
          _image = compressImg;
          ftype = "image";
          _file=null;
          
          
        } else {
          print('no image selected');
        }
    });
    print(ftype);
  }

  Future upload(File imageFile) async {
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    var uri = Uri.parse("https://ugwb.dollarstir.com/demo.php");

    var request = new http.MultipartRequest("POST", uri);

    var multipartFile = new http.MultipartFile("image", stream, length,
        filename: basename(imageFile.path));
    request.fields['title'] = cTitle.text;
    request.fields['studid'] = myid;
    request.fields['ftype'] = ftype;
    request.files.add(multipartFile);

    var response = await request.send();

    if (response.statusCode == 200) {
      print("Image Uploaded");
      setState(() {
        mess = "Report Submitted ";
        _visible = !_visible;
      });
    } else {
      print("Upload Failed");

      mess = "Upload Failed";
        _visible = !_visible;
    }
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  }




  // Beloow codes helps to upload videos from both camera or Gallery

  _getVideoGallery() async{
    try {
    var vidgall = await ImagePicker.pickVideo(source: ImageSource.gallery);

       setState(() {
      

       if (vidgall != null) {
          _file = vidgall;
          ftype = "video";
          _image= null;
          
          
        } else {
          print('no image selected');
        }
    });
   

    } catch (e) {
      print(e);
    }
   
    print(ftype);
     print(_video);
  }



   _getVideoCamera() async{
    try {
      var vidgcam = await ImagePicker.pickVideo(source: ImageSource.camera);
            setState(() {
      _video = vidgcam;
      ftype = "video";
    });
      
    } catch (e) {
      print(e);
    }
  }


  Future uploadVideo(File videoFile) async{
    var uri = Uri.parse("https://ugwb.dollarstir.com/demo.php");
    var request = new http.MultipartRequest("POST", uri);

    var multipartFile = await http.MultipartFile.fromPath("video", videoFile.path);
    request.fields['title'] = cTitle.text;
    request.fields['studid'] = myid;
    request.fields['ftype'] = ftype;
    request.files.add(multipartFile);
    var  response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
    if(response.statusCode==200){
      print("Video uploaded");
    }else{
      print("Video upload failed");
    }
  }

  var _currentindex = 0;
  var mess = "";
  bool _visible = true;
  bool _isready = true;

  


  Widget mything(){

      if(_image == null && _file == null){
        
        return new Text("Choose or caputre image of event!");

      }
      else if(_image != null && _file == null){

          

        return new Image.file(
                        _image,
                        width: 320,
                        height: 150,
                      );

      }
      else{
         var _controller = VideoPlayerController.network("http://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4");
        //  _controller.setLooping(true);
         

        return   new  Container(
              margin: EdgeInsets.only(top:10,left: 20,right: 20),
              child: TextField(
                controller: cTitle,
                
                decoration: new InputDecoration(
                  hintText: _file.toString(),
                ),
              ),
            );

      }

  }
  @override
  Widget build(BuildContext context) {

     var box = Hive.box('ugbox');

// box.put('name', 'David');

    var mid = box.get('myid');
    var name = box.get('username');
    var stud = box.get('studentid');
    setState(() {
      
      myid =mid;
      myname =name;
      mystud =stud;

    });
    return Scaffold(
      appBar: AppBar(
        title:  Row(
          children: <Widget>[
            // Container(
            //   child: Image.asset('assets/images/logo.png'),
            //   width: 50,
            //   height: 50,
            //   padding: EdgeInsetsDirectional.only(top: 10),
            //   //  margin: EdgeInsets.only(right: -20,),

            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     shape: BoxShape.circle,
            //     // image: DecorationImage(
            //     //   image: AssetImage('assets/images/logo.png'),
            //     // ),
            //   ),
            // ),
            SizedBox(
              width: 10,
            ),
            Text("Start reporting"),
            SizedBox(
              width: 1,
            ),
          ],
        ),
        centerTitle: true,
      ),
      drawer: Drawer(

        child: Container(
          child: Column(
      children: <Widget>[
        
        Container(
          // height: 27,
          margin: EdgeInsets.only(bottom: 10),
          // alignment: AlignmentDirectional.topCenter,
          decoration: BoxDecoration(
            
              border: Border.all(
            color: Colors.blueAccent,
          )),
          child: ListTile(
            title: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Icon(
                    Icons.close,
                    size: 30,
                    color: Colors.red,
                    
                  ),
                ],
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ),

        UserAccountsDrawerHeader(
          
          decoration: BoxDecoration(
            
            
          ),
          accountName: Text(name.toString(),style: TextStyle(color: Colors.black),),
          accountEmail: Text(stud.toString(),style: TextStyle(color: Colors.black),),  
          
          currentAccountPicture: CircleAvatar(
            child: Image.asset("assets/images/logo1.png"),
          ),
          otherAccountsPictures: [
           
            CircleAvatar(
              
              child: RaisedButton(
                onPressed: (){
                   var box = Hive.box('ugbox');

                              
                                box.put('islog', '0');
                                Navigator.push(context, MaterialPageRoute(builder: (context){
                                   return Home();
                                }));
                },
                child: Icon(Icons.power_settings_new,size: 16,),
              ),
            )
          ],
        ),
        
      ],
    ),
        ),

      ),
      
      body: SingleChildScrollView(

        child: Column(
          children: <Widget>[
            SizedBox(height: 150),
            Center(
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 15),
                child: Column(
                  children:[
                    
                    mything(),


                  ] 

                    
                )
              ),
            ),
            Container(
              margin: EdgeInsets.only(top:10,left: 20,right: 20),
              child: TextField(
                controller: cTitle,
                decoration: new InputDecoration(
                  hintText: "Brief description",
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 20,right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  

                  RaisedButton(
                    child: Icon(Icons.image),
                    onPressed: getImageGallery,
                  ),
                  RaisedButton(
                    child: Icon(Icons.camera_alt),
                    onPressed: getImageCamera,
                  ),


                  RaisedButton(
                    child: Icon(Icons.video_library),
                    onPressed: (){
                      getFile();
                    },
                  ),
                  RaisedButton(
                    child: Icon(Icons.videocam),
                    onPressed: ()async{
                      _getVideoCamera();
                    },
                  ),

                  // Expanded(
                  //   child: Container(),
                  // ),
                  
                 
                  
                  
                ],
              ),
            ),

            Center(
              child: AnimatedOpacity(
                opacity: _isready ? 0.0 : 1.0,
                duration: Duration(milliseconds: 100),
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
              padding: EdgeInsets.all(15.0),
              child: new LinearPercentIndicator(
                width: MediaQuery.of(context).size.width - 50,
                animation: true,
                lineHeight: 20.0,
                animationDuration: 2500,
                percent: cpercent/100,
                center: Text(cpercent.toString()+ "%"),
                linearStrokeCap: LinearStrokeCap.roundAll,
                progressColor: Colors.green,
              ),
            ),
              ],
            ),
              ),
            ),

            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   _image == null
                  ? Text('')
                  :RaisedButton(
                    child: Text("UPLOAD"),
                    onPressed: () {
                      upload(_image);
                    },
                  ),
                   _file == null
                  ? Text('')
                  :RaisedButton(
                    child: Text("UPLOAD"),
                    onPressed: () {
                      _uploadFile(_file);
                    },
                  ),
                ],
              )
            ),
            SizedBox(height: 10),
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
                    color: Colors.green,
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
                          
                          color: Colors.green,
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
          } else if (_currentindex == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return Rcases();
              }),
            );
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
