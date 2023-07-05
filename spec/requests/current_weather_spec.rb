require 'rails_helper'

RSpec.describe "CurrentWeather", type: :request do

  describe "GET /fetch" do

    let(:endpoint_path) { "/current_weather/fetch.json?zipcode=#{zipcode}" }
    before(:example) do
      allow(WeatherReporterService).to receive(:call).with(zipcode: zipcode) { service_response }
    end

    context 'when the weather provider API call succeeds' do
      let(:zipcode) { '01571' }
      let(:service_response) do
        instance_double(
          WeatherApi::Response, 
          success?: true
        )
      end

      it "returns http success" do
        get endpoint_path

        expect(response).to have_http_status(:success)
      end
    end

    context 'when the weather provider API call fails' do
      let(:zipcode) { '0157100000000' }
        let(:service_response) do
          instance_double(
            WeatherApi::Response, 
            success?: false,
            error: { error: "<html>Missing api key</html>" }.to_s
          )
        end

      it "returns http bad_request and html_escaped error message" do
        get endpoint_path

        expect(response).to have_http_status(:bad_request)
        expect(response.parsed_body['error']).to eq "{:error=&gt;&quot;&lt;html&gt;Missing api key&lt;/html&gt;&quot;}"
      end

    end

  end

end
