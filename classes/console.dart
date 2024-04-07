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
  String? promptServer() {
    // var defaultUrl = "https://cssrvlab01.utep.edu/Classes/cs3360Cheon/Section1/deavilesrio/";
    
    stdout.write('Enter the server URL [default: $defaultUrl] ');
    var url = stdin.readLineSync();  
    // Attempt to parse the URI using Uri.parse()
      
    return url;
  }

@override
  Future promptStrategy(var x, var url) async {
    var strategies = x['strategies'];
    stdout.write("Select the server strategy: 1. " +
        strategies[0] +
        " 2. " +
        strategies[1] +
        "[default: 1] ");
        var isValid = true;
    while(isValid){
    try {
      var line = stdin.readLineSync();      
      var selection = int.parse(line!);
      var uri;
      if (selection == 1) {
        isValid = false;
        print("Creating New Game.......\n");
        var newGameSmart = "new/index.php?strategy=Smart";
        if(url == ""){
          uri = Uri.parse(defaultUrl + newGameSmart);
        }else{
          uri = Uri.parse(url! + newGameSmart);
          //print("URL: $uri");
        }
        var response = await http.get(uri);
        var info = json.decode(response.body);
        var pid = info['pid'];
        return pid;
        //Parse the response to obtain the pid
      } else if (selection == 2) {
        isValid = false;
        print("Creating New Game.......\n");
        var newGameRandom = "new/index.php?strategy=Random";
        if(url == ""){
          uri = Uri.parse(defaultUrl + newGameRandom);
        }else{
          uri = Uri.parse(url! + newGameRandom);
          //print("URL: $uri");
        }
        var response = await http.get(uri);
        var info = json.decode(response.body);
        var pid = info['pid'];
        // print(pid);
        return pid;
      } else {
        print("Invalid response: $selection");
        print("Choose 1 or 2");
      }
    } on FormatException {
      print("Invalid response:");
      print("Choose 1 or 2");
    }
    }
  }

  void displayError(dynamic error) {
    print('Error: $error');
  }

    @override
  Future<dynamic> promptMove(var url, var pid, var board) async {
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
              if(url == ""){
                fullUrl = "${defaultUrl}play/?pid=$pid&x=$x&y=$y";
              }else{
                fullUrl = "${url}play/?pid=$pid&x=$x&y=$y";
              }
              //print("Full URL: $fullUrl");
              // printBoard(board);
              var uri; 
              if(url == ""){
               uri = Uri.parse("${defaultUrl}play/?pid=$pid&x=$x&y=$y");
              }else{
                uri = Uri.parse("${url}play/?pid=$pid&x=$x&y=$y");
              }
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
    printWinningRow(board, win_list);
    print("You Win!");
  }

  void promptLoss(var board, var win_list) {
    printWinningRow(board, win_list);
    print("You Lose!");
  }

  void promptTie(var board) {
    printBoard(board);
    print("It is a tie!");
  }

  void printBoard(Board board) {
    print("");
    print(" x 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4");
    print("y --------------------------------");
    int k = 0;
    for (int i = 0; i < board.rows; i++) {
      if(k == 10){
        k = 0;
      }
      stdout.write("$k |");
      k++;
      for (int j = 0; j < board.columns; j++) {
        stdout.write("${board.cells[i][j]} ");
      }
      stdout.write("|\n");
    }
  }

  void printWinningRow(Board board, List<dynamic> winningCoordinates) {
    final int totalCells = board.rows * board.columns;
    print(" x 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4");
    print("y ------------------------------");
    int k = 0;
    for (int i = 0; i < board.rows; i++) {
      if(k == 10){
        k = 0;
      }
      stdout.write("$k |");
      k++;
      for (int j = 0; j < board.columns; j++) {
        final int cellIndex = i * board.columns + j;
        // Check if cellIndex is within valid range
        if (cellIndex >= 0 && cellIndex < totalCells) {
          bool isHighlighted = false;
          // Check if cell belongs to the winning row
          for (int k = 0; k < winningCoordinates.length - 1; k += 2) {
            int winX = winningCoordinates[k];
            int winY = winningCoordinates[k + 1];
            if (winX == i && winY == j) {
              isHighlighted = true;
              break; // Exit inner loop if cell found in winningCoordinates
            }
          }

          String cellValue = board.cells[i][j];
          stdout.write(isHighlighted
              ? "\x1b[41m$cellValue\x1b[0m" // Highlight with red background
              : "$cellValue");
        } else {
          // Handle out-of-bounds cell (optional: print something different)
          stdout.write(" "); // Replace with a visual indicator if needed
        }
        stdout.write(" ");
      }
      stdout.write("|\n");
    }
  }
  
}
