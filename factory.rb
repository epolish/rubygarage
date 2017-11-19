class Factory
  class << self
    def new name, *args, &block
 
      args << name unless name.is_a? String

      klass = Class.new do
        @attributes

        attr_accessor *args

        def initialize(*args)
          raise ArgumentError if attributes.size < args.size

          attributes.each_with_index do |value, index|
            self.instance_variable_set((prepare_key value), args[index])
          end
        end

        def attributes
          @attribute ||= self.class.instance_methods(false)
            .select{|method_name| method_name[/(?<!=)=(?!=)/]}
            .select{|method_name| method_name[/(?=.*^[^\[\]]+$)/]}
            .map{|method_name| method_name.to_s.chomp('=').to_sym}
        end

        def [](index)
          parse_index index
          self.instance_variable_get((prepare_key index))
        end

        def []=(index, value)
          parse_index index
          self.instance_variable_set((prepare_key index), value)
        end

        def dig(*args)
          self[args.first] rescue return nil
          args.inject(self){|key, value| key = key[value]} rescue raise TypeError
        end

        def each_pair(&block)
          attributes
            .each_with_object({}){|value, hash| hash[value] = self[value]}
            .each(&block)
        end

        def to_a
          attributes.each_with_object([]) do |value, array|
            array.push(self.instance_variable_get(prepare_key value))
          end
        end

        def values_at(*args)
          result = to_a.values_at *args
          raise IndexError if result.any? { |e| e.nil? }
          result
        end

        def size; attributes.size end

        def each(&block); to_a.each(&block) end

        def select(&block); to_a.select(&block) end

        def ==(other); self.to_a == other.to_a end

        alias_method :length, :size

        alias_method :members, :attributes

        class_eval(&block) if block

        private

        def prepare_key(key)
          "@#{((key.is_a? Numeric) ? attributes[key] : key)}"
        end

        def parse_index(index)
          if index.is_a? Numeric
            raise IndexError if attributes[index].nil?
          else
            raise NameError unless attributes.include? index.to_sym
          end
        end
      end

      const_set(name.capitalize, klass) if name.is_a? String

      klass
    end
  end
end