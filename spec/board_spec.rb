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

    it 'keeps track of all pieces' do
      expect(board.rem_pieces.size).to eql(32)
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

  describe '#move' do

    before do 
      board.add_piece([0,0], :white, 'king')
      board.add_piece([1,0], :black, 'pawn')
      board.move([0,0],[1,0])
    end

    it 'removes target piece from starting square' do
      expect(board.squares[0].piece).to be nil
    end

    it 'adds target piece to destination square' do
      expect(board.squares[1].piece).to be_a WKing
    end

    it 'removes taken piece' do
      expect(board.rem_pieces.size).to eql(1)
    end

    it 'adds taken piece to corresponding array' do
      expect(board.taken_pieces.size).to eql(1)
    end
  end

  describe '#draw_str_path' do

    it 'returns an array' do
      expect(board.draw_str_path([0,0],[0,7])).to be_an Array
    end

    context 'moving horisontally' do

      context 'by one square' do

        it 'returns empty path' do
          expect(board.draw_str_path([0,0],[1,0]).size).to eql(0)
          expect(board.draw_str_path([1,0],[0,0]).size).to eql(0)
        end
      end

      context 'by multiple squares' do

        it 'returns path with correct length' do
          expect(board.draw_str_path([0,0],[6,0]).size).to eql(5)
          expect(board.draw_str_path([7,3],[4,3]).size).to eql(2)
        end
      end
    end

    context 'moving vertically' do

      context 'by one square' do

        it 'returns empty path' do
          expect(board.draw_str_path([0,0],[0,1]).size).to eql(0)
          expect(board.draw_str_path([0,1],[0,0]).size).to eql(0)
        end
      end

      context 'by multiple squares' do

        it 'returns path with correct length' do
          expect(board.draw_str_path([0,7],[0,1]).size).to eql(5)
          expect(board.draw_str_path([3,3],[3,6]).size).to eql(2)
        end
      end
    end
  end

  describe '#draw_diag_path' do

    it 'returns an array' do
      expect(board.draw_diag_path([0,0],[1,1])).to be_an Array
    end

    context 'moving by one square' do

      it 'returns empty path' do
        expect(board.draw_diag_path([0,0],[1,1]).size).to eql(0)
        expect(board.draw_diag_path([2,0],[1,1]).size).to eql(0)
        expect(board.draw_diag_path([5,5],[4,4]).size).to eql(0)
        expect(board.draw_diag_path([1,5],[2,4]).size).to eql(0)
      end
    end

    context 'moving by multiple squares' do

      it 'returns path with correct size' do
        expect(board.draw_diag_path([0,0],[5,5]).size).to eql(4)
        expect(board.draw_diag_path([3,5],[7,1]).size).to eql(3)
        expect(board.draw_diag_path([2,4],[0,2]).size).to eql(1)
        expect(board.draw_diag_path([6,0],[0,6]).size).to eql(5)
      end
    end
  end

  describe '#path_clear?' do

    before { board.add_piece([2,2], :white, 'pawn') }

    context 'when moving by one square' do

      it 'returns true' do
        expect(board.path_clear?([1,1],[2,2])).to be true
        expect(board.path_clear?([2,3],[2,2])).to be true
      end
    end

    context 'when moving multiple squares' do

      it 'returns true on a clear path' do
        expect(board.path_clear?([3,3],[7,7])).to be true
        expect(board.path_clear?([2,2],[2,5])).to be true
      end

      it 'returns false on a blocked path' do
        expect(board.path_clear?([1,1],[3,3])).to be false
        expect(board.path_clear?([2,0],[2,4])).to be false
        expect(board.path_clear?([5,2],[1,2])).to be false
      end
    end

    context 'when no direct path exists' do

      it 'returns true' do
        expect(board.path_clear?([2,0],[3,2])).to be true
        expect(board.path_clear?([1,1],[6,5])).to be true
        expect(board.path_clear?([0,0],[1,2])).to be true
      end
    end
  end
end
