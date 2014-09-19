require 'rubygems'
require 'rubygame'

class Game
  def initialize
    @screen = Rubygame::Screen.new [640, 480], 0, 
                                   [Rubygame::HWSURFACE, Rubygame::DOUBLEBUF]
    @screen.title = "Pong"
    
    @queue = Rubygame::EventQueue.new
    @clock = Rubygame::Clock.new
    @clock.target_framerate = 60
    limit = @screen.height - 10
    @player = Paddle.new 50, 10, Rubygame::K_W, Rubygame::K_S, 10, limit
    @enemy = Paddle.new @screen.width-50-@player.width, 10, Rubygame::K_UP, Rubygame::K_DOWN, 10, limit
    @player.center_y @screen.height
    @enemy.center_y @screen.height
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
    @player.update
    @enemy.update
    @queue.each do |event|
      @player.handle_event event
      @enemy.handle_event event
      case event
      when Rubygame::QuitEvent # The x at the top right corner
        Rubygame.quit
        exit
      when Rubygame::KeyDownEvent
        if event.key == Rubygame::K_ESCAPE
          @queue.push Rubygame::QuitEvent.new  # Not duplicating quit code
        end
      end
    end
  end
  
  def draw
    @screen.fill [0, 0, 0]
    
    @background.draw @screen   
    
    @player.draw @screen  # Draw the player after the background!
    
    @enemy.draw @screen
    
    @screen.flip # Rubygame::Surface#flip displays what we've been drawing to the actual screen
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
  
  def draw screen
    @surface.blit screen, [@x, @y] # Rubygame::Surface#blit method is for drawing a surface onto another surface. Arg1: which surface drawing on, Arg2: where on the surface to draw it.
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
    # Middle Divide
    surface.draw_box_s [surface.width/2-5, 0], [surface.width/2+5, surface.height], white
         
    super 0, 0, surface
  end
end

class Paddle < GameObject
  def initialize x, y, up_key, down_key, top_limit, bottom_limit
    surface = Rubygame::Surface.new [20, 100]
    surface.fill [255, 255, 255]
    @up_key = up_key
    @down_key = down_key
    @moving_up = false
    @moving_down = false
    @top_limit = top_limit
    @bottom_limit = bottom_limit
    super x, y, surface
  end
  
  def center_y h
    @y = h/2-@height/2
  end
  
  def handle_event event
    case event
    when Rubygame::KeyDownEvent  # KeyDownEvent: when user presses a key
      if event.key == @up_key
        @moving_up = true
      elsif event.key == @down_key
        @moving_down = true
      end
    when Rubygame::KeyUpEvent
      if event.key == @up_key
        @moving_up = false
      elsif event.key == @down_key
        @moving_down = false
      end
    end
  end
  
  def update
    if @moving_up and @y > @top_limit
      @y -= 5
    end
    if @moving_down and @y+@height < @bottom_limit
      @y += 5
    end
  end
end

g = Game.new
g.run!