
# H1 - FSM State and Transition Tables

## 1. FSM Description

The Water Temperature Classifier uses a Moore Finite State Machine (FSM) to classify a 3-bit temperature input into five states: IDLE, VERY COLD, COLD, NEUTRAL and HOT.

The FSM uses a 3-bit state encoding to represent all five states.

## 2. State Encoding Table

| State | State Encoding | Output |
|---|---|---|
| IDLE | 000 | All valves OFF |
| VERY COLD | 001 | Very Cold Valve ON |
| COLD | 010 | Cold Valve ON |
| NEUTRAL | 011 | Neutral Valve ON |
| HOT | 100 | Hot Valve ON |

## 3. FSM State Table (Moore Model)

| Present State | State Encoding | Very Cold | Cold | Neutral | Hot |
|---|---|---|---|---|---|
| IDLE | 000 | 0 | 0 | 0 | 0 |
| VERY COLD | 001 | 1 | 0 | 0 | 0 |
| COLD | 010 | 0 | 1 | 0 | 0 |
| NEUTRAL | 011 | 0 | 0 | 1 | 0 |
| HOT | 100 | 0 | 0 | 0 | 1 |

## 4. FSM Transition Table

The FSM transitions according to the START, ACK and temperature input conditions.

RESET has the highest priority and returns the FSM to IDLE.

| Present State | START | ACK | Temperature Input | Next State |
|---|---|---|---|---|
| IDLE | 0 | X | X | IDLE |
| IDLE | 1 | X | 0–1 | VERY COLD |
| IDLE | 1 | X | 2–3 | COLD |
| IDLE | 1 | X | 4–5 | NEUTRAL |
| IDLE | 1 | X | 6–7 | HOT |
| VERY COLD | X | 0 | X | VERY COLD |
| VERY COLD | X | 1 | X | IDLE |
| COLD | X | 0 | X | COLD |
| COLD | X | 1 | X | IDLE |
| NEUTRAL | X | 0 | X | NEUTRAL |
| NEUTRAL | X | 1 | X | IDLE |
| HOT | X | 0 | X | HOT |
| HOT | X | 1 | X | IDLE |

**Note:**
- X represents a don't-care condition.
- RESET = 1 forces the FSM to IDLE from any state.
- START = 1 initiates classification when the FSM is in IDLE.
- ACK = 1 acknowledges the classification and returns the FSM to IDLE.
- When ACK = 0, the FSM remains in its current classification state.

## 5. Temperature Classification Table

| Decimal Input | Binary Input | Category | State Encoding |
|---|---|---|---|
| 0 | 000 | VERY COLD | 001 |
| 1 | 001 | VERY COLD | 001 |
| 2 | 010 | COLD | 010 |
| 3 | 011 | COLD | 010 |
| 4 | 100 | NEUTRAL | 011 |
| 5 | 101 | NEUTRAL | 011 |
| 6 | 110 | HOT | 100 |
| 7 | 111 | HOT | 100 |

## 6. Output Behaviour

The FSM follows the Moore model, meaning that the outputs depend only on the current state.

- IDLE: All valve outputs are LOW.
- VERY COLD: Very Cold valve output is HIGH.
- COLD: Cold valve output is HIGH.
- NEUTRAL: Neutral valve output is HIGH.
- HOT: Hot valve output is HIGH.

Only one category output is HIGH at a time.

## 7. Conclusion

The FSM classifies the 3-bit temperature input into four temperature categories using five states, including the initial IDLE state. The 3-bit state encoding allows all five states to be represented. START initiates classification, while ACK returns the FSM to IDLE after the category has been detected.
