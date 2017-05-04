require_relative 'player'
require_relative 'square'
require_relative 'king'

class Chess
  attr_reader :plr1, :plr2
  attr_accessor :act_plr, :board

  def initialize(name_1, name_2)
    @plr1 = Player.new(name_1, :white, WKing.new([4,0]))
    @plr2 = Player.new(name_2, :black, BKing.new([4,7]))
    @act_plr = @plr1
    @rem_pieces = []
    @taken_pieces = []
    gen_board
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
end
