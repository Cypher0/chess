# class for pawn, init with position, passable(can be taken en passant) and has_moved params
class Pawn
  attr_accessor :pos, :passable, :has_moved
  
  def initialize(coords)
    @pos = coords
    @passable = false
    @has_moved = false
  end

  # helper method to find piece on board by coordinates
  def find_piece(coords, board)
    board.squares.find { |sq| sq.coords == coords }.piece
  end
  
  # helper method to check whether coordinates are within the board
  def within_board?(coords)
    coords.all? { |i| i.between?(0,7) }
  end
end

# class for white pawn, init with color, symbol and possible moves
class WPawn < Pawn
  attr_reader :sym, :color, :poss_moves

  def initialize(coords)
    super
    @sym = "\u2659"
    @color = :white
  end

  # check if pawn can jump two squares(path is clear and is on initial position)
  def can_jump_fwd?(pos, board)
    pos[1] == 1 && board.path_clear?(pos, [pos[0], pos[1] + 3])
  end
  
  # check if pawn can move one square(target square within board and has no piece)
  def can_move_fwd?(pos, board)
    target_coords = ([pos[0], pos[1] + 1])
    within_board?(target_coords) && find_piece(target_coords, board).nil?
  end

  # check if pawn can capture diag-left(target square within board and has opponents piece)
  def can_capture_l?(pos, board)
    target_coords = ([pos[0] - 1, pos[1] + 1])
    return false unless within_board?(target_coords)
    target_piece = find_piece(target_coords, board)
    !target_piece.nil? && target_piece.color != @color
  end

  def can_capture_r?(pos, board)
    target_coords = ([pos[0] + 1, pos[1] + 1])
    return false unless within_board?(target_coords)
    target_piece = find_piece(target_coords, board)
    !target_piece.nil? && target_piece.color != @color
  end

  # check if pawn can pass diag-left(has passable opponents pawn on direct left)
  def can_pass_l?(pos, board)
    target_coords = ([pos[0] - 1, pos[1] + 1])
    target_pc_coords = ([pos[0] - 1, pos[1]])
    return false unless within_board?(target_coords) && within_board?(target_pc_coords)
    target_piece = find_piece(target_pc_coords, board)
    target_piece.is_a?(BPawn) && target_piece.passable == true
  end

  def can_pass_r?(pos, board)
    target_coords = ([pos[0] + 1, pos[1] + 1])
    target_pc_coords = ([pos[0] + 1, pos[1]])
    return false unless within_board?(target_coords) && within_board?(target_pc_coords)
    target_piece = find_piece(target_pc_coords, board)
    target_piece.is_a?(BPawn) && target_piece.passable == true
  end
  
  # generate possible moves depending on board state
  def gen_moves(board)
    @poss_moves = []
    @poss_moves << [0,2] if can_jump_fwd?(@pos, board) 
    @poss_moves << [0,1] if can_move_fwd?(@pos, board)
    @poss_moves << [-1,1] if can_capture_l?(@pos, board) || can_pass_l?(@pos, board)
    @poss_moves << [1,1] if can_capture_r?(@pos, board) || can_pass_r?(@pos, board)
  end
end

class BPawn < Pawn
  attr_reader :sym, :color, :poss_moves

  def initialize(coords)
    super
    @sym = "\u265F"
    @color = :black
  end

  def can_jump_fwd?(pos, board)
    pos[1] == 6 && board.path_clear?(pos, [pos[0], pos[1] - 3])
  end  

  def can_move_fwd?(pos, board)
    target_coords = ([pos[0], pos[1] - 1])
    within_board?(target_coords) && find_piece(target_coords, board).nil?
  end

  def can_capture_l?(pos, board)
    target_coords = ([pos[0] + 1, pos[1] - 1])
    return false unless within_board?(target_coords)
    target_piece = find_piece(target_coords, board)
    !target_piece.nil? && target_piece.color != @color
  end

  def can_capture_r?(pos, board)
    target_coords = ([pos[0] - 1, pos[1] - 1])
    return false unless within_board?(target_coords)
    target_piece = find_piece(target_coords, board)
    !target_piece.nil? && target_piece.color != @color
  end

  def can_pass_l?(pos, board)
    target_coords = ([pos[0] + 1, pos[1] - 1])
    target_pc_coords = ([pos[0] + 1, pos[1]])
    return false unless within_board?(target_coords) && within_board?(target_pc_coords)
    target_piece = find_piece(target_pc_coords, board)
    target_piece.is_a?(WPawn) && target_piece.passable == true
  end

  def can_pass_r?(pos, board)
    target_coords = ([pos[0] - 1, pos[1] - 1])
    target_pc_coords = ([pos[0] - 1, pos[1]])
    return false unless within_board?(target_coords) && within_board?(target_pc_coords)
    target_piece = find_piece(target_pc_coords, board)
    target_piece.is_a?(WPawn) && target_piece.passable == true
  end

  def gen_moves(board)
    @poss_moves = []
    @poss_moves << [0,-2] if can_jump_fwd?(@pos, board) 
    @poss_moves << [0,-1] if can_move_fwd?(@pos, board)
    @poss_moves << [1,-1] if can_capture_l?(@pos, board) || can_pass_l?(@pos, board)
    @poss_moves << [-1,-1] if can_capture_r?(@pos, board) || can_pass_r?(@pos, board)
  end
end
