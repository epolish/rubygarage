[
  'date'
].each {|resource| require resource}
[
  './resource/validator',
  './resource/application'
].each {|resource| require_relative resource}

class Order < Application
  include Validator

  attr_accessor :book, :reader, :date

  def initialize(book=nil, reader=nil, date=nil)
    self.validate(date_rule: date || Date.new)

    @book = book
    @reader = reader
    @date = date
  end
end