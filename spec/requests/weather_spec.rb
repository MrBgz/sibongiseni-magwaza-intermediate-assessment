require "rails_helper"

RSpec.describe "Weather", type: :request do
  let(:weather_payload) do
    {
      city: "Johannesburg",
      temperature_c: 24.1,
      sunrise: "06:02 AM",
      sunset: "06:11 PM",
      condition_text: "Sunny",
      condition_icon_url: "https://cdn.weather/icon.png"
    }
  end

  describe "GET /weather" do
    it "returns weather data for provided coordinates" do
      client = instance_double(WeatherApi::Client, call: weather_payload)
      expect(WeatherApi::Client).to receive(:new).with(location: "-26.1,28.0").and_return(client)

      get "/weather", params: { lat: "-26.1", lon: "28.0" }

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body).to include(
        "city" => "Johannesburg",
        "temperature_c" => 24.1,
        "sunrise" => "06:02 AM",
        "sunset" => "06:11 PM"
      )
    end

    it "falls back to default location when coordinates are missing" do
      client = instance_double(WeatherApi::Client, call: weather_payload)
      expect(WeatherApi::Client).to receive(:new).with(location: "Johannesburg").and_return(client)

      get "/weather"

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body).to include("city" => "Johannesburg")
    end

    it "returns service unavailable when weather cannot be fetched" do
      client = instance_double(WeatherApi::Client, call: nil)
      allow(WeatherApi::Client).to receive(:new).and_return(client)

      get "/weather", params: { lat: "-26.1", lon: "28.0" }

      expect(response).to have_http_status(:service_unavailable)
      expect(response.parsed_body).to eq("error" => "Weather unavailable")
    end
  end
end
