class Bishop
  attr_reader :poss_moves

  def initialize
    gen_moves
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

  def initialize
    @sym = "\u2657"
    @color = :white
  end
end

class BBishop < Bishop
  attr_reader :sym, :color

  def initialize
    @sym = "\u265D"
    @color = :black
  end
end
