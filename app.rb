require './factory'

Customer = Factory.new(:name, :address, :zip) do
  def greeting
    "Hello #{name}!"
  end
end

joe = Customer.new('Joe Smith', '123 Maple, Anytown NC', 12345)

joe.each_pair{|name, value| puts "#{name} => #{value}" }