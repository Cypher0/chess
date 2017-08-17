# class for playes, init with name, color and type(cpu or human)
class Player
  attr_reader :name, :color
  attr_accessor :type

  def initialize(name, color, type = :human)
    @name = name
    @color = color
    @type = type
  end
end
