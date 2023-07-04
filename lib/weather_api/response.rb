class WeatherApi::Response

  attr_reader :weather_data

  def initialize(weather_data:, api_response:)
    @weather_data = weather_data
    @api_response = api_response
  end

  def success?
    api_response.success?
  end

  def to_json
    @to_json ||= weather_data.to_json
  end

  private

  attr_reader :api_response

end
