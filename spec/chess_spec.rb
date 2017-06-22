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
      game.board.add_queen([0,0], :white)
      game.board.add_knight([1,0], :black)
      game.board.add_pawn([3,1], :black)
      game.board.add_pawn([0,2], :white)
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

        before { game.board.squares[16].piece.gen_moves(game.board.squares) }

        context 'to empty square' do

          it 'returns true' do
            expect(game.legal_move?([0,2],[0,3])).to be true
          end
        end

        context 'to occupied square' do
         
          it 'returns false' do
            game.board.add_pawn([0,3], :black)
            expect(game.legal_move?([0,2],[0,3])).to be false
          end
        end
      end

      context 'two squares forward' do

        context 'when it has not moved' do

          it 'returns true' do
            game.board.add_pawn([7,1], :white)
            game.board.squares[15].piece.gen_moves(game.board.squares)
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
            game.board.add_pawn([1,4], :black)
            game.board.move([1,4],[1,2])
            game.board.squares[16].piece.gen_moves(game.board.squares)
            expect(game.legal_move?([0,2],[1,3])).to be true
          end
        end

        context 'capturing a piece' do

          it 'returns true' do
            game.board.add_pawn([1,3], :black)
            expect(game.legal_move?([0,2],[1,3])).to be true
          end
        end
      end
    end
  end

  describe '#check?' do

    before do
      game.board.add_king([0,0], :black)
    end

    context 'when targeted by opponent\'s piece' do

      it 'returns true' do
        game.board.add_knight([1,2], :white)
        expect(game.check?(game.plr2)).to be true
      end
    end

    context 'when targeted by own piece' do

      it 'returns false' do
        game.board.add_queen([7,0], :black)
        expect(game.check?(game.plr2)).to be false
      end
    end

    context 'when opponent\'s path is blocked' do

      it 'returns false' do
        game.board.add_queen([0,7], :white)
        game.board.add_pawn([0,4], :white)
        expect(game.check?(game.plr2)).to be false
      end
    end
  end

  describe '#stalemate?' do

    it 'returns true ex. 1' do
      game.board.add_king([5,6], :white)
      game.board.add_queen([6,5], :white)
      game.board.add_king([7,7], :black)
      expect(game.stalemate?(game.plr2)).to be true
    end

    it 'returns true ex. 2' do
      game.board.add_king([0,0], :black)
      game.board.add_rook([1,1], :white)
      game.board.add_king([2,2], :white)
      expect(game.stalemate?(game.plr2)).to be true
    end

    it 'returns true ex. 3' do
      game.board.add_king([0,7], :black)
      game.board.add_king([0,5], :white)
      game.board.add_bishop([5,3], :white)
      expect(game.stalemate?(game.plr2)).to be true
    end

    it 'returns true ex. 4' do
      game.board.add_queen([5,5], :white)
      game.board.add_pawn([5,6], :white)
      game.board.add_king([5,7], :black)
      expect(game.stalemate?(game.plr2)).to be true
    end
  end

  describe '#can_castle_kingside?' do

    before do
      game.board.add_king([4,0], :white)
      game.board.add_rook([7,0], :white)
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
        game.board.add_queen([5,0], :white)
        expect(game.can_castle_kingside?(game.plr1)).to be false
      end
    end

    context 'when king is in check' do

      it 'returns false' do
        game.board.add_queen([4,5], :black)
        expect(game.can_castle_kingside?(game.plr1)).to be false
      end
    end

    context 'when king\'s path is in check' do

      it 'returns false' do
        game.board.add_queen([5,5], :black)
        expect(game.can_castle_kingside?(game.plr1)).to be false
      end
    end
  end

  describe '#can_castle_queenside?' do

    before do
      game.board.add_king([4,0], :white)
      game.board.add_rook([0,0], :white)
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
        game.board.add_queen([3,0], :white)
        expect(game.can_castle_queenside?(game.plr1)).to be false
      end
    end

    context 'when king is in check' do

      it 'returns false' do
        game.board.add_queen([4,5], :black)
        expect(game.can_castle_queenside?(game.plr1)).to be false
      end
    end

    context 'when king\'s path is in check' do

      it 'returns false' do
        game.board.add_queen([3,5], :black)
        expect(game.can_castle_queenside?(game.plr1)).to be false
      end
    end

    context 'when rook\'s path is in check' do

      it 'returns true' do
        game.board.add_queen([1,5], :black)
        expect(game.can_castle_queenside?(game.plr1)).to be true
      end
    end
  end
end
