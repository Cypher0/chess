# class for a chess board square, init with coordinates and piece occupying it.
class Square
  attr_reader :coords
  attr_accessor :piece

  def initialize(coords, piece = nil)
    @coords = coords
    @piece = piece
  end
end
