class Rook
  attr_reader :poss_moves

  def initialize
    gen_moves
  end

  def gen_moves
    @poss_moves = []
    (-7..7).each do |i|
      @poss_moves << [i,0]
      @poss_moves << [0,i]
    end
  end
end

class WRook < Rook
  attr_reader :sym, :color

  def initialize
    @sym = "\u2656"
    @color = :white
  end
end

class BRook < Rook
  attr_reader :sym, :color

  def initialize
    @sym = "\u265C"
    @color = :black
  end
end
