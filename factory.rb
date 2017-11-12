class Factory
  class << self
    def new *args, &block
      Class.new do
        attr_accessor *args

        @@attributes = instance_methods(false)
          .select{|method_name| method_name[/=/]}
          .map{|method_name| method_name.to_s.chomp('=').to_sym}

        def initialize(*args)
          args.each_with_index do |value, index|
            self.instance_variable_set("@#{@@attributes[index]}", value)
          end
        end

        def [](index)
          index = @@attributes[index] if index.is_a? Integer

          self.instance_variable_get("@#{index}")
        end

        class_eval(&block) if block
      end
    end
  end
end