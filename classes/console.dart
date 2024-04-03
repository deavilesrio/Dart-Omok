import 'package:my_package/my_package.dart';
import 'dart:io';
import 'Board.dart';
class ConsoleUI extends Board implements Messege, PromptServer, PromptStrategy, PromptMove{
   @override
  void showMessege() {
    
    print("Welcome to Omokgame!");
  }
  @override
  void promptServer() {
    var defaultUrl = "https://www.cs.utep.edu/cheon/cs3360/project/omok/";
    stdout.write('Enter the server URL [default: $defaultUrl] ');
  }
  @override
  void promptStrategy(var info) {
    var strategies = info['strategies'];
    stdout.write("Select the server strategy: 1. " + strategies[0] + " 2. " + strategies[1] + "[default: 1] ");
    var line = stdin.readLineSync();
    try {
    var selection = int.parse(line!);
    if(selection == 1 || selection == 2){
      print("Creating New Game.......\n");
      
    }else{
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
  void promptMove(){
    bool isValid = true;
    while(isValid){
    try{
      Board board = Board();
      while(isValid){
        stdout.write("Enter x and y(1-15, e.g, 8 10) ");
        var move = stdin.readLineSync();
          // Split the input string by commas or spaces
        List<String> moves = move!.split(RegExp(r'[,\s]+'));
        int x = int.parse(moves[0]);
        int y = int.parse(moves[1]);
        if(((x > 0) & (x < 16)) & ((y > 0) & (y < 16))){
          while(isValid){
            if(board.cells[x][y] == '*'){
              print("Is empty!");
              board.cells[x][y] = 'x';
              isValid = false;
              printBoard(board);
            }else{
              print("Is not empty!, try another move");
            }
          }
        }else{
          print("Invalid index");
        }
      }
    } catch (e) {
    // Handle any exceptions thrown during input reading or splitting
      print('An error occurred: Invalid move!!');
      
    }
    }
  }
  void printBoard(Board board){
    for(int i = 0; i<board.rows; i++){
      stdout.write("[");
      for(int j = 0; j<board.columns; j++){
        stdout.write("${board.cells[i][j]} ");
      }
      stdout.write("]\n");
    }
  }
  
    
}
 
