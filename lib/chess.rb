require_relative 'player'
require_relative 'square'
require_relative 'king'

class Chess
  attr_reader :plr1, :plr2
  attr_accessor :act_plr, :board

  def initialize(name_1, name_2)
    @plr1 = Player.new(name_1, :white, WKing.new([4,0]))
    @plr2 = Player.new(name_2, :black, BKing.new([4,7]))
    @act_plr = @plr1
    @rem_pieces = []
    @taken_pieces = []
    gen_board
  end

  def gen_board
    @board = []
    (0..7).each do |col|
      (0..7).each do |row|
        @board << Square.new([row,col])
      end
    end
  end

  def switch_plrs
    @act_plr = if @act_plr == @plr1
                 @plr2
               else
                 @plr1
               end
  end
end
