class Player
  attr_reader :name, :color
  attr_accessor :king

  def initialize(name, color, king)
    @name = name
    @color = color
    @king = king
  end
end
