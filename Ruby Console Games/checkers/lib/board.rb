require 'colorize'
require_relative 'piece'

class Board
  
  attr_accessor :grid
  
  def initialize(fill_board = false)
    @grid = make_grid
    populate_board if fill_board 
  end  
  
  def [](pos)
    row, col = pos[0], pos[1]
    @grid[row][col]
  end
  
  def []=(pos, piece)
    row, col = pos[0], pos[1]
    @grid[row][col] = piece
  end
  
  def display(name, cursor_pos = nil)
    system("clear")
    border = "    " * 8
    game_ui_string = "\n " + (border + "  \n").on_white
    @grid.each_with_index do |row, row_idx|
      display_row = row.map.with_index do |tile, col_idx|
        display_tile(tile, row_idx, col_idx, cursor_pos)
      end.join + " \n".on_white 
      game_ui_string << ' ' + " ".on_white + display_row
    end
    
    game_ui_string << " "+ (border + "  \n").on_white    
    puts game_ui_string
    
    give_instructions(name)
    
  end
  
  def give_instructions(name)
    puts "It's #{name}'s turn."
    game_ui_string << " Move with arrow keys.\n"
    game_ui_string << " Spacebar to select a piece,\n"
    game_ui_string << " 'quit' to quit.\n\n"
    puts game_ui_string
  end
  
  def display_tile(piece, row_idx, col_idx, cursor_pos = nil)
    tile = piece.nil? ? "    " : " #{piece.display}  "
    if cursor_pos && [col_idx, row_idx] == cursor_pos
      tile.on_magenta
    else
      (row_idx + col_idx).even? ? tile.on_white : tile.on_light_black
    end
  end
  
  def dup
    dup_board = Board.new(false)
    @grid.each_with_index do |row, row_idx|
      row.each_with_index do |piece, col_idx|
        unless piece.nil?
          pos = [row_idx, col_idx]
          color = piece.color
          dup_board[pos] = Piece.new(dup_board, color, pos)
        end
      end
    end
    
    dup_board
  end
  
  def onboard?(pos)
    pos.all? { |coord| coord.between?(0, 7) }
  end
  
  def empty?(pos)
    self[pos].nil?
  end
  
  def over?
    pieces(:black) == 0 or pieces(:red) == 0
  end
  
  private
  def make_grid
    Array.new(8) { Array.new(8) { nil } }
  end
  
  def populate_board
    @grid.each_with_index do |row, row_idx|
      next if (row_idx == 3 || row_idx == 4)
      row.each_with_index do |tile, col_idx|
        pos = [row_idx, col_idx]
        if row_idx < 3
          @grid[row_idx][col_idx] = Piece.new(self, :black, pos) if (row_idx + col_idx).even?
        elsif row_idx > 4
          @grid[row_idx][col_idx] = Piece.new(self, :red, pos) if (row_idx + col_idx).even?
        end
      end
    end
  end
  
  def same_color_pieces color
    @grid.flatten.compact.select { |piece| piece.color == color }
  end
  
end