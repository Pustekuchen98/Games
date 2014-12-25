class Player
    attr_accessor :cursor_pos

    def initialize(color)
        @color = color
        @cursor_pos = [4, 4]
    end

    def set_name(player_number)
        puts "Player #{player_number}, you will be #{color.capitalize}."
        puts "What is your name?"
        self.name = gets.chomp
    end

    def move
        [select_pos, select_pos]
    end

    def play_turn(board)
        @turn = true
        begin                
            if board[origin].color != @color
                raise IllegalMoveError.new "What's ya doin'? Trying to cheat?"  
            end  
            board.move_piece(origin, destination)   
        rescue IllegalMoveError => e
            puts "Could not perform move."
            puts "Error was #{e.message}"
            retry
        end
    end

    def select_pos
        until get_input == ' '
            new_cursor_pos = vector(cursor_dir(get_input))
            move_cursor(cursor_pos, new_cursor_pos)
            board.display(color, name, cursor_pos)
            cursor_pos
        end

    end
    private
    def get_input
        begin
            user_input = STDIN.getch
            unless ['^[[A', '^[[B', '^[[D', '^[[C', ' '].include?(user_input)
                raise InputError.new "Unexpected input."
            end
        rescue InputError
            retry
        end
        user_input
    end

    def cursor_dir(user_input)
        case user_input
        when '^[[A' then :up
        when '^[[B' then :down
        when '^[[D' then :left
        when '^[[C' then :right
        end
    end

    def vector(direction)
        case direction
        when :up then [0, -1]
        when :down then [0, 1]
        when :right then [1, 0]
        when :left then [-1, 0]
        end
    end

    def move_cursor(cursor_pos, vector)
        drow, dcol = vector[0], vector[1]
        new_cursor_pos = [cursor_pos[0] + drow, cursor_pos[1] + dcol]
        self.cursor_pos = new_cursor_pos unless board.offboard?(new_cursor_pos)
    end

end

