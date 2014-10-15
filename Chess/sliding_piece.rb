# encoding: utf-8

require_relative "piece"

class SlidingPiece < Piece

  DIAGONALS = [1, -1].product([1, -1])
  ORTHOGONALS = [[1, 0], [-1, 0], [0, 1], [0, -1]]

  def initialize(color, board, pos)
    super(color, board, pos)
  end
  
  def moves
    legal_moves = []
    position = self.pos
    
    self.move_dirs.each do |dir|
      new_position = add_vector(@pos, dir)
      while @board.onboard?(new_position)
         if @board[new_position].nil?
           legal_moves << new_position
           new_position = add_vector(new_position, dir)
         else
          legal_moves << new_position if !color_match?(new_position)
          break
        end
      end
    end
    
    legal_moves
  end
  
  private
  
  def valid_move?(pos)
    @board.onboard? && !color_match?
  end
  
 
  
end

class Bishop < SlidingPiece
  
  def display
    color == :white ?  "♗" :  "♝"
  end
  
  def move_dirs
    DIAGONALS
  end
  
end

class Rook < SlidingPiece
  
  def display
    color == :white ?  "♖" :  "♜"
  end
  
  def move_dirs
    ORTHOGONALS
  end
  
end

class Queen < SlidingPiece
  
  def display
    color == :white ?  "♕" :  "♛"
  end
  
  def move_dirs
    ORTHOGONALS + DIAGONALS
  end

end