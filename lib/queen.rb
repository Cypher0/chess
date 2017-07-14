class Queen
  attr_reader :poss_moves
  attr_accessor :pos

  def initialize(coords)
    @poss_moves = []
    @pos = coords
    gen_moves
  end

  def gen_str_moves
    (-7..7).each do |i|
      @poss_moves << [i,0] << [0,i]
    end
  end

  def gen_diag_moves
    (1..7).each do |i|
      @poss_moves << [i,i] << [i,-i] << [-i,i] << [-i,-i]
    end
  end

  def gen_moves
    gen_str_moves
    gen_diag_moves
    @poss_moves.delete_if { |i| i == [0,0] }
  end
end

class WQueen < Queen
  attr_reader :sym, :color

  def initialize(coords)
    super
    @sym = "\u2655"
    @color = :white
  end
end

class BQueen < Queen
  attr_reader :sym, :color

  def initialize(coords)
    super
    @sym = "\u265B"
    @color = :black
  end
end
