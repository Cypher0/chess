require 'chess'

describe 'Chess' do

  let(:game) { Chess.new('White', 'Black') }

  describe '#gen_board' do

    before { game.gen_board }

    it 'creates an array' do
      expect(game.board).to be_an Array
    end

    it 'creates squares' do
      expect(game.board[0]).to be_a Square
      expect(game.board[54]).to be_a Square
    end

    it 'creates the correct number of squares' do
      expect(game.board.size).to eql(64)
    end

    it 'keeps the squares ordered' do
      expect(game.board[0].coords).to eql([0,0])
      expect(game.board[-1].coords).to eql([7,7])
      expect(game.board[11].coords).to eql([3,1])
    end
  end
end