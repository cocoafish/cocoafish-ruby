module Cocoafish

  class Endpoint

    class << self
      def url(realm, path)
        [realm, API_VERSION, path].join('/')
      end
    end

  end

end
