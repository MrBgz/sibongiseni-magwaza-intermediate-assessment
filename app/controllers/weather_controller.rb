class WeatherController < ApplicationController
  FALLBACK_LOCATION = "Johannesburg".freeze

  def show
    lat = params[:lat]
    lon = params[:lon]
    location = if lat.present? && lon.present?
      "#{lat},#{lon}"
    else
      FALLBACK_LOCATION
    end

    weather = WeatherApi::Client.new(location: location).call
    if weather.nil?
      render json: { error: "Weather unavailable" }, status: :service_unavailable
    else
      render json: weather
    end
  end
end
