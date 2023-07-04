class WeatherApi::Query
  attr_reader :zipcode

  def initialize(zipcode:)
    raise(ArgumentError, "Required zipcode param is blank") if zipcode.blank?

    @zipcode = zipcode
  end
end
