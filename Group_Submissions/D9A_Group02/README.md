# Digital System Design – Group Project

> Complete every mandatory section. Do not delete headings. Replace bracketed prompts. If a section is not applicable, explain why.

## 1. Team Details
| Role | Student name | Roll number | GitHub username |
|---|---|---|---|
| Group leader | Vasudha Saxena | 52 | star388 |
| Member 2 | Tanisha Dembla | 8 | tanishadembla88-commits |
| Member 3 | Prakhar Srivastava | 62 | prakharsrivastavwork-ship-it |
| Member 4 | Hadi Ansari | 1 | hadiansari25 |

**Class:** D9A/D9B
**Group ID:** D9A_Group02  
**Repository URL:** https://github.com/star388/DSD-2026-D9A-Group02  
**Final Pull Request URL:** [URL]

## 2. Assigned Problem Statement
- **Number/title:** 8
- **Problem summary:** In my problem I has to Add a master level to my existing 3 level Gaming XP System, this required me to change the combinational logic of my circuit and also changes the XP Range assumed earlier.
- **Objective:** The system should be able to correctly identify which level a player belongs to depending on their XP(categorizing them into four levels).
- **Inputs and outputs:**
-   * `clk` (1-bit, Input): System clock (positive-edge triggered).
    * `reset` (1-bit, Input): Synchronous active-high reset; clears input register and returns FSM to `IDLE`.
    * `start` (1-bit, Input): Initiates XP classification from `IDLE`.
    * `ack` (1-bit, Input): Acknowledges the displayed level and returns the FSM to `IDLE`.
    * `xp_in[3:0]` (4-bit, Input): 4-bit unsigned XP value from switches (`X3` to `X0`).
    * `led_beginner` (1-bit, Output): Active-high LED for XP `0–3`.
    * `led_intermediate` (1-bit, Output): Active-high LED for XP `4–7`.
    * `led_expert` (1-bit, Output): Active-high LED for XP `8–11`.
    * `led_master` (1-bit, Output): Active-high LED for XP `12–15`.
* **Constraints and assumptions:**
    * `xp_in[3:0]` is treated as an unsigned binary integer (`0` to `15`).
    * Adding the Master state increases total states to 5 (`IDLE` + 4 levels), requiring a 3-bit state register ($\lceil \log_2 5 \rceil = 3$ flip-flops).
    * Outputs must follow a strict **Moore** architecture (LEDs depend only on the current state, with all LEDs OFF in `IDLE`).
    * `reset`, `start`, and `ack` are synchronous control signals sampled on the rising edge of `clk`.

## 3. Problem Analysis and Proposed Solution
Explain the requirements, edge cases, proposed solution, distinctive features and why the design is feasible.
**Requirement:**
   Read a 4-bit XP input (0 to 15) from switches and hold it in a 4-bit input register.
   Sort the XP value into four ranges:
   Beginner: 0–3 (0000–0011)
   Intermediate: 4–7 (0100–0111)
   Expert: 8–11 (1000–1011)
   Master: 12–15 (1100–1111)
   Use a 5-state Moore FSM (IDLE, BEGINNER, INTERMEDIATE, EXPERT, MASTER) controlled by START, ACK, and RESET.
   Keep all LEDs off in IDLE and turn on only the matching level LED once decoded.
   Build and test the circuit in Logisim, then verify all 16 XP inputs in Vivado using a Verilog testbench.
**Proposed Solution:**
   We have divided into 4 parts as follows:
   Input Register: Stores the 4-bit XP switch value while the FSM is in IDLE. Once START is pressed and the FSM moves on, the value stays locked so flipping          switches later won't change the output.
   Range Decoder (Two Stages): First, Range Decoder 1 checks if the XP is Beginner (0–3), Intermediate (4–7), or greater than 7. If it's greater than 7, Range       Decoder 2 uses that signal along with the 4-bit XP value to check whether it's Expert (8–11) or Master (12–15).
   Moore FSM Controller: Starts in IDLE (000). When START = 1, it moves to BEGINNER (001), INTERMEDIATE (010), EXPERT (011), or MASTER (100) based on the decoder    output. It stays in that state until ACK = 1 brings it back to IDLE
   Output Logic: Simply checks which state the FSM is in and turns on the matching LED (all LEDs stay off in IDLE).
