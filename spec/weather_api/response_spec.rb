require 'rails_helper'

RSpec.describe WeatherApi::Response do

  let(:api_response) do
    instance_double(Faraday::Response)
  end
  let(:weather_data) do
    {}
  end
  subject do
    described_class.new(weather_data: weather_data, api_response: api_response)
  end

  describe '#success' do
    it 'delegates to the api_response param in its constructor' do
      success = double
      allow(api_response).to receive(:success?) { success }

      expect(subject.success?).to eq(success)
    end

  end

  describe '#error' do
    context 'when the response was successful' do
      before(:example) do
        allow(api_response).to receive(:success?) { true }
      end

      it 'returns nil' do
        expect(subject.error).to eq nil
      end
    end

    context 'when the response was not successful' do
      before(:example) do
        allow(api_response).to receive(:success?) { false }
      end

      it 'returns the api_response body as a string' do
        # NOTE: This is the current behavior but there's no tech/business
        #   reason you can't change it to do something actually useful.
        parsed_error = {"error"=>{"code"=>1006, "message"=>"No matching location found."}}
        allow(api_response).to receive(:body) do
          parsed_error
        end
        expect(subject.error).to eq parsed_error.to_s
      end
    end
  end

  describe '#as_json' do
    it 'delegates to the weather_data param in its constructor' do
      as_json = double
      allow(weather_data).to receive(:as_json) { as_json }

      expect(subject.as_json).to eq(as_json)
    end
  end

end
