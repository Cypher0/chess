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

  describe '#legal_move?' do

    before do
      game.board.add_piece([0,0], :white, 'queen')
      game.board.add_piece([1,0], :black, 'knight')
      game.board.add_piece([3,1], :black, 'pawn')
      game.board.add_piece([0,2], :white, 'pawn')
    end

    context 'moving a queen' do

      context 'to empty square' do

        it 'returns true' do
          expect(game.legal_move?([0,0],[0,1])).to be true
          expect(game.legal_move?([0,0],[5,5])).to be true
        end
      end

      context 'to square with opponent\'s piece' do

        it 'returns true' do
          expect(game.legal_move?([0,0],[1,0])).to be true
        end
      end

      context 'to square with your own piece' do

        it 'returns false' do
          expect(game.legal_move?([0,0],[0,2])).to be false
        end
      end

      context 'to square not on direct path' do

        it 'returns false' do
          expect(game.legal_move?([0,0],[1,2])).to be false
        end
      end

      context 'jumping over a piece' do

        it 'returns false' do
          expect(game.legal_move?([0,0],[4,0])).to be false
          expect(game.legal_move?([0,0],[0,3])).to be false
        end
      end
    end

    context 'moving a knight' do

      context 'to empty square' do

        it 'returns true' do
          expect(game.legal_move?([1,0],[2,2])).to be true
        end
      end

      context 'to square with own piece' do

        it 'returns false' do
          expect(game.legal_move?([1,0],[3,1])).to be false
        end
      end

      context 'to square with opponent\'s piece' do

        it 'returns true' do
          expect(game.legal_move?([1,0],[0,2])).to be true
        end
      end

      context 'to non-reachable square' do

        it 'return false' do
          expect(game.legal_move?([1,0],[3,2])).to be false
        end
      end
    end

    context 'moving a pawn' do

      context 'one square forward' do

        before { game.board.squares[16].piece.gen_moves(game.board) }

        context 'to empty square' do

          it 'returns true' do
            expect(game.legal_move?([0,2],[0,3])).to be true
          end
        end

        context 'to occupied square' do
         
          it 'returns false' do
            game.board.add_piece([0,3], :black, 'pawn')
            expect(game.legal_move?([0,2],[0,3])).to be false
          end
        end
      end

      context 'two squares forward' do

        context 'when it has not moved' do

          it 'returns true' do
            game.board.add_piece([7,1], :white, 'pawn')
            game.board.squares[15].piece.gen_moves(game.board)
            expect(game.legal_move?([7,1],[7,3])).to be true
          end
        end

        context 'from random position' do

          it 'returns false' do
            game.board.move([0,2],[0,4])
            expect(game.legal_move?([0,4],[0,6])).to be false
          end
        end
      end

      context 'one square diagonally' do

        context 'to empty square' do

          it 'returns false' do
            expect(game.legal_move?([0,2],[1,3])).to be false
          end
        end

        context 'en passant' do

          it 'returns true' do
            game.board.add_piece([1,4], :black, 'pawn')
            game.board.move([1,4],[1,2])
            game.board.squares[16].piece.gen_moves(game.board)
            expect(game.legal_move?([0,2],[1,3])).to be true
          end
        end

        context 'capturing a piece' do

          it 'returns true' do
            game.board.add_piece([1,3], :black, 'pawn')
            expect(game.legal_move?([0,2],[1,3])).to be true
          end
        end
      end
    end
  end

  describe '#check?' do

    before do
      game.board.add_piece([0,0], :black, 'king')
    end

    context 'when targeted by opponent\'s piece' do

      it 'returns true' do
        game.board.add_piece([1,2], :white, 'knight')
        expect(game.check?(game.plr2)).to be true
      end
    end

    context 'when targeted by own piece' do

      it 'returns false' do
        game.board.add_piece([7,0], :black, 'queen')
        expect(game.check?(game.plr2)).to be false
      end
    end

    context 'when opponent\'s path is blocked' do

      it 'returns false' do
        game.board.add_piece([0,7], :white, 'queen')
        game.board.add_piece([0,4], :white, 'pawn')
        expect(game.check?(game.plr2)).to be false
      end
    end
  end

  describe '#stalemate?' do

    it 'returns true ex. 1' do
      game.board.add_piece([5,6], :white, 'king')
      game.board.add_piece([6,5], :white, 'queen')
      game.board.add_piece([7,7], :black, 'king')
      expect(game.stalemate?(game.plr2)).to be true
    end

    it 'returns true ex. 2' do
      game.board.add_piece([0,0], :black, 'king')
      game.board.add_piece([1,1], :white, 'rook')
      game.board.add_piece([2,2], :white, 'king')
      expect(game.stalemate?(game.plr2)).to be true
    end

    it 'returns true ex. 3' do
      game.board.add_piece([0,7], :black, 'king')
      game.board.add_piece([0,5], :white, 'king')
      game.board.add_piece([5,3], :white, 'bishop')
      expect(game.stalemate?(game.plr2)).to be true
    end

    it 'returns true ex. 4' do
      game.board.add_piece([5,5], :white, 'queen')
      game.board.add_piece([5,6], :white, 'pawn')
      game.board.add_piece([5,7], :black, 'king')
      expect(game.stalemate?(game.plr2)).to be true
    end
  end

  describe '#can_castle_kingside?' do

    before do
      game.board.add_piece([4,0], :white, 'king')
      game.board.add_piece([7,0], :white, 'rook')
    end

    it 'returns true' do
      expect(game.can_castle_kingside?(game.plr1)).to be true
    end

    context 'when king has moved' do

      it 'returns false' do
        game.board.move([4,0],[5,0])
        game.board.move([5,0],[4,0])
        expect(game.can_castle_kingside?(game.plr1)).to be false
      end
    end

    context 'when rook has moved' do

      it 'returns false' do
        game.board.move([7,0],[7,7])
        game.board.move([7,7],[7,0])
        expect(game.can_castle_kingside?(game.plr1)).to be false
      end
    end

    context 'when path is blocked' do

      it 'returns false' do
        game.board.add_piece([5,0], :white, 'queen')
        expect(game.can_castle_kingside?(game.plr1)).to be false
      end
    end

    context 'when king is in check' do

      it 'returns false' do
        game.board.add_piece([4,5], :black, 'queen')
        expect(game.can_castle_kingside?(game.plr1)).to be false
      end
    end

    context 'when king\'s path is in check' do

      it 'returns false' do
        game.board.add_piece([5,5], :black, 'queen')
        expect(game.can_castle_kingside?(game.plr1)).to be false
      end
    end
  end

  describe '#can_castle_queenside?' do

    before do
      game.board.add_piece([4,0], :white, 'king')
      game.board.add_piece([0,0], :white, 'rook')
    end

    it 'returns true' do
      expect(game.can_castle_queenside?(game.plr1)).to be true
    end

    context 'when king has moved' do

      it 'returns false' do
        game.board.move([4,0],[5,0])
        game.board.move([5,0],[4,0])
        expect(game.can_castle_queenside?(game.plr1)).to be false
      end
    end

    context 'when rook has moved' do

      it 'returns false' do
        game.board.move([0,0],[0,7])
        game.board.move([0,7],[0,0])
        expect(game.can_castle_queenside?(game.plr1)).to be false
      end
    end

    context 'when path is blocked' do

      it 'returns false' do
        game.board.add_piece([3,0], :white, 'queen')
        expect(game.can_castle_queenside?(game.plr1)).to be false
      end
    end

    context 'when king is in check' do

      it 'returns false' do
        game.board.add_piece([4,5], :black, 'queen')
        expect(game.can_castle_queenside?(game.plr1)).to be false
      end
    end

    context 'when king\'s path is in check' do

      it 'returns false' do
        game.board.add_piece([3,5], :black, 'queen')
        expect(game.can_castle_queenside?(game.plr1)).to be false
      end
    end

    context 'when rook\'s path is in check' do

      it 'returns true' do
        game.board.add_piece([1,5], :black, 'queen')
        expect(game.can_castle_queenside?(game.plr1)).to be true
      end
    end
  end

  describe '#checkmate?' do

    it 'returns true on "rook checkmate"' do
      game.board.add_piece([4,0], :white, 'king')
      game.board.add_piece([7,0], :black, 'rook')
      game.board.add_piece([4,2], :black, 'king')
      expect(game.checkmate?(game.plr1)).to be true
    end

    it 'returns true on "bishop checkmate' do
      game.board.add_piece([4,2], :black, 'bishop')
      game.board.add_piece([5,2], :black, 'bishop')
      game.board.add_piece([7,2], :black, 'king')
      game.board.add_piece([7,0], :white, 'king')
      expect(game.checkmate?(game.plr1)).to be true
    end

    it 'returns true on "fools mate"' do
      game.board.setup_pieces
      game.board.move([5,1],[5,2])
      game.board.move([4,6],[4,4])
      game.board.move([6,1],[6,3])
      game.board.move([3,7],[7,3])
      expect(game.checkmate?(game.plr1)).to be true
    end

    it 'returns true on "bishop checkmate"' do
      game.board.add_piece([0,7], :white, 'king')
      game.board.add_piece([1,5], :black, 'king')
      game.board.add_piece([2,5], :black, 'bishop')
      game.board.add_piece([2,6], :black, 'bishop')
      expect(game.checkmate?(game.plr1)).to be true
    end

    it 'returns true on "knight checkmate"' do
      game.board.add_piece([7,7], :white, 'king')
      game.board.add_piece([6,5], :black, 'king')
      game.board.add_piece([5,5], :black, 'bishop')
      game.board.add_piece([7,5], :black, 'knight')
      expect(game.checkmate?(game.plr1)).to be true
    end

    it 'returns true on "back-rank mate"' do
      game.board.add_piece([6,0], :white, 'king')
      game.board.add_piece([7,1], :white, 'pawn')
      game.board.add_piece([6,1], :white, 'pawn')
      game.board.add_piece([5,1], :white, 'pawn')
      game.board.add_piece([3,0], :black, 'rook')
      expect(game.checkmate?(game.plr1)).to be true
    end
  end
end
