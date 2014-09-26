require 'rubygems'
require 'rubygame'
require './lib/shared.rb'
require './lib/pause.rb'
require './lib/title.rb'
require './lib/ingame.rb'


class Title
    def initialize game
        @game = game
        @screen = game.screen
        @queue = game.queue
 
        @title_text = Text.new 0, 35, "Pong", 100
        @play_text = Text.new 0, 200, "Play Game", 50
        @about_text = Text.new 0, 275, "About", 50
        @quit_text = Text.new 0, 350, "Quit", 50
        [@title_text, @play_text, @about_text, @quit_text].each { |text| text.center_x @screen.width }
        @line = GameObject.new(0, 150, Rubygame::Surface.new([@screen.width,10]).fill([255,255,255]))
    end
 
    def update
        @queue.each do |ev|
        end
    end
 
    def draw
        @screen.fill [0, 0, 0]
 
        [@title_text, @play_text, @about_text, @quit_text, @line].each { |text| text.draw @screen }
 
        @screen.flip
    end
end

class Selector < GameObject
  attr_reader :choice
  def initialize *texts
    @texts = texts
    @choice = 0
    @x = @x2 = 0
    @y = @texts[0].y+3
    @speed = 10
    @left = Rubygame::Surface.new [5, 40]
    @right = Rubygame::Surface.new [5, 40]
    @left.fill [255, 255, 255]
    @right.fill [255, 255, 255]
    super x, y, @left
  end

  def update
    x_target = @texts[@choice].x-10
    x2_target = @texts[@choice].x+@texts[@choice].width+4
    y_target = @texts[@choice].y+3
    if @x != x_target and (@x-x_target).abs <= @speed
        @x = x_target
    elsif @x < x_target
        @x += @speed
    elsif @x > x_target
        @x -= @speed
    end
    if @x2 != x2_target and (@x2-x2_target).abs <= @speed
        @x2 = x2_target
    elsif @x2 < x2_target
        @x2 += @speed
    elsif @x2 > x2_target
        @x2 -= @speed
    end
    if @y != y_target and (@y-y_target).abs <= @speed
        @y = y_target
    elsif @y < y_target
        @y += @speed
    elsif @y > y_target
        @y -= @speed
    end
  end
     
  def draw screen
    @left.blit screen, [@x, @y]
    @right.blit screen, [@x2, @y]
  end
     
 def handle_event event
        case event
            when Rubygame::KeyDownEvent
                if event.key == Rubygame::K_UP
                    unless @choice == 0
                        @choice -= 1
                    end
                end
                if event.key == Rubygame::K_DOWN
                    unless @choice == @texts.length-1
                        @choice += 1
                    end
                end
        end
  end
end  
