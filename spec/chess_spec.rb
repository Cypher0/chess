require 'chess'

describe 'Chess' do

  let(:game) { Chess.new('White', 'Black') }

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
