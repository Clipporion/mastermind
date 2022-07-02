require "pry-byebug"
class Game

    def initialize
        puts "Welcome to mastermind!"
        puts "In this game you have to crack the code the computer set for you!"
        puts "The code is made of 4 digits, each between 1 and 6."
        puts "X means match, O means included number"
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
        copy_choice = @choice.map {|num| num}
        copy_code = @code.map {|num| num}

        while i < copy_choice.length
            if copy_choice[i] == copy_code[i]
                @hints.push("X")
                copy_choice.delete_at(i)
                copy_code.delete_at(i)
            else
                i+=1
            end
        end

        copy_choice.map! {|num| num.to_s}
        copy_code.map! {|num| num.to_s}
        copy_choice.each do |num|
            if copy_code.include?(num)
                @hints.push("O")
                copy_code.slice!(copy_code.index(num))
            end
        end
    end

    def play_round
        i = 1
        while @ended == false && i <= @rounds
            self.enter_code
            if @code == @choice
                puts "You cracked the code, it was #{@code}"
                puts "It took you #{@rounds} turns"
                @ended = true
                return
            else
                self.compare_codes
                p @hints
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