### Distinctive Features
* **Input Locking via 4-Bit Register (`xp_reg`):** The circuit only samples `xp_in[3:0]` while in the `IDLE` state. Once `start` is pressed and a level is decoded, the input is locked so flipping the XP switches afterward will not corrupt the active LED output.
* **Two-Stage Combinational Range Decoder:** Instead of a single bulky comparator, the logic is split into two stages—Range Decoder 1 checks `0–3`, `4–7`, and raises a `greater` flag for `XP > 7`, which Range Decoder 2 uses to separate `8–11` (Expert) from `12–15` (Master). This makes the thresholds easy to read and modify if unequal XP ranges are ever needed.
* **Glitch-Free Moore FSM Architecture:** All four output LEDs depend strictly on the current state (`state[2:0]`), keeping all LEDs OFF in `IDLE` and ensuring only one LED turns ON at a time. Unused 3-bit state encodings (`101`, `110`, `111`) are safely handled by returning to `IDLE` on `ack` or `reset`.
* **Exhaustive Self-Checking Verification:** The Verilog testbench automatically checks all 16 possible 4-bit inputs (`0–15`), boundary transitions (`3 → 4`, `7 → 8`, `11 → 12`), and control signals (`reset`, `start`, `ack`) with automatic `PASS`/`FAIL` reporting.

### Why the Design is Feasible
* **Minimal Hardware Footprint:** The entire design requires only 7 flip-flops (4 for `xp_reg` and 3 for the FSM state) and 6 LUTs—synthesizing to just **24 cells total** on a Xilinx Spartan-7 (`xc7s50csga324-1`) with under 0.01% routing utilization.
* **Clean, Synthesizable RTL:** Written in standard synchronous Verilog with a single clock domain and no inferred latches, the design passed Vivado synthesis and implementation with **0 errors and 0 critical warnings**.
* **100% Verifiable:** Because a 4-bit input has only 16 combinations, the circuit can be exhaustively tested in both Logisim and Vivado (completing simulation in `490 ns` with 16/16 passing cases), leaving zero untested edge cases.
* **Hardware-Ready I/O:** The pin count (8 inputs, 4 outputs) maps directly onto standard FPGA development board switches, pushbuttons, and LEDs without needing external peripherals.

## 4. Architecture

Block Diagram: Group_Submissions/D9A_Group02/01_Problem_Analysis/block diagram.jpeg

### Module Breakdown
1. **4-Bit Input Register (`xp_reg`):** Captures `xp_in[3:0]` on the rising edge of `clk` while the FSM is in `IDLE`, and clears to `0` on synchronous `reset`. Once the FSM leaves `IDLE`, `xp_reg` holds its value so changing the switches later does not corrupt the active output.
2. **Two-Stage Range Decoder (Combinational):**
   * **Range Decoder 1** evaluates `is_beg` (`xp_reg <= 3`), `is_int` (`4 <= xp_reg <= 7`), and asserts a `greater` flag when `xp_reg > 7`.
   * **Range Decoder 2** uses `greater` along with `xp_reg[3:0]` to assert `is_exp` (`8 <= xp_reg <= 11`) or `is_mas` (`xp_reg > 11`).
3. **5-State Moore FSM Controller:** Uses a 3-bit state register (`IDLE = 000`, `BEG = 001`, `INT = 010`, `EXP = 011`, `MAS = 100`). When `start = 1` in `IDLE`, it transitions to the decoded level state and holds it until `ack = 1` or `reset = 1` returns it to `IDLE`.
4. **Moore Output Logic:** Four combinational comparators drive `led_beginner`, `led_intermediate`, `led_expert`, and `led_master` strictly from `state`, ensuring all LEDs remain OFF in `IDLE`.

