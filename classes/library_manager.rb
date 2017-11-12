[
  'active_support/hash_with_indifferent_access'
].each {|resource| require resource}
[
  './book',
  './order',
  './reader',
  './author',
  './resource/application',
  './resource/data_provider'
].each {|resource| require_relative resource}

class LibraryManager < Application
  include DataProvider

  attr_accessor :library

  def initialize(library=nil)
    @library = library
  end

  def load_data(data=nil)
    data ||= self.read

    load_readers data['readers']
    load_authors_with_books data['authors']
    load_orders data['orders']
  end

  def save_data
    self.write({
      readers: readers_to_hash_array,
      authors: authors_to_hash_array,
      orders: orders_to_hash_array
    })
  end
  
  def get_most_popular(options={})
    if options[:key]
      get_order_most_repeated_sorted_entities(
        get_order_entities_with_number_of_repetitions(options[:key]),
        options[:limit]
      )
    end
  end

  private

  def get_order_most_repeated_sorted_entities(entities, limit=nil)
    result_entities = entities
      .sort_by{|_, value| -value}
      .first(limit || 1)
      .map{|key, value| {item: key, count: value}}

    limit ? result_entities : result_entities.first[:item]
  end

  def get_order_entities_with_number_of_repetitions(entity_key)
    @library.orders.each_with_object(Hash.new(0)) do |order, hash|
      entity_value = case entity_key
        when 'date' then order.date
        when 'book' then order.book
        when 'reader' then order.reader
        else raise KeyError, "undefined key <#{entity_key}>"
      end

      hash[entity_value] += 1
    end
  end

  def load_orders(source)
    source.each do |value|
      @library.orders.push Order.new \
        @library.books.select {|book| book.title == value['book_title']}.first, 
        @library.readers.select {|reader| reader.name == value['reader_name']}.first, 
        value['date']
    end
  end

  def load_readers(source)
    source.each do |value|
      @library.readers.push Reader.new \
        value['name'],
        value['email'],
        value['city'],
        value['street'],
        value['house']
    end
  end

  def load_authors_with_books(source)
    source.each do |value|
      author = Author.new value['name']
      
      value['biography'].each do |book_title|
        book = Book.new book_title, author

        author.biography.push book
        @library.books.push book
      end

      @library.authors.push author
    end
  end

  def authors_to_hash_array
    collection = []

    @library.authors.each do |author|
      collection.push({
        name: author.name,
        biography: author.biography.map {|book| book.title}
      })
    end

    collection
  end

  def orders_to_hash_array
    collection = []

    @library.orders.each do |order|
      collection.push({
        book: order.book.title,
        reader: order.reader.name,
        date: order.date
      })
    end

    collection
  end

  def readers_to_hash_array
    collection = []

    @library.readers.each do |reader|
      collection.push({
        name: reader.name,
        email: reader.email,
        city: reader.city,
        street: reader.street,
        house: reader.house
      })
    end

    collection
  end
end