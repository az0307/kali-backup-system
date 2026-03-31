---
name: cognitive-architecture-designer
description: Provides procedural knowledge for implementing cognitive architectures, thinking methodologies, and psychological principles in AI agents/skills.
---

# Cognitive Architecture Designer (Skill)

## Core Objective
To provide the procedural knowledge and specific instructions for implementing cognitive architectures, thinking methodologies, and psychological principles within an AI agent or skill, as designed by the Cognitive Architect Agent.

## Design Rationale (CoT/ToT Inspired):
-   **Problem:** Abstract cognitive designs from the Agent need to be translated into concrete, implementable instructions or code. A skill is perfect for encapsulating this procedural knowledge.
-   **Need:** This skill translates high-level architectural ideas into actionable steps or configurations that Gemini CLI can follow.
-   **Foundation:** It operationalizes the cognitive designs created by the agent, making them usable by other parts of the system. It bridges the gap between theoretical design and practical implementation.
-   **Enables:** Agents and skills to adopt specific reasoning patterns, integrate psychological insights, or implement novel thinking processes.

## Key Functionalities:
-   Implement specific Chain-of-Thought or Tree-of-Thought patterns based on design.
-   Integrate prompt templates that guide LLMs towards desired psychological or reasoning biases (e.g., "think step-by-step," "consider counter-arguments").
-   Structure output to reflect specific cognitive steps or analysis stages.
-   Provide procedural guidance on how to use specific LLM parameters (like temperature) to influence cognitive output.
-   Guide the structuring of thought logs or intermediate reasoning steps.

## Tool & MCP Integration:
-   `mcp_openrouter_chat_with_model`: For generating prompt snippets, structuring thought steps.
-   `write_file` / `replace`: For generating skill/agent code or configuration files that embed these cognitive patterns.
-   `save_memory`: To store custom prompt structures or reasoning pattern configurations.

## Dependencies & Enablers:
-   *Depends on:* Output/guidance from the **Cognitive Architect Agent**.
-   *Enables:* Specific agents and skills to execute defined cognitive architectures and thinking methodologies.

## Blueprint Notes:
-   This skill might have sub-modules or variants for different cognitive architectures (e.g., `cognitive-architecture.cot.skill`, `cognitive-architecture.tot.skill`).
-   It would likely contain template code snippets or configuration structures.