### Data & Control Flow
* **Data path:** `xp_in[3:0]` → `xp_reg[3:0]` → Range Decoders 1 & 2 → FSM next-state decision.
* **Control path:** `clk`, `reset`, `start`, and `ack` synchronize input capture and state transitions; `state[2:0]` drives the four output LEDs.

### Design Trade-Offs
Because the four XP ranges are equal (`0–3`, `4–7`, `8–11`, `12–15`), decoding only the top two bits (`xp_in[3:2]`) uses fewer gates (as done in our Logisim schematic). In our Verilog RTL, we kept explicit range comparisons (`<= 3`, `4–7`, `8–11`, `> 11`) so the code stays readable and easy to adjust if unequal XP ranges are needed later, while letting Vivado optimize the logic into just 6 LUTs during synthesis.

---

## 5. FSM Design
Yes, the design uses a **5-state Moore FSM** with a 3-bit binary state encoding (`000`–`100`) and synchronous active-high reset (`reset = 1` forces `state <= IDLE` and `xp_reg <= 0`). Outputs depend strictly on the present state.

**Diagram:** Group_Submissions/D9A_Group02/02_FSM_Logisim/fsm state diagram.jpeg
**State table:**

| Present State | Encoding (`Q2 Q1 Q0`) | Input Condition (`reset = 0`) | Next State | Output LEDs (`M E I B`) |
| :--- | :---: | :--- | :--- | :---: |
| **Any State** | `xxx` | `reset = 1` | `IDLE (000)` | `0000` |
| **IDLE** | `000` | `start = 0` | `IDLE (000)` | `0000` |
| **IDLE** | `000` | `start = 1` & `XP <= 3` | `BEGINNER (001)` | `0000` |
| **IDLE** | `000` | `start = 1` & `4 <= XP <= 7` | `INTERMEDIATE (010)` | `0000` |
| **IDLE** | `000` | `start = 1` & `8 <= XP <= 11` | `EXPERT (011)` | `0000` |
| **IDLE** | `000` | `start = 1` & `XP >= 12` | `MASTER (100)` | `0000` |
| **BEGINNER** | `001` | `ack = 0` / `ack = 1` | `BEGINNER` / `IDLE` | `0001` |
| **INTERMEDIATE** | `010` | `ack = 0` / `ack = 1` | `INTERMEDIATE` / `IDLE` | `0010` |
| **EXPERT** | `011` | `ack = 0` / `ack = 1` | `EXPERT` / `IDLE` | `0100` |
| **MASTER** | `100` | `ack = 0` / `ack = 1` | `MASTER` / `IDLE` | `1000` |

---

## 6. Logisim Implementation
- **Logisim version:** Logisim v2.7.1
- **Circuit file:** Group_Submissions/D9A_Group02/02_FSM_Logisim/xplvlfinal_fixed.circ (Main circuit: `gaming_xp_decoder`)
- **Test cases and expected/observed behaviour:**
  - `reset = 1` → `Q2 Q1 Q0 = 000`, all 4 LEDs OFF.
  - `xp_in = 0010` (2), `start = 1` + `clk` → `Q2 Q1 Q0 = 001`, `led_beginner = 1`.
  - `xp_in = 0101` (5), `start = 1` + `clk` → `Q2 Q1 Q0 = 010`, `led_intermediate = 1`.
  - `xp_in = 1010` (10), `start = 1` + `clk` → `Q2 Q1 Q0 = 011`, `led_expert = 1`.
  - `xp_in = 1110` (14), `start = 1` + `clk` → `Q2 Q1 Q0 = 100`, `led_master = 1`.
  - `ack = 1` + `clk` from any active level state → returns to `IDLE (000)` with all LEDs OFF.
- **Screenshot/evidence:** Group_Submissions/D9A_Group02/02_FSM_Logisim/logisim idle state .png, Group_Submissions/D9A_Group02/02_FSM_Logisim/logisim beginner state.png, Group_Submissions/D9A_Group02/02_FSM_Logisim/logisim intermediate state.png, Group_Submissions/D9A_Group02/02_FSM_Logisim/logisim expert state.png, Group_Submissions/D9A_Group02/02_FSM_Logisim/logisim master state.png

