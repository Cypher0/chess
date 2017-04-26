class Queen
  attr_reader :poss_moves

  def initialize
    gen_moves
  end

  def gen_moves
    @poss_moves = []
    (-7..7).each do |i|
      @poss_moves << [i,0] << [0,i]
    end
    (1..7).each do |i|
      @poss_moves << [i,i] << [i,-i] << [-i,i] << [-i,-i]
    end
  end
end

class WQueen < Queen
  attr_reader :sym, :color

  def initialize
    @sym = "\u2655"
    @color = :white
  end
end

class BQueen < Queen
  attr_reader :sym, :color

  def initialize
    @sym = "\u265B"
    @color = :black
  end
end
