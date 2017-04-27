class King
  attr_reader :poss_moves
  attr_accessor :pos

  def initialize(coords)
    @poss_moves = [[1-,0],[-1,1],[0,1],[1,1],[1,0],[1,-1],[0,-1],[-1,-1]]
    @pos = coords
  end
end

class WKing < King
  attr_reader :sym, :color

  def initialize
    @sym = "\u2654"
    @color = :white
  end
end

class BKing < King
  attr_reader :sym, :color

  def initialize(coords)
    @sym = "\u265A"
    @color = :black
  end
end
