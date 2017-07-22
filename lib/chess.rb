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

  def not_own_piece?(start, dest)
    dest.piece.nil? || start.piece.color != dest.piece.color
  end

  def piece_can_move?(start, dest)
    start.piece.poss_moves.any? { |mv| [start.piece.pos[0] + mv[0], start.piece.pos[1] + mv[1]] == dest.coords }
  end

  def legal_move?(start, dest, board = @board)
    return false unless (start + dest).all? { |i| i.between?(0, 7) }
    start_sq = board.find_square(start)
    dest_sq = board.find_square(dest)
    start_sq.piece.gen_moves(board) if start_sq.piece.class < Pawn
    board.path_clear?(start, dest) &&
    not_own_piece?(start_sq, dest_sq) &&
    piece_can_move?(start_sq, dest_sq)
  end

  def can_castle_kingside?(plr, board = @board.dup)
    result = true
    king = board.rem_pieces.find { |pc| pc.class < King && pc.color == plr.color }
    rook_sq = board.find_square([7, king.pos[1]])
    if rook_sq.piece.class < Rook
      rook = rook_sq.piece
    else
      return false
    end
    result = false if king.has_moved || rook.has_moved || check?(plr, board) || !board.path_clear?(king.pos, rook.pos)
    board.move(king.pos, [king.pos[0] + 1, king.pos[1]])
    result = false if check?(plr, board)
    board.move(king.pos, [king.pos[0] + 1, king.pos[1]])
    result = false if check?(plr, board)
    result
  end

  def can_castle_queenside?(plr, board = @board.dup)
    result = true
    king = board.rem_pieces.find { |pc| pc.class < King && pc.color == plr.color }
    rook_sq = board.find_square([0, king.pos[1]])
    if rook_sq.piece.class < Rook
      rook = board.find_square([0, king.pos[1]]).piece
    else
      return false
    end
    result = false if king.has_moved || rook.has_moved || check?(plr, board) || !board.path_clear?(king.pos, rook.pos)
    board.move(king.pos, [king.pos[0] - 1, king.pos[1]])
    result = false if check?(plr, board)
    board.move(king.pos, [king.pos[0] - 1, king.pos[1]])
    result = false if check?(plr, board)
    result
  end

  def check?(plr, board = @board)
    king = board.rem_pieces.find { |pc| pc.class < King && pc.color == plr.color }
    board.rem_pieces.any? { |pc| pc.color != king.color && legal_move?(pc.pos, king.pos) }
  end

  def stalemate?(plr, board = @board.dup)
    temp_piece = []
    @board.squares.each do |sq|
      start = sq.coords
      next if sq.piece.nil? || sq.piece.color != plr.color
      sq.piece.gen_moves(board) if sq.piece.class < Pawn
      sq.piece.poss_moves.each do |mv|
        dest = [start[0] + mv[0], start[1] + mv[1]]
        dest_sq = board.find_square(dest)
        next unless legal_move?(start, dest)
        temp_piece << dest_sq.piece unless dest_sq.piece.nil?
        dest_sq.piece = nil
        board.move(start, dest)
        return false unless check?(plr, board)
        board.move(dest, start)
        dest_sq.piece = temp_piece.pop unless temp_piece.empty?
      end
    end
    true
  end

  def checkmate?(plr)
    stalemate?(plr) && check?(plr)
  end

  def game_over?
    checkmate?(@act_plr) || stalemate?(@act_plr)
  end
end
