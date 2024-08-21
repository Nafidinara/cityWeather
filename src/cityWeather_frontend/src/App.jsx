import { useState } from 'react';
import { cityWeather_backend } from 'declarations/cityWeather_backend';

function App() {
  const [weather, setWeather] = useState('');
  const [city, setCity] = useState('');

  async function handleSubmit(event) {
    event.preventDefault();
    const cityName = event.target.elements.city.value;
    try {
      const weatherData = await cityWeather_backend.get_weather(cityName);
      setWeather(weatherData);
      setCity(cityName);
    } catch (error) {
      setWeather('Failed to fetch weather data. Please try again.');
      console.error('Error fetching weather data:', error);
    }
    return false;
  }

  return (
    <main>
      <img src="/logo2.svg" alt="DFINITY logo" />
      <br />
      <br />
      <form action="#" onSubmit={handleSubmit}>
        <label htmlFor="city">Enter your city: &nbsp;</label>
        <input id="city" alt="City" type="text" />
        <button type="submit">Get Weather</button>
      </form>
      {weather && (
        <section id="weather">
          <h2>Weather in {city}</h2>
          <p>{weather}</p>
        </section>
      )}
    </main>
  );
}

export default App;