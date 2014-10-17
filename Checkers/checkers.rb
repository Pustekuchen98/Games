require_relative './lib/board'
require_relative './lib/piece'
require_relative './lib/player'
require 'colorize'

class Game
  attr_accessor :current_board
  attr_reader :players
  
  def initialize
    @current_board = Board.new(true)
    player1 = Player.new(@current_board, :red)
    player2 = Player.new(@current_board, :black)
    @players = [player1, player2]
    setup_player_name
  end
  
  def play
    until @current_board.over?
      board.display(current_player.name, current_player.cursor_pos)
      play_turn
    end
    puts "Game over. #{@players.last.name} won!"
    puts "Thanks for playing!"
  end
    
  def setup_player_name
    system('clear')
    players.each_with_index do |player, player_idx| 
      player.set_name(player_idx + 1) 
    end
  end
  
  def current_player
    players.first
  end
  
  def change_turn
    players.rotate!
  end
  
  def play_turn
    source_pos, dest_pos = current_player.move
    @current_board[source_pos].perform_moves(dest_pos)
    change_turn
  
  rescue IllegalMoveError => e
    board.display(current_player.name, current_player.cursor_pos)
    puts "#{e.class}: #{e.message}"
    retry
  end
end

game = Checkers.new
game.play
