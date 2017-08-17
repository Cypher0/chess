require_relative 'player'
require_relative 'board'

# main game class, init with board, two players and active player params
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
  
  # convert a string coordinate to array coordinates(ex a1 to [0,0])
  def conv_coords(string)
    result = []
    cols = { 'a' => 0, 'b' => 1, 'c' => 2, 'd' => 3, 'e' => 4, 'f' => 5, 'g' => 6, 'h' => 7 }
    result << cols[string[0].downcase] << string[1].to_i - 1
    result
  end
  
  # make sure that piece on dest square isnt same players as piece on start square
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

  # make sure that player wont be in check after performing move(make the move, check it, then reverse move)
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

  # check if moving from start to dest is a legal move
  def legal_move?(start, dest)
    return false unless (start + dest).all? { |i| i.between?(0, 7) } # both coordinates are within the board
    @board.path_clear?(start, dest) && # path is clear(cant jump over pieces)
    not_own_piece?(start, dest) && # dest square has no piece with the same color as start square
    piece_can_move?(start, dest) && # piece is able to move from start to dest
    !check_after_move?(@act_plr, start, dest) # player wont be in check after moving
  end
  
  # check if player can perform kingside castling:
  #   -return if king has moved or kingside corner doesnt have a rook
  #   -return false if rook has moved, path isnt clear or player is in check
  #   -move king one square, result is false if king is check
  #   -repeat prev step
  #   -move king back, return result
  def can_castle_kingside?(plr)
    temp_piece = []
    temp_piece_2 = []
    result = true
    king = @board.rem_pieces.find { |pc| pc.class < King && pc.color == plr.color }
    return false unless !king.has_moved && @board.find_square([7, king.pos[1]]).piece.class < Rook
    rook = @board.find_square([7, king.pos[1]]).piece
    return false if rook.has_moved || check?(plr) || !@board.path_clear?(king.pos, rook.pos)
    @board.move(king.pos, [king.pos[0] + 1, king.pos[1]])
    result = false if check?(plr)
    @board.move(king.pos, [king.pos[0] + 1, king.pos[1]])
    result = false if check?(plr)
    @board.move(king.pos, [king.pos[0] - 2, king.pos[1]])
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
    @board.move(king.pos, [king.pos[0] - 1, king.pos[1]])
    result = false if check?(plr)
    @board.move(king.pos, [king.pos[0] - 1, king.pos[1]])
    result = false if check?(plr)
    @board.move(king.pos, [king.pos[0] + 2, king.pos[1]])
    result
  end
  
  # if queenside castling possible, perform it by moving king and rook
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

  # find players king, return true if any opponents piece is able to move to its pos and has clear path
  def check?(plr)
    king = @board.rem_pieces.find { |pc| pc.class < King && pc.color == plr.color }
    @board.rem_pieces.any? { |pc| pc.color != king.color && 
    piece_can_move?(pc.pos, king.pos) &&
    @board.path_clear?(pc.pos, king.pos) }
  end
  
  # check for stalemate
  def stalemate?(plr)
    result = true
    temp_piece = [] # array for temporarily removing target squares piece
    @board.squares.each do |sq| # loop through squares
      start = sq.coords
      next if sq.piece.nil? || sq.piece.color != plr.color # next if no piece or opponents piece on square
      sq.piece.gen_moves(board) if sq.piece.class < Pawn # pawn needs to gen its moves
      sq.piece.poss_moves.each do |mv| # loop through pieces possible moves
        dest = [start[0] + mv[0], start[1] + mv[1]] # gen destination with start+move
        dest_sq = @board.find_square(dest)
        next unless legal_move?(start, dest) # next unless move is legal
        temp_piece << dest_sq.piece unless dest_sq.piece.nil? # push target piece to temp array
        dest_sq.piece = nil
        @board.move(start, dest) # perform move
        result = false unless check?(plr) # result is false if player is not in check(has a legal move)
        @board.move(dest, start)
        dest_sq.piece = temp_piece.pop unless temp_piece.empty?
        return result unless result == true #  return if result is false
      end
    end
    result 
  end
  
  # checkmate if player is in stalemate AND check
  def checkmate?(plr)
    stalemate?(plr) && check?(plr)
  end

  def game_over?
    checkmate?(@act_plr) || stalemate?(@act_plr)
  end
  
  # check if input is a coordinate string
  def is_coord?(input)
    input.size == 2 && input[0].downcase.between?('a','h') && input[1].to_i.between?(1,8)
  end

  # gen array of strings of all possible coordinates on board
  def coords_array
    array = []
    ('a'..'h').each do |n|
      (1..8).each do |i|
        array << "#{n}#{i}"
      end
    end
    array
  end

  # get a coord string or a command
  def get_action(plr)
    if plr.type == :human # if human player, gets an input, return it if legal
      @board.display
      sleep 1
      puts "#{plr.name}, what piece would you like to move? Enter coordinates or:\n[S]ave the game\n[Q]ueenside Castling\n[K]ingside Castling\n[E]xit Game\n"
      input = STDIN.gets.chomp.downcase
      if is_coord?(input) || ['k', 'q', 's', 'e'].include?(input)
        input
      else
        puts 'Invalid input!'
        get_action(plr)
      end
    else # if cpu player, add kingside, queenside castling commands to coords array, get a random input from there 
      poss_acts = coords_array
      poss_acts << 'k' << 'q'
      poss_acts.sample
    end
  end

  def save_game
    puts 'Enter a name for your save:'
    game = STDIN.gets.chomp
    File.open("saves/#{game}", 'w').puts Marshal.dump(self)
    puts 'Game saved!'
  end
  
  # change all opponents pawns passable to false
  def change_passant
    @board.rem_pieces.each do |pc|
      if pc.color != @act_plr.color && pc.class < Pawn
        pc.passable = false
      end
    end
  end
  
  # take an input, perform action using it
  def perform_action(input)
    case input
    when 'k' then perform_kcastl(@act_plr)
    when 'q' then perform_qcastl(@act_plr)
    when 's' then save_game
    when 'e' then abort('Thanks for playing! Goodbye!')
    else
      if is_coord?(input)
        target = @board.find_square(conv_coords(input))
        if target.piece.nil? || target.piece.color != @act_plr.color
          puts 'You have no piece there!' if @act_plr.type == :human
          perform_action(get_action(@act_plr)) # get new input if no piece
        else # if player has piece
          if @act_plr.type == :human
            puts "Where do you want to move?" # gets target coords from human player
            answer = STDIN.gets.chomp.downcase
          else
            array = coords_array 
            array.delete(input)
            answer = array.sample # get random target from (coords array minus input coords) if cpu player
          end
          if legal_move?(conv_coords(input), conv_coords(answer)) # if move is legal
            @board.move(conv_coords(input), conv_coords(answer)) # move the piece
            puts "\nComputer moves #{input} to #{answer}" if @act_plr.type == :cpu # announce move if cpu moved
          else
            puts 'That is not a legal move!' if @act_plr.type == :human
            perform_action(get_action(@act_plr)) # repeat method until legal action found
          end
        end
      else
        puts 'Invalid input!'
        perform_action(get_action(@act_plr)) # repeat method if input is not valid
      end
    end
    change_passant # cant pass eligible pawns next turn, so change passable to false
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
 