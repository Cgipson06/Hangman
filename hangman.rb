class Hangman
    attr_accessor :answer_array, :incorrect_letters, :word_display
    
    def initialize(incorrect_letters=[], answer_array=[], word_display = [])
      @answer_array = answer_array
      @incorrect_letters = incorrect_letters
      @word_display = word_display
     end
    
    def print_banner
      print "="*40
      print "\n"
      print " Hangman powered by Ruby\n"
      print "="*40
      print "\n" 
    end

    def print_hangman(incorrect)
      hangman_character=["\t\t============\n\t\t|\n\t\t|\n","\t\tO\n","\t\t|\n","\t       \\|/\n","\t\t|\n","\t       / \\"]
      puts hangman_character[0..incorrect]
      (4-incorrect).times do 
        print "\n"
      end
    end

    def display(word_display)
      word_display.each do |a|
        print a
        print ' '
      end
      puts ""
    end

    def get_guess
      puts "Please enter your guess (type save to save the game and quit"
      answer = gets.chomp.downcase
      save_game if answer == 'save'
      answer
    end

    def save_game()
      game = Hangman.new(incorrect_letters,answer_array, word_display)
      puts "answer array: #{answer_array}"
      puts "incorrect_letters : #{incorrect_letters}"
      puts "word_display : #{word_display}"
      File.open('saves', 'wb') { |a| Marshal.dump(game,a)}
      throw :game_over
    end
    
    def display_incorrect_letters(incorrect_letters)
      puts "Incorrect letter list:#{incorrect_letters}"
    end
    
    def game_over?  
      guess_limit = 4  #the hangman character is formatted to complete at the fifth incorrect answer
      if word_display == answer_array
        system ("cls")
        puts "Congratulations!!! You solved the puzzle!"
        sleep 2
        throw :game_over
      elsif incorrect_letters.length > guess_limit
        print_hangman(incorrect_letters.length)
        puts "Sorry, you are out of guesses.  Game Over"
        puts "The answer was #{answer_array.join('')}"
        throw :game_over
      end    
    end
        
    def new_game
      word_display=[] # Holds blank spaces and solved letters for display
      answer_array = [] # Holds the answer in array form
      words = [] #Holds words that meet the criteria for selecting the answer
      incorrect_letters = []
      dictionary = open('5desk.txt','r')
      dictionary.readlines.each do |a|
        words.push(a) if a.length > 5 && a.length < 12
      end
      answer = words.sample.downcase
      ##
      #puts "The answer is #{answer}"   #wanna cheat, or debug?
      ##
      answer.strip.split(//).each do |a|  #populates two arrays, one with the answer, one with blanks for every letter
        word_display.push('_')
        answer_array.push(a)
      end
      @answer_array = answer_array
      @word_display = word_display
      @incorrect_letters = incorrect_letters
      play(incorrect_letters, answer_array, word_display)
    end
   
    def play(incorrect_letters, answer_array, word_display)
      print "\n"
      print "- _ " * 20
      print "\n\n"
        
      catch(:game_over) do
        loop do
          print_banner
          print_hangman(incorrect_letters.length)
          display(@word_display)
          display_incorrect_letters(@incorrect_letters) unless incorrect_letters.empty?
          guess = get_guess
          if answer_array.include?(guess) #will not penalize guessing an already solved letter
            answer_array.each_with_index do  |element,index_value|
              word_display[index_value] = guess if element == guess
            end
            puts "You guessed a letter!"
            puts ""
          else
            incorrect_letters.push(guess)# will totally penalize repeating an incorrect letter, thats why we show them.
            puts "Sorry, that letter is not in the answer :( "
          end
          game_over? 
        
       sleep 1
       system ("cls")
      end
      
    end
    puts "Thanks for playing!! -Cody"
  end
end #of class Hangman


def load_option
  puts "Welcome to Hangman."
  puts "Would you like to load the previous saved game? y/n :"
  input = gets.chomp
  if input.downcase == 'y'
    File.open('saves') {|f| @game = Marshal.load(f) }
    a=Hangman.new(@game.incorrect_letters, @game.answer_array, @game.word_display) 
    a.play(@game.incorrect_letters, @game.answer_array, @game.word_display)
  else
    a=Hangman.new
    a.new_game
  end
end
    
load_option