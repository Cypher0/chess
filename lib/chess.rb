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

  def legal_move?(start, dest)
    a = @board.squares.find { |sq| sq.coords == start }
    b = @board.squares.find { |sq| sq.coords == dest }
    @board.path_clear?(start, dest) &&
    (b.piece.nil? || @act_plr.color != b.piece.color) &&
    a.piece.poss_moves.any? { |mv| mv.map.with_index { |v, i| v + start[i] } == dest }
  end

  def check?(plr)
    target = @board.rem_pieces.find { |pc| pc.class < King && pc.color == plr.color }
    @board.rem_pieces.any? { |pc| pc.color != target.color && legal_move?(pc.pos, target.pos) }
  end
end
