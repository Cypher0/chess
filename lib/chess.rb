require_relative 'player'
require_relative 'square'
require_relative 'king'
require_relative 'queen'
require_relative 'pawn'
require_relative 'rook'
require_relative 'bishop'
require_relative 'knight'

class Chess
  attr_reader :plr1, :plr2
  attr_accessor :act_plr, :board, :rows, :rem_pieces, :taken_pieces

  def initialize(name_1, name_2)
    @plr1 = Player.new(name_1, :white, WKing.new([4,0]))
    @plr2 = Player.new(name_2, :black, BKing.new([4,7]))
    @act_plr = @plr1
    @rem_pieces = []
    @taken_pieces = []
    gen_board
    @rows = []
  end

  def gen_board
    @board = []
    (0..7).each do |col|
      (0..7).each do |row|
        @board << Square.new([row,col])
      end
    end
  end

  def switch_plrs
    @act_plr = if @act_plr == @plr1
                 @plr2
               else
                 @plr1
               end
  end

  def add_king(coords, color, board = @board)
    pos = @board.find { |sq| sq.coords == coords }
    if color == :white
      pos.piece = @plr1.king
    elsif color == :black
      pos.piece = @plr2.king
    end
  end

  def add_queen(coords, color, board = @board)
    pos = @board.find { |sq| sq.coords == coords }
    if color == :white
      pos.piece = WQueen.new(coords)
    elsif color == :black
      pos.piece = BQueen.new(coords)
    end
  end

  def add_pawn(coords, color, board = @board)
    pos = @board.find { |sq| sq.coords == coords }
    if color == :white
      pos.piece = WPawn.new(coords)
    elsif color == :black
      pos.piece = BPawn.new(coords)
    end
  end

  def add_rook(coords, color, board = @board)
    pos = @board.find { |sq| sq.coords == coords }
    if color == :white
      pos.piece = WRook.new(coords)
    elsif color == :black
      pos.piece = BRook.new(coords)
    end
  end

  def add_bishop(coords, color, board = @board)
    pos = @board.find { |sq| sq.coords == coords }
    if color == :white
      pos.piece = WBishop.new(coords)
    elsif color == :black
      pos.piece = BBishop.new(coords)
    end
  end

  def add_knight(coords, color, board = @board)
    pos = @board.find { |sq| sq.coords == coords }
    if color == :white
      pos.piece = WKnight.new(coords)
    elsif color == :black
      pos.piece = BKnight.new(coords)
    end
  end

  def setup_kings
    add_king([4,0], :white)
    add_king([4,7], :black)
  end

  def setup_queens
    add_queen([3,0], :white)
    add_queen([3,7], :black)
  end

  def setup_pawns
    (0..7).each do |i|
      add_pawn([i,1], :white)
      add_pawn([i,6], :black)
    end
  end

  def setup_rooks
    add_rook([0,0], :white)
    add_rook([7,0], :white)
    add_rook([0,7], :black)
    add_rook([7,7], :black)
  end

  def setup_bishops
    add_bishop([2,0], :white)
    add_bishop([5,0], :white)
    add_bishop([2,7], :black)
    add_bishop([5,7], :black)
  end

  def setup_knights
    add_knight([1,0], :white)
    add_knight([6,0], :white)
    add_knight([1,7], :black)
    add_knight([6,7], :black)
  end

  def setup_pieces # DRY this!
    setup_kings
    setup_queens
    setup_pawns
    setup_rooks
    setup_bishops
    setup_knights
  end

  def gen_rows
    i = 0
    8.times do
      @rows << @board[i..(i+7)]
      i += 8
    end
  end
end
