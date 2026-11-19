# 02 – FSM Design and Logisim Implementation (H4)

## 1. Moore FSM State Diagram
```mermaid
stateDiagram-v2
    [*] --> IDLE : RESET = 1
    IDLE --> IDLE : START = 0
    IDLE --> BEG : START = 1 & XP [0–3]
    IDLE --> INT : START = 1 & XP [4–10]
    IDLE --> EXP : START = 1 & XP [11–15]

    BEG --> BEG : ACK = 0
    BEG --> IDLE : ACK = 1

    INT --> INT : ACK = 0
    INT --> IDLE : ACK = 1

    EXP --> EXP : ACK = 0
    EXP --> IDLE : ACK = 1
