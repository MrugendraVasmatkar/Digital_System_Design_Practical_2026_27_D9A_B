# 02 – FSM and Logisim

## 1. Moore FSM State Encoding & Outputs

| State Name | Encoding (`Q1 Q0`) | `led_beg` | `led_int` | `led_exp` | Description |
|---|:---:|:---:|:---:|:---:|---|
| `IDLE` | `00` | `0` | `0` | `0` | Waiting for `START = 1`; all tier LEDs OFF |
| `BEG` | `01` | `1` | `0` | `0` | Beginner tier (`XP: 0–3`) active |
| `INT` | `10` | `0` | `1` | `0` | Intermediate tier (`XP: 4–10`) active |
| `EXP` | `11` | `0` | `0` | `1` | Expert tier (`XP: 11–15`) active |

## 2. State Transition Table

| Current State | Input Condition | Next State | Datapath & Counter Action |
|---|---|---|---|
| `IDLE (00)` | `START == 0` | `IDLE (00)` | Hold all three 4-bit counts |
| `IDLE (00)` | `START == 1` & `XP <= 3` | `BEG (01)` | Latch `XP_IN`, `Beg_Count <= Beg_Count + 1` |
| `IDLE (00)` | `START == 1` & `4 <= XP <= 10` | `INT (10)` | Latch `XP_IN`, `Int_Count <= Int_Count + 1` |
| `IDLE (00)` | `START == 1` & `XP >= 11` | `EXP (11)` | Latch `XP_IN`, `Exp_Count <= Exp_Count + 1` |
| `BEG (01)` | `ACK == 0` / `ACK == 1` | `BEG (01)` / `IDLE (00)` | Hold counts across `ACK` cycles |
| `INT (10)` | `ACK == 0` / `ACK == 1` | `INT (10)` / `IDLE (00)` | Hold counts across `ACK` cycles |
| `EXP (11)` | `ACK == 0` / `ACK == 1` | `EXP (11)` / `IDLE (00)` | Hold counts across `ACK` cycles |

*(Asserting `RESET = 1` synchronously clears `FSM_STATE` to `00` (`IDLE`) and resets `Beg_Count`, `Int_Count`, and `Exp_Count` to `0000`.)*

## 3. Logisim-Evolution Circuit Architecture (`logidsim_group26.circ`)
- **Input Stage:** 4-bit `XP_IN` register gated by `STEP_EN = START & IDLE` so mid-round switch changes do not corrupt active states[cite: 28].
- **Comparator Stage:** Two 4-bit magnitude comparators (`0x3` and `0xa`) generating one-hot `BEG_FLAG` (`0–3`), `Int_Flag` (`4–10`), and `EXP_FLAG` (`11–15`)[cite: 28].
- **H4 Level Counters:** Three 4-bit counters (`Beg_Count`, `Int_Count`, `Exp_Count`) triggered on `STEP_EN` with 1-bit tier flags passed directly to the FSM[cite: 28].
- **Moore FSM & LEDs:** 2-bit `FSM_STATE` register feeding a 2-to-4 decoder driving the three tier LEDs (`BEG`, `INT`, `EXP`)[cite: 28].

## 4. Uploaded Files & Verification Status
- `logidsim_group26.circ` — Complete Logisim-evolution circuit source file.
- `logisim_circuit.jpg` — Full schematic capture showing connected 4-bit register, comparators, three 4-bit counters, Moore FSM, and tier LEDs[cite: 28].
- **Status (19/11/2026):** Schematic and `.circ` source uploaded prior to Day 1 cutoff; full 16-input (`0–15`) simulation sweep verification scheduled for Day 2 (`20/11/2026`).
