class King
  attr_reader :poss_moves
  attr_accessor :pos, :has_moved

  def initialize(coords)
    @pos = coords
    @poss_moves = [[-1,0],[-1,1],[0,1],[1,1],[1,0],[1,-1],[0,-1],[-1,-1]]
    @has_moved = false
  end
end

class WKing < King
  attr_reader :sym, :color

  def initialize(coords)
    super
    @sym = "\u2654"
    @color = :white
  end
end

class BKing < King
  attr_reader :sym, :color

  def initialize(coords)
    super
    @sym = "\u265A"
    @color = :black
  end
end
