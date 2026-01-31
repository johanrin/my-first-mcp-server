#!/bin/bash
set -e

# Configuration - modify these as needed
RESOURCE_GROUP="mcp-weather-rg"
LOCATION="eastus"
CONTAINER_ENV="mcp-weather-env"
CONTAINER_APP="weather-mcp-server"

echo "=== Azure MCP Server Deployment ==="

# Check if Azure CLI is installed
if ! command -v az &> /dev/null; then
    echo "Error: Azure CLI is not installed. Install it from https://docs.microsoft.com/en-us/cli/azure/install-azure-cli"
    exit 1
fi

# Check if logged in
echo "Checking Azure login status..."
az account show &> /dev/null || az login

# Create resource group
echo "Creating resource group: $RESOURCE_GROUP..."
az group create --name "$RESOURCE_GROUP" --location "$LOCATION" --output none

# Create Container Apps environment
echo "Creating Container Apps environment: $CONTAINER_ENV..."
az containerapp env create \
    --name "$CONTAINER_ENV" \
    --resource-group "$RESOURCE_GROUP" \
    --location "$LOCATION" \
    --output none

# Deploy the container app (builds from source)
echo "Building and deploying container app: $CONTAINER_APP..."
az containerapp up \
    --name "$CONTAINER_APP" \
    --resource-group "$RESOURCE_GROUP" \
    --environment "$CONTAINER_ENV" \
    --source . \
    --ingress external \
    --target-port 8000

# Get the app URL
APP_URL=$(az containerapp show \
    --name "$CONTAINER_APP" \
    --resource-group "$RESOURCE_GROUP" \
    --query "properties.configuration.ingress.fqdn" \
    --output tsv)

echo ""
echo "=== Deployment Complete ==="
echo "Your MCP server is available at: https://$APP_URL"
echo ""
echo "MCP endpoint: https://$APP_URL/mcp"
echo ""
echo "To connect from an MCP client, use:"
echo "  URL: https://$APP_URL/mcp"
echo ""
echo "To view logs:"
echo "  az containerapp logs show --name $CONTAINER_APP --resource-group $RESOURCE_GROUP --follow"
echo ""
echo "To delete all resources:"
echo "  az group delete --name $RESOURCE_GROUP --yes --no-wait"
