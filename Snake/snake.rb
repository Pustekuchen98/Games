#!/usr/bin/ruby

require 'gtk+3'
require './board'

class RubyApp < Gtk::Window

    def initialize
        super
    
        set_title "Snake"
        signal_connect "destroy" do 
            Gtk.main_quit 
        end
        
        @board = Board.new
        signal_connect "key-press-event" do |w, e|
            on_key_down w, e
        end
        
        add @board

        set_default_size WIDTH, HEIGHT
        set_window_position :center
        show_all
    end
    
    def on_key_down widget, event 
     
        key = event.keyval
        @board.on_key_down event
    end
end

Gtk.init
    window = RubyApp.new
Gtk.main