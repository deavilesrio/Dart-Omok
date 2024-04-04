import 'response.dart';
import 'package:http/http.dart' as http; // Import for http package
import 'dart:io';
import 'console.dart';
class WebClient extends Response{
  var response;

  WebClient(){

  }
  Future<dynamic> fetchData() async{
    // var defaultUrl = "http://omok.atwebpages.com/";
    ConsoleUI console = ConsoleUI();
    var url = stdin.readLineSync();
    var fullUrl;
    if(url == ""){
      url = "info";
      
      if (url != null) {
        fullUrl = ConsoleUI.defaultUrl + url;
        print("Full URL: $fullUrl");
      }
    }else{
      if (url != null) {
        fullUrl = url;
        print("Full URL: $fullUrl");
      }
    }
    
    var response;
    if (fullUrl is String) {
    var uri = Uri.parse(fullUrl);
    response = await http.get(uri);
    }
    return response;
  }
   
}
