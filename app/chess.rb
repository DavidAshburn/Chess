class String
	def colorize(color_code)
		"\e[#{color_code}m#{self}\e[0m"
	end

	def red
		colorize(31)
	end

	def green
		colorize(32)
	end

	def yellow
		colorize(33)
	end

	def blue
		colorize(34)
	end

	def pink
		colorize(35)
	end

	def cyan
		colorize(36)
	end

	def gray
		colorize(37)
	end

	def bg_black;
		colorize(40)
	end

	def bg_red;
		colorize(41)
	end
	def bg_green;
		colorize(42)
	end
	def bg_yellow;
		colorize(43)
	end
	def bg_blue;
		colorize(44)
	end
	def bg_magenta;
		colorize(45)
	end
	def bg_cyan;
		colorize(46)
	end
	def bg_gray;
		colorize(47)
	end

	def bold
		colorize(1)
	end

	def italic
		colorize(3)
	end

	def underline
		colorize(4)
	end

	def blink
		colorize(5)
	end

	def reverse_color
		colorize(7)
	end
end

class Board
	attr_reader :board

	def initialize
		@board = Array.new(64,:z)

		@unicode_map = {
			:K => ["\u2654","white","King"],
			:k => ["\u265a","black","King"],
			:Q => ["\u2655","white","Queen"],
			:q => ["\u265b","black","Queen"],
			:R => ["\u2656","white","Rook"],
			:r => ["\u265c","black","Rook"],
			:B => ["\u2657","white","Bishop"],
			:b => ["\u265d","black","Bishop"],
			:N => ["\u2658","white","Knight"],
			:n => ["\u265e","black","Knight"],
			:P => ["\u2659","white","Pawn"],
			:p => ["\u265f","black","Pawn"],
			:z => [" ","none","empty"]
		}

		starting_position = "RNBQKBNR/PPPPPPPP/////pppppppp/rnbqkbnr"
		setup_board(starting_position)
		puts_board
	end

	def play_awhile
		(0..5).each do 
			prompt_input
		end
	end

	def setup_board(string_code)
		list = string_code.split("")
		board_index = 0
		board_line = 0

		list.each do |char|
			if char == '/'
				board_line += 1 
				board_index = board_line * 8
			elsif char.match?(/\d/)
				board_index += char.to_i
			else
				@board[board_index] = char.to_sym
				board_index += 1
			end
		end
	end

	def puts_board
		puts "     .------------------------.".yellow
		(0..7).to_a.reverse.each do |row|
			row_string = "     |".yellow
			(0..7).each do |col|
				sym = @board[(row*8)+col]

				if row.even?
					if ((row*8)+col).even?
						if sym == :z
							space = "   ".gray.bg_black.reverse_color
							row_string.concat(space)
						else
							sym = " " + @unicode_map[sym][0] + " "
							row_string.concat(sym.gray.bg_black.reverse_color)
						end
					else
						if sym == :z
							space = "   ".yellow.bg_black.reverse_color
							row_string.concat(space)
						else
							sym = " " + @unicode_map[sym][0] + " "
							row_string.concat(sym.yellow.bg_black.reverse_color)
						end
					end
				else
					if ((row*8)+col).even?
						if sym == :z
							space = "   ".yellow.bg_black.reverse_color
							row_string.concat(space)
						else
							sym = " " + @unicode_map[sym][0] + " "
							row_string.concat(sym.yellow.bg_black.reverse_color)
						end
					else
						if sym == :z
							space = "   ".gray.bg_black.reverse_color
							row_string.concat(space)
						else
							sym = " " + @unicode_map[sym][0] + " "
							row_string.concat(sym.gray.bg_black.reverse_color)
						end
					end
				end
			end
			row_string.concat("|".yellow)
			puts row_string
		end
		puts "     *------------------------*".yellow
	end

	def prompt_input
		puts "Enter the piece you want to move and the target square (e2-e4) :"
		taken = move(player_input)
		puts_board
		if taken != nil
			puts "You took a piece! It's a #{taken}!"
		end
	end

	def move(index_pair)
		start = index_pair[0]
		finish = index_pair[1]

		taken = nil
		taken = @board[finish][2] if @board[finish] != :z
		@board[finish] = @board[start]
		@board[start] = :z
		return taken
	end

	def player_input
  		loop do
  			user_input = gets.chomp
  			if user_input.match?(/^[a-h][1-8]-[a-h][1-8]/i)
	      		verified_move = verify_move(user_input.split('')) 
	      		case verified_move
	      		when -2
	      			puts "There's something in the way! Try again"
	      		when -3
	      			puts "That would put you in check, be careful! Try again"
	      		else
	      			return verified_move
	      		end
	      	else
	      		puts "Enter your moves like this: a4-a6"
	  		end
	  	end
  	end

	def verify_move(input)
		start_index = (input[0].downcase.ord - 'a'.ord) + ((input[1].to_i - 1) * 8)

		end_index = (input[3].downcase.ord - 'a'.ord) + ((input[4].to_i - 1) * 8)

		type = @board[start_index]

		if type == :n || type == :N
		 	list = knight_moves(start_index)
	 	elsif type == :k || type == :K	
	 		list = king_moves(start_index)
		elsif type == :p || type == :P
			list = pawn_moves(start_index) 
		else
			list = slider_moves(start_index)
		end
		if list.include?(end_index)
			return [start_index,end_index]
		else
			return -2
		end
	end

	def knight_moves(start)
		my_type = @board[start]
		my_color = @unicode_map[my_type][1]
		list = []
		if start < 56
			list.push(6) if start % 8 > 1
			list.push(10) if start % 8 < 6
		end
		if start < 48
			list.push(15) if start % 8 > 0
			list.push(17) if start % 8 < 7
		end
		if start > 7
			list.push(-10) if start % 8 > 1
			list.push(-6) if start % 8 < 6
		end
		if start < 15
			list.push(-17) if start % 8 > 0
			list.push(-15) if start % 8 < 7
		end
		
		out = list.reduce([]) do |out, item|
			target_symbol = @board[start + item]
			if @unicode_map[target_symbol][1] != my_color
				out.push(start + item)
			end
			out
		end
		out
	end

	def king_moves(start)
		list = []
		my_type = @board[start]
		my_color = @unicode_map[my_type][1]
		if start % 8 > 0
			list.push(-1)
			list.push(-9) if start > 7
			list.push(7) if start < 56
		end
		if start % 8 < 7
			list.push(1)
			list.push(9) if start < 56
			list.push(-7) if start > 7
		end
		list.push(-8) if start > 7
		list.push(8) if start < 56

		out = list.reduce([]) do |out, item|
			target_symbol = @board[start + item]
			if @unicode_map[target_symbol][1] != my_color
				out.push(start + item)
			end
			out
		end
		out
	end

	def pawn_moves(start)
		list = []
		my_type = @board[start]
		my_color = @unicode_map[my_type][1]
		if start < 56
			list.push(8)
		end
		if start.between?(8,15)
			list.push(16)
		end

		out = list.reduce([]) do |out, item|
			target_symbol = @board[start + item]
			if @unicode_map[target_symbol][1] != my_color
				out.push(start + item)
			end
			out
		end
		out
	end

	def slider_moves(start)
		my_type = @board[start]
		my_color = @unicode_map[my_type][1]
		if my_type.to_s.downcase == 'r' || my_type.to_s.downcase == 'q'
			straight = straight_check(start, my_color)
		end

		if my_type.to_s.downcase == 'b' || my_type.to_s.downcase == 'q'
			diag = diag_check(start, my_color)
		end
		return straight.concat(diag)
	end

	def straight_check(start,my_color)
		out = []
		out.concat(look_up(start, my_color))
		out.concat(look_down(start, my_color))
		out.concat(look_left(start, my_color))
		out.concat(look_right(start, my_color))
		out
	end

	def look_up(start, my_color)
		list = []
		loop do
			if start + 8 > 63
				return list
			end
			start += 8
			if @board[start] == :z
				list.push(start)
			elsif @board[start][1] == my_color
				return list
			else
				list.push(start)
				return list
			end
		end
	end

	def look_down(start, my_color)
		list = []
		loop do
			if start - 8 < 0
				return list
			end
			start -= 8
			if @board[start] == :z
				list.push(start)
			elsif @board[start][1] == my_color
				return list
			else
				list.push(start)
				return list
			end
		end
	end

	def look_right(start, my_color)
		list = []
		limit = ((start / 8) * 8) + 7
		loop do
			if start + 1 > limit
				return list
			end
			start += 1
			if @board[start] == :z
				list.push(start)
			elsif @board[start][1] == my_color
				return list
			else
				list.push(start)
				return list
			end
		end
	end

	def look_left(start, my_color)
		list = []
		limit = ((start / 8) * 8)
		loop do
			if start - 1 < limit
				return list
			end
			start -= 1
			if @board[start] == :z
				list.push(start)
			elsif @board[start][1] == my_color
				return list
			else
				list.push(start)
				return list
			end
		end
	end

	def diag_check(start, my_color)
		out = []
		out.concat(look_u_right(start, my_color))
		out.concat(look_d_left(start, my_color))
		out.concat(look_d_right(start, my_color))
		out.concat(look_u_left(start, my_color))
		out
	end

	def look_u_left(start, my_color)
		list = []
		loop do
			if start + 7 > 63 || start % 8 == 0
				return list
			end
			start += 7
			if @board[start] == :z
				list.push(start)
			elsif @board[start][1] == my_color
				return list
			else
				list.push(start)
				return list
			end
		end
	end

	def look_u_right(start, my_color)
		list = []
		loop do
			if start + 9 > 63 || ((start * 8) - 1) % 8 == 7
				return list
			end
			start += 9
			if @board[start] == :z
				list.push(start)
			elsif @board[start][1] == my_color
				return list
			else
				list.push(start)
				return list
			end
		end
	end

	def look_d_left(start, my_color)
		list = []
		loop do
			if start - 9 < 0 || start % 8 == 0
				return list
			end
			start -= 9
			if @board[start] == :z
				list.push(start)
			elsif @board[start][1] == my_color
				return list
			else
				list.push(start)
				return list
			end
		end
	end

	def look_d_right(start, my_color)
		list = []
		loop do
			if start - 7 < 0 || ((start * 8) - 1) % 8 == 7
				return list
			end
			start -= 7
			if @board[start] == :z
				list.push(start)
			elsif @board[start][1] == my_color
				return list
			else
				list.push(start)
				return list
			end
		end
	end
end

game = Board.new
game.play_awhile