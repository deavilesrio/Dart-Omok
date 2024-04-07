import 'response.dart';
import 'package:http/http.dart' as http; // Import for http package
import 'dart:io';
import 'console.dart';

class WebClient extends Response {
  var response;

  WebClient() {}
  Future<dynamic> fetchData(var url) async{
    // var defaultUrl = "http://omok.atwebpages.com/";
    ConsoleUI console = ConsoleUI();
    
      var fullUrl;
   
      var info = "info";
      
      if (url == "") {
        fullUrl = ConsoleUI.defaultUrl + info;
        print("Full URL: $fullUrl");
      }else{
        fullUrl = url + info;
        print("Full URL: $fullUrl");
      }
    
    var response;
    if (fullUrl is String) {
    var uri = Uri.parse(fullUrl);
    response = await http.get(uri);
    }
    return response;
  }
  
}
