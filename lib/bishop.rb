class Bishop
  attr_reader :poss_moves
  attr_accessor :pos

  def initialize(coords)
    gen_moves
    @pos = coords
  end

  def gen_moves
    @poss_moves = []
    (1..7).each do |i|
      @poss_moves << [i,i] << [i,-i] << [-i,i] << [-i,-i]
    end
  end
end

class WBishop < Bishop
  attr_reader :sym, :color

  def initialize(coords)
    @sym = "\u2657"
    @color = :white
  end
end

class BBishop < Bishop
  attr_reader :sym, :color

  def initialize(coords)
    @sym = "\u265D"
    @color = :black
  end
end
