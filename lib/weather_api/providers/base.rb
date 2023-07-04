class WeatherApi::Providers::Base

  class MustBeImplementedBySubclassError < StandardError; end

  class << self

    private
    
    def request_params(query)
      raise MustBeImplementedBySubclassError
    end

    def endpoint_base_url
      raise MustBeImplementedBySubclassError
    end

    def endpoint_path
      raise MustBeImplementedBySubclassError
    end

    def api_key_identifier
      raise MustBeImplementedBySubclassError
    end

    def connection 
      Faraday.new(endpoint_base_url) do |f|
        f.request :json
        f.request :retry
        f.response :json
      end
    end

    def api_key
      ENV.fetch(api_key_identifier)
    end

    def default_request_headers
      {
        'User-Agent' => 'IveActuallySeenSomeoneSlipOnABananaPeelInRealLife/1.0'
      }
    end

  end

end
