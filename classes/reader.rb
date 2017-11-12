[
  './resource/validator',
  './resource/application'
].each {|resource| require_relative resource}

class Reader < Application
  include Validator

  attr_accessor :name, :email, :city, :street, :house

  def initialize(name=nil, email=nil, city=nil, street=nil, house=nil)
    self.validate(email_rule: email || 'default@mail.com')

    @name = name
    @city = city
    @email = email
    @house = house
    @street = street
  end
end