---

## 7. Verilog HDL Implementation
- **Tool/version:** Xilinx Vivado v2018.3 (64-bit)
- **Top module and submodules:** Single-file RTL module `gaming_xp_decoder`, verified by testbench `tb_gaming_xp_decoder`.
- **Architecture/coding decisions:** Combined the 4-bit input register (`xp_reg`) and 5-state Moore FSM into a single synchronous `always @(posedge clk)` block using non-blocking assignments (`<=`), with combinational `wire` equations for Range Decoders 1 & 2 and `assign` statements for the four Moore LED outputs.
- **Synthesizability considerations:** Standard synthesizable Verilog with synchronous active-high reset, no inferred latches, explicit `default` case handling, and no simulation-only delays in the RTL.
- **RTL:** Group_Submissions/D9A_Group02/03_Verilog_Implementation/RTL/gaming_xp_decoder.v
- **Testbench:** Group_Submissions/D9A_Group02/03_Verilog_Implementation/Testbench/tb_gaming_xp_decoder.v

---

## 8. Verification and Simulation Results

| Test ID | Inputs/conditions | Expected output (`leds[3:0]` = `{M,E,I,B}`) | Observed output (`leds[3:0]`) | Pass/Fail |
| :--- | :--- | :---: | :---: | :---: |
| T01 | `reset = 1` (`0–10 ns`) | `0000` (`IDLE`) | `0000` | PASS |
| T02 | `xp_in = 0–3` (`0–3`), `start = 1` | `0001` (`BEGINNER`) | `0001` | PASS |
| T03 | `xp_in = 4–7` (`4–7`), `start = 1` | `0010` (`INTERMEDIATE`) | `0010` | PASS |
| T04 | `xp_in = 8–11` (`8–b`), `start = 1` | `0100` (`EXPERT`) | `0100` | PASS |
| T05 | `xp_in = 12–15` (`c–f`), `start = 1` | `1000` (`MASTER`) | `1000` | PASS |
| T06 | `ack = 1` (after each XP test) | `0000` (`IDLE`) | `0000` | PASS |

- **Tool/version:** Xilinx Vivado v2018.3 XSim (`tb_gaming_xp_decoder_behav`, 1 ps resolution, finished at `490 ns`)
- **Number passed/failed:** 16 / 16 XP combinations PASSED, 0 FAILED (100% pass rate)
- **Waveform/log path:** Group_Submissions/D9A_Group02/03_Verilog_Implementation/Simulation_Results/waveform screenshot.png and Group_Submissions/D9A_Group02/03_Verilog_Implementation/Simulation_Results/tcl console result.png

---

## 9. FPGA Hardware Implementation
- **FPGA board/device:** Xilinx Spartan-7 (`xc7s50csga324-1`)
- **Tool/version:** Xilinx Vivado v2018.3 (64-bit)
- **Clock/constraints:** Group_Submissions/D9A_Group02/04_FPGA_Hardware/xp_gaming_constraints.xdc — 100 MHz clock constraint (`10.00 ns` period) on `F14` (`LVCMOS33`), 4 switches for `xp_in[3:0]`, 3 pushbuttons for `reset`/`start`/`ack`, and 4 LEDs for level outputs.
- **Synthesis/implementation summary:**
  - **Synthesis:** Completed with **0 errors, 0 critical warnings, 0 warnings** (`9 s`). Vivado inferred the 5-state FSM and re-encoded it to 5-bit one-hot. Total footprint: **24 cells** (`5 LUT3`, `1 LUT4`, `7 FDRE`, `1 BUFG`, `6 IBUF`, `4 OBUF`).
  - **Implementation:** `opt_design`, `place_design`, and `route_design` completed with **0 errors**, **0 failed/unrouted nets**, **0 overlaps**, and `< 0.01%` routing utilization.
