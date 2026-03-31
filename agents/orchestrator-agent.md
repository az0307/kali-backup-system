# Orchestrator Agent Configuration

## Agent: orchestrator-agent
## Platform: Laptop (control hub)
## Purpose: Coordinate both machines

### Functions
- Deploy commands to desktop
- Sync tools
- Manage workflows
- Aggregate results

### Commands
```bash
# Deploy to desktop
./orchestrate.sh deploy-tools

# Run on both
./orchestrate.sh scan-all

# Collect results
./orchestrate.sh collect
```
