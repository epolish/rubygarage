[
  './resource/application'
].each {|resource| require_relative resource}

class Author < Application
  attr_accessor :name, :biography

  def initialize(name=nil, biography=[])
    @name = name
    @biography = biography
  end
end