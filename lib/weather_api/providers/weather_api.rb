require 'weather_api/providers'
require 'weather_api/providers/base'

# BTS: It's just an awkward coincidence that this provider's business name matches our top level namespace
class WeatherApi::Providers::WeatherApi < WeatherApi::Providers::Base

  class << self

    def current(query:)
      # TODO: This is probably generic enough to move to the superclass
      api_response = connection.get(
        endpoint_path, 
        request_params(query), 
        request_headers
      )

      WeatherApi::Response.new(
        weather_data: map_response_data(api_response.body),
        api_response: api_response,
      )
    end

    private

    # BTS: The below methods will differ between providers
    def map_response_data(response_data)
      return {} unless response_data.respond_to?(:dig)

      {
        'city' => response_data.dig('location', 'name'),
        'temp_f' => response_data.dig('current', 'temp_f'),
        'wind_mph' => response_data.dig('current', 'wind_mph'),
        'wind_direction' => response_data.dig('current', 'wind_dir')
      }
    end

    def request_params(query)
      {
        'key' => api_key,
        'q' => query.zipcode
      }
    end

    def endpoint_base_url
      'https://api.weatherapi.com'
    end

    def endpoint_path
      '/v1/current.json'
    end

    def api_key_identifier
      'WEATHER_API_API_KEY'
    end

    def request_headers
      default_request_headers
    end

  end

end
