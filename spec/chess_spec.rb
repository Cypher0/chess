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

  describe '#setup_pieces' do

    before do
      game.gen_board
      game.setup_pieces
    end

    it 'adds kings to correct positions' do
      expect(game.board[4].piece).to be_a WKing
      expect(game.board[-4].piece).to be_a BKing
    end

    it 'adds queens to correct positions' do
      expect(game.board[3].piece).to be_a WQueen
      expect(game.board[-5].piece).to be_a BQueen
    end

    it 'adds rooks to correct positions' do
      expect(game.board[0].piece).to be_a WRook
      expect(game.board[-1].piece).to be_a BRook
    end

    it 'adds knights to correct positions' do
      expect(game.board[1].piece).to be_a WKnight
      expect(game.board[-2].piece).to be_a BKnight
    end

    it 'adds bishops to correct positions' do
      expect(game.board[2].piece).to be_a WBishop
      expect(game.board[-3].piece).to be_a BBishop
    end

    it 'adds pawns to correct positions' do
      expect(game.board[10].piece).to be_a WPawn
      expect(game.board[15].piece).to be_a WPawn
      expect(game.board[-9].piece).to be_a BPawn
      expect(game.board[-15].piece).to be_a BPawn
    end
  end
end
