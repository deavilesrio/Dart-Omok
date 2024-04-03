import 'response.dart';
import 'package:http/http.dart' as http; // Import for http package
import 'dart:io';
class WebClient extends Response{
  var response;

  WebClient(){

  }
  Future<dynamic> fetchData() async{
    var defaultUrl = "https://cssrvlab01.utep.edu/Classes/cs3360Cheon/Section1/deavilesrio/";
    var url = stdin.readLineSync();
    var fullUrl;
    if (url != null) {
    fullUrl = defaultUrl + url;
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
