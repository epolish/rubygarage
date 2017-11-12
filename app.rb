[
  './classes/library',
  './classes/library_manager'
].each {|resource| require resource}

def get_data_file_path(file_name) File.join(Dir.pwd, 'src', file_name); end

def some_actions(library_manager)
  puts 'Most popular reader: ' << (library_manager.get_most_popular key: 'reader').name
  puts 'Most popular book: ' << (library_manager.get_most_popular key: 'book').title
  puts 'Most popular date: ' << (library_manager.get_most_popular key: 'date')
  puts 'Top three books: '
  (library_manager.get_most_popular key: 'book', limit: 3).map do |value|
    puts "#{value[:item].title} - taken #{value[:count]} time(s)"
  end
end

export_file = get_data_file_path 'data.json'
import_file = get_data_file_path 'seeds.json'
library_manager = LibraryManager.new Library.new

library_manager.source = import_file
library_manager.load_data

some_actions library_manager

library_manager.source = export_file
library_manager.save_data