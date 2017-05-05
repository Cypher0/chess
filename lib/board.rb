require_relative 'square'
require_relative 'king'
require_relative 'queen'
require_relative 'pawn'
require_relative 'rook'
require_relative 'bishop'
require_relative 'knight'

class Board
  attr_accessor :squares, :rows, :rem_pieces, :taken_pieces

  def initialize
    @rem_pieces = []
    @taken_pieces = []
    @rows = []
    gen_board
  end

  def gen_board
    @squares = []
    (0..7).each do |col|
      (0..7).each do |row|
        @squares << Square.new([row,col])
      end
    end
  end

    def add_king(coords, color, board = @squares)
    pos = @squares.find { |sq| sq.coords == coords }
    if color == :white
      pos.piece = WKing.new([4,0])
    elsif color == :black
      pos.piece = BKing.new([4,7])
    end
  end

  def add_queen(coords, color, board = @squares)
    pos = @squares.find { |sq| sq.coords == coords }
    if color == :white
      pos.piece = WQueen.new(coords)
    elsif color == :black
      pos.piece = BQueen.new(coords)
    end
  end

  def add_pawn(coords, color, board = @squares)
    pos = @squares.find { |sq| sq.coords == coords }
    if color == :white
      pos.piece = WPawn.new(coords)
    elsif color == :black
      pos.piece = BPawn.new(coords)
    end
  end

  def add_rook(coords, color, board = @squares)
    pos = @squares.find { |sq| sq.coords == coords }
    if color == :white
      pos.piece = WRook.new(coords)
    elsif color == :black
      pos.piece = BRook.new(coords)
    end
  end

  def add_bishop(coords, color, board = @squares)
    pos = @squares.find { |sq| sq.coords == coords }
    if color == :white
      pos.piece = WBishop.new(coords)
    elsif color == :black
      pos.piece = BBishop.new(coords)
    end
  end

  def add_knight(coords, color, board = @squares)
    pos = @squares.find { |sq| sq.coords == coords }
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
      @rows << @squares[i..(i+7)]
      i += 8
    end
  end

  def print_row(i)
    print ["246#{i}".to_i(16)].pack('U*') + ' '
  end

  def print_col(i)
    print ["24b#{i}".to_i(16)].pack('U*') + ' '
  end

  def print_cols
    print '  '
    (6..9).each do |n|
      print_col(n)
    end
    ("a".."d").each do |n|
      print_col(n)
    end
  end

  def display
    row_index = 7
    @rows.each do |row|
      print_row(row_index)
      row.each do |sq|
        if sq.piece.nil?
          print "  "
        else
          print "#{sq.piece.sym} "
        end
      end
      print "\n"
      row_index -= 1
    end
    print_cols
  end
end
