# Digital System Design – Group Project

> Complete every mandatory section. Do not delete headings. Replace bracketed prompts. If a section is not applicable, explain why.

## 1. Team Details
| Role | Student name | Roll number | GitHub username |
|---|---|---|---|
| Group leader | Yashodhara Suryawanshi | D9A – 56 | [GitHub Username] |
| Member 2 | Sunny Yadav | D9A – 63 | [GitHub Username] |
| Member 3 | Jyotiraditya Nikam | D9B – 43 | [GitHub Username] |
| Member 4 | Neha Patil | D9B – 69 | [GitHub Username] |

**Class:** D9A / D9B  
**Group ID:** [e.g. D9A_D9B_GroupXX]  
**Repository URL:** [Fork URL]  
**Final Pull Request URL:** [PR URL]

## 2. Assigned Problem Statement
- **Number/title:** H4 – Weather Alert System: Add Category Counter
- **Problem summary:** Enhance the base Weather Alert System by integrating dedicated digital counters that record how many times each weather condition—Calm, Breezy, and Storm—is detected from a 3-bit wind speed input.
- **Objective:**
  - Classify a 3-bit wind speed input into three mutually exclusive weather categories (Calm, Breezy, Storm).
  - Maintain independent running counts of detections for each weather category (`Calm_Count`, `Breezy_Count`, and `Storm_Count`).
  - Trigger an alert (`Buzzer`) when Storm conditions are detected and allow acknowledgement (`ACK`) and full system reset (`reset`).
- **Inputs and outputs:**

| Signal Name | Direction | Width | Meaning |
|---|---|---|---|
| `clk` | Input | 1 bit | System clock driving FSM transitions and counter registers |
| `reset` | Input | 1 bit | Synchronous/active-high reset that returns FSM to `IDLE` and clears all counters to `0` |
| `START` | Input | 1 bit | Trigger signal to sample `Wind[2:0]`, transition FSM state, and increment the active category counter |
| `ACK` | Input | 1 bit | Acknowledge signal to clear the active weather alert state and return the FSM to `IDLE` |
| `Wind[2:0]` | Input | 3 bits | Unsigned wind speed input (`0–2`: Calm, `3–5`: Breezy, `6–7`: Storm) |
| `state[1:0]` | Output | 2 bits | Current encoded FSM state (`00`: IDLE, `01`: CALM, `10`: BREEZY, `11`: STORM) |
| `Buzzer` | Output | 1 bit | High (`1`) when the system is in the `STORM` state; Low (`0`) otherwise |
| `Calm_Count[3:0]` | Output | 4 bits | Total number of Calm weather detections (`0–15`) |
| `Breezy_Count[3:0]` | Output | 4 bits | Total number of Breezy weather detections (`0–15`) |
| `Storm_Count[3:0]` | Output | 4 bits | Total number of Storm weather detections (`0–15`) |
| `Calm_LED[3:0]` | Output | 4 bits | LED display output mirroring `Calm_Count[3:0]` |
| `Breezy_LED[3:0]` | Output | 4 bits | LED display output mirroring `Breezy_Count[3:0]` |
| `Storm_LED[3:0]` | Output | 4 bits | LED display output mirroring `Storm_Count[3:0]` |

- **Constraints and assumptions:**
  - `Wind[2:0]` represents 8 discrete wind intensity levels (`0` to `7`) partitioned cleanly across all three categories with no undefined gaps.
  - Each category counter is 4 bits wide in Verilog (supporting up to 15 detections before rollover) and resets cleanly to `0` when `reset` is asserted.
  - A new weather reading is logged once per `START -> Category -> ACK` cycle so that holding a wind condition does not spuriously over-increment the counter on every clock cycle.

## 3. Problem Analysis and Proposed Solution
The base Weather Alert System monitors a 3-bit wind sensor input and classifies weather severity, but it lacks historical tracking of how frequently each alert condition occurs. For monitoring and safety analytics, knowing the cumulative number of Calm, Breezy, and Storm detections is essential.

**Key Requirements & Edge Cases:**
- **Mutually Exclusive Decoding:** Every 3-bit input (`000`–`111`) must map to exactly one category so two counters never increment simultaneously.
- **Boundary Values:** Exact classification at range edges (`2` as Calm vs. `3` as Breezy; `5` as Breezy vs. `6` as Storm).
- **Single Count per Detection:** Incrementing counters only on the `IDLE` to Category transition (when `START = 1`) avoids repeated counting while waiting for `ACK`.
- **Reset Recovery:** Asserting `reset` at any time must immediately return the FSM to `IDLE`, silence `Buzzer`, and zero all three counters and LED outputs.

