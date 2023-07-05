class CurrentWeatherController < ApplicationController

  def fetch
    cache_hit = true
    error_details = nil

    # TODO: Extract caching and cache_hit detection. Possibly into WeatherReporterService
    weather_data = Rails.cache.fetch(cache_key, skip_nil: true, expires_in: 5.seconds) do
      cache_hit = false

      response = WeatherReporterService.call(zipcode: params[:zipcode])
      if response.success?
        response.as_json
      else
        # TODO: Differentiate the errors that should be cached (ex: invalid zipcode) from
        #   the ones that should not be (ex: invalid API key, network issue, etc)
        error_details = response.error
        nil
      end
    end

    if weather_data
      weather_data.merge!('cache_hit' => cache_hit)
      render json: weather_data
    else
      # TODO: Return error details in a way that is potentially actionable to the consumer
      Rails.logger.error "WEATHER_API: API call failed with details: #{error_details}"
      render json: {error: CGI.escape_html(error_details)}, status: :bad_request
    end

  end

  private

  def cache_key
    ['zipcode', params[:zipcode]]
  end

end
