class WeatherController < ApplicationController
  def show
    lat = params[:lat]
    lon = params[:lon]

    if lat.blank? || lon.blank?
      return render json: { error: "Missing lat/lon" }, status: :bad_request
    end

    weather = WeatherApi::Client.new(location: "#{lat},#{lon}").call
    if weather.nil?
      render json: { error: "Weather unavailable" }, status: :service_unavailable
    else
      render json: weather
    end
  end
end
