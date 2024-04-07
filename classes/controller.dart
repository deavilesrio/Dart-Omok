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
    final url = await _view.promptServer();
    Board board = Board();

    try {
      final response = await _webClient.fetchData(url);
      final parsedData = await _webClient.parseInfo(response);
      final pid = await _view.promptStrategy(parsedData, url);

      while (true) {
        // Loop until win or potential errors
        try {
          final moveData = await _view.promptMove(url, pid, board);
          //print(moveData.body);
          final parsedMoveData = await _webClient.parseInfo(moveData);
          final playerMove = parsedMoveData['ack_move'];
          final botMove = parsedMoveData['move'];
          if (playerMove["isWin"] == true) {
            _view.promptWin(board, playerMove["row"]);
            break; // Exit loop on win
          } else if (botMove["isWin"] == true) {
            _view.promptLoss(board, botMove["row"]);
            break; // Exit loop on loss
          }
          if (playerMove["isDraw"] == true) {
            _view.promptTie(board);
            break; // Exit loop on draw
          } else if (botMove["isDraw"] == true) {
            _view.promptTie(board);
            break; // Exit loop on draw
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
