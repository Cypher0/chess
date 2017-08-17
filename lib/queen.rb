# class for queen, init with position and possible moves
class Queen
  attr_reader :poss_moves
  attr_accessor :pos

  def initialize(coords)
    @poss_moves = []
    @pos = coords
    gen_moves
  end
  
  # generate possible moves for horizontal-vertical moving
  def gen_str_moves
    (-7..7).each do |i|
      @poss_moves << [i,0] << [0,i]
    end
  end
  
  # generate possible moves for diagonal moving
  def gen_diag_moves
    (1..7).each do |i|
      @poss_moves << [i,i] << [i,-i] << [-i,i] << [-i,-i]
    end
  end
  
  # generate possible moves for queen using loops
  def gen_moves
    gen_str_moves
    gen_diag_moves
    @poss_moves.delete_if { |i| i == [0,0] } # remove invalid entries
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
