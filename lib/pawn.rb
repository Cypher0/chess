class Pawn
  attr_reader :poss_moves
  
  def initialize
    @poss_moves = [[0,1]]
  end
end

class WPawn < Pawn
  attr_reader :sym, :color

  def initialize
    @sym = "\u2659"
    @color = :white
  end
end

class BPawn < Pawn
  attr_reader :sym, :color

  def initialize
    @sym = "\u265F"
    @color = :black
  end
end
