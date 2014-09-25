require 'rubygems'
require 'rubygame'
require './lib/shared.rb'
require './lib/ingame.rb'
Rubygame::TTF.setup
 
class Game
    attr_accessor :screen, :queue, :clock, :state
    def initialize
        @screen = Rubygame::Screen.new [640, 480], 0, [Rubygame::HWSURFACE, Rubygame::DOUBLEBUF]
        @screen.title = "Pong"
         
        @queue = Rubygame::EventQueue.new
        @clock = Rubygame::Clock.new
        @clock.target_framerate = 60
         
        # The state has to be changed by the developer
        # using the game class, or else the game won't
        # start successfully
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
        @queue.peek_each do |ev|
            case ev
                when Rubygame::QuitEvent
                    Rubygame.quit
                    exit
                when Rubygame::KeyDownEvent
                    if ev.key == Rubygame::K_ESCAPE
                        @queue.push Rubygame::QuitEvent.new
                    end
            end
        end
        @state.update
        if @state_buffer != nil
            @state = @state_buffer
            @state_buffer = nil
        end
    end
     
    def draw
        @state.draw
    end
     
    def switch_state state
        if @state != nil
            @state_buffer = state
        else
            @state = state
        end
    end
end
 
g = Game.new
g.switch_state InGame.new(g)
g.run!