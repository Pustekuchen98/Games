# encoding: utf-8
require 'colorize'
require_relative "sliding_piece"
require_relative "stepping_piece"
require_relative "pawn"

class Board
  
  attr_reader :grid
  
  def initialize(fill_board = false)
    @grid = make_grid
    populate_board if fill_board
  end
  
  def check_mate?(color)
    if in_check?(color)
      list_pieces = same_color_pieces(color)
      return list_pieces.all? { |piece| piece.valid_moves.empty? }
    end
    false
  end
  
  def same_color_pieces color
    @grid.flatten.compact.select { |piece| piece.color == color }
  end
  
  def display
    system('clear')
    space = " " * 30
    puts "  #{space}#{(0..7).to_a.join("  ")}"
    self.grid.each_with_index do |row, row_idx|
      row_array = ["#{space}#{row_idx}"]
      row.each_with_index do |piece, col_idx|
        color = (row_idx + col_idx).even? ? :white : :black 
          
        if piece.nil?
          if color == :white
            row_array << "   ".on_light_white
          else
            row_array << "   ".on_light_black
          end
        else 
          if color == :white
            row_array << " #{piece.display} ".on_light_white
          else
            row_array << " #{piece.display} ".on_light_black
          end
        end
          
      end
      puts row_array.join
    end
    return nil
  end
  
  
  def onboard?(pos)
    pos.all? { |coord| coord.between?(0, 7) }
  end
  
  def [](pos)
    row, col = pos[0], pos[1]
    @grid[row][col]
  end
  
  def move_piece(origin, destination)
    raise IllegalMoveError.new('No piece there') if self[origin].nil?
    
    if self[origin].move_into_check?(destination) 
      raise IllegalMoveError.new("nope! nope! don't move into check!!!")
    end
     
    if self[origin].moves.include?(destination)
      self.move!(origin, destination)
    else
      raise IllegalMoveError.new('Please try again')
    end
  end
  
  def move!(origin, destination)
    self[origin].pos = destination
    self[destination] = self[origin]
    self[origin] = nil
  end
    
  def in_check?(color)
    pos = find_king(color)
    @grid.flatten.compact.each do |piece|
      next if piece.color == color
      return true if piece.moves.include?(pos)
    end
    false
  end
  
  def find_king(color)
    king = self.grid.flatten.compact.select do |piece| 
      piece.is_a?(King) && piece.color == color 
    end
    king[0].pos
  end
  
  def dup
    dup_board = Board.new(false)
    @grid.each_with_index do |row, row_idx|
      row.each_with_index do |piece, col_idx|
        unless piece.nil?
          pos = [row_idx, col_idx]
          color = piece.color
          dup_board[pos] = piece.class.new(color, dup_board, pos)
        end
      end
    end
    
    dup_board
  end
  
  def []=(pos, piece)
    row, col = pos[0], pos[1]
    @grid[row][col] = piece
  end
   
  private
  
  def make_grid
    Array.new(8) { Array.new(8) { nil } }
  end
    
  def populate_board
    # Pawns - White
    self.grid[6].each_index do |col|
      self[[6, col]] = Pawn.new(:white, self, [6, col])
    end  
    
    # Pawns - black
    self.grid[1].each_index do |col|
      self[[1, col]] = Pawn.new(:black, self, [1, col])
    end 
    
    # Rooks
    self[[0, 0]] = Rook.new(:black, self, [0, 0])
    self[[0, 7]] = Rook.new(:black, self, [0, 7])
    self[[7, 0]] = Rook.new(:white, self, [7, 0])
    self[[7, 7]] = Rook.new(:white, self, [7, 7])    
    
    # Knights
    self[[0, 1]] = Knight.new(:black, self, [0, 1])
    self[[0, 6]] = Knight.new(:black, self, [0, 6])
    self[[7, 6]] = Knight.new(:white, self, [7, 6])
    self[[7, 1]] = Knight.new(:white, self, [7, 1])    
    
    # Bishop    
    self[[0, 2]] = Bishop.new(:black, self, [0, 2])
    self[[0, 5]] = Bishop.new(:black, self, [0, 5])
    self[[7, 2]] = Bishop.new(:white, self, [7, 2])
    self[[7, 5]] = Bishop.new(:white, self, [7, 5])
    
    # Queen
    self[[0, 3]] = Queen.new(:black, self, [0, 3])
    self[[7, 3]] = Queen.new(:white, self, [7, 3])
    
    # King
    self[[0, 4]] = King.new(:black, self, [0, 4])
    self[[7, 4]] = King.new(:white, self, [7, 4])    
  
  end
end
