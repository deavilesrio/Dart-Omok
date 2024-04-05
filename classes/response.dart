import 'package:my_package/infoPackage.dart';
import 'dart:convert'; // Import for json.decode

class Response implements Parse {
  @override
  Future parseInfo(var response) async {
    var info = json.decode(response.body);
    return info;
  }
}
