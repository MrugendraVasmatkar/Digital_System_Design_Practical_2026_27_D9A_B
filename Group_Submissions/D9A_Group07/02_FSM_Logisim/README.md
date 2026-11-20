## Allowed and Rejected Inputs (X0 = don't care)

**REJECT (Y = 0, red LED), forbidden zone:**
| X3 X2 X1 X0 | Decimal values covered |
|---|---|
| 0 1 1 X | 6, 7 |
| 1 0 0 X | 8, 9 |

These two patterns match the two terms of the equation:
FZ = X3'·X2·X1 + X3·X2'·X1'

**ACCEPT (Y = 1, green LED), when the FSM is in IDLE:**
| X3 X2 X1 X0 | Decimal values covered |
|---|---|
| 0 0 0 X | 0, 1 |
| 0 0 1 X | 2, 3 |
| 0 1 0 X | 4, 5 |
| 1 0 1 X | 10, 11 |
| 1 1 X X | 12, 13, 14, 15 |

Summary: X0 never affects the result. Values 6 to 9 are rejected (2 patterns, 4 values). Values 0 to 5 and 10 to 15 are accepted (12 values).


## FSM States

| State | Encoding (Q) | Output Y | Meaning |
|---|---|---|---|
| IDLE | 0 | 1 if X is allowed, 0 if X is forbidden | Normal checking. Accepts allowed values and rejects forbidden ones immediately. |
| REJECT | 1 | Always 0 | A forbidden value was seen. Output stays 0 (red LED) until ACK = 1 or RESET. |

Transitions:
- IDLE, allowed value: stay in IDLE, Y = 1
- IDLE, forbidden value (6 to 9): go to REJECT, Y = 0
- REJECT, ACK = 0: stay in REJECT, Y = 0
- REJECT, ACK = 1: go to IDLE
- RESET (any state): go to IDLE
