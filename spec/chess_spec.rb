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

  describe '#switch_plrs' do

    before { game.switch_plrs }

    it 'switches to player2' do
      expect(game.act_plr).to eql(game.plr2)
    end

    it 'switches back to player1' do
      game.switch_plrs
      expect(game.act_plr).to eql(game.plr1)
    end
  end
end
