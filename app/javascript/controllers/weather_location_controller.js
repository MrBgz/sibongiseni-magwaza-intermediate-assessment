import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["locationLabel", "status", "weatherData", "temperature", "sunrise", "sunset", "icon", "condition"]

  connect() {
    if (!navigator.geolocation) {
      this.statusTarget.textContent = "Geolocation is not supported in this browser."
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
        this.statusTarget.textContent = "Could not access your location."
      },
      { timeout: 8000, maximumAge: 60_000 },
    )
  }

  async fetchWeather(lat, lon) {
    this.statusTarget.textContent = "Fetching weather..."

    try {
      const response = await fetch(`/weather?lat=${encodeURIComponent(lat)}&lon=${encodeURIComponent(lon)}`, {
        headers: { Accept: "application/json" },
      })

      if (!response.ok) throw new Error("Weather request failed")

      const data = await response.json()
      this.locationLabelTarget.textContent = data.city || `Lat ${lat}, Lon ${lon}`
      this.temperatureTarget.textContent = data.temperature_c ?? "--"
      this.sunriseTarget.textContent = data.sunrise ?? "--"
      this.sunsetTarget.textContent = data.sunset ?? "--"
      this.renderCondition(data)
      this.weatherDataTarget.hidden = false
      this.statusTarget.textContent = ""
    } catch (_error) {
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
