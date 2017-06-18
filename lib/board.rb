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

  def add_king(coords, color)
    pos = @squares.find { |sq| sq.coords == coords }
    if color == :white
      pos.piece = WKing.new(coords)
    elsif color == :black
      pos.piece = BKing.new(coords)
    end
    @rem_pieces << pos.piece
  end

  def add_queen(coords, color)
    pos = @squares.find { |sq| sq.coords == coords }
    if color == :white
      pos.piece = WQueen.new(coords)
    elsif color == :black
      pos.piece = BQueen.new(coords)
    end
    @rem_pieces << pos.piece
  end

  def add_pawn(coords, color)
    pos = @squares.find { |sq| sq.coords == coords }
    if color == :white
      pos.piece = WPawn.new(coords)
    elsif color == :black
      pos.piece = BPawn.new(coords)
    end
    @rem_pieces << pos.piece
  end

  def add_rook(coords, color)
    pos = @squares.find { |sq| sq.coords == coords }
    if color == :white
      pos.piece = WRook.new(coords)
    elsif color == :black
      pos.piece = BRook.new(coords)
    end
    @rem_pieces << pos.piece
  end

  def add_bishop(coords, color)
    pos = @squares.find { |sq| sq.coords == coords }
    if color == :white
      pos.piece = WBishop.new(coords)
    elsif color == :black
      pos.piece = BBishop.new(coords)
    end
    @rem_pieces << pos.piece
  end

  def add_knight(coords, color)
    pos = @squares.find { |sq| sq.coords == coords }
    if color == :white
      pos.piece = WKnight.new(coords)
    elsif color == :black
      pos.piece = BKnight.new(coords)
    end
    @rem_pieces << pos.piece
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

  def take_piece(coords)
    target = @squares.find { |sq| sq.coords == coords }
    @taken_pieces << target.piece
    @rem_pieces.delete(target.piece)
    target.piece = nil
  end

  def move(a, b)
    start = @squares.find { |sq| sq.coords == a }
    target = @squares.find { |sq| sq.coords == b }
    if start.piece.class < Pawn && (b[1] - a[1] == 2 || a[1] - b[1] == 2)
      start.piece.passable = true
    end
    take_piece(b) unless target.piece.nil?
    target.piece = start.piece
    target.piece.pos = target.coords
    start.piece = nil
    take_piece([b[0], b[1] - 1]) if target.piece.class < Pawn && @squares.find { |sq| sq.coords == [b[0], b[1] - 1] }.piece.class < Pawn && @squares.find { |sq| sq.coords == [b[0], b[1] - 1] }.piece.passable == true
    take_piece([b[0], b[1] + 1]) if target.piece.class < Pawn && @squares.find { |sq| sq.coords == [b[0], b[1] + 1] }.piece.class < Pawn && @squares.find { |sq| sq.coords == [b[0], b[1] + 1] }.piece.passable == true
  end

  def promote_pawn(color, coords)
    take_piece(coords) unless @squares.find { |sq| sq.coords == coords }.piece.nil?
    puts "Promote your pawn to:\n[Q]ueen\n[R]ook\n[B]ishop\n[K]night"
    input = STDIN.gets.chomp.downcase
    case input
    when 'q'
      add_queen(coords, color)
    when 'r'
      add_rook(coords, color)
    when 'b'
      add_bishop(coords, color)
    when 'k'
      add_knight(coords, color)
    else
      puts 'Invalid input!'
      promote_pawn(color, coords)
    end 
  end

  def conv_coords(string)
    result = []
    cols = { 'a' => 0, 'b' => 1, 'c' => 2, 'd' => 3, 'e' => 4, 'f' => 5, 'g' => 6, 'h' => 7 }
    result << cols[string[0].downcase] << string[1].to_i - 1
    result
  end

  def draw_str_path(start, dest)
    path = []
    if start[0] == dest[0]
      start[1] < dest[1] ? current = [start[0], start[1] + 1] : current = [start[0], start[1] - 1]
      until current == dest do
        path << @squares.find { |sq| sq.coords == current }
        current[1] < dest[1] ? current[1] += 1 : current[1] -= 1
      end
    else
      start[0] < dest[0] ? current = [start[0] + 1, start[1]] : current = [start[0] - 1, start[1]]
      until current == dest do
        path << @squares.find { |sq| sq.coords == current }
        current[0] < dest[0] ? current[0] += 1 : current[0] -= 1
      end
    end
    path
  end

  def draw_diag_path(start, dest)
    path = []
    current = []
    start[0] < dest[0] ? current[0] = start[0] + 1 : current[0] = start[0] - 1
    start[1] < dest[1] ? current[1] = start[1] + 1 : current[1] = start[1] - 1
    until current == dest do
      path << @squares.find { |sq| sq.coords == current }
      current[0] < dest[0] ? current[0] += 1 : current[0] -= 1
      current[1] < dest[1] ? current[1] += 1 : current[1] -= 1
    end
    path
  end

  def path_clear?(start, dest)
    if start[0] + start[1] == dest[0] + dest[1] ||
        start[0] - start[1] == dest[0] - dest[1]
      path = draw_diag_path(start, dest)
    elsif start[0] == dest[0] || start[1] == dest[1]
      path = draw_str_path(start, dest)
    else
      path = []
    end
    path.size.zero? || path.all? { |sq| sq.piece == nil }
  end
end
