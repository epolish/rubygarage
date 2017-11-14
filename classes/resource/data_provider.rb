[
  'json'
].each {|resource| require resource}

module DataProvider
  attr_accessor :source

  def read
    JSON.parse(File.read(@source))
  end

  def write(data={})
    File.write(@source, JSON.generate(data, max_nesting: 4))
  end
end