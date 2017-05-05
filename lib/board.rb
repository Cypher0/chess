require_relative 'square'
require_relative 'king'
require_relative 'queen'
require_relative 'pawn'
require_relative 'rook'
require_relative 'bishop'
require_relative 'knight'

class Board
  attr_accessor :squares, :rows, :rem_pieces, :taken_pieces

  def initialize
    @rem_pieces = []
    @taken_pieces = []
    @rows = []
    gen_board
  end

  def gen_board
    @squares = []
    (0..7).each do |col|
      (0..7).each do |row|
        @squares << Square.new([row,col])
      end
    end
  end
end
