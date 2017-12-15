[
  'game',
  'console'
].each { |file|
  require_relative file
}

module Codebreaker
  class Application
    attr_accessor :game, :console

    def initialize(locale_sym = :en_us)
      @game = Game.new
      @console = Console.new(self.game, locale_sym)
    end

    def run
      self.console.run
    end
  end
end