# 02 – FSM and Logisim

Upload FSM diagram, state table, Logisim `.circ` source and simulation evidence. If FSM is not applicable, explain the alternative control approach.
# 5-State Moore FSM State Table (Gaming XP Level Decoder)

## 1. Moore Output Table (State Encoding & LED Outputs)

Because this is a **Moore FSM**, each LED output depends **only on the present state** (`Q2 Q1 Q0`)[cite: 1, 4, 8]:

| State Name | State Code (`Q2 Q1 Q0`) | Beginner LED (`0–3`) | Intermediate LED (`4–7`) | Expert LED (`8–11`) | Master LED (`12–15`) |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **IDLE** | `000` | `0` | `0` | `0` | `0` |
| **BEGINNER** | `001` | `1` | `0` | `0` | `0` |
| **INTERMEDIATE** | `010` | `0` | `1` | `0` | `0` |
| **EXPERT** | `011` | `0` | `0` | `1` | `0` |
| **MASTER** | `100` | `0` | `0` | `0` | `1` |

* **Reset behavior:** When `RESET = 1`, the next state is **IDLE (`000`)** regardless of present state or inputs[cite: 1, 8].
* **Level signals:** `BEG` (`XP ≤ 3`), `INT` (`4 ≤ XP ≤ 7`), `EXP` (`8 ≤ XP ≤ 11`), and `MST` (`XP ≥ 12`) come from the two-stage comparator[cite: 1, 4, 8].

---

## 2. State Transition Table (`RESET = 0`)

| Present State (`Q2 Q1 Q0`) | Input Condition (`START`, `ACK`, Level) | Next State (`D2 D1 D0`) | Next State Name |
| :--- | :--- | :---: | :--- |
| **IDLE (`000`)** | `START = 0` | `000` | IDLE[cite: 8] |
| **IDLE (`000`)** | `START = 1`, `BEG = 1` (`0–3`) | `001` | BEGINNER[cite: 1, 8] |
| **IDLE (`000`)** | `START = 1`, `INT = 1` (`4–7`) | `010` | INTERMEDIATE[cite: 1, 8] |
| **IDLE (`000`)** | `START = 1`, `EXP = 1` (`8–11`) | `011` | EXPERT[cite: 1, 8] |
| **IDLE (`000`)** | `START = 1`, `MST = 1` (`12–15`) | `100` | MASTER[cite: 1, 8] |
| **BEGINNER (`001`)** | `ACK = 0` | `001` | BEGINNER[cite: 8] |
| **BEGINNER (`001`)** | `ACK = 1` | `000` | IDLE[cite: 8] |
| **INTERMEDIATE (`010`)** | `ACK = 0` | `010` | INTERMEDIATE[cite: 8] |
| **INTERMEDIATE (`010`)** | `ACK = 1` | `000` | IDLE[cite: 8] |
| **EXPERT (`011`)** | `ACK = 0` | `011` | EXPERT[cite: 8] |
| **EXPERT (`011`)** | `ACK = 1` | `000` | IDLE[cite: 8] |
| **MASTER (`100`)** | `ACK = 0` | `100` | MASTER[cite: 8] |
| **MASTER (`100`)** | `ACK = 1` | `000` | IDLE[cite: 8] |
