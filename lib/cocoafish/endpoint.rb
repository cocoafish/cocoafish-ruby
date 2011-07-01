module Cocoafish

  class Endpoint

    class << self
      
      def url(path)
        endpoint_url path, 'v1'
      end
      
      def search(object_type)
        endpoint_url "#{object_type}s/search.json", 'v1'
      end
      
      def create(object_type)
        endpoint_url "#{object_type}s/create.json", 'v1'
      end
      
      def update(object_type)
        endpoint_url "#{object_type}s/update.json", "v1"
      end
      
      def delete(object_type)
        endpoint_url "#{object_type}s/delete.json", "v1"
      end
      
      def show(object_type)
      endpoint_url "#{object_type}s/show.json", "v1"
      end
      
      def endpoint_url(path, version)
        [REALM, version, path].join('/')
      end
    end

  end

end
