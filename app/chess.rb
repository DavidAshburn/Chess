class Board
	attr_reader :board

	def initialize
		attr_reader :board
		@board = Array.new(64,0)
		@piece_map = {
			K: 6;
			k: 12;
			Q: 5;
			q: 5;
			R: 4;
			r: 10;
			B: 3;
			b: 9;
			N: 2;
			n: 8;
			P: 1;
			p: 7;
		}

		starting_position = "rnbqkbnr/pppppppp/////PPPPPPPP/RNBQKBNR"
		setup_board(starting_position)
		puts_board
	end

	def setup_board(string_code)
		list = string_code.split("")
		board_index = 0
		board_line = 0

		list.each do |char|
			if char == '/'
				board_line += 1 
				board_index = board_line * 8
			elsif char.match?(/^\d+$/)
				board_index += char.to_i
			else
				@board[board_index] = @piece_map[char.to_sym]
			end
		end
	end

	def puts_board
		(0..7).reverse.each do |row|
			row_string = ""
			(0..7).each do |col|
				row_string.concat("| #{@board[(row*8)+col]}")
			end
			row_string.concat(" |")
			puts row_string
		end
	end

end

game = Board.new