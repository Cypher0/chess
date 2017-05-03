class Square
  attr_reader :coords
  attr_accessor :piece

  def initialize(coords, piece = nil)
    @coords = coords
    @piece = piece
  end
end
