require "pry-byebug"
class Game

    def initialize
        puts "Welcome to mastermind!"
        puts "This game is about cracking a code in a chosen number of turns."
        puts "The code is made of 4 digits, each between 1 and 6."
        puts "X means match, O correct number, wrong place.\n"
        puts "Do you want to set the code or choice it? Enter m to make and b to break"

        @maker = ""
        while @maker != "m" && @maker != "b"
            @maker = gets.chomp
        end

        puts "How many choicees to a max of 20?"
        @rounds = 0
        while @rounds < 1 || @rounds > 20
            @rounds = gets.chomp.to_i
        end

        @code = []
        if @maker == "b"
            4.times {@code.push(rand(1..6))}
        elsif @maker == "m"
            unless @code.all? {|num| num.between?(1,6)} && code.length == 4
                puts "Enter a 4 digit code with each digit between 1 and 6"
                pick = gets.chomp.to_s.split("")
                pick.map! {|num| num.to_i}
                @code = pick
            end  
            
        end
        @poss = []
        @choice = []
        @hints = []
        @ended = false
    end

    attr_accessor :ended, :code, :choice, :hints, :poss, :maker
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

    def fill_possibilities
        a = 1
        while a <= 6 do
            b = 1
            while b <= 6 do
                c = 1
                while c <= 6 do
                    d = 1
                    while d <= 6 do
                        @poss.push([a,b,c,d])
                        d += 1
                    end
                    c += 1
                end
                b += 1
            end
            a += 1
        end
    end

    def remove_impossibles
        index = 0
        while index < @poss.length do
            if hints.count("X") == 0 && hints.count("O") == 0
                if @poss[index].include?(@choice[0]) || @poss[index].include?(@choice[1]) ||
                    @poss[index].include?(@choice[2]) || @poss[index].include?(@choice[3])
                    @poss.delete_at(index)
                else
                    index += 1
                end
            elsif hints.count("X") == 1
                if @poss[index][0] == @choice[0] || @poss[index][1] == @choice[1] ||
                    @poss[index][2] == @choice[2] || @poss[index][3] == @choice[3]
                index += 1
                else
                    @poss.delete_at(index)
                end
            elsif hints.count("X") == 2
                if (@poss[index][0] == @choice[0] && @poss[index][1] == @choice[1]) || 
                    (@poss[index][0] == @choice[0] && @poss[index][2] == @choice[2]) ||
                    (@poss[index][0] == @choice[0] && @poss[index][3] == @choice[3]) ||
                    (@poss[index][1] == @choice[1] && @poss[index][2] == @choice[2]) ||
                    (@poss[index][1] == @choice[1] && @poss[index][3] == @choice[3]) ||
                    (@poss[index][2] == @choice[2] && @poss[index][3] == @choice[3])
                    index += 1
                else
                    @poss.delete_at(index)
                end
            elsif hints.count("X") == 3
                if (@poss[index][0] == @choice[0] && @poss[index][1] == @choice[1] && @poss[index][2] == @choice[2]) ||
                    (@poss[index][0] == @choice[0] && @poss[index][1] == @choice[1] && @poss[index][3] == @choice[3]) ||
                    (@poss[index][0] == @choice[0] && @poss[index][2] == @choice[2] && @poss[index][3] == @choice[3]) ||
                    (@poss[index][1] == @choice[1] && @poss[index][2] == @choice[2] && @poss[index][3] == @choice[3])
                    index += 1
                else
                    @poss.delete_at(index)
                end
            else
                index = @poss.length
            end
            @poss.delete(@choice)
        
        # subindex = 0
        # while subindex < @poss.length do
        #     if hints.count("O") == 1
        #         if @poss[subindex].include?(choice[0]) || @poss[subindex].include?(choice[1]) ||
        #             @poss[subindex].include?(choice[2]) || @poss[subindex].include?(choice[3])
        #             subindex += 1
        #         else
        #             @puss.delete_at(subindex)
        #         end
        #     end
        end
    end

    def play_round
        i = 1
        if @maker == "m"
            self.fill_possibilities
        end
        while @ended == false && i <= @rounds
            if @maker == "b"
                self.enter_code
                if @code == @choice
                    puts "You cracked the code, it was #{@code}"
                    puts "It took you #{i} turns"
                    @ended = true
                    return
                else
                    self.compare_codes
                    p @hints
                    i+=1
                end
            elsif @maker == "m"
                @choice = @poss.sample
                p @choice
                if @code == @choice
                    puts "The computer cracked the code, it was #{@code}"
                    puts "It took #{i} turns"
                    @ended = true
                    return
                else
                    self.compare_codes
                    p @hints
                    puts "Computing..."
                    self.remove_impossibles
                    i += 1
                    sleep 2
                end
            end

        end
        if i > @rounds
            puts "You're out of choicees, better luck next time"
            p @code
        end
    end
end


game = Game.new
game.play_round
