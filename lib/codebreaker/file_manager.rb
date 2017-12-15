[
  'yaml'
].each { |file|
  require file
}

[
  'config'
].each { |file|
  require_relative file
}

module Codebreaker
  module FileManager
    include Config

    def get_file_path(file_path)
      File.join(Dir.pwd, APPLICATION_FOLDER, "#{file_path}.yml")
    end

    def read(file_path)
      YAML.load_file(get_file_path(file_path))
    end

    def write(file_path, data)
      File.open(get_file_path(file_path), 'w') do |source| 
         source.write(data.to_yaml)
      end
    end
  end
end