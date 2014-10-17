# encoding: utf-8

class Piece
  attr_accessor :pos
  attr_reader :color, :board
  
  def initialize(color, board, pos)
    @color, @board, @pos = color, board, pos
  end
  
  def move_into_check?(destination)
    dup_board = @board.dup
    dup_board.move!(@pos, destination)
    dup_board.in_check?(@color)
  end
  
  def color_match?(pos)
    @board[pos].color == self.color    
  end
  
  def valid_moves
    semi_legal_moves = self.moves
    semi_legal_moves.select { |pos| !move_into_check?(pos) }      
  end
  
  private
  
  def add_vector(pos, dir)
    row = pos[0] + dir[0]
    col = pos[1] + dir[1]
    [row, col]
  end
  
end