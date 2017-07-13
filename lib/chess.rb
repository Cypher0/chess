require_relative 'player'
require_relative 'board'

class Chess
  attr_reader :plr1, :plr2
  attr_accessor :act_plr, :board

  def initialize(name_1, name_2)
    @board = Board.new
    @plr1 = Player.new(name_1, :white)
    @plr2 = Player.new(name_2, :black)
    @act_plr = @plr1
  end

  def switch_plrs
    @act_plr = if @act_plr == @plr1
                 @plr2
               else
                 @plr1
               end
  end

  def legal_move?(start, dest, board = @board)
    return false unless (start + dest).all? { |i| i.between?(0,7)}
    a = board.squares.find { |sq| sq.coords == start }
    b = board.squares.find { |sq| sq.coords == dest }
    a.piece.gen_moves(@board.squares) if a.piece.class < Pawn
    !a.piece.nil? &&
    board.path_clear?(start, dest) &&
    (b.piece.nil? || a.piece.color != b.piece.color) &&
    a.piece.poss_moves.any? { |mv| [a.piece.pos[0] + mv[0], a.piece.pos[1] + mv[1]] == dest }
  end

  def can_castle_kingside?(plr, board = @board.dup, king = board.rem_pieces.find { |pc| pc.class < King && pc.color == plr.color} )
    result = true
    if board.squares.find { |sq| sq.coords == [7, king.pos[1]]}.piece.class < Rook
      rook = board.squares.find { |sq| sq.coords == [7, king.pos[1]] }.piece
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

  def can_castle_queenside?(plr, board = @board.dup, king = board.rem_pieces.find { |pc| pc.class < King && pc.color == plr.color} )
    result = true
    if board.squares.find { |sq| sq.coords == [0, king.pos[1]]}.piece.class < Rook
      rook = board.squares.find { |sq| sq.coords == [0, king.pos[1]] }.piece
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
      sq.piece.gen_moves(board.squares) if sq.piece.class < Pawn
      sq.piece.poss_moves.each do |mv|
        target = [start[0] + mv[0], start[1] + mv[1]]
        if legal_move?(start, target)
          temp_piece << board.squares.find { |sq| sq.coords == target }.piece unless board.squares.find { |sq| sq.coords == target }.piece.nil?
          board.squares.find { |sq| sq.coords == target }.piece = nil
          board.move(start, target)
          puts start.inspect unless check?(plr, board)
          return false unless check?(plr, board)
          board.move(target, start)
          board.squares.find { |sq| sq.coords == target }.piece = temp_piece.pop unless temp_piece.empty?
        end
      end
    end
    true
  end

  def checkmate?(plr)
    stalemate?(plr) && check?(plr)
  end
end


game = Chess.new('a','b')

game.board.setup_pieces
game.board.move([5,1],[5,2])
game.board.move([4,6],[4,4])
game.board.move([6,1],[6,3])
game.board.move([3,7],[7,3])
puts game.checkmate?(game.plr1)
