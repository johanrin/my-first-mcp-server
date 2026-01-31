# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

MCP (Model Context Protocol) server providing weather information via the Open-Meteo API. Exposes a `get_weather(latitude, longitude)` tool that returns current temperature and wind speed.

## Commands

```bash
uv sync          # Install dependencies
uv run main.py   # Run the MCP server
```

## Architecture

Single-file MCP server (`main.py`) using FastMCP. The server uses streamable-http transport for remote deployment (Docker, Azure Container Apps).
