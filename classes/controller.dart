import 'webCliente.dart';
import 'console.dart';
import 'dart:convert'; // Import for json.decode
import 'response.dart';
import 'Board.dart';

class Controller extends WebClient {
  final ConsoleUI _view;
  final WebClient _webClient;

  Controller(this._view, this._webClient);

  void run() async {
    _view.showMessege();
    _view.promptServer();
    Board board = Board();

    try {
      final response = await _webClient.fetchData();
      final parsedData = await _webClient.parseInfo(response);
      final pid = await _view.promptStrategy(parsedData);

      while (true) {
        // Loop until win or potential errors
        try {
          final moveData = await _view.promptMove(pid, board);
          print(moveData.body);
          final parsedMoveData = await _webClient.parseInfo(moveData);
          final playerMove = parsedMoveData['ack_move'];
          final botMove = parsedMoveData['move'];
          if (playerMove["isWin"] == true) {
            _view.promptWin(board, playerMove["row"]);
            break; // Exit loop on win
          } else if (botMove["isWin"] == true) {
            _view.promptLoss(board, playerMove["row"]);
            break; // Exit loop on win
          }
        } catch (error) {
          _view.displayError(error); // Handle errors within the loop
        }
      }
    } catch (error) {
      _view.displayError(error); // Handle errors during initial setup
    }
  }
}
