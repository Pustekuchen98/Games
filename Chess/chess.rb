# encoding: utf-8

require_relative "./lib/board"
require_relative "./lib/player"
require 'io/console'

class Chess
  attr_accessor :current_board
  
  def initialize
    @current_board = Board.new(true)
    @player1 = Player.new(:white)
    @player2 = Player.new(:black)
  end
  
  def play
    system('clear')
    @current_board.display
    @player1.play_turn(@current_board)
    until game_over?
      system('clear')
      @current_board.display
      begin
      if @turn
        puts "It's White's turn"
        @player1.play_turn(@current_board)
      else
        puts "It's Black's turn"
        @player2.play_turn(@current_board)
      end
      rescue IllegalMoveError => e
        puts "#{e.message}"
        retry
      end
      @turn = !@turn
    end
    
    puts "Game over!!!"    
  end

  def game_over?
    @current_board.check_mate?(:white) || @current_board.check_mate?(:black)
  end
end

c = Chess.new
c.play

class IllegalMoveError < RuntimeError
end

class InputError < RuntimeErro
end
