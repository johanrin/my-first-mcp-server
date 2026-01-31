import os

import httpx
from mcp.server.fastmcp import FastMCP

# Constants
OPEN_METEO_API_URL = "https://api.open-meteo.com/v1/forecast"

# Configuration from environment variables
HOST = os.getenv("MCP_HOST", "0.0.0.0")
PORT = int(os.getenv("MCP_PORT", "8000"))

# Initialize MCP server
mcp = FastMCP("weather", host=HOST, port=PORT)


async def fetch_weather(latitude: float, longitude: float) -> dict | str:
    """Fetch weather data from Open-Meteo API."""
    try:
        async with httpx.AsyncClient() as client:
            response = await client.get(
                OPEN_METEO_API_URL,
                params={
                    "latitude": latitude,
                    "longitude": longitude,
                    "current": "temperature_2m,windspeed_10m",
                },
            )
            response.raise_for_status()
            return response.json()
    except httpx.HTTPError as e:
        return f"Failed to fetch weather data: {e}"


@mcp.tool()
async def get_weather(latitude: float, longitude: float) -> str:
    """Get current weather for a location."""
    data = await fetch_weather(latitude, longitude)

    if isinstance(data, str):
        return data

    current = data["current"]
    temperature = current["temperature_2m"]
    wind_speed = current["windspeed_10m"]

    return (
        f"Current Weather ({latitude}, {longitude}):\n"
        f"- Temperature: {temperature}°C\n"
        f"- Wind Speed: {wind_speed} km/h"
    )


if __name__ == "__main__":
    mcp.run(transport="streamable-http")