- **Programming and hardware test result:** Synthesis and implementation are complete; physical FPGA board programming/demonstration is pending.
- **Evidence path:** Group_Submissions/D9A_Group02/04_FPGA_Hardware

*Simulation vs. hardware differences:* Behavioral simulation uses ideal instantaneous control pulses, whereas physical FPGA deployment would require pushbutton debouncing for `reset`, `start`, and `ack`.

---

## 10. Challenges, Debugging and Improvements

| Issue | Root cause | Correction | Outcome |
| :--- | :--- | :--- | :--- |

- **Future improvements:** Add hardware pushbutton debouncers for physical FPGA testing, display the current XP value on a 7-segment display, or add level counters (Hint H4) to track how many times each rank is reached.

---

## 11. Task Allocation and Individual Contribution

| Student | Assigned responsibility | Actual contribution/evidence |
| :--- | :--- | :--- |
| Vasudha Saxena (Group leader) | Problem Analysis, Architecture & GitHub Management, Verilog RTL | Group_Submissions/D9A_Group02/01_Problem_Analysis, Group_Submissions/D9A_Group02/STATUS.md, repo organization |
| Tanisha Dembla (Member 2) | FSM Design & Logisim Circuit Implementation | 5-state Moore FSM diagram/table, Group_Submissions/D9A_Group02/02_FSM_Logisim/xplvlfinal_fixed.circ |
| Prakhar Srivastava (Member 3) | Verilog RTL & Self-Checking Testbench | Group_Submissions/D9A_Group02/03_Verilog_Implementation/RTL/gaming_xp_decoder.v, Group_Submissions/D9A_Group02/03_Verilog_Implementation/Testbench/tb_gaming_xp_decoder.v |
| Hadi Ansari (Member 4) | Vivado Simulation, FPGA Synthesis & Results | Group_Submissions/D9A_Group02/04_FPGA_Hardware, Group_Submissions/D9A_Group02/05_Results, waveform & Tcl logs |

*(Adjust the row responsibilities above if your team split the work differently.)* Every student is ready to explain the complete design.

---

## 12. Progress Log
Maintain time-wise updates in `STATUS.md`.

---

## 13. Final Results and Conclusion
We successfully upgraded the 3-level Gaming XP Decoder into a 4-level system (**Beginner** `0–3`, **Intermediate** `4–7`, **Expert** `8–11`, and **Master** `12–15`) controlled by a 5-state Moore FSM. The circuit was verified in Logisim v2.7.1, exhaustively simulated in Vivado v2018.3 with **16/16 XP values passing** in `490 ns`, and synthesized/implemented for the **Xilinx Spartan-7 (`xc7s50csga324-1`)** with **0 errors**, using only **24 cells** (6 LUTs and 7 flip-flops). Limitations include the fixed 4-bit unsigned XP range (`0–15`) and the need for pushbutton debouncers before physical board deployment. Overall, all functional and verification requirements were met, and the design is compact and ready for hardware testing.

---

## 14. Team Reflection
Working through the full flow showed us how a small specification change—adding a fourth Master level—impacts the entire architecture, from comparator ranges to expanding the FSM state register from 2 bits to 3. We also learned how to write self-checking Verilog testbenches and debug real EDA tool issues (disk space limits, Logisim XML toolbars, and FPGA `VREF` pin constraints). Next time, we would set up pin constraints and check tool environments earlier in the workflow.

---

## 15. Final Submission Checklist
- [x] Team details and problem analysis complete.
- [x] Architecture/block diagram included.
- [x] FSM diagram/table or justified alternative included.
- [x] Logisim source and simulation evidence uploaded.
- [x] Verilog RTL and testbench uploaded.
- [x] Simulation results and test cases documented.
- [x] FPGA implementation and hardware evidence uploaded.
- [x] Results, challenges and conclusion documented.
- [x] Presentation and final report uploaded.
- [x] STATUS.md is up to date.
- [x] Final Pull Request created and URL recorded.
