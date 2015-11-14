require_relative  '../TicTacToe'

describe "TicTacToe" do



	before :each do
		@game = Tictactoe.new
	end

	describe "#initialize" do
		it "initializes player 1 win count to 0" do
			expect(@game.player1_win_count).to eq(0)
		end

		it "initializes player 2 win count to 0" do
			expect(@game.player2_win_count).to eq(0)
		end

		it "initializes the draw count to 0" do
			expect(@game.draw_count).to eq(0)
		end
	end

end