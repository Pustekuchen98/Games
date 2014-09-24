# Great thanks to http://devel.manwithcode.com/making-games-with-ruby.html!! 

require 'rubygems'
require 'rubygame'
require './lib/shared.rb'
require './lib/ingame.rb'
Rubygame::TTF.setup

class Game
  attr_accessore :screen, :queue, :clock, :state
  
  def initialize
    @screen = Rubygame::Screen.new [640, 480], 0, [Rubygame::HWSURFACE, Rubygame::DOUBLEBUF]
    @screen.title = "Ruby Pong"
    
    @queue = Rubygame::EventQueue.new
    @clock = Rubygame::Clock.new
    @clock.target_framerate = 60
    
    @state = nil
    @state_buffer = nil
  end
  
  def run!
    loop do
      update
      draw
      @clock.tick
    end
  end
  
  def update 
    @queue.peek_each 