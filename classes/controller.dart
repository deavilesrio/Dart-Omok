import 'webCliente.dart';
import 'console.dart';
import 'dart:convert'; // Import for json.decode
import 'response.dart';
import 'Board.dart';

class Controller extends WebClient {
  final ConsoleUI _view;
  final WebClient _webClient;

  Controller(this._view, this._webClient);
/*
  void run() {
    _view.showMessege();
    _view.promptServer();
    var playerMove;
    var botMove;

    _webClient.fetchData().then((response) {
      _webClient.parseInfo(response).then((parsedData) {
        _view.promptStrategy(parsedData).then((pid) {
          _view.promptMove(pid).then((response) {
            _webClient.parseInfo(response).then((parsedData) {
              playerMove = parsedData['move'];
              botMove = ['ack_move'];
              print(playerMove['isWin']);
              while (playerMove['isWin'] == 'false') {
                _view.promptMove(pid).then((response) {
                  _webClient.parseInfo(response).then((parsedData) {
                    playerMove = parsedData['move'];
                    botMove = ['ack_move'];
                  });
                });
              }
            });
          });
        });
      });
    }).catchError((error) {
      _view.displayError(error);
    });
  }
  */

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
          final parsedMoveData = await _webClient.parseInfo(moveData);
          final playerMove = parsedMoveData['move'];
          final botMove = ['ack_move'];

          print(playerMove['isWin']);

          if (playerMove['isWin'] == 'true') {
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
