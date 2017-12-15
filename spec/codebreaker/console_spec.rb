module Codebreaker
  RSpec.describe Console do
    subject { Console.new(Game.new) }

    context 'general console methods' do
      it 'ask_for_question returns true or false' do
        expect(subject.send(:ask_for_question, '')).to be_a_kind_of(FalseClass)  
      end

      it 'get_result_data returns hash' do
        expect(subject.send(:get_result_data)).to be_a_kind_of(Hash)  
      end

      it 'load_locale returns hash' do
        expect(subject.send(:load_locale, :en_us)).to be_a_kind_of(Hash)  
      end
      
      it 'load_locale throws an exception when cannot find locale yml file with specified name' do
        expect { subject.send(:load_locale, nil) }.to raise_exception(Errno::ENOENT)
      end

      it 'ask_for returns string' do
        expect(subject.send(:ask_for, '')).to be_a_kind_of(String)  
      end

      it '__ returns translated "Title" string' do
        expect(subject.send(:__, 'Title')).to be_a_kind_of(String)  
      end

      it '__ returns nil when cannot find key in dictionary' do
        expect(subject.send(:__, '')).to be_a_kind_of(NilClass)  
      end
    end
  end
end