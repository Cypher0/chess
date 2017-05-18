class Pawn
  attr_reader :poss_moves
  attr_accessor :pos
  
  def initialize(coords)
    @poss_moves = [[0,1]]
    @pos = coords
  end
end

class WPawn < Pawn
  attr_reader :sym, :color

  def initialize(coords)
    super
    @sym = "\u2659"
    @color = :white
  end
end

class BPawn < Pawn
  attr_reader :sym, :color

  def initialize(coords)
    super
    @sym = "\u265F"
    @color = :black
  end
end
