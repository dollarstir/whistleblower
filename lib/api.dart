import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
// String mytrackid;
Future tracking(String trackid)async{
  String url = 'https://courierconnectgh.com/api/track.php';
  
  final response = await http.post(url,
    
    // headers: {"Accept": "application/json"},
    
    body: {'trackid' : trackid}
  );  

  var conVertDatatojson = jsonDecode(response.body);
  return conVertDatatojson;
}

Future login(String studid, String password)async{
  String logurl = 'https://ugwb.dollarstir.com/login.php';

  final response = await http.post(logurl,
    
    // headers: {"Accept": "application/json"},
    
    body: {'studid' : studid,'password':password}
  );  

  var conVertDatatojson = jsonDecode(response.body);
  return conVertDatatojson;
}


Future register(String name, String studid, String password)async{
  String logurl = 'https://ugwb.dollarstir.com/register.php';

  final response = await http.post(logurl,
    
    // headers: {"Accept": "application/json"},
    
    body: {'name':name,'studid' : studid,'password':password}
  );  

  var conVertDatatojson = jsonDecode(response.body);
  return conVertDatatojson;
}



Future getuser()async{

  var box = Hive.box('cbox');

// box.put('name', 'David');

    // var hisname = box.get('username');
    var hisid = box.get('myid');
  String gggurl = 'https://courierconnectgh.com/api/user.php';

  final response = await http.post(gggurl,
    
    // headers: {"Accept": "application/json"},
    
    body: {'uid' : hisid}
  );  

  var conVertDatatojson = jsonDecode(response.body);
  return conVertDatatojson;
}


Future<void> getNews()async{
   var data = await http.get("https://courierconnectgh.com/api/news.php",
    headers: {"Accept": "application/json"},
   
   );
   var jsonData = jsonDecode(data.body);

   List<News> news =[];
   for(var u in jsonData){
     News nn = News(u['NewsId'],u['Title'],u['News'],u['RegDate']);
     news.add(nn);
   }

   print(news.length);
   return news;



  }



  Future<void> Recorded()async{
     var box = Hive.box('ugbox');

// box.put('name', 'David');

   var mid = box.get('myid');
  //  var data = await http.get("https://courierconnectgh.com/api/news.php",
  //   headers: {"Accept": "application/json"},
  //   body: json.encode(data)
    

    var data = await http.post("https://ugwb.dollarstir.com/getrecord.php", 
    body: {'studid' : mid});
   
   
   var jsonData = jsonDecode(data.body);

  //  List<Airactivi> airs =[];
  //  for(var u in jsonData){
  //    Airactivi aa = Airactivi(u['FullName'],u['Telephone'],u['Location'],u['Origin'],u['Destination'],u['Items'],u['Quantity'],u['Weight'],u['Dimensions'],u['PickupDate'],u['CompanyName'],u['CompanyAddress'],u['CompanyContact'],u['Country'],u['District'],u['RegDate']);
  //    airs.add(aa);
  //  }

  //  print(airs.length);
   return jsonData;

  }



  Future<void> Mesaages()async{
     var box = Hive.box('ugbox');

// box.put('name', 'David');

   var mid = box.get('myid');
  //  var data = await http.get("https://courierconnectgh.com/api/news.php",
  //   headers: {"Accept": "application/json"},
  //   body: json.encode(data)
    

    var data = await http.post("https://ugwb.dollarstir.com/messages.php", 
    body: {'studid' : mid});
   
   
   var jsonData = jsonDecode(data.body);

  //  List<Airactivi> airs =[];
  //  for(var u in jsonData){
  //    Airactivi aa = Airactivi(u['FullName'],u['Telephone'],u['Location'],u['Origin'],u['Destination'],u['Items'],u['Quantity'],u['Weight'],u['Dimensions'],u['PickupDate'],u['CompanyName'],u['CompanyAddress'],u['CompanyContact'],u['Country'],u['District'],u['RegDate']);
  //    airs.add(aa);
  //  }

  //  print(airs.length);
   return jsonData;

  }

class News{
  final int newsID;
  final String ntitle;
  final String newsc;
  final String dateadded;
  News(this.newsID,this.ntitle,this.newsc,this.dateadded);


}

class Airactivi{
  final int rBy;
  final String tele;
  final String loc;
  final String origin;
  final String destination; 
  final String item; 
  final String quant; 
  final String weight; 
  final String dimension; 
  final String pickdate; 
  final String company; 
  final String address; 
  final String phone; 
  final String departurecountry; 
  final String departurecity; 
  final String  rdate;












  Airactivi(this.rBy,this.tele,this.loc,this.origin,this.destination,this.item,this.quant,this.weight,this.dimension,this.pickdate,this.company,this.address,this.phone,this.departurecountry,this.departurecity,this.rdate);


}