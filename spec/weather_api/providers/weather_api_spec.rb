require 'ostruct'
require 'spec_helper'
require 'rails_helper'
require 'weather_api/providers/weather_api'

RSpec.describe WeatherApi::Providers::WeatherApi do

  describe '.current' do

    let(:api_response_body) do
      # Entire API response for reference. Most of these are not currently used.
      {"location"=>
       {"name"=>"TEST Salt Lake City",
        "region"=>"Utah",
        "country"=>"USA",
        "lat"=>40.76,
        "lon"=>-111.87,
        "tz_id"=>"America/Denver",
        "localtime_epoch"=>1688445395,
        "localtime"=>"2023-07-03 22:36"},
       "current"=>
       {"last_updated_epoch"=>1688445000,
        "last_updated"=>"2023-07-03 22:30",
        "temp_c"=>27.8,
        "temp_f"=>82.0,
        "is_day"=>0,
        "condition"=>
        {"text"=>"Partly cloudy",
         "icon"=>"//cdn.weatherapi.com/weather/64x64/night/116.png",
         "code"=>1003},
        "wind_mph"=>19.2,
        "wind_kph"=>31.0,
        "wind_degree"=>340,
        "wind_dir"=>"NNW",
        "pressure_mb"=>1013.0,
        "pressure_in"=>29.9,
        "precip_mm"=>0.0,
        "precip_in"=>0.0,
        "humidity"=>34,
        "cloud"=>75,
        "feelslike_c"=>30.3,
        "feelslike_f"=>86.6,
        "vis_km"=>16.0,
        "vis_miles"=>9.0,
        "uv"=>1.0,
        "gust_mph"=>10.3,
        "gust_kph"=>16.6}
      }
    end

    let(:api_key) { 'apitestkey123' }
    let(:zipcode) { '84102' }
    let(:endpoint_base_url) { 'https://api.weatherapi.com' }
    let(:endpoint_path) { '/v1/current.json' }
    let(:api_key_identifier) { 'WEATHER_API_API_KEY' }

    let(:stubs) { Faraday::Adapter::Test::Stubs.new }
    let!(:conn) { Faraday.new { |b| b.adapter(:test, stubs) } }

    before(:example) do
      allow(ENV).to receive(:fetch).and_call_original
      allow(ENV).to receive(:fetch).with(api_key_identifier) { api_key }
      allow(Faraday).to receive(:new).with(endpoint_base_url) { conn }
    end

    context 'successful API call' do
      # TODO: Extract into separate DRY tests
      it 'calls correct endpoint with correct params and maps response correctly' do
        stubs.get(endpoint_path) do |env|
          expect(env.params).to eq({"key" => api_key, "q" => zipcode})

          [200, {}, api_response_body]
        end

        mapped_response_data = {
          'temp_f' => 82.0,
          'wind_direction' => "NNW",
          'wind_mph' => 19.2,
          'city' => "TEST Salt Lake City"
        }
        response_object = instance_double(WeatherApi::Response)
        allow(WeatherApi::Response).to receive(:new).with(
                                         weather_data: mapped_response_data,
                                         api_response: an_instance_of(Faraday::Response)
                                       ) { response_object }

        query = WeatherApi::Query.new(zipcode: zipcode)
        result = described_class.current(query: query)

        # This will only pass if the SUT passed the correct params to the WeatherApi::Response 
        # constructor. This is how we test that things are wired correctly here without also 
        # testing WeatherApi::Response behavior.
        expect(result).to eq(response_object)

        stubs.verify_stubbed_calls
      end

    end

    context 'failed API call due to blank API key' do
      it 'gracefully handles surprise non-JSON api response' do
        # NOTE: The API can return HTML for some errors like a blank API key, despite what 
        # their docs say.
        allow(ENV).to receive(:fetch).with(api_key_identifier) { '' }

        stubs.get(endpoint_path) do |env|
          # Verify the specific condition known to trigger this error
          expect(env.params).to eq({"key" => '', "q" => zipcode})

          [403, {}, '<html>403 Forbidden</html>']
        end

        query = WeatherApi::Query.new(zipcode: zipcode)
        expect { described_class.current(query: query) }.not_to raise_error

        stubs.verify_stubbed_calls
      end

    end

  end

end
