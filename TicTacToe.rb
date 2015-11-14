class Tictactoe

	attr_reader :player1_win_count, :player2_win_count, :draw_count
	attr_accessor :board

	WINNING_BOARDS = [ [1,2,3], [4,5,6], [7,8,9], [1,4,7], [2,5,8], [3,6,9], [1,5,9], [7,5,3] ]

	def initialize
		@player1_win_count = 0
		@player2_win_count = 0
		@draw_count = 0
		reset_board
	end

#-----------Setup--------------

def introduction
		puts "-------Welcome to Noughts and Crosses!-------\n "
		instruction_board
		puts "\n"
		game_mode
		choose_names
	end

	def instruction_board
		puts "When playing, chose a position using the corresponding numbers as shown:"
		@board = { 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5, 6 => 6, 7 => 7, 8 => 8, 9 => 9 }
		show_board
	end

	def reset_board
		@board = { 1 => " ", 2 => " ", 3 => " ", 4 => " ", 5 => " ", 6 => " ", 7 => " ", 8 => " ", 9 => " " }
	end

	def show_board
		line = "---+---+---"
		puts " #{@board[7]} | #{@board[8]} | #{@board[9]} "
		puts line
		puts " #{@board[4]} | #{@board[5]} | #{@board[6]} "
		puts line
		puts " #{@board[1]} | #{@board[2]} | #{@board[3]} "
	end

	def choose_names
		puts "Player 1, what's your name?"
		@player1 = gets.chomp
		puts "\n"
		puts "Player 2, what's your name?"
		if !@ai
			@player2 = gets.chomp
		else
			ai_type_name
			@player2 = "HAL"
		end
		puts "\n"
	end

	def ai_type_name
		sleep(0.7)
		print "H"
		sleep(0.2)
		print("A")
		sleep(0.4)
		print("L")
		sleep(0.5)
		print("\n")
	end

	def game_mode
		puts "Would you like to play against the computer or with a friend?\n[1] - Computer\n[2] - Friend"
		@num_players = gets.to_i
		while @num_players != 1 && @num_players != 2
			puts "Sorry, please enter either 1 or 2.\n[1] - Computer\n[2] - Friend"
			@num_players = gets.to_i
		end
		@ai = (@num_players == 1 ? true : false)
		@num_players
	end

	def start_game
		introduction
		reset_board
		play
	end

#-----------Between games----------------

	def play_again?
		@winner = nil
		@game_draw = nil
		puts " \nWould you like to play again?[Y/N]"
		new_game = gets.chomp
		if new_game[0].upcase == "Y"
			reset_board
			play
		else
			puts "Goodbye!"
		end
	end

	def increase_scores
			if @winner == @player1
				@player1_win_count += 1
			elsif @winner == @player2
				@player2_win_count += 1
			else
				@draw_count += 1
			end
	end

	def show_scores
		puts "#{@player1} wins: #{@player1_win_count}"
		puts "#{@player2} wins: #{@player2_win_count}"
		puts "Draws: #{@draw_count}"
	end

#---------Win/draw checks-------------

	def check_winner
		WINNING_BOARDS.each do |win_board|
			if @board[win_board[0]] != " " && @board[win_board[0]] == @board[win_board[1]] && @board[win_board[1]] == @board[win_board[2]]
				if @board[win_board[0]] == "x"
					@winner = @player1
				else
					@winner = @player2
				end
			end
		end
	end

	def game_draw?
		if (@board.values.none? { |x| x == " " }) && @winner == nil
			@game_draw = true
		end
	end

#------------Game turns-----------------
	
	def play
		show_board
		while @winner == nil && @game_draw == nil
			player_one_turn
			break if @winner != nil || @game_draw != nil
			@ai ? ai_turn : player_two_turn
		end
		puts @game_draw == true ? "Game draw." : "#{@winner} wins!"
		puts "\n"
		increase_scores
		show_scores
		play_again?
	end

	def player_one_turn
		@current_player = 1
		puts (@current_player == 1 ? @player1 : @player2) + ", choose a square."
		turn
		turn_end
	end

	def player_two_turn
		@current_player = 2
		puts "Player 2, choose a square."
		turn
		end_turn
	end

	def make_move
		puts "\n"
		if @current_player == 1
			@board[@chosen_square] = "x"
		else
			@board[@chosen_square] = "o"
		end
	end

	def turn
		if @current_player != "HAL"
			@chosen_square = gets.chomp.to_i
			while valid_move? == false
				puts "Please enter a valid move."
				@chosen_square = gets.chomp.to_i
			end
		end
		make_move
	end

	def turn_end
		@chosen_square = nil
		show_board
		check_winner
		game_draw?
	end

	def valid_move?
		if ((1..9).include? @chosen_square) && @board[@chosen_square] != "x" && @board[@chosen_square] != "o"
			true
		else
			false
		end
	end

# -----------AI------------------
	
	def ai_turn
		@current_player = "HAL"
		puts "HAL, choose a square."
		sleep(1.8)
		case 
		when ai_possible_win then make_move
		when ai_possible_player_win then make_move
		when ai_random_square then make_move
		end
		turn_end
	end

	def ai_possible_win
		WINNING_BOARDS.each do |wb|
			currently_examining = ""
			3.times do |x|
				currently_examining += @board[wb[x]].to_s
			end
			if (currently_examining.split("").select { |x| x == "o" }.count) == 2
				target = currently_examining.index(" ")
				return @chosen_square = wb[target] unless target == nil
			else
			end
		end
		return false
	end

	def ai_possible_player_win
		WINNING_BOARDS.each do |wb|
			currently_examining = ""
			3.times do |x|
				currently_examining += @board[wb[x]].to_s
			end
			if (currently_examining.split("").select { |x| x == "x" }.count) == 2
				target = currently_examining.index(" ")
				return @chosen_square = wb[target] unless target == nil
			else
			end
		end
		return false
	end

	def ai_random_square
		empty_squares = []
		@board.each do |k,v|
			empty_squares << k if v == " "
		end
		@chosen_square = empty_squares[rand(1..(empty_squares.count-1))]
	end

	# ----------- Test Method --------------------
	def test

	end

end

game = Tictactoe.new
game.start_game