# class for rook, init with position, possible moves and has_moved params
class Rook
  attr_reader :poss_moves
  attr_accessor :pos, :has_moved

  def initialize(coords)
    @pos = coords
    @has_moved = false
    gen_moves
  end
  
  # generate possible moves for rook
  def gen_moves
    @poss_moves = []
    (-7..7).each do |i|
      @poss_moves << [i,0] << [0,i]
    end
    @poss_moves.delete_if { |i| i == [0,0] } # remove invalid entries
  end
end

class WRook < Rook
  attr_reader :sym, :color

  def initialize(coords)
    super
    @sym = "\u2656"
    @color = :white
  end
end

class BRook < Rook
  attr_reader :sym, :color

  def initialize(coords)
    super
    @sym = "\u265C"
    @color = :black
  end
end
