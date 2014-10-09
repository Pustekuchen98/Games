require 'rubygems'
require 'rubygame'
require './lib/shared.rb'
require './lib/pause.rb'
require './lib/ingame.rb'

class Pause
  def intialize game, old_state
    @game = game
    @screen = game.screen
    @queue = game.queue
    @old_state = old_state
    
    @text = Text.new 0, 0, "Paused", 100
    @text.center_x @screen.width
    @text.center_y @screen.height
  end
  
  def update
    @queue.each do |event|
      case event
      when Rubygame::KeyDownEvent
        if event.key == Rubygame::K_P
          @game.switch_state @old_state
        end
      end
    end
  end
  
  def draw
    @screen.fill [0, 0, 0]
    @text.draw @screen
    @screen.flip
  end
end