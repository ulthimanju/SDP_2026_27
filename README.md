# AgentTaint: A Security Framework for Protecting Tool-Using AI Agents Against Indirect Prompt Injection

## 1. Introduction
With the growth of Agentic AI, AI agents are increasingly capable of performing tasks autonomously by interacting with external tools such as email services, file systems, websites and databases.

However, these agents face a security problem called Indirect Prompt Injection. In this attack, malicious instructions are hidden inside external content, such as emails, documents or websites. When an AI agent processes this content, it may interpret those instructions as commands and perform unauthorized actions, such as deleting files, sharing confidential information or sending emails.

## 2. Proposed Solution
I propose developing AgentTaint, a security framework that acts as an intermediate layer between an AI agent and its external tools.

Instead of relying only on prompt-based instructions to prevent malicious behavior, AgentTaint tracks where information comes from and how it influences the actions performed by the agent.

The framework will examine tool requests before execution and determine whether the requested action is appropriate and authorized in the context of the user's original task.

## 3. How It Works
The proposed framework consists of four major components:
- **Taint Tagging:** Identifies the origin of information and labels it as trusted or untrusted. For example, user instructions are trusted, whereas external emails and websites are treated as untrusted sources.
- **Provenance Analyzer:** Tracks how information from different sources influences the arguments passed to external tools.
- **Capability Policy Engine:** Checks whether the requested tool action is permitted based on the user's task, security policies and information provenance. It can allow, block or request user approval.
- **Safe Declassification:** Allows the agent to extract legitimate information from untrusted content without automatically trusting instructions embedded within it.

## 4. Research Objective
The primary objective is to investigate whether information provenance tracking combined with context-aware permission enforcement can reduce indirect prompt-injection attacks while maintaining the normal functionality of AI agents.

The framework will be evaluated using existing agent-security benchmarks and controlled attack scenarios.

## 5. Expected Outcomes
- A working security middleware for tool-using AI agents.
- Improved protection against indirect prompt-injection attacks.
- Reduced unauthorized tool execution.
- Evaluation of security, legitimate task completion and runtime overhead.
- A research paper presenting the proposed framework and experimental findings.

## 6. Research Direction
Agentic AI Security, Information-Flow Control and Runtime Security Enforcement.
