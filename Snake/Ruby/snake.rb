require 'rubygems'
require 'rubygame'

class Game
  def initialize
    @screen = Rubygame::Screen.new [640, 480], 0, [Rubygame::HWSURFACE, Rubygame::DOUBLEBUF]
    @screen.title = "Snake"
    
    @queue = Rubygame::EventQueue.new
    @clock = Rubygame::Clock.new
    @clock.target_framerate = 60
    
    @snake = Snake.new 50, 100
    @background = Background.new @screen.width, @screen.height
  end
  
  def run!
    loop do
      update
      draw
      @clock.tick
    end
  end
  
  def update
    @snake.update
    @queue.each do |event|
      @snake.handle_event event
      case event
      when Rubygame::QuitEvent
        Rubygame.quit
        exit
      end
    end
  end
  
  def draw
    @screen.fill [0, 0, 0]
    
    @background.draw @screen
    @snake.draw @screen
    
    @screen.flip
  end
end

class GameObject
  attr_accessor :x, :y, :width, :height, :surface
  
  def initialize x, y, surface
    @x = x
    @y = y
    @surface = surface
    @width = surface.width
    @height = surface.height
  end
  
  def update
  end
  
  def center_y h
    @y = h/2-@height/2
  end
  
  def draw screen
    @surface.blit screen, [@x, @y]
  end
  
  def handle_event event
  end
end

class Background < GameObject
  def initialize width, height
    surface = Rubygame::Surface.new [width, height]
    
    # Draw background
    white = [255, 255, 255]
     
    # Top
    surface.draw_box_s [0, 0], [surface.width, 10], white
    # Left
    surface.draw_box_s [0, 0], [10, surface.height], white
    # Bottom
    surface.draw_box_s [0, surface.height-10], [surface.width, surface.height], white
    # Right
    surface.draw_box_s [surface.width-10, 0], [surface.width, surface.height], white
    
    super 0, 0, surface
  end
end

class Snake < GameObject
  def initialize x, y, size
    @dead = false
    @segments = []
    @length = 60
     = Rubygame::Surface.new [20, @length]
    surface.fill [255, 255, 255]
    super x, y, surface
  end
  
  def length
    @segments.size
  end
  
  def handle_event event
    case event
    when Rubygame::KeyDownEvent
      if event.key == Rubygame::K_UP
        move_up
      elsif event.key == Rubygame::K_DOWN
        move_down
      elsif event.key == Rubygame::K_LEFT
        move_left
      elsif event.key == Rubygame::K_RIGHT
        move_right
      end
  end
  
  def move_snake
    @segments.reverse.each_with_index do |segment, i|
      if i + 1 == length
        segment
  
  def grow
    @height += 10
  end
  
  def update
  end
end

g = Game.new
g.run!