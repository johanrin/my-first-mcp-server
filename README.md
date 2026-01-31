# my-first-mcp-server

A simple MCP (Model Context Protocol) server that provides weather information using the [Open-Meteo API](https://open-meteo.com/).

## Features

- `get_weather(latitude, longitude)` - Get current temperature and wind speed for any location
- Remote HTTP transport (streamable-http)
- Docker-ready with Azure Container Apps deployment support

## Requirements

- Python 3.12+
- [uv](https://docs.astral.sh/uv/) (recommended) or pip

## Installation

```bash
uv sync
```

Or with pip:

```bash
pip install -e .
```

## Usage

### Running the server

```bash
uv run main.py
```

The server will start on `http://0.0.0.0:8000` by default.

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `MCP_HOST` | `0.0.0.0` | Host to bind the server to |
| `MCP_PORT` | `8000` | Port to listen on |

## MCP Client Configuration

Connect to the server using the MCP endpoint URL:

```
https://your-server-url/mcp
```

## Docker

### Build

```bash
docker build -t weather-mcp-server .
```

### Run

```bash
docker run -p 8000:8000 weather-mcp-server
```

## Azure Deployment

Deploy to Azure Container Apps using the provided script:

```bash
./deploy-azure.sh
```

This script will:
1. Create an Azure resource group
2. Set up a Container Apps environment
3. Build and deploy the container from source
4. Output the public MCP endpoint URL

### Prerequisites

- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) installed and logged in

### Configuration

Edit `deploy-azure.sh` to customize:
- `RESOURCE_GROUP` - Azure resource group name
- `LOCATION` - Azure region
- `CONTAINER_ENV` - Container Apps environment name
- `CONTAINER_APP` - Container app name

## Example

Once connected, you can ask Claude things like:
- "What's the weather in Paris?" (latitude: 48.8566, longitude: 2.3522)
- "Get the current temperature in Tokyo" (latitude: 35.6762, longitude: 139.6503)

## Project Structure

```
.
├── main.py           # MCP server implementation
├── pyproject.toml    # Project dependencies
├── Dockerfile        # Container configuration
├── deploy-azure.sh   # Azure deployment script
└── CLAUDE.md         # Claude Code instructions
```

## API

This server uses the free [Open-Meteo API](https://open-meteo.com/) which requires no API key.
