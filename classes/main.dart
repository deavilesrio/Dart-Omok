// Main function
import 'console.dart';
import 'controller.dart';
import 'webCliente.dart';

void main() {
  ConsoleUI view = ConsoleUI();
  WebClient webClient = WebClient();
  Controller controller = Controller(view, webClient);
  controller.run();
}