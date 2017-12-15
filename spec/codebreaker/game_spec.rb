module Codebreaker
  RSpec.shared_examples 'game object instance variables' do |subject|
    context 'secret_number' do
      let(:secret_number) { subject.secret_number }

      it 'secret_number is kind of array' do
        expect(secret_number).to be_kind_of(Array)
      end

      it 'secret_number has 4 digit' do
        expect(secret_number.size).to eq(4)
      end

      it 'secret_number has only digits between 1 and 6' do
        expect(secret_number.join).to match(/^[1-6]{4}$/)
      end
    end

    context 'other fields' do
      it 'is_win is kind of FalseClass' do
        expect(subject.is_win).to be_kind_of(FalseClass)
      end

      it 'progress is kind of NilClass' do
        expect(subject.progress).to be_kind_of(NilClass)
      end

      it 'hint_count is 0' do
        expect(subject.hint_count).to eq(0)
      end

      it 'try_number is 0' do
        expect(subject.try_number).to eq(0)
      end
    end
  end

  RSpec.describe Game do
    context 'game initialize and reload method' do
      object = Game.new

      include_examples 'game object instance variables', object
      
      object.reload

      include_examples 'game object instance variables', object
    end

    context 'game methods' do
      subject { Game.new }

      let(:test_secret_number) { [1, 2, 3, 4] }

      let(:max_tries) { subject.class::MAX_TRIES }

      it 'win? return true or false' do
        expect(subject.win?).to eq(false)

        subject.send(:is_win=, true)

        expect(subject.win?).to eq(true)
      end

      it 'can_try return true while try_number is less than MAX_TRIES' do
        0.upto(max_tries - 1) do |i|
          subject.send(:try_number=, i)

          expect(subject.can_try).to eq(true)
        end

        subject.send(:try_number=, max_tries) 

        expect(subject.can_try).to eq(false)
      end

      it 'add_hint increments hint_count' do
        old_hint_count = subject.hint_count

        subject.add_hint

        expect(subject.hint_count).to eq(old_hint_count + 1)
      end

      it 'get_answer returns secret_number with hints' do
        subject.send(:hint_count=, 2)

        subject.send(:secret_number=, test_secret_number)

        expect(subject.get_answer).to eq([1, 2, nil, nil])
      end

      it 'get_answer returns secret_number with hints' do
        subject.send(:hint_count=, 2)

        subject.send(:secret_number=, test_secret_number)

        expect(subject.get_answer).to eq([1, 2, nil, nil])
      end

      it 'get_exact_match returns exact match' do
        subject.send(:secret_number=, test_secret_number)

        exact_match_count = subject.send(:get_exact_match, [1, 4, 3, 2])

        expect(exact_match_count).to eq([1, nil, 3, nil])
      end

      it 'get_exact_match_count returns exact match count' do
        subject.send(:secret_number=, test_secret_number)

        exact_match_count = subject.send(:get_exact_match_count, [1, 4, 3, 2])

        expect(exact_match_count).to eq(2)
      end

      it 'get_numbered_match returns numbered match' do
        subject.send(:secret_number=, test_secret_number)

        exact_match_count = subject.send(:get_numbered_match, [1, 4, 4, 2])

        expect(exact_match_count).to eq([2, 4])
      end

      it 'get_exact_match_count returns numbered match count' do
        subject.send(:secret_number=, test_secret_number)

        exact_match_count = subject.send(:get_numbered_match_count, [1, 4, 4, 2])

        expect(exact_match_count).to eq(2)
      end

      it 'prepare_gues_number returns prepared user number' do
        expect(subject.send(:prepare_gues_number, '1234')).to eq(test_secret_number)

        expect(subject.send(:prepare_gues_number, '123456789')).to eq(test_secret_number)

        expect(subject.send(:prepare_gues_number, 'testtest')).to eq([0, 0, 0, 0])

        expect(subject.send(:prepare_gues_number, test_secret_number)).to eq([1, 2, 3, 4])

        expect(subject.send(:prepare_gues_number, test_secret_number + [5, 6])).to eq([1, 2, 3, 4])

        expect(subject.send(:prepare_gues_number, ['a', 'b', 'c', 'd', 'e', 'f'])).to eq([0, 0, 0, 0])
      end

      it 'reload_progress returns reloaded progress game information' do
        subject.send(:secret_number=, test_secret_number)

        reload_progress = subject.send(:reload_progress, [1, 2, 4, 3])

        expect(reload_progress).to eq([:+, :+, :-, :-])

        reload_progress = subject.send(:reload_progress, test_secret_number)

        expect(reload_progress).to eq([:+, :+, :+, :+])

        reload_progress = subject.send(:reload_progress, [4, 3, 2, 1])

        expect(reload_progress).to eq([:-, :-, :-, :-])

        reload_progress = subject.send(:reload_progress, [1, 2, 6, 6])

        expect(reload_progress).to eq([:+, :+])

        reload_progress = subject.send(:reload_progress, [3, 4, 6, 5])

        expect(reload_progress).to eq([:-, :-])

        reload_progress = subject.send(:reload_progress, [5, 6, 6, 5])

        expect(reload_progress).to eq([])
      end
    end
  end
end