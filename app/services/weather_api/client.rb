require "net/http"
require "json"

module WeatherApi
  class Client
    BASE_URL = "https://api.weatherapi.com/v1/forecast.json".freeze

    def initialize(location:)
      @location = location
      @api_key = ENV["WEATHER_API_KEY"]
    end

    def call
      return nil if api_key.blank?

      response = fetch_weather
      return nil unless response.is_a?(Net::HTTPSuccess)

      parse_response(response.body)
    rescue StandardError
      nil
    end

    private

    attr_reader :location, :api_key

    def fetch_weather
      uri = URI(BASE_URL)
      uri.query = URI.encode_www_form(
        key: api_key,
        q: location,
        days: 1
      )

      Net::HTTP.get_response(uri)
    end

    def parse_response(body)
      data = JSON.parse(body)

      {
        temperature_c: data.dig("current", "temp_c"),
        sunrise: data.dig("forecast", "forecastday", 0, "astro", "sunrise"),
        sunset: data.dig("forecast", "forecastday", 0, "astro", "sunset")
      }
    end
  end
end