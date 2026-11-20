## Allowed and Rejected Inputs

**ACCEPT (Y = 1, green LED), when the FSM is in IDLE:**
| Decimal | Binary (X3 X2 X1 X0) |
|---|---|
| 0 | 0000 |
| 1 | 0001 |
| 2 | 0010 |
| 3 | 0011 |
| 4 | 0100 |
| 5 | 0101 |
| 10 | 1010 |
| 11 | 1011 |
| 12 | 1100 |
| 13 | 1101 |
| 14 | 1110 |
| 15 | 1111 |

**REJECT (Y = 0, red LED), forbidden zone:**
| Decimal | Binary (X3 X2 X1 X0) |
|---|---|
| 6 | 0110 |
| 7 | 0111 |
| 8 | 1000 |
| 9 | 1001 |

Summary: values 0 to 5 and 10 to 15 are accepted (12 values). Values 6 to 9 are rejected (4 values).X0 is put as don't care , simplifying the hardware.

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
