class Square
  attr_reader :coords
  attr_accessor :color, :piece

  def initialize(coords, color = nil, piece = nil)
    @coords = coords
    @color = color
    @piece = piece
  end
end
