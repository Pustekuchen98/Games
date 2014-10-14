class Board
  attr_accessor :board
  attr_reader :win_pos
  
  def initialize
    @board = Array.new(9) { " " }
    @win_pos = [[0, 1, 2], [3, 4, 5], [6, 7, 8],
                [0, 3, 6], [1, 4, 7], [2, 5, 8],
                [0, 4, 8], [2, 4, 6]]
  end
  
  def find_array pos
      result = []
      @win_pos.each { |i| result << i if i.include?(pos) }
      result
  end
  
  def materialize combo
      combo.map {|x| x.map {|y| board[y]}}
  end
  
  # Check if the latest move is a winning move
  def won? pos, mark
      checklist = materialize(find_array pos)
      checklist.each { |arr| return true if arr.count(mark) == 3 }
      false
  end
  
  def empty?(pos)
    board[pos] == " "
  end
  
  def place_mark(pos, mark)
    board[pos] = mark
  end
  
  def empty_list
      result = []
      board.each_with_index { |item, index| result << index if item == " " }
      result
  end
  
  def winner_move mark
    empty_checklist = self.empty_list
    
    empty_checklist.each do |i|
        win_checklist = materialize(find_array i)
        win_checklist.each { |arr| return i if arr.count(mark) == 2 }
    end
    nil
  end
  
  def finish? game_won
      game_won || !board.include?(" ")
  end
  
end

class Player     
  attr_accessor :mark
  
  def initialize mark
    @mark = mark
  end
  
end

class HumanPlayer < Player
  def move board
    puts "Please choose a position"
    pos = gets.chomp.to_i - 1
    until valid_move pos, board
      puts "Choose again!"
      pos = gets.chomp.to_i - 1
    end
    board.place_mark(pos, mark)
    pos
  end
  
  def valid_move pos, board
    pos.between?(0, 8) && board.empty_list.include?(pos)
  end
end

class ComputerPlayer < Player
  def move board
    winner_move = board.winner_move(mark)
    pos = winner_move ? winner_move : generate_move(board)
    board.place_mark(pos, mark)
    pos
  end
  
  def generate_move board
    board.empty_list.sample
  end
end


class Game
  attr_reader :my_board, :human_player, :computer, :human_mark, :computer_mark
  
  def initialize
    @my_board = Board.new
  end

  def begin_game
    puts "Please choose a mark between X and O"
    @human_mark = gets.chomp
    until valid_mark? @human_mark
      puts "Choose again!"
      @human_mark = gets.chomp
    end
    @human_player = HumanPlayer.new(human_mark) 
    @computer_mark = (human_mark == "X" ? "O" : "X")
    @computer = ComputerPlayer.new(computer_mark)
  end
  
  def valid_mark? mark
      ["X", "O"].include?(mark)
  end

  def play
    begin_game
    human_turn = (human_mark == "X")
    game_won = false
    last_player = nil
    until my_board.finish? game_won
      display
      pos = human_turn ? human_player.move(my_board) : computer.move(my_board)
      last_player = human_turn ? human_mark : computer_mark
      game_won = my_board.won? pos, last_player
      human_turn = !human_turn
    end
    
    if game_won
        puts "#{last_player} won the game!"
    else
        puts "Game draw!"
    end
    
    display
  end

  
  def display
    puts "---------"
    3.times do |i|
      j = i * 3
      puts "#{ my_board.board[j] } | #{ my_board.board[j + 1] } | #{ my_board.board[j + 2] }"
    end
    puts "---------"
  end
end

g = Game.new
g.play