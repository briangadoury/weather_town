class WeatherReporterService
  attr_reader :query

  def initialize(zipcode:)
    @query = WeatherApi::Query.new(
      zipcode: zipcode
    ) 
  end

  private_class_method :new

  # NOTE: This is only entry point for this service object. Ex: WeatherReporter.call
  def self.call(...)
    new(...).call
  end

  def call
    WeatherApi::Providers::WeatherApi.current(query: query)
  end
end
