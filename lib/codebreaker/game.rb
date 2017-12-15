module Codebreaker
  class Game
    MAX_TRIES = 7
    HINT_LIMIT = 4
    NUMBERS_COUNT = 4
    RANDOM_RANGE = 1..6

    attr_reader :is_win, :progress, :try_number, :hint_count, :secret_number

    def initialize()
      reload
    end

    def reload
      @is_win = false
      @progress = nil
      @hint_count = 0
      @try_number = 0
      @secret_number = generate_secret_number
    end

    def win?
      self.is_win
    end

    def can_try
      (self.try_number += 1) < MAX_TRIES
    end

    def add_hint
      self.hint_count += 1 if (self.hint_count + 1 <= HINT_LIMIT)
    end

    def get_answer
      self.secret_number.each_with_index.map do |digit, index|
        digit = index < self.hint_count ? digit : nil
      end
    end

    def try(gues_number)
      gues_number = prepare_gues_number(gues_number)

      if gues_number.join == self.secret_number.join
        self.is_win = true
      else
        reload_progress(gues_number)
      end
    end

    private

    attr_writer :is_win, :progress, :try_number, :hint_count, :secret_number

    def get_exact_match_count(gues_number)
      get_exact_match(gues_number).compact.size
    end
    
    def get_numbered_match_count(gues_number)
      get_numbered_match(gues_number).size
    end

    def generate_secret_number
      NUMBERS_COUNT.times.map { Random.rand(RANDOM_RANGE) }
    end

    def prepare_gues_number(gues_number)
      gues_number = gues_number.split('') if gues_number.is_a? String
      
      gues_number.map(&:to_i)[0..3]
    end

    def get_exact_match(gues_number)
      self.secret_number.map.with_index do |digit, index|
        digit = digit == gues_number[index] ? digit : nil
      end
    end

    def reload_progress(gues_number)
      exact_progress = Array.new(get_exact_match_count(gues_number), :+)
      numbered_progress = Array.new(get_numbered_match_count(gues_number), :-)

      self.progress = exact_progress + numbered_progress
    end

    def get_numbered_match(gues_number)
      exact_match = get_exact_match(gues_number)
      guess_non_exact_match = (gues_number - exact_match).uniq
      secret_non_exact_match = (self.secret_number - exact_match).uniq

      secret_non_exact_match.select do |digit|
        guess_non_exact_match.include? digit
      end
    end
  end
end