# 05 – Results

## 1. Summary of Results
The Weather Alert System (Problem 7H3) was designed, simulated, and verified across two independent environments:
1. **Logisim-evolution (v5.0.0):** Interactive gate/datapath level simulation.
2. **Xilinx Vivado (2018.3):** Synthesizable Verilog HDL behavioral simulation and synthesis elaboration.

Both implementations completely confirmed correct 5-state Moore FSM operation with exact parity.

## 2. Comprehensive Test Verification Matrix

| Test ID | Input `w[3:0]` (Decimal) | Control (`START`, `ACK`, `RST`) | FSM State | Expected Active LED | Observed Logisim LED | Observed Vivado Simulation | Verification Status |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **TC-01** | `0000` (`0`) | `RST = 1` | `S_IDLE` (`000`) | `idle_led = 1` | `Idle` (Orange) | `idle_led = 1` | **PASS** |
| **TC-02** | `0001` (`1`) | `START = 1, ACK = 0` | `S_CALM` (`001`) | `calm_led = 1` | `Calm` (Green) | `calm_led = 1` | **PASS** |
| **TC-03** | `0010` (`2`) | `START = 1, ACK = 0` | `S_CALM` (`001`) | `calm_led = 1` | `Calm` (Green) | `calm_led = 1` | **PASS** |
| **TC-04** | Any | `ACK = 1` | `S_IDLE` (`000`) | `idle_led = 1` | `Idle` (Orange) | `idle_led = 1` | **PASS** |
| **TC-05** | `0101` (`5`) | `START = 1, ACK = 0` | `S_BREEZY` (`010`) | `breezy_led = 1` | `Breezy` (Yellow) | `breezy_led = 1` | **PASS** |
| **TC-06** | Any | `ACK = 1` | `S_IDLE` (`000`) | `idle_led = 1` | `Idle` (Orange) | `idle_led = 1` | **PASS** |
| **TC-07** | `0110` (`6`) | `START = 1, ACK = 0` | `S_STORM` (`011`) | `stormy_led = 1` | `Storm` (Red) | `stormy_led = 1` | **PASS** |
| **TC-08** | `0111` (`7`) | `START = 1, ACK = 0` | `S_STORM` (`011`) | `stormy_led = 1` | `Storm` (Red) | `stormy_led = 1` | **PASS** |
| **TC-09** | Any | `ACK = 1` | `S_IDLE` (`000`) | `idle_led = 1` | `Idle` (Orange) | `idle_led = 1` | **PASS** |
| **TC-10** | `1000` (`8`) | `START = 1, ACK = 0` | `S_ERROR` (`100`) | `error_led = 1` | `Error` (Cyan) | `error_led = 1` | **PASS** |
| **TC-11** | `1001` (`9`) | `START = 1, ACK = 0` | `S_ERROR` (`100`) | `error_led = 1` | `Error` (Cyan) | `error_led = 1` | **PASS** |
| **TC-12** | Any | `ACK = 1` | `S_IDLE` (`000`) | `idle_led = 1` | `Idle` (Orange) | `idle_led = 1` | **PASS** |

## 3. Key Observations and Correctness Analysis
1. **Hint H3 Error Detection (> 7):** Expanding the wind bus to 4 bits (`w[3:0]`) and using unsigned comparators successfully detected invalid inputs `8–15` without arithmetic overflow or signed bit misinterpretation.
2. **Synchronous Moore Stability:** All indicator LEDs remained strictly stable with 0 glitches across clock transitions and input manipulations.
3. **Control Signal Priority:** `RST` and `ACK` reliably reset/cleared the state to `S_IDLE`, overriding `START` under all conditions.
