require "rails_helper"

RSpec.describe WeatherApi::Client do
  describe "#call" do
    it "returns temperature, sunrise, and sunset from the WeatherAPI response" do
      location = "Sandton"
      api_key_before = ENV["WEATHER_API_KEY"]
      ENV["WEATHER_API_KEY"] = "test_key"

      json_body = {
        "location" => {
          "name" => "Sandton",
          "region" => "Gauteng",
          "country" => "South Africa"
        },
        "current" => { "temp_c" => 24.2 },
        "forecast" => {
          "forecastday" => [
            { "astro" => { "sunrise" => "05:58 AM", "sunset" => "06:44 PM" } }
          ]
        }
      }.to_json

      fake_response = instance_double(Net::HTTPSuccess, body: json_body)
      allow(fake_response).to receive(:is_a?).with(Net::HTTPSuccess).and_return(true)
      allow(Net::HTTP).to receive(:get_response).and_return(fake_response)

      result = described_class.new(location: location).call

      expect(result).to eq(
        city: "Sandton",
        temperature_c: 24.2,
        sunrise: "05:58 AM",
        sunset: "06:44 PM",
        condition_text: nil,
        condition_icon_url: nil
      )
    ensure
      ENV["WEATHER_API_KEY"] = api_key_before
    end

    it "returns nil when the API key is missing" do
      api_key_before = ENV["WEATHER_API_KEY"]
      ENV["WEATHER_API_KEY"] = nil

      result = described_class.new(location: "Sandton").call

      expect(result).to be_nil
    ensure
      ENV["WEATHER_API_KEY"] = api_key_before
    end
  end
end
