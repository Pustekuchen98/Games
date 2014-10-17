class Player
  attr_accessor :name, :color, :board, :cursor_pos
  
  def initialize(board, color)
    @board, @color = board, color
    @cursor_pos = [4, 4]
  end
  
  def set_name(player_number)
    puts "Player #{player_number}, you will be #{@color.capitalize}."
    puts "What is your name?"
    self.name = gets.chomp
  end
  
  # Take the move from two consecutive selected positions 
  def move
    [select_pos, select_pos]
  end
  
  def select_pos
    until get_input == ' '
      new_cursor_pos = vector(cursor_dir(get_input)
      move_cursor(cursor_pos, new_cursor_pos)
      @board.display(color, name, cursor_pos)
    end
    cursor_pos
  end
  
  private
  
  # Get input from keyboard
  def get_input
    begin
      user_input = STDIN.getch
      unless ['^[[A', '^[[B', '^[[D', '^[[C', ' '].include?(user_input)
        raise InputError.new "Wrong input. Please try again"
      end
    rescue InputError => e
      puts e.message
      retry
    end
    user_input
  end
  
  # Translate input into direction
  def cursor_dir(user_input)
    case user_input
      when '^[[A' then :up
      when '^[[B' then :down
      when '^[[D' then :left
      when '^[[C' then :right
    end
  end
  
  # Translate direction into coordinates
  def vector(direction)
    case direction
      when :up then [0, -1]
      when :down then [0, 1]
      when :right then [1, 0]
      when :left then [-1, 0]
    end
  end
  
  def move_cursor(cursor_pos, vector)
    new_cursor_pos = [cursor_pos[0] + vector[0], cursor_pos[1] + vector[1]]
    self.cursor_pos = new_cursor_pos unless self.board.offboard?(new_cursor_pos)
  end
  
end