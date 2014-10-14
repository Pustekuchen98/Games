class Tile
  attr_reader :bomb, :flagged, :revealed
  
  def initialize(board, position, bomb = false)
    @board = board
    @position = position
    @flagged = false
    @revealed = false
    @bomb = bomb
  end
  
  def reveal
    return self if revealed || flagged

    neighbors = self.neighbors_list

    @revealed = true                
    if self.neighbors_bomb_count == 0
      neighbors.each { |neighbor| neighbor.reveal }                  
    end
                       
  end
  
  def neighbors_list 
    row = @position[0]
    col = @position[1]
    upper_bound = @board.board.count - 1
    # use product to find all coordinates
    [row + 1, row - 1, row].product([col + 1, col - 1, col])[0..-2].select do |pos|
      # only take those within boundaries
      pos[0].between?(0, upper_bound) && pos[1].between?(0, upper_bound)
    end.map { |pos| @board[pos] } # map to tiles   
  end
  
  def neighbors_bomb_count
    self.neighbors_list.select { |tile| tile.bomb }.count
  end
  
  def show
    return :F if flagged
    if revealed
      return :B if bomb
      count = neighbors_bomb_count
      return :_ if count == 0
      return count
    else
      return :*
    end
  end
  
  def flag
    @flagged = !@flagged
  end

  
end

class Board
  
  attr_accessor :board
  
  def initialize(size)
    make_board(size)
  end
  
  def [](pos)
    row, col = pos
    @board[row][col]
  end
  
  def won?
    @board.flatten.none? { |tile| tile.bomb != tile.flagged }
  end
  
  def lose?
     @board.flatten.any? { |tile| tile.bomb && tile.revealed }       
  end
    
  def display
    @board[0].count.times { |idx1| print "   #{idx1}" }
    puts
      
    @board.each_with_index do |row, idx2|
      puts "----" * row.count + "--"
      print idx2
      row.each do |tile|
        print "| #{tile.show} "
      end
      print "|"
      puts
    end
    puts "----" * @board[0].count + "-"
  end
  
  private
  def seed_bomb
    num = rand(100)
    return (num < 15) ? true : false
  end
  
  def make_board(size)
    @board = Array.new(size) { Array.new(size) }
    @board.count.times do |row|
      @board.count.times do |col|
        @board[row][col] = Tile.new(self, [row, col], bomb = seed_bomb)
      end
    end
  end

end

class Game
  def initialize(n = 9)
    @board = Board.new(n)
  end
  
  def play
    display
    pos = [0, 0]
    until over?
      pos, action = get_input
      move(action, pos)
      display
    end
    
    puts @board.lose? ? "You Lose, sorry!" : "You Win!"  
      
  end
  
  private
  
  def get_input
    puts "please choose a position row, col"
    pos = gets.chomp.split(",").map(&:to_i)
    puts "please choose an action (flag or reveal)"
    action = gets.chomp
    [pos, action]
  end
  
  def move(action, pos)
    if action == "flag"
      @board[pos].flag
    else
      @board[pos].reveal
    end
  end
  
  def display
    @board.display
  end
  
  def over?
    return true if @board.won? || @board.lose? 
    false
  end  
end

g = Game.new(5)
g.play