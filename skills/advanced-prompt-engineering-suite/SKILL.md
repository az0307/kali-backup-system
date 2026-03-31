---
name: advanced-prompt-engineering-suite
description: Provides procedural implementation and templates for creating advanced prompts, incorporating psychological principles and thinking methodologies.
---

# Advanced Prompt Engineering Suite (Skill)

## Core Objective
To provide the procedural implementation and templates for creating and applying advanced prompts, incorporating psychological principles and specific thinking methodologies, as guided by the Prompt Engineering Specialist Agent.

## Design Rationale (CoT/ToT Inspired):
-   **Problem:** Crafting effective prompts requires specific syntax, structuring, and iterative refinement. Simply knowing *what* prompt to use is less helpful than knowing *how* to construct it reliably.
-   **Need:** This skill encapsulates the concrete steps, templates, and patterns for prompt engineering, making it a reusable capability.
-   **Foundation:** It operationalizes the design principles and strategies developed by the Prompt Engineering Specialist Agent, allowing other agents and skills to easily implement sophisticated prompting.
-   **Enables:** Consistent and effective LLM interactions across the system, directly supporting the "prompt design" and "thinking methodology" requirements.

## Key Functionalities:
-   Generate prompt structures based on task type, desired LLM model, and cognitive goals.
-   Incorporate user-defined context, examples, and constraints into prompts.
-   Implement specific prompt patterns (e.g., Few-shot learning, role-playing, Chain-of-Thought structures).
-   Provide templates for persona-based prompting or style emulation.
-   Guide the formatting of inputs for multimodal models if applicable.
-   Assist in formatting prompts for specific MCPs or API endpoints.

## Tool & MCP Integration:
-   `mcp_openrouter_chat_with_model`: To generate prompt variations and test them.
-   `write_file` / `replace`: To create prompt template files or incorporate prompt snippets into agent/skill code.
-   `save_memory`: To store prompt templates and successful prompt strategies.

## Dependencies & Enablers:
-   *Depends on:* Guidance and strategies from the **Advanced Prompt Engineering & Psychology Specialist Agent**.
-   *Enables:* Any agent or skill that needs to interact with an LLM in a sophisticated and controlled manner.

## Blueprint Notes:
-   This skill could be modular, with sub-skills for different prompt types (e.g., `prompt-suite.cot.skill`, `prompt-suite.persona.skill`).
-   It should provide clear examples and usage instructions.
-   Its effectiveness will be reviewed by the **Quality Assurance & Auditing Bureau Agent**.
