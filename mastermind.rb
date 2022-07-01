class Game

    def initialize
        puts "Welcome to mastermind!"
        puts "In this game you have to crack the code the computer set for you!"
        puts "The code is made of 4 digits, each between 1 and 6."
        puts "How many guesses do you want to make"
        @rounds = gets.chomp.to_i
        @code = []
        @choice = []
        @hints = []
        @ended = false
        4.times{@code.push(rand(1..6))}
    end

    attr_accessor :ended, :code, :choice, :hints
    attr_reader :rounds
    
    def enter_code
        puts "Enter a 4 digit code with each digit between 1 and 6"
        pick = gets.chomp.to_s.split("")
        pick.map! {|num| num.to_i}
        if pick.all? {|num| num.between?(1,6)} && pick.length == 4
            @choice = pick
        else
            "This was not a valid code"
            self.enter_code
        end
    end

    def compare_codes
        i = 0
        @hints = []
        # copy_choice = choice.map {|num| num}
        # copy_code = choice.map {num| num}
        while i < 4
            if @choice[i] == @code[i]
                @hints.push("X")
            elsif @code.include?(@choice[i])
                @hints.push("O")
            end
            i+=1
        end
        @hints.sort! {|a,b| b<=>a}
    end

    def play_round
        i = 1
        while @ended == false && i <= @rounds
            self.enter_code
            if @code == @choice
                puts "You cracked the code, it was #{@code}"
                @ended = true
                return
            else
                self.compare_codes
                p @hints
                puts ("Each X represents a correct number in the right place, each O represents a correct number in a wrong place")
                i+=1
            end
        end
        if i > @rounds
            puts "You're out of guesses, better luck next time"
            p @code
        end
    end
end

game = Game.new
game.play_round
