FROM python:3.12-slim

WORKDIR /app

# Install uv for fast dependency management
RUN pip install uv

# Copy dependency files first for better caching
COPY pyproject.toml uv.lock* ./

# Install dependencies
RUN uv sync --no-dev

# Copy application code
COPY main.py .

# Expose the port for HTTP transport
EXPOSE 8000

# Run the MCP server
CMD ["uv", "run", "main.py"]
