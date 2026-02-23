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
      return nil unless api_key.present?

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
        city: city(data),
        temperature_c: temperature(data),
        sunrise: sunrise(data),
        sunset: sunset(data),
        condition_text: condition_text(data),
        condition_icon_url: condition_icon_url(data)
      }
    end

    def temperature(data)
      data.dig("current", "temp_c")
    end

    def city(data)
      data.dig("location", "name")
    end

    def sunrise(data)
      data.dig("forecast", "forecastday", 0, "astro", "sunrise")
    end

    def sunset(data)
      data.dig("forecast", "forecastday", 0, "astro", "sunset")
    end

    def condition_text(data)
      data.dig("current", "condition", "text")
    end

    def condition_icon_url(data)
      icon_path = data.dig("current", "condition", "icon")
      icon_path.present? ? "https:#{icon_path}" : nil
    end
  end
end
