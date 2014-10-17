# encoding: utf-8

require_relative "piece"

class Pawn < Piece
  
  def display
    color == :white ?  "♙" :  "♟"
  end
  
  def moves
    @color == :white ? move_white : move_black
  end
   
  def attack_moves
    dir = (@color == :white) ? -1 : 1
    moves = []
    
    attack_positions = [add_vector(@pos, [dir, -1]), add_vector(@pos, [dir, 1])]
    attack_positions.each do |pos|
      next if @board[pos].nil?
      moves << pos unless self.color_match?(pos)
    end
    
    moves  
  end
  
  def move_white
    return [] if @pos[0] == 0
    legal_moves = []
    new_position = add_vector(@pos, [-1, 0])
    legal_moves = [new_position] if @board[new_position].nil?
    second_position = add_vector(@pos, [-2, 0])
    legal_moves << second_position if (@pos[0] == 6 && @board[second_position].nil?)
    return legal_moves + self.attack_moves 
  end
  
  def move_black
    return [] if @pos[0] == 7
    legal_moves = []
    new_position = add_vector(@pos, [1, 0])
    legal_moves = [new_position] if @board[new_position].nil?
    second_position = add_vector(@pos, [2, 0])
    legal_moves << second_position if (@pos[0] == 1 && @board[second_position].nil?)
    return legal_moves + self.attack_moves
  end
  
end