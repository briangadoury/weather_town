require 'rails_helper'

RSpec.describe WeatherApi::Query do

  it 'raises a helpful exception if the required zipcode is blank' do
    expect { described_class.new(zipcode: "") }.to raise_error(
      ArgumentError, "Required zipcode param is blank"
    )
  end

end
