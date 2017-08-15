require_relative 'player'
require_relative 'board'

class Chess
  attr_reader :plr1, :plr2
  attr_accessor :act_plr, :board

  def initialize(name1, name2)
    @board = Board.new
    @plr1 = Player.new(name1, :white)
    @plr2 = Player.new(name2, :black)
    @act_plr = @plr1
  end

  def switch_plrs
    @act_plr = if @act_plr == @plr1
                 @plr2
               else
                 @plr1
               end
  end

  def conv_coords(string)
    result = []
    cols = { 'a' => 0, 'b' => 1, 'c' => 2, 'd' => 3, 'e' => 4, 'f' => 5, 'g' => 6, 'h' => 7 }
    result << cols[string[0].downcase] << string[1].to_i - 1
    result
  end

  def not_own_piece?(start, dest)
    start_sq = @board.find_square(start)
    dest_sq = @board.find_square(dest)
    dest_sq.piece.nil? || start_sq.piece.color != dest_sq.piece.color
  end

  def piece_can_move?(start, dest)
    start_sq = @board.find_square(start)
    start_sq.piece.gen_moves(@board) if start_sq.piece.class < Pawn
    start_sq.piece.poss_moves.any? { |mv| [start[0] + mv[0], start[1] + mv[1]] == dest }
  end

  def check_after_move?(plr, start, dest)
    result = false
    start_sq = @board.find_square(start)
    dest_sq = @board.find_square(dest)
    temp_piece = dest_sq.piece
    dest_sq.piece = nil
    @board.move_piece(start_sq, dest_sq)
    result = true if check?(plr)
    @board.move_piece(dest_sq, start_sq)
    dest_sq.piece = temp_piece
    result
  end

  def legal_move?(start, dest)
    return false unless (start + dest).all? { |i| i.between?(0, 7) }
    @board.path_clear?(start, dest) &&
    not_own_piece?(start, dest) &&
    piece_can_move?(start, dest) &&
    !check_after_move?(@act_plr, start, dest)
  end

  def can_castle_kingside?(plr)
    temp_piece = []
    temp_piece_2 = []
    result = true
    king = @board.rem_pieces.find { |pc| pc.class < King && pc.color == plr.color }
    return false unless !king.has_moved && @board.find_square([7, king.pos[1]]).piece.class < Rook
    rook = @board.find_square([7, king.pos[1]]).piece
    return false if rook.has_moved || check?(plr) || !@board.path_clear?(king.pos, rook.pos)
    king_next_one, king_next_two = @board.find_square([king.pos[0] + 1, king.pos[1]]), @board.find_square([king.pos[0] + 2, king.pos[1]])
    temp_piece_one, temp_piece_two = king_next_one.piece, king_next_two.piece
    king_next_one.piece, king_next_two.piece = nil, nil
    @board.move(king.pos, king_next_one.coords)
    result = false if check?(plr)
    @board.move(king.pos, king_next_two.coords)
    result = false if check?(plr)
    @board.move(king.pos, [king.pos[0] - 2, king.pos[1]])
    king_next_one.piece, king_next_two.piece = temp_piece_one, temp_piece_two
    result
  end

  def can_castle_queenside?(plr)
    temp_piece = []
    temp_piece_2 = []
    result = true
    king = @board.rem_pieces.find { |pc| pc.class < King && pc.color == plr.color }
    return false unless !king.has_moved && @board.find_square([0, king.pos[1]]).piece.class < Rook
    rook = @board.find_square([0, king.pos[1]]).piece
    return false if rook.has_moved || check?(plr) || !@board.path_clear?(king.pos, rook.pos)
    king_next_one, king_next_two = @board.find_square([king.pos[0] - 1, king.pos[1]]), @board.find_square([king.pos[0] - 2, king.pos[1]])
    temp_piece_one, temp_piece_two = king_next_one.piece, king_next_two.piece
    king_next_one.piece, king_next_two.piece = nil, nil
    @board.move(king.pos, king_next_one.coords)
    result = false if check?(plr)
    @board.move(king.pos, king_next_two.coords)
    result = false if check?(plr)
    @board.move(king.pos, [king.pos[0] + 2, king.pos[1]])
    king_next_one.piece, king_next_two.piece = temp_piece_one, temp_piece_two
    result
  end

  def check?(plr)
    king = @board.rem_pieces.find { |pc| pc.class < King && pc.color == plr.color }
    @board.rem_pieces.any? { |pc| pc.color != king.color && 
    piece_can_move?(pc.pos, king.pos) &&
    @board.path_clear?(pc.pos, king.pos) }
  end

  def stalemate?(plr)
    result = true
    temp_piece = []
    @board.squares.each do |sq|
      start = sq.coords
      next if sq.piece.nil? || sq.piece.color != plr.color
      sq.piece.gen_moves(board) if sq.piece.class < Pawn
      sq.piece.poss_moves.each do |mv|
        dest = [start[0] + mv[0], start[1] + mv[1]]
        dest_sq = @board.find_square(dest)
        next unless legal_move?(start, dest)
        temp_piece << dest_sq.piece unless dest_sq.piece.nil?
        dest_sq.piece = nil
        @board.move(start, dest)
        result = false unless check?(plr)
        @board.move(dest, start)
        dest_sq.piece = temp_piece.pop unless temp_piece.empty?
        return result unless result == true
      end
    end
    result
  end

  def checkmate?(plr)
    stalemate?(plr) && check?(plr)
  end

  def game_over?
    checkmate?(@act_plr) || stalemate?(@act_plr)
  end

  def is_coord?(input)
    input.size == 2 && input[0].downcase.between?('a','h') && input[1].to_i.between?(1,8)
  end

  def get_action(plr)
    if plr.type == :human
      @board.display
      sleep 1
      puts "#{plr.name}, what piece would you like to move? Enter coordinates or:\n[S]ave the game\nCastle [Q]ueenside\nCastle [K]ingside\n"
      input = STDIN.gets.chomp.downcase
      if is_coord?(input) || ['k', 'q', 's'].include?(input)
        input
      else
        puts 'Invalid input!'
        get_action(plr)
      end
    else
      poss_acts = coords_array
      poss_acts << 'k' << 'q'
      poss_acts.sample
    end
  end

  def coords_array
    array = []
    ('a'..'h').each do |n|
      (1..8).each do |i|
        array << "#{n}#{i}"
      end
    end
    array
  end

  def perform_qcastl(plr)
    king = @board.rem_pieces.find { |pc| pc.class < King && pc.color == plr.color }
    rook = @board.find_square([0, king.pos[1]]).piece
    if can_castle_queenside?(plr)
      @board.move(king.pos, [king.pos[0] - 2, king.pos[1]])
      @board.move(rook.pos, [rook.pos[0] + 3, rook.pos[1]])
    else
      puts 'Castling not possible!' if plr.type == :human
      perform_action(get_action(plr))
    end
  end

  def perform_kcastl(plr)
    king = @board.rem_pieces.find { |pc| pc.class < King && pc.color == plr.color }
    rook = @board.find_square([7, king.pos[1]]).piece
    if can_castle_kingside?(plr)
      @board.move(king.pos, [king.pos[0] + 2, king.pos[1]])
      @board.move(rook.pos, [rook.pos[0] - 2, rook.pos[1]])
    else
      puts 'Castling not possible!' if plr.type == :human
      perform_action(get_action(plr))
    end
  end

  def save_game
    puts 'Enter a name for your save:'
    game = STDIN.gets.chomp
    File.open("saves/#{game}", 'w').puts Marshal.dump(self)
    puts 'Game saved!'
  end

  def change_passant
    @board.rem_pieces.each do |pc|
      if pc.color != @act_plr.color && pc.class < Pawn
        pc.passable = false
      end
    end
  end

  def perform_action(input)
    case input
    when 'k' then perform_kcastl(@act_plr)
    when 'q' then perform_qcastl(@act_plr)
    when 's' then save_game
    else
      if is_coord?(input)
        target = @board.find_square(conv_coords(input))
        if target.piece.nil? || target.piece.color != @act_plr.color
          puts 'You have no piece there!' if @act_plr.type == :human
          perform_action(get_action(@act_plr))
        else
          if @act_plr.type == :human
            puts "Where do you want to move?"
            answer = STDIN.gets.chomp.downcase
          else
            array = coords_array
            array.delete(input)
            answer = array.sample
          end
          if legal_move?(conv_coords(input), conv_coords(answer))
            @board.move(conv_coords(input), conv_coords(answer))
            puts "\nComputer moves #{input} to #{answer}" if @act_plr.type == :cpu
          else
            puts 'That is not a legal move!' if @act_plr.type == :human
            perform_action(get_action(@act_plr))
          end
        end
      else
        puts 'Invalid input!'
        perform_action(get_action(@act_plr))
      end
    end
    change_passant
  end

  def print_result
    @board.display
    if checkmate?(@act_plr)
      switch_plrs
      puts "\nCheckmate, #{@act_plr.name} won!"
    elsif stalemate?(@act_plr)
      puts "\n#{act_plr.name} is in stalemate! It's a draw!"
    end
  end

  def play
    until game_over?
      perform_action(get_action(@act_plr))
      switch_plrs
    end
    print_result
  end
end
