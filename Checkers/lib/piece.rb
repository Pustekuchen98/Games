class Piece
  attr_accessor :pos
  attr_reader :color, :board
  
  def initialize(board, color, pos)
    @board, @color, @pos = board, color, pos
    @king = false
  end
  
  # Move a piece to new destination
  def move_piece(destination) # remember to check on_board here
    slide_pos_list = self.move_vector_slide.map { |dir| add_vector(self.pos, dir) }
    jump_pos_list = self.move_vector_jump.map { |dir| add_vector(self.pos, dir) }
    
    # Player chose a random destination
    if !slide_pos_list.include?(destination) && !jump_pos_list.include?(destination)
      raise IllegalMoveError.new "Please try again, this move is illegal"
      return false
    # Destination is a slide tile  
    elsif slide_pos_list.include?(destination)
      perform_slide(destination)
    
    # Destination is a jump tile
    else
      perform_jump(destination)           
    end              
  end
  
  def perform_moves(move_sequence)
    if valid_move_sequence?(move_sequence)
      perform_moves!(move_sequence)
    else
      raise IllegalMoveError
    end
  end
  
  # Take a sequence of moves
  def perform_moves!(move_sequence)
    move_piece(move_sequence.first) if move_sequence.size == 1
    move_sequence.each do |destination|
      raise IllegalMoveError unless perform_jump(destination)
    end
  end                
  
  def valid_move_sequence?(move_sequence)
    dup_board = @board.dup
    begin
      dup_board[pos].perform_moves!(move_positions)
    rescue IllegalMoveError
      false
    else
      true
    end
  end
  
  # Check to see if piece reaches back row
  def maybe_promote?
    back_row = @color == :black ? 7 : 0
    @pos[0] == back_row
  end
  
  # turn character into string. Check display_tile in board.rb
  def display
    @color == :black ? "⚫" : "⚪"
  end
  
  # Perform the slide_move
  def perform_slide(destination)
    if @board[destination].nil?
      move!(destination)
      @king = true if maybe_promote?
      return true
    else
      raise IllegalMoveError.new "Please try again, this move is illegal"
      return false
    end                               
  end                                          
  
  # Perform the jump_move
  def perform_jump(destination)
    if prey_exist?(@pos, destination)
      prey_pos = prey_position(self.pos, destination)
      move!(destination)
      @board[prey_pos] = nil
      @king = true if maybe_promote?
      return true 
    else
      raise IllegalMoveError.new "Please try again, this move is illegal"
      return false
    end
  end
  
  # Perform the move
  def move!(destination)
    @board[destination] = Piece.new(@board, self.color, destination)
    @board[self.pos] = nil
  end
  
  # Check if there is an enemy between original position and destination position                   
  def prey_exist?(origin, destination)
    prey_pos = prey_position(origin, destination)
    if @board[prey_pos].nil?
      return false
    else 
      return false if color_match?(origin, prey_pos)
    end
    true
  end
  
  # Find the position of the prey
  def prey_position(origin, destination)
    row_vector = (destination[0] - origin[0]) / 2
    col_vector = (destination[1] - origin[1]) / 2
    add_vector(origin, [row_vector, col_vector])
  end
  
  # Return the direction-vector a piece can slide to
  def move_vector_slide
    if @king
      move_vector = [1, -1].product([-1, -1]) 
    else
      move_vector = (@color == :black) ? [[1, 1], [1, -1]] : [[-1, 1], [-1, -1]] 
    end
  end
  
  # Return the direction-vector a piece can jump to  
  def move_vector_jump
    if @king
      move_vector = [2, 2].product([-2, -2])
    else
      move_vector = (@color == :black) ? [[2, 2], [2, -2]] : [[-2, 2], [-2, -2]] 
    end
  end
  
  # Check if 2 pieces have same color
  def color_match?(pos1, pos2)
    @board[pos1].color == @board[pos2].color    
  end
  
  # Create a new position from original position and direction vector
  def add_vector(pos, dir)
    row = pos[0] + dir[0]
    col = pos[1] + dir[1]
    [row, col]
  end
end

class IllegalMoveError < RuntimeError
end