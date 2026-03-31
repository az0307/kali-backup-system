#!/bin/bash
# Use TARS to fix USB WiFi

echo "Starting TARS to fix USB WiFi..."

# Start TARS web interface
agent-tars web &
sleep 5

echo "TARS should be running at http://localhost:8888"

# Or use TARS command mode
echo "Running TARS command to check USB..."
agent-tars run "check lsusb and ip link show"

echo ""
echo "If TARS is running, open browser to:"
echo "http://localhost:8888"
echo ""
echo "Then ask TARS to: 'run lsusb and fix the wifi adapter'"
