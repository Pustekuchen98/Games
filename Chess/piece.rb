# encoding: utf-8

class Piece
  attr_reader :color, :board, :pos
  
  def initialize(color, board, pos)
    @color, @board, @pos = color, board, pos
  end
  
  def move
  end
  
  private
  
  def color_match?(pos)
    @board[pos].color == self.color    
  end
  
  def add_vector(pos, dir)
    row = pos[0] + dir[0]
    col = pos[1] + dir[1]
    [row, col]
  end
  
end