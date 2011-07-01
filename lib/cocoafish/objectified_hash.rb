module Cocoafish

  class ObjectifiedHash

      def initialize hash
          @data = hash.inject({}) do |data, (key,value)|
            if value.kind_of? Hash  
              value = ObjectifiedHash.new value
            elsif value.kind_of? Array
              value = value.map {|arrayvalue| ObjectifiedHash.new arrayvalue}
            end
            data[key.to_s] = value
            data
          end
      end

      def method_missing key
          if @data.key? key.to_s
              @data[key.to_s]
          else
              nil
          end
      end

  end
end