**Proposed Solution & Distinctive Features:**
We combine a combinational **Range Decoder** with a 4-state **Moore FSM Controller** and **three parallel 4-bit Category Counters** (`Calm_Count`, `Breezy_Count`, `Storm_Count`). Dedicated LED outputs (`Calm_LED`, `Breezy_LED`, `Storm_LED`) provide immediate visual feedback alongside the `Buzzer` alarm during Storm states. The design is compact (elaborating to only 39 RTL cells and 60 nets in Vivado), fully synchronous, and straightforward to verify in both Logisim and Verilog.

## 4. Architecture
The system is organized into three tightly coupled blocks:

1. **Combinational Range Decoder:** Evaluates `Wind[2:0]` (`W2, W1, W0`) using basic logic gates:
   - `Calm` (`0–2`): `~W2 & (~W1 | ~W0)`
   - `Breezy` (`3–5`): `(~W2 & W1 & W0) | (W2 & ~W1)`
   - `Storm` (`6–7`): `W2 & W1`
2. **FSM Controller (`state_reg[1:0]`):** Manages operational flow using `START` and `ACK`. On `START = 1` in `IDLE`, it latches the decoded weather state (`CALM`, `BREEZY`, or `STORM`) and drives `Buzzer` high solely in `STORM`. On `ACK = 1`, it returns to `IDLE`.
3. **Category Counters & Output Drivers:** Three independent 4-bit registers (`Calm_Count_reg[3:0]`, `Breezy_Count_reg[3:0]`, `Storm_Count_reg[3:0]`) increment by `+1` whenever their corresponding category is triggered from `IDLE`. Their values are routed directly to both count outputs and LED indicators.

**Design Trade-offs:**
- Using three separate 4-bit counters increases flip-flop usage slightly compared to a single shared multiplexed counter, but allows simultaneous parallel display on `Calm_LED`, `Breezy_LED`, and `Storm_LED` with minimal control overhead.
- Gate-level decoding keeps combinational path delay very low, ensuring high maximum operating frequency.

![Block diagram / Elaborated RTL Schematic](02_Architecture/elaborated_schematic.png)

## 5. FSM Design
Yes, the design uses a **4-state Moore Finite State Machine** (output `Buzzer` depends solely on the current state `state[1:0]`).

**State Encoding:**
- `S_IDLE` (`2'b00` / `0`): Default waiting state; `Buzzer = 0`.
- `S_CALM` (`2'b01` / `1`): Calm weather detected (`Wind` = `0–2`); `Buzzer = 0`.
- `S_BREEZY` (`2'b10` / `2`): Breezy weather detected (`Wind` = `3–5`); `Buzzer = 0`.
- `S_STORM` (`2'b11` / `3`): Storm weather detected (`Wind` = `6–7`); `Buzzer = 1`.

**Reset Behaviour:** When `reset = 1`, `state[1:0]` returns to `S_IDLE` (`2'b00`), `Buzzer` is forced to `0`, and `Calm_Count`, `Breezy_Count`, and `Storm_Count` are cleared to `4'b0000`.

**State Transition Table:**

| Current State | Condition | Next State | Counter Action | `Buzzer` |
|---|---|---|---|---|
| Any State | `reset = 1` | `S_IDLE (00)` | Clear all counts to `0` | `0` |
| `S_IDLE (00)` | `START = 0` | `S_IDLE (00)` | Hold | `0` |
| `S_IDLE (00)` | `START = 1`, `Wind = 0..2` | `S_CALM (01)` | `Calm_Count <= Calm_Count + 1` | `0` |
| `S_IDLE (00)` | `START = 1`, `Wind = 3..5` | `S_BREEZY (10)` | `Breezy_Count <= Breezy_Count + 1` | `0` |
| `S_IDLE (00)` | `START = 1`, `Wind = 6..7` | `S_STORM (11)` | `Storm_Count <= Storm_Count + 1` | `0` |
| `S_CALM (01)` | `ACK = 0` / `ACK = 1` | `S_CALM` / `S_IDLE` | Hold | `0` |
| `S_BREEZY (10)` | `ACK = 0` / `ACK = 1` | `S_BREEZY` / `S_IDLE` | Hold | `0` |
| `S_STORM (11)` | `ACK = 0` / `ACK = 1` | `S_STORM` / `S_IDLE` | Hold | `1` |

**Diagram:** `02_Architecture/fsm_diagram.png` *(update path if stored elsewhere)*  
**State table:** Documented above (and in `02_Architecture/fsm_state_table.md` if maintained separately).

## 6. Logisim Implementation
- **Logisim version:** Logisim-evolution *(specify exact version, e.g., v3.8.0)*
- **Circuit file:** `01_Logisim/weather_alert_H4.circ` *(update to exact `.circ` path)*
- **Implementation overview:** Built using 3 single-bit input pins (`W2`, `W1`, `W0`), NOT/AND/OR logic gates forming the three category outputs (`S0_calm`, `S1_breezy`, `S2_Storm`), status LEDs, and three separate D flip-flop counter chains (`D1–D5`, `D12–D15`, `D22–D25`) with LED readouts for each category count.
- **Test cases and expected/observed behaviour:**
  - Verified all 8 binary combinations of `W2, W1, W0` (`000` through `111`).
  - Confirmed `S0_calm` activates exclusively for `000–010`, `S1_breezy` for `011–101`, and `S2_Storm` for `110–111`.
  - Confirmed each respective flip-flop counter chain increments only when its corresponding weather category activates.
- **Issues and corrections:**
  - Initial gate wiring caused overlapping activation at boundary `011` (`3`); corrected by explicitly gating `S0_calm` with `~W2 & (~W1 | ~W0)` and `S1_breezy` with `(~W2 & W1 & W0) | (W2 & ~W1)`.
- **Screenshot/evidence:** `01_Logisim/logisim_simulation.png`

## 7. Verilog HDL Implementation
- **Tool/version:** Xilinx Vivado Design Suite *(specify exact version, e.g., 2023.2 / 2024.1)*
- **Top module and submodules:**
  - RTL Top Module: `weather_alert_H4.v`
  - Verification Testbench: `tb_weather_alert_H4.v`
- **Architecture/coding decisions:**
  - Implemented synchronous state transitions and 4-bit category counter updates inside a clocked `always` block triggered on `posedge clk` with clean reset handling.
  - Separated combinational range-decoding logic and `Buzzer` output logic for clarity and clean RTL elaboration (`39 Cells`, `34 I/O Ports`, `60 Nets`).
  - Wired `Calm_LED`, `Breezy_LED`, and `Storm_LED` directly to their corresponding 4-bit counter registers for easy FPGA pin mapping.
- **Synthesizability considerations:**
  - Used non-blocking assignments (`<=`) for sequential registers (`state`, `Calm_Count`, `Breezy_Count`, `Storm_Count`) and blocking assignments (`=`) / `assign` statements for combinational logic.
  - Avoided latches by specifying default assignments/branches for all FSM states and inputs.
- **RTL:** `03_Verilog_Implementation/RTL/weather_alert_H4.v`
- **Testbench:** `03_Verilog_Implementation/Testbench/tb_weather_alert_H4.v`

## 8. Verification and Simulation Results
Behavioral simulation was executed in Vivado Simulator (`sim_1 - tb_weather_alert_H4`) over `0 ns` to `271 ns` using an automated self-checking loop (`i = 0` to `7`) that sweeps all 8 possible `Wind[2:0]` values and compares actual outputs against expected counters (`exp_calm`, `exp_breezy`, `exp_storm`).

| Test ID | Inputs/conditions | Expected output | Observed output | Pass/Fail |
|---|---|---|---|---|
| T01 | Initial `reset = 1` (`0–20 ns`) | `state = 0`, all counts & LEDs = `0`, `Buzzer = 0` | `state = 0`, all counts & LEDs = `0`, `Buzzer = 0` | Pass |
| T02 | `Wind = 0` (`3'b000`), `START = 1`, then `ACK = 1` | `state = 1 -> 0`, `Calm_Count = 1`, `Buzzer = 0` | `state = 1 -> 0`, `Calm_Count = 1`, `Calm_LED = 1`, `Buzzer = 0` | Pass |
| T03 | `Wind = 1` (`3'b001`), `START = 1`, then `ACK = 1` | `state = 1 -> 0`, `Calm_Count = 2`, `Buzzer = 0` | `state = 1 -> 0`, `Calm_Count = 2`, `Calm_LED = 2`, `Buzzer = 0` | Pass |
| T04 | `Wind = 2` (`3'b010`), `START = 1`, then `ACK = 1` | `state = 1 -> 0`, `Calm_Count = 3`, `Buzzer = 0` | `state = 1 -> 0`, `Calm_Count = 3`, `Calm_LED = 3`, `Buzzer = 0` | Pass |
| T05 | `Wind = 3` (`3'b011`), `START = 1`, then `ACK = 1` | `state = 2 -> 0`, `Breezy_Count = 1`, `Buzzer = 0` | `state = 2 -> 0`, `Breezy_Count = 1`, `Breezy_LED = 1`, `Buzzer = 0` | Pass |
| T06 | `Wind = 4` (`3'b100`), `START = 1`, then `ACK = 1` | `state = 2 -> 0`, `Breezy_Count = 2`, `Buzzer = 0` | `state = 2 -> 0`, `Breezy_Count = 2`, `Breezy_LED = 2`, `Buzzer = 0` | Pass |
| T07 | `Wind = 5` (`3'b101`), `START = 1`, then `ACK = 1` | `state = 2 -> 0`, `Breezy_Count = 3`, `Buzzer = 0` | `state = 2 -> 0`, `Breezy_Count = 3`, `Breezy_LED = 3`, `Buzzer = 0` | Pass |
| T08 | `Wind = 6` (`3'b110`), `START = 1`, then `ACK = 1` | `state = 3 -> 0`, `Storm_Count = 1`, `Buzzer = 1 -> 0` | `state = 3 -> 0`, `Storm_Count = 1`, `Storm_LED = 1`, `Buzzer = 1 -> 0` | Pass |
| T09 | `Wind = 7` (`3'b111`), `START = 1`, then `ACK = 1` | `state = 3 -> 0`, `Storm_Count = 2`, `Buzzer = 1 -> 0` | `state = 3 -> 0`, `Storm_Count = 2`, `Storm_LED = 2`, `Buzzer = 1 -> 0` | Pass |
| T10 | Final `reset = 1` (`~260 ns`) | All counts & LEDs reset to `0`, `state = 0` | `Calm/Breezy/Storm_Count = 0`, all LEDs = `0`, `state = 0` | Pass |

**Tool/version:** Xilinx Vivado Behavioral Simulator  
**Number passed/failed:** 10 / 10 Passed (`errors = 0`)  
**Waveform/log path:** `03_Verilog_Implementation/Simulation/waveform_weather_alert_H4.png`

## 9. FPGA Hardware Implementation
- **FPGA board/device:** Xilinx Kintex-7 `xc7k70tfbv676-1` (target part in Vivado RTL Elaboration) *[Update with physical lab FPGA board model, e.g., Basys 3 / Nexys A7, if programmed on hardware]*
- **Tool/version:** Xilinx Vivado Design Suite
- **Clock/constraints:** 100 MHz clock (`10 ns` period in simulation); XDC pin constraints mapping `Wind[2:0]`, `START`, `ACK`, `reset` to switches/buttons and `Calm_LED`, `Breezy_LED`, `Storm_LED`, `Buzzer` to board LEDs/buzzer *(add `.xdc` file path if applicable)*.
- **Synthesis/implementation summary:** RTL Elaboration succeeded cleanly with **39 Cells**, **34 I/O Ports**, and **60 Nets**, with zero syntax or elaboration warnings. *(Add post-implementation LUT/FF utilization and WNS timing once bitstream generation is run.)*
- **Programming and hardware test result:** *[Update with hardware demo results & photos once bitstream is downloaded to the FPGA board, or note if verification was completed through Vivado RTL elaboration and behavioral simulation only.]*
- **Evidence path:** `04_FPGA_Hardware/`

*Note on simulation vs. hardware differences:* On physical FPGA hardware, mechanical push-buttons for `START`, `ACK`, and `reset` require debouncing (or a divided slow clock) to prevent multiple unintended transitions per press, whereas behavioral simulation applies clean single-cycle pulses.

## 10. Challenges, Debugging and Improvements
| Issue | Root cause | Correction | Outcome |
|---|---|---|---|
| Overlapping range detection at boundary wind values | Incomplete minterm simplification in combinational gate-level decoder | Re-derived mutually exclusive Boolean equations for `0–2`, `3–5`, and `6–7` | Clean single-category activation across all 8 input values |
| Multiple counter increments for a single weather event | Counter incremented every clock cycle while FSM stayed in a weather state | Gated counter increment strictly on the `S_IDLE` to category transition when `START = 1` | Each weather detection increments its counter by exactly `1` |
| Ensuring deterministic startup and clearing of counts | Uninitialized flip-flops in simulation produced `X` states | Added explicit `reset` handling for `state` and all three 4-bit counter registers | Zero unknown (`X`) output states; clean reset verified at start and end (`260 ns`) |

**Future improvements:**
- Add hardware switch debouncers and a clock divider for direct human-speed operation on an FPGA board.
- Extend counter widths (e.g., 8-bit) or add overflow flag indicators and 7-segment display drivers for decimal count readouts.
- Add configurable threshold registers so Calm/Breezy/Storm wind speed boundaries can be adjusted dynamically.

## 11. Task Allocation and Individual Contribution
*(Adjust roles below if your internal task split differed.)*

| Student | Assigned responsibility | Actual contribution/evidence |
|---|---|---|
| Yashodhara Suryawanshi (D9A – 56) | Project coordination, problem formulation & FSM design | Defined H4 specifications, FSM transition logic, and coordinated repository/presentation integration |
| Sunny Yadav (D9A – 63) | Logisim gate-level & flip-flop circuit design | Designed and verified the 3-bit Range Decoder and three D flip-flop counter chains in Logisim |
| Jyotiraditya Nikam (D9B – 43) | Verilog RTL design & Vivado elaboration | Authored `weather_alert_H4.v`, generated and verified the Vivado elaborated schematic (`39 Cells`, `34 I/O Ports`) |
| Neha Patil (D9B – 69) | Verification testbench, simulation & documentation | Developed self-checking `tb_weather_alert_H4.v`, verified `0` errors across all 8 wind inputs, and prepared final presentation/documentation |

Every student must be ready to explain the complete design.

## 12. Progress Log
Maintain time-wise updates in `STATUS.md`.

## 13. Final Results and Conclusion
The **Weather Alert System with Category Counters (H4)** was successfully designed, modeled, and verified at both the gate level (Logisim) and RTL level (Verilog HDL in Xilinx Vivado).

- **Requirements met:** All 3-bit wind speed inputs (`0–7`) are accurately classified into Calm (`0–2`), Breezy (`3–5`), and Storm (`6–7`). Three dedicated 4-bit category counters (`Calm_Count`, `Breezy_Count`, `Storm_Count`) and corresponding LED outputs track every detection independently, while `Buzzer` alerts exclusively during Storm states.
- **Measured verification results:** Vivado behavioral simulation passed all test cases across the full input range with `errors = 0` (final counts before reset: `Calm = 3`, `Breezy = 3`, `Storm = 2`), and RTL elaboration compiled cleanly to `39 Cells`, `34 I/O Ports`, and `60 Nets`.
- **Limitations:** Current 4-bit counters roll over after 15 detections per category, and physical button debouncing should be added when deploying to manual FPGA push-buttons.
- **Conclusion:** Integrating independent sequential category counters into the Weather Alert System FSM provides reliable real-time alerting alongside structured event logging in a compact, synthesizable digital hardware design.

## 14. Team Reflection
- **What the team learned:** We gained hands-on experience translating Boolean range-decoding equations and FSM specifications from gate-level Logisim schematics into clean, synthesizable Verilog HDL. Building a self-checking testbench (`exp_calm`, `exp_breezy`, `errors`) significantly sped up verification and increased confidence in edge-case behavior.
- **What we would improve:** In future iterations, we would parameterize counter bit-widths in Verilog, incorporate an onboard 7-segment display controller, and integrate switch-debouncing modules early in the RTL phase for smoother FPGA board testing.

## 15. Final Submission Checklist
- [x] Team details and problem analysis complete. *(Add GitHub usernames & Repo/PR URLs in Section 1)*
- [x] Architecture/block diagram included. *(Ensure image file path matches repo)*
- [x] FSM diagram/table or justified alternative included.
- [x] Logisim source and simulation evidence uploaded.
- [x] Verilog RTL and testbench uploaded.
- [x] Simulation results and test cases documented.
- [ ] FPGA implementation and hardware evidence uploaded. *(Update Section 9 if physical board testing is completed)*
- [x] Results, challenges and conclusion documented.
- [x] Presentation and final report uploaded.
- [ ] STATUS.md is up to date.
- [ ] Final Pull Request created and URL recorded.