class Factory
  class << self
    def new *args, &block
      Class.new do
        include Enumerable

        @attributes

        attr_accessor *args

        def initialize(*args)
          attributes.each_with_index do |value, index|
            puts (parse_index value), args[index]
            self.instance_variable_set((parse_index value), args[index])
          end
        end

        def [](index)
          self.instance_variable_get((parse_index index))
        end

        def []=(index, value)
          self.instance_variable_set((parse_index index), value)
        end

        def dig(*args)
          args.inject(self){|key, value| key = key[value]} rescue nil
        end

        def each(&block)
          attributes.each(&block)
        end

        def each_pair(&block)
          attributes
            .each_with_object({}){|value, hash| hash[value] = self[value]}
            .each(&block)
        end

        class_eval(&block) if block

        private

        def parse_index(index)
          "@#{((index.is_a? Integer) ? attributes[index] : index)}"
        end

        def attributes
          @attribute ||= self.class.instance_methods(false)
            .select{|method_name| method_name[/(?=.*=)(?=.*^[^\[\]]+$)/]}
            .map{|method_name| method_name.to_s.chomp('=').to_sym}
        end
      end
    end
  end
end