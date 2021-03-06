module Cocoafish

  class CocoafishObject
    def initialize(hash)
      hash.each do |k,v|
        if k == "ratings_summary"
          # ratings_summary is a hash with keys as integers
          next
        end
        v = CocoafishObject.new(v) if v.is_a?(Hash)
        v = v.map {|arrayvalue| arrayvalue.is_a?(Hash) ? CocoafishObject.new(arrayvalue) : arrayvalue} if v.is_a?(Array)
        begin
          self.instance_variable_set("@#{k}", v) ## create and initialize an instance variable for this key/value pair
          self.class.send(:define_method, k, proc{self.instance_variable_get("@#{k}")}) ## create the getter that returns the instance variable
          self.class.send(:define_method, "#{k}=", proc{|v| self.instance_variable_set("@#{k}", v)}) ## create the setter that sets the instance variable
        rescue
        end
      end
    end
    
    def method_missing key
      nil
    end
  end
  
end