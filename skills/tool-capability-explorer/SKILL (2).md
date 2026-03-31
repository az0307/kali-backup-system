---
name: tool-capability-explorer
description: Researches, catalogs, and provides information on Gemini CLI tools and MCPs, aiding efficient and correct tool usage.
---

# Tool Capability Explorer (Skill)

## Core Objective
To research, catalog, and provide clear, actionable information about the functionalities, limitations, and optimal use cases of all available Gemini CLI tools and MCPs.

## Design Rationale (CoT/ToT Inspired):
-   **Problem:** Agents and skills need to effectively leverage the available tools (e.g., `google_web_search`, `mcp_openrouter_chat_with_model`, `run_shell_command`, `codebase_investigator`, `skill-creator`, etc.) to perform their tasks. Without clear understanding, tool usage can be inefficient, incorrect, or lead to errors. This addresses the "power user" and "best workaround methods" aspect by ensuring optimal tool selection.
-   **Need:** A dedicated skill is required to act as a comprehensive guide and reference for Gemini CLI's toolset. It ensures agents and skills can utilize their available resources to their fullest potential.
-   **Foundation:** This skill provides essential meta-knowledge about the AI's own capabilities (its tools), which is fundamental for designing effective skills and agents that can realistically perform tasks. It informs "power user" methods and "best workaround methods."
-   **Enables:** Efficient and correct utilization of all Gemini CLI tools, informing skill design and agent decision-making about which tool is best suited for a given sub-task. This is crucial for leveraging the entire ecosystem.

## Key Functionalities:
-   Catalog all available tools and MCPs with their descriptions and parameters.
-   Provide examples of how to use specific tools for common tasks.
-   Explain the limitations and potential pitfalls of each tool.
-   Recommend the most appropriate tool(s) for a given task or problem.
-   Research tool updates or new tool integrations.
-   Compare functionalities of similar tools to aid selection.

## Tool & MCP Integration:
-   `cli_help`: To query information about Gemini CLI tools directly.
-   `read_file`: To read documentation related to tools or MCPs if available locally.
-   `web_fetch` / `google_web_search`: To research external documentation for tools or MCPs not directly exposed via `cli_help`.
-   `save_memory`: To store a catalog of tool capabilities and best practices, making it quickly accessible.

## Dependencies & Enablers:
-   *Depends on:* Access to Gemini CLI's tool definitions and documentation.
-   *Enables:* All other skills and agents to make informed decisions about tool selection and usage, leading to more effective and efficient execution. It ensures agents can intelligently use their "functions."

## Blueprint Notes:
-   This skill should maintain an up-to-date registry of tools.
-   It could be structured to allow queries like "What's the best tool for searching files?" or "Show me examples of using `run_shell_command`."
-   Its findings would be reviewed by the **Tooling, MCP & Hook Integrator Agent** and potentially inform the **Research & Strategic Foresight Department**.
