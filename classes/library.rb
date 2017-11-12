[
  './resource/application'
].each {|resource| require_relative resource}

class Library < Application
  attr_accessor :books, :orders, :readers, :authors

  def initialize(books=[], orders=[], readers=[], authors=[])
    @books = books
    @orders = orders 
    @readers = readers
    @authors = authors
  end
end