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

  def check?(plr, board = @board)
    king = board.rem_pieces.find { |pc| pc.class < King && pc.color == plr.color }
    board.rem_pieces.any? { |pc| pc.color != king.color && legal_move?(pc.pos, king.pos) }
  end

  def stalemate?(plr, board = @board.dup)
    temp_piece = []
    @board.squares.each do |sq|
      start = sq.coords
      next if sq.piece.nil? || sq.piece.color != plr.color
      sq.piece.poss_moves.each do |mv|
        target = [start[0] + mv[0], start[1] + mv[1]]
        if legal_move?(start, target)
          temp_piece << board.squares.find { |sq| sq.coords == target }.piece unless board.squares.find { |sq| sq.coords == target }.piece.nil?
          board.squares.find { |sq| sq.coords == target }.piece = nil
          board.move(start, target)
          return false unless check?(plr, board)
          board.move(target, start)
          board.squares.find { |sq| sq.coords == target }.piece = temp_piece.pop unless temp_piece.empty?
        end
      end
    end
    true
  end
end

game = Chess.new('a','b')
