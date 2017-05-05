require 'board'

describe 'Board' do

  let(:board) { Board.new }

  describe '#gen_board' do

    it 'creates an array' do
      expect(board.squares).to be_an Array
    end

    it 'creates squares' do
      expect(board.squares[0]).to be_a Square
      expect(board.squares[54]).to be_a Square
    end

    it 'creates the correct number of squares' do
      expect(board.squares.size).to eql(64)
    end

    it 'keeps the squares ordered' do
      expect(board.squares[0].coords).to eql([0,0])
      expect(board.squares[-1].coords).to eql([7,7])
      expect(board.squares[11].coords).to eql([3,1])
    end
  end

  describe '#setup_pieces' do

    before { board.setup_pieces }

    it 'adds kings to correct positions' do
      expect(board.squares[4].piece).to be_a WKing
      expect(board.squares[-4].piece).to be_a BKing
    end

    it 'adds queens to correct positions' do
      expect(board.squares[3].piece).to be_a WQueen
      expect(board.squares[-5].piece).to be_a BQueen
    end

    it 'adds rooks to correct positions' do
      expect(board.squares[0].piece).to be_a WRook
      expect(board.squares[-1].piece).to be_a BRook
    end

    it 'adds knights to correct positions' do
      expect(board.squares[1].piece).to be_a WKnight
      expect(board.squares[-2].piece).to be_a BKnight
    end

    it 'adds bishops to correct positions' do
      expect(board.squares[2].piece).to be_a WBishop
      expect(board.squares[-3].piece).to be_a BBishop
    end

    it 'adds pawns to correct positions' do
      expect(board.squares[10].piece).to be_a WPawn
      expect(board.squares[15].piece).to be_a WPawn
      expect(board.squares[-9].piece).to be_a BPawn
      expect(board.squares[-15].piece).to be_a BPawn
    end
  end

  describe '#gen_rows' do

    before { board.gen_rows }

    it 'creates 8 rows' do
      expect(board.rows.size).to eql(8)
    end

    it 'adds 8 squares to each row' do
      expect(board.rows[0].size).to eql(8)
      expect(board.rows[5].size).to eql(8)
      expect(board.rows[-1].size).to eql(8)
    end
  end
end
