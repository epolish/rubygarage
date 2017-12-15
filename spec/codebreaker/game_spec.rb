module Codebreaker
  RSpec.describe Game do
    subject { Game.new }

    context 'instance variables after creating Game object' do
      context 'secret_number' do
        let(:secret_number) { subject.secret_number }

        it 'return secret number' do
          expect(secret_number).to be_kind_of(Array)
        end

        it 'has 4 digit' do
          expect(secret_number.size).to eq(4)
        end

        it 'has only digits between 1 and 6' do
          expect(secret_number.join).to match(/^[1-6]{4}$/)
        end
      end
    end
  end
end