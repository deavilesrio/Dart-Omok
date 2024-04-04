// ignore: file_names
class Board {
  // Fields to represent the state of the board
  late List<List<String>> cells;
  int rows;
  int columns;

  // Constructor to initialize the board with empty cells
  Board()
      : this.rows = 15,
        this.columns = 15 {
    cells = List.generate(rows, (r) => List.filled(columns, '.'));
  }
}