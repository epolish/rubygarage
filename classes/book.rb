[
  './resource/application'
].each {|resource| require_relative resource}

class Book < Application
  attr_accessor :title, :author

  def initialize(title=nil, author=nil)
    @title = title
    @author = author
  end
end