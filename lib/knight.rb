class Knight
  attr_reader :poss_moves
  attr_accessor :pos

  def initialize
    @poss_moves = [[-1,-2],[-1,2],[-2,-1],[-2,1],[1,2],[1,-2],[2,1],[2,-1]]
  end
end

class WKnight < Knight
  attr_reader :sym, :color

  def initialize(coords)
    @pos = coords
    @sym = "\u2658"
    @color = :white
  end
end

class BKnight < Knight
  attr_reader :sym, :color

  def initialize(coords)
    @pos = coords
    @sym = "\u265E"
    @color = :black
  end
end
