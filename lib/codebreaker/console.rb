[
  'file_manager'
].each { |file|
  require_relative file
}

module Codebreaker
  class Console
    include FileManager

    attr_accessor :game, :locale;

    def initialize(game = nil, locale_sym = :en_us)
      @game = game;
      @locale = load_locale(locale_sym);
    end

    def __(string)
      self.locale[string]
    end

    def run
      puts __('Title')

      while ask_for_question('Start Game');
        run_game
      end
      
      puts __('Good bye')
    end

    private

    def load_locale(locale)
      read("#{LOCALE_FOLDER}/#{locale}")
    end

    def ask_for(question)
      print "#{__(question)}: "
      
      gets.chomp
    end

    def ask_for_question(question)
      print "#{__(question)}? [y,N]: "
      
      gets.chomp.downcase == 'y'
    end

    def prepare_game_progress(progress)
      progress.map(&:to_s).join
    end

    def prepare_game_answer(answer)
      answer.map { |digit| digit = digit ? digit : '*' }.join
    end

    def render_question(question)
      print "#{__(question)}? [y,N]: "
    end

    def render_result
      puts __('Your Result')

      get_result_data.each do |key, value|
        puts "#{key}: #{value}"
      end
    end

    def get_result_data
      {
        __('Answer') => self.game.secret_number.join.to_i,
        __('Last Try') => self.game.try_number,
        __('Hints requested') => self.game.hint_count
      }
    end

    def save_game_result
      initials = ask_for('Type your initials')
      
      write("#{USER_DATA_FOLDER}/#{initials}", get_result_data)
    end

    def run_game
      self.game.reload
      play_game
      render_result
      
      if self.game.win?
        puts __('You win the game')        

        save_game_result if ask_for_question('Save Result')
      end
    end

    def play_game
      while self.game.can_try && !self.game.win?
        if ask_for_question('Add hint')
          self.game.add_hint
          puts prepare_game_answer(self.game.get_answer)
        end

        self.game.try(ask_for('Type your number'))
        puts prepare_game_progress(self.game.progress)
        puts prepare_game_answer(self.game.get_answer)
      end
    end
  end
end