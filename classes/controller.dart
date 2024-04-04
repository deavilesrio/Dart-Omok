
import 'webCliente.dart';
import 'console.dart';
class Controller extends WebClient{
  final ConsoleUI _view;
  final WebClient _webClient;

  Controller(this._view, this._webClient);

  void run() {
    _view.showMessege();
    _view.promptServer();
  
    _webClient.fetchData().then((response) {
      _webClient.parseInfo(response).then((parsedData) {
        _view.promptStrategy(parsedData).then((pid){
        _view.promptMove(pid);});
        
      });
    }).catchError((error) {
      _view.displayError(error);
    });
  }
  }
