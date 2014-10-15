# encoding: utf-8
require_relative "piece"

class SteppingPiece < Piece
  attr_reader :step_moves
 
  def initialize(color, board, pos)
    super
    @step_moves = []
  end
  
  def moves
    legal_moves = []
    @step_moves.each do |vector|
      new_position = add_vector(@pos, vector)
      legal_moves << new_position if valid_move?(new_position)
    end 
    legal_moves                            
  end
    
  private
  def valid_move? pos
    if @board.onboard?(pos)
      return true if @board[pos].nil?                   
      return !color_match?
    end
    false
  end

end

class Knight < SteppingPiece
  attr_reader :step_moves
  
  def initialize(color, board, pos)
    super
    @step_moves = [[1, 2], [-1, 2], [1, -2], [-1, -2], 
                   [2, 1], [2, -1], [-2, 1], [-2, -1]]    
  end
  
  def display
    color == :white ?  "♘" :  "♞"
  end
end

class King < SteppingPiece
  attr_reader :step_moves
  
  def display
    color == :white ?  "♔" :  "♚"
  end
  
  def initialize(color, board, pos)
    super
    @step_moves = [1, -1, 0].product([1, -1, 0])[0..-2]    
  end
end
