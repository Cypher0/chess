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
    gen_board
    gen_rows
  end

  def gen_board
    @squares = []
    (0..7).each do |col|
      (0..7).each do |row|
        @squares << Square.new([row,col])
      end
    end
  end

  def find_square(coords, board = @squares)
    board.find { |sq| sq.coords == coords }
  end

  def add_piece(coords, color, piece)
    pos = find_square(coords)
    clr_str = if color == :white
                'W'
              elsif color == :black
                'B'
              end
    piece_str = clr_str + piece.capitalize
    pos.piece = Object.const_get(piece_str).new(coords)
    @rem_pieces << pos.piece
  end

  def setup_kings
    add_piece([4,0], :white, 'king')
    add_piece([4,7], :black, 'king')
  end

  def setup_queens
    add_piece([3,0], :white, 'queen')
    add_piece([3,7], :black, 'queen')
  end

  def setup_pawns
    (0..7).each do |i|
      add_piece([i,1], :white, 'pawn')
      add_piece([i,6], :black, 'pawn')
    end
  end

  def setup_rooks
    add_piece([0,0], :white, 'rook')
    add_piece([7,0], :white, 'rook')
    add_piece([0,7], :black, 'rook')
    add_piece([7,7], :black, 'rook')
  end

  def setup_bishops
    add_piece([2,0], :white, 'bishop')
    add_piece([5,0], :white, 'bishop')
    add_piece([2,7], :black, 'bishop')
    add_piece([5,7], :black, 'bishop')
  end

  def setup_knights
    add_piece([1,0], :white, 'knight')
    add_piece([6,0], :white, 'knight')
    add_piece([1,7], :black, 'knight')
    add_piece([6,7], :black, 'knight')
  end

  def setup_pieces
    setup_kings
    setup_queens
    setup_pawns
    setup_rooks
    setup_bishops
    setup_knights
  end

  def gen_rows
    @rows = []
    i = 0
    8.times do
      @rows << @squares[i..(i+7)]
      i += 8
    end
  end

  def print_square(square)
    print square.piece.nil? ? "  " : "#{square.piece.sym} "
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
    print "\n\n"
  end

  def print_taken
    print 'Taken pieces:  ' unless taken_pieces.empty?
    @taken_pieces.each do |pc|
      print "#{pc.sym} "
    end
    print "\n\n"
  end

  def display
    print "\n"
    row_index = 7
    @rows.reverse.each do |row|
      print_row(row_index)
      row.each do |sq|
        print_square(sq)
      end
      print "\n"
      row_index -= 1
    end
    print_cols
    print_taken
  end

  def take_piece(coords)
    target = find_square(coords)
    @taken_pieces << target.piece
    @rem_pieces.delete(target.piece)
    target.piece = nil
  end

  def pawn_jump?(start, target)
    start_sq = find_square(start)
    start_sq.piece.class < Pawn && (target[1] - start[1] == 2 || start[1] - target[1] == 2)
  end

  def w_did_pass?(pos)
    return false unless pos[1] == 5
    target_pc = find_square(pos).piece
    passed_pc = find_square([pos[0], pos[1] - 1]).piece
    target_pc.is_a?(WPawn) && passed_pc.is_a?(BPawn) && passed_pc.passable
  end

  def b_did_pass?(pos)
    return false unless pos[1] == 2
    target_pc = find_square(pos).piece
    passed_pc = find_square([pos[0], pos[1] + 1]).piece
    target_pc.is_a?(BPawn) && passed_pc.is_a?(WPawn) && passed_pc.passable
  end

  def take_passed_pc(pos)
    take_piece([pos[0], pos[1] - 1]) if w_did_pass?(pos)
    take_piece([pos[0], pos[1] + 1]) if b_did_pass?(pos)
  end

  def move_piece(start, target)
    target.piece = start.piece
    target.piece.pos = target.coords
    start.piece = nil
  end

  def w_can_promote?(target)
    target.piece.is_a?(WPawn) && target.piece.pos[1] == 7
  end

  def b_can_promote?(target)
    target.piece.is_a?(BPawn) && target.piece.pos[1] == 0
  end

  def move(start, target)
    start_sq = find_square(start)
    target_sq = find_square(target)
    start_sq.piece.passable = true if pawn_jump?(start, target)
    start_sq.piece.has_moved = true if [Pawn, Rook, King].any? { |parent| start_sq.piece.class < parent }
    take_piece(target) unless target_sq.piece.nil?
    move_piece(start_sq, target_sq)
    take_passed_pc(target) if target_sq.piece.class < Pawn
    promote_pawn(:white, target) if w_can_promote?(target_sq)
    promote_pawn(:black, target) if b_can_promote?(target_sq)
  end

  def promote_pawn(color, coords)
    take_piece(coords) unless find_square(coords).piece.nil?
    puts "Promote your pawn to:\n[Q]ueen\n[R]ook\n[B]ishop\n[K]night"
    input = STDIN.gets.chomp.downcase
    case input
    when 'q'
      add_piece(coords, color, 'queen')
    when 'r'
      add_piece(coords, color, 'rook')
    when 'b'
      add_piece(coords, color, 'bishop')
    when 'k'
      add_piece(coords, color, 'knight')
    else
      puts 'Invalid input!'
      promote_pawn(color, coords)
    end 
  end

  def draw_hor_path(start, dest)
    path = []
    start[0] < dest[0] ? current = [start[0] + 1, start[1]] : current = [start[0] - 1, start[1]]
    until current == dest do
      path << find_square(current)
      current[0] < dest[0] ? current[0] += 1 : current[0] -= 1
    end
    path
  end

  def draw_vert_path(start, dest)
    path = []
    start[1] < dest[1] ? current = [start[0], start[1] + 1] : current = [start[0], start[1] - 1]
    until current == dest do
      path << find_square(current)
      current[1] < dest[1] ? current[1] += 1 : current[1] -= 1
    end
    path
  end

  def draw_str_path(start, dest)
    if start[0] == dest[0]
      draw_vert_path(start, dest)
    else
      draw_hor_path(start, dest)
    end
  end

  def draw_diag_path(start, dest)
    path = []
    current = []
    start[0] < dest[0] ? current[0] = start[0] + 1 : current[0] = start[0] - 1
    start[1] < dest[1] ? current[1] = start[1] + 1 : current[1] = start[1] - 1
    until current == dest do
      path << find_square(current)
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
