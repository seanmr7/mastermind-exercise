# Defines solution creation and guess methods for human player.
module Human_Player
  def guess
    @colors = []
    4.times do
      puts 'What\'s your guess: '
      @colors << gets.chomp
    end
  end

  def define_solution
    4.times do
      puts 'Create a solution using colors: (r)ed, (g)reen, (y)ellow, (b)lue'
      @colors << gets.chomp
    end
    puts "Your code is #{@colors}"
  end
end

# Defines solution creation and guess methods for computer player.
module Computer_player
  def solution_and_guess
    @colors = []
    4.times do
      choice = rand(1..4)
      case choice
      when 1
        @colors << 'r'
      when 2
        @colors << 'g'
      when 3
        @colors << 'y'
      when 4
        @colors << 'b'
      end
    end
    @colors
  end

  def guess
    solution = Game.give_solution
    @colors.each_with_index do |color, idx|
      if color == solution[idx]
        @colors[idx] = solution[idx]
      else
        choice = rand(1..4)
        case choice
        when 1
          @colors[idx] = 'r'
        when 2
          @colors[idx] = 'g'
        when 3
          @colors[idx] = 'y'
        when 4
          @colors[idx] = 'b'
        end
      end
    end
    @colors
  end
end

# Creates CodeBreaker classs to initialize colors array.
class CodeBreaker
  include Human_Player
  include Computer_player
  attr_accessor :colors
  def initialize
    @colors = []
  end
end

# Creates CodeMaker classs to initialize colors array.
class CodeMaker
  include Human_Player
  include Computer_player
  attr_accessor :colors
  def initialize
    @colors = []
  end
end

# Create Game class and methods to play mastermind.
class Game
  attr_accessor :colors
  @@guesses = 1
  @@solution = []

  def initialize
    puts 'Welcome to Mastermind. Get ready to play'
    puts 'Do you want to be the codemaker?'
    answer = gets.chomp
    if answer == 'y' || answer == 'Y'
      @human = CodeMaker.new
      @computer = CodeBreaker.new
    else
      @human = CodeBreaker.new
      @computer = CodeMaker.new
    end
    @feedback = []
    @guess = []
  end

  def self.give_solution
    @@solution
  end

  def total_guess
    @@guesses
  end

  def start_game
    if @human.instance_of? CodeMaker
      @@solution = @human.define_solution
    else
      @@solution = @computer.solution_and_guess
      puts 'Your oppenent has generated a solution made up of: (r)ed, (g)reen, (b)lue, and (y)ellow.'
    end
  end

  def turn
    if @human.instance_of? CodeMaker
      @@guesses == 1 ? @guess = @computer.solution_and_guess : @guess = @computer.guess
    else
      @guess = @human.guess
    end
    @@guesses += 1
  end

  def compare
    if @guess == @@solution
      true
    else
      false
    end
  end

  def give_feedback
    @feedback = []
    p @guess
    @guess.each_with_index do |color, idx|
      if @guess[idx] == @@solution[idx]
        @feedback << "Correct Space and color for #{color}"
      elsif @@solution.include?(color) && @guess[idx] != @@solution[idx]
        @feedback << "Correct color incorrect space for #{color}"
      elsif @@solution.include?(color) != true
        @feedback << '--'
      else
        @feedback << '--'
      end
    end
    p @feedback
  end

  def win_statement
    if @human.instance_of? CodeBreaker
      puts 'You found the solution! You WIN!'
    else
      puts 'The computer found the solution and WON!'
    end
  end

  def lose_statement
    if @human.instance_of? CodeBreaker
      puts "You lost, the solution was #{@solution}"
    else
      puts "The computer couldn't solve your code!"
    end
  end

  def play_game
    while @@guesses <= 12
      puts "Turn #{@@guesses}"
      turn
      compare
      give_feedback
      if compare
        win_statement
        break
      end
    end
    lose_statement unless compare
  end
end

new_game = Game.new
new_game.start_game
new_game.play_game
