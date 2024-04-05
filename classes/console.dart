import 'package:my_package/my_package.dart';
import 'dart:io';
import 'Board.dart';
import 'package:http/http.dart' as http; // Import for http package
import 'dart:convert'; // Import for json.decode

class ConsoleUI extends Board
    implements Messege, PromptServer, PromptStrategy, PromptMove {
  static const String defaultUrl = "http://omok.atwebpages.com/";
  var pid;
  //const pid
  @override
  void showMessege() {
    print("Welcome to Omokgame!");
  }

  @override
  void promptServer() {
    // var defaultUrl = "https://cssrvlab01.utep.edu/Classes/cs3360Cheon/Section1/deavilesrio/";
    stdout.write('Enter the server URL [default: $defaultUrl] ');
  }

  @override
  Future promptStrategy(var x) async {
    var strategies = x['strategies'];
    stdout.write("Select the server strategy: 1. " +
        strategies[0] +
        " 2. " +
        strategies[1] +
        "[default: 1] ");
    var line = stdin.readLineSync();
    try {
      var selection = int.parse(line!);
      if (selection == 1) {
        print("Creating New Game.......\n");
        var newGameSmart = "new/index.php?strategy=Smart";
        var uri = Uri.parse(defaultUrl + newGameSmart);
        var response = await http.get(uri);
        var info = json.decode(response.body);
        var pid = info['pid'];
        return pid;
        //Parse the response to obtain the pid
      } else if (selection == 2) {
        print("Creating New Game.......\n");
        var newGameRandom = "new/index.php?strategy=Random";
        var uri = Uri.parse(defaultUrl + newGameRandom);
        var response = await http.get(uri);
        var info = json.decode(response.body);
        var pid = info['pid'];
        return pid;
      } else {
        print("Invalid response: $selection");
      }
    } on FormatException {
      print("Invalid response:");
    }
  }

  void displayError(dynamic error) {
    print('Error: $error');
  }

  @override
  Future<dynamic> promptMove(var pid, var board) async {
    bool isValid = true;
    while (isValid) {
      try {
        while (isValid) {
          stdout.write("Enter x and y(0-14, e.g, 8 10) ");
          var move = stdin.readLineSync();
          // Split the input string by commas or spaces
          List<String> moves = move!.split(RegExp(r'[,\s]+'));
          int x = int.parse(moves[0]);
          int y = int.parse(moves[1]);
          var fullUrl;
          // play/?pid=660da36212f70&x=14&y=14

          if (((x >= 0) & (x <= 14)) & ((y >= 0) & (y <= 14))) {
            if (board.cells[x][y] == '.') {
              print("Is empty!");
              board.cells[x][y] = 'x';
              isValid = false;
              fullUrl = "${defaultUrl}play/?pid=$pid&x=$x&y=$y";
              print("Full URL: $fullUrl");
              // printBoard(board);
              var uri = Uri.parse("${defaultUrl}play/?pid=$pid&x=$x&y=$y");
              var response = await http.get(uri);
              var info = json.decode(response.body);
              var bot_move = info['move'];
              if (bot_move == null) {
                return response;
              }
              var bot_x = bot_move['x'];
              var bot_y = bot_move['y'];
              board.cells[bot_x][bot_y] = '@';
              printBoard(board);
              return response;
            } else {
              print("Is not empty!, try another move");
            }
          } else {
            print("Invalid index");
          }
        }
      } catch (e) {
        // Handle any exceptions thrown during input reading or splitting
        print('An error occurred: Invalid move!!');
      }
    }
  }

  void promptWin(var board, var win_list) {
    printBoard(board);
    print("You Win!");
  }

  void promptLoss(var board, var win_list) {
    printBoard(board);
    print("You Lose!");
  }

  void printBoard(Board board) {
    print("");
    for (int i = 0; i < board.rows; i++) {
      stdout.write("[");
      for (int j = 0; j < board.columns; j++) {
        stdout.write("${board.cells[i][j]} ");
      }
      stdout.write("]\n");
    }
  }
}
