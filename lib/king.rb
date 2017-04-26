class King
  attr_reader :poss_moves

  def initialize
    @poss_moves = [[1-,0],[-1,1],[0,1],[1,1],[1,0],[1,-1],[0,-1],[-1,-1]]
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

  def initialize
    @sym = "\u265A"
    @color = :black
  end
end
