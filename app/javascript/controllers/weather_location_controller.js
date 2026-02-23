import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["locationLabel", "status", "weatherData", "temperature", "sunrise", "sunset", "icon", "condition"]

  connect() {
    this.statusTarget.hidden = false

    if (!navigator.geolocation) {
      this.statusTarget.textContent = "Geolocation is not supported. Using fallback location..."
      this.fetchWeather()
      return
    }

    this.statusTarget.textContent = "Detecting location..."
    navigator.geolocation.getCurrentPosition(
      (position) => {
        const lat = position.coords.latitude.toFixed(4)
        const lon = position.coords.longitude.toFixed(4)
        this.fetchWeather(lat, lon)
      },
      () => {
        this.statusTarget.textContent = "Could not access location. Using fallback location..."
        this.fetchWeather()
      },
      { timeout: 8000, maximumAge: 60_000 },
    )
  }

  async fetchWeather(lat, lon) {
    this.statusTarget.hidden = false
    this.statusTarget.textContent = "Fetching weather..."
    const hasCoords = lat && lon
    const weatherUrl = hasCoords
      ? `/weather?lat=${encodeURIComponent(lat)}&lon=${encodeURIComponent(lon)}`
      : "/weather"

    try {
      const response = await fetch(weatherUrl, {
        headers: { Accept: "application/json" },
      })

      if (!response.ok) throw new Error("Weather request failed")

      const data = await response.json()
      this.locationLabelTarget.textContent = data.city || (hasCoords ? `Lat ${lat}, Lon ${lon}` : "Default location")
      this.temperatureTarget.textContent = data.temperature_c ?? "--"
      this.sunriseTarget.textContent = data.sunrise ?? "--"
      this.sunsetTarget.textContent = data.sunset ?? "--"
      this.renderCondition(data)
      this.weatherDataTarget.hidden = false
      this.statusTarget.hidden = true
    } catch (_error) {
      this.statusTarget.hidden = false
      this.statusTarget.textContent = "Weather unavailable right now."
      this.weatherDataTarget.hidden = true
    }
  }

  renderCondition(data) {
    if (this.hasConditionTarget) {
      if (data.condition_text) {
        this.conditionTarget.textContent = data.condition_text
        this.conditionTarget.hidden = false
      } else {
        this.conditionTarget.hidden = true
      }
    }

    if (this.hasIconTarget) {
      if (data.condition_icon_url) {
        this.iconTarget.src = data.condition_icon_url
        this.iconTarget.alt = data.condition_text || "Weather icon"
        this.iconTarget.hidden = false
      } else {
        this.iconTarget.hidden = true
      }
    }
  }
}
