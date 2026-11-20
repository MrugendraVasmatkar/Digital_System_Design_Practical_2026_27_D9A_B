# 01 – Problem Analysis

**Project:** Weather Alert System, modification **H1: Four-Category Weather Alert (add a Warning level)**

## Files in this folder
| File | Contents |
|---|---|
| `problem_analysis.md` | Full problem analysis: requirements, I/O table, assumptions, edge cases, proposed solution |
| `block_diagram_H1.png` | Architecture / block diagram |
| `fsm_state_diagram_H1.png` | Moore FSM state diagram |

## Summary
A 3-bit wind value (W2 W1 W0, 0–7) is set on switches. A Moore FSM lights one indicator for the wind category and keeps it on until ACK is pressed.

| Wind | Wind[2:0] | Category | Indicator |
|---|---|---|---|
| 0 – 1 | 000 – 001 | CALM | Green LED |
| 2 – 4 | 010 – 100 | BREEZY | Yellow LED |
| 5 | 101 | **WARNING** (new in H1) | Orange LED |
| 6 – 7 | 110 – 111 | STORM | Red LED / Buzzer |

## Inputs and outputs
| Signal | Dir | Width | Meaning |
|---|---|---|---|
| `clk` | in | 1 | System clock |
| `reset` | in | 1 | Synchronous, active-high reset to IDLE |
| `start` | in | 1 | Classify the stored wind value (acts only in IDLE) |
| `ack` | in | 1 | Acknowledge the alert, return to IDLE |
| `wind_in[2:0]` | in | 3 | Wind value W2..W0 |
| `calm_led`, `breezy_led`, `warning_led`, `storm_led` | out | 1 each | Category indicators |
| `buzzer` | out | 1 | ON in STORM |

## Key assumptions
- Moore FSM: outputs depend only on the state, so the LEDs are steady.
- 5 states (IDLE, CALM, BREEZY, WARNING, STORM), so a **3-bit** state register is needed.
- The input register loads only in IDLE, so START uses a stable value and the stored value cannot change during an alert.
- Alerts hold until ACK. RESET has the highest priority.
- A 3-bit input cannot exceed 7, so no error state is needed.
