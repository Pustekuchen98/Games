class Game
  attr_reader :checker, :guesser
  
  def initialize(checker, guesser)
    @board = Board.new
    @checker = checker
    @guesser = guesser
  end
  
  def play
    puts "Welcome to Hangman."
    choose_word
    @number_of_guesses = 15
    until game_over?
      display
      make_player_guess
      @number_of_guesses -= 1 if wrong_guess?
    end
    puts "Congrats! You had #{ @number_of_guesses } guesses left!"
  end
  
  def choose_word
    print "Please choose a word: "
    @chosen_word = @checker.choose_word
    @board.set_word(@chosen_word)
  end
  
  def make_player_guess
    puts "Player two, please choose a letter"
    @players_guess = @guesser.guess_letter(@board.guessed_word)
  end
  
  def wrong_guess?
    !@board.correct_guess?(@players_guess)
  end
  
  def display
    puts "Secret word: #{ @board.guessed_word }"
  end
  
  def game_over?
    @number_of_guesses == 0 || @board.guessed_word == @chosen_word
  end
end
#
# class Player
# end

class HumanPlayer# < Player
  def guess_letter(current_board)
    guess = gets.chomp.scan(/[a-z]{1}/)
    guess[0]
  end
  
  def choose_word
    dictionary = Dictionary.new
    word = gets.chomp
    until dictionary.dict.include? word
      word = gets.chomp
    end
    word
  end
end

class ComputerPlayer# < Player
  def initialize
    @guessed_letters = []
    @dictionary = Dictionary.new
    @possible_words = []
  end
  
  def guess_letter(current_board)
    create_word_list(current_board)
    guess = best_guess(letters_frequency)
    @guessed_letters << guess
    puts "Computer is guessing #{guess}"
    guess
  end
  
  def choose_word
    @dictionary.choose_word
  end
  
  private
  
  def create_word_list(current_board)
    correct_letters = current_board.scan(/[a-z]/)
    wrong_letters = @guessed_letters - correct_letters
    
    # Filter words with wrong lengths and characters
    @possible_words = @dictionary.dict.select do |word|
      word.length == current_board.length &&
      !word.split(//).any? { |i| wrong_letters.include?(i) }
    end
    
    # Select only words with characters in correct position
    regex = generate_regex current_board
    @possible_words.select! { |word| word.match(regex) }
  end
  
  def letters_frequency
    letters = Hash.new(0)
    @possible_words.each do |word|
      word.each_char { |char| letters[char] += 1 }
    end
    letters
  end
  
  def best_guess(letters)
    letters.select! { |k, v| !@guessed_letters.include? k }
    best_guess = letters.select { |k, v| v == letters.values.max }
    
    best_guess.flatten.first    
  end
  
  def generate_regex(pattern)
    regex = ""
    pattern.each_char do |char|
      if char == "-"
        regex += "[a-z]{1}"
      else
        regex += char
      end
    end
    regex
  end
end

class Board
  attr_accessor :guessed_letter, :guessed_word
  
  def draw
  end
  
  def correct_guess?(letter)
    # puts "in correct guess, letter: #{letter}"
    if @word.split(//).include?(letter)
       update_guessed_word(letter)
       return true
    end
    false
  end
  
  def update_guessed_word(letter)
    indices = index(letter)
    indices.each { |i| @guessed_word[i] = letter }
    guessed_word
  end
  
  def index(letter)
    i = -1
    indices = []
    while i = @word.index(letter,i+1)
      indices << i
    end
    indices
  end
  
  def set_word(game_word)
    @word = game_word
    set_guessed_word game_word
  end
  
  def set_guessed_word(chosen_word)
    @guessed_word = "-" * chosen_word.length
  end
  
end

class Dictionary
  attr_accessor :dict
  
  def initialize
    @dict = File.readlines("dictionary.txt").map(&:chomp)
  end
  
  def choose_word
    @dict.sample
  end
end

hangman = Game.new(ComputerPlayer.new, HumanPlayer.new)
#hangman = Game.new(HumanPlayer.new, ComputerPlayer.new)
hangman.play