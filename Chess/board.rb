# encoding: utf-8
require_relative "sliding_piece"
require_relative "stepping_piece"
require_relative "pawn"

class Board
  
  attr_reader :grid
  
  def initialize
    @grid = make_grid
    set_board
    return nil
  end
  
  def display
    puts
    space = " " * 30
      puts "  #{space}| #{(0..7).to_a.join(" | ")}"
      self.grid.each_with_index do |row, index|
        puts "#{space}" + "----" * 8 + "---"
        row_array = ["#{space}#{index}"]
        row.each do |piece|
          if piece.nil?
            row_array << " "
          else 
            row_array << piece.display
          end
        end
        puts row_array.join(' | ')
      end
      return nil
    end
  
  def onboard?(pos)
    pos[0].between?(0, 7) && pos[1].between?(0, 7)
  end
  
  def [](pos)
    row, col = pos[0], pos[1]
    @grid[row][col]
  end
  
  private
  def make_grid
    Array.new(8) { Array.new(8) { nil } }
  end
  
  def []=(pos, piece)
    row, col = pos[0], pos[1]
    @grid[row][col] = piece
  end
    
  def set_board
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

