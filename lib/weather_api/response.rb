class WeatherApi::Response

  attr_reader :weather_data

  delegate :success?, to: :api_response

  def initialize(weather_data:, api_response:)
    @weather_data = weather_data
    @api_response = api_response
  end

  def error
    api_response.body.to_s unless success?
  end

  def as_json
    @as_json ||= weather_data.as_json
  end

  private

  attr_reader :api_response

end
