# 05 – Results

# 05 – Results and Analysis

## 1. Simulation Overview
* **Simulator:** Xilinx Vivado v2018.3 XSim (`tb_gaming_xp_decoder_behav`)
* **Time Precision:** `1 ps`
* **Total Run Time:** `490 ns` (`$finish` reached at `490 ns`)
* **Execution Time:** `5 s` CPU / `10 s` elapsed
* **Final Verdict:** **16 / 16 XP combinations PASSED (100% pass rate, 0 failures)**

---

## 2. Expected vs. Observed Test-Case Table

**Output Bus Order:** `leds[3:0] = {led_m, led_e, led_i, led_b}`

| Test ID | Control Condition | XP Input (Dec) | XP Input (Hex) | Expected State | Expected `exp[3:0]` (Bin / Hex) | Observed `leds[3:0]` (Bin / Hex) | Result |
| :--- | :--- | :---: | :---: | :--- | :---: | :---: | :---: |
| Reset | `reset = 1` (`0–10 ns`) | `0` | `0` | `IDLE (000)` | `0000` (`0`) | `0000` (`0`) | **PASS** |
| TC01 | `start = 1` | `0` | `0` | `BEGINNER (001)` | `0001` (`1`) | `0001` (`1`) | **PASS** |
| TC02 | `start = 1` | `1` | `1` | `BEGINNER (001)` | `0001` (`1`) | `0001` (`1`) | **PASS** |
| TC03 | `start = 1` | `2` | `2` | `BEGINNER (001)` | `0001` (`1`) | `0001` (`1`) | **PASS** |
| TC04 | `start = 1` | `3` | `3` | `BEGINNER (001)` | `0001` (`1`) | `0001` (`1`) | **PASS** |
| TC05 | `start = 1` | `4` | `4` | `INTERMEDIATE (010)` | `0010` (`2`) | `0010` (`2`) | **PASS** |
| TC06 | `start = 1` | `5` | `5` | `INTERMEDIATE (010)` | `0010` (`2`) | `0010` (`2`) | **PASS** |
| TC07 | `start = 1` | `6` | `6` | `INTERMEDIATE (010)` | `0010` (`2`) | `0010` (`2`) | **PASS** |
| TC08 | `start = 1` | `7` | `7` | `INTERMEDIATE (010)` | `0010` (`2`) | `0010` (`2`) | **PASS** |
| TC09 | `start = 1` | `8` | `8` | `EXPERT (011)` | `0100` (`4`) | `0100` (`4`) | **PASS** |
| TC10 | `start = 1` | `9` | `9` | `EXPERT (011)` | `0100` (`4`) | `0100` (`4`) | **PASS** |
| TC11 | `start = 1` | `10` | `a` | `EXPERT (011)` | `0100` (`4`) | `0100` (`4`) | **PASS** |
| TC12 | `start = 1` | `11` | `b` | `EXPERT (011)` | `0100` (`4`) | `0100` (`4`) | **PASS** |
| TC13 | `start = 1` | `12` | `c` | `MASTER (100)` | `1000` (`8`) | `1000` (`8`) | **PASS** |
| TC14 | `start = 1` | `13` | `d` | `MASTER (100)` | `1000` (`8`) | `1000` (`8`) | **PASS** |
| TC15 | `start = 1` | `14` | `e` | `MASTER (100)` | `1000` (`8`) | `1000` (`8`) | **PASS** |
| TC16 | `start = 1` | `15` | `f` | `MASTER (100)` | `1000` (`8`) | `1000` (`8`) | **PASS** |
| Ack | `ack = 1` (after each XP) | `0–15` | `0–f` | `IDLE (000)` | `0000` (`0`) | `0000` (`0`) | **PASS** |

---

## 3. Simulation Evidence

### Vivado Tcl Console Output
![Tcl Console Output](<tcl console result.png>)

### Behavioral Simulation Waveform
![Behavioral Simulation Waveform](<waveform screenshot.png>)

---

## 4. Accuracy and Correctness Analysis
* **Full Input Coverage:** All 16 possible 4-bit inputs (`0` through `15`) were tested automatically by the self-checking testbench. Every single case matched its expected one-hot LED pattern (`0001`, `0010`, `0100`, or `1000`) with zero mismatches.
* **Exact Boundary Switching:** Level transitions happened cleanly at all three boundary points—`3 → 4` (`Beginner` to `Intermediate`), `7 → 8` (`Intermediate` to `Expert`), and `11 → 12` (`Expert` to `Master`). At no point did two LEDs turn on together or leave a gap between ranges.
* **Synchronous Control Behaviour:**
  * Holding `reset = 1` from `0–10 ns` forced the FSM into `IDLE` with all LEDs off (`0000`).
  * Asserting `start = 1` latched the XP value and switched on only the corresponding level LED.
  * Asserting `ack = 1` after each check cleared the active LED and returned the FSM to `IDLE` cleanly before the next input cycle.
* **Cross-Stage Consistency:** The Verilog simulation results matched our Logisim v2.7.1 circuit tests and synthesized cleanly for the RealDigital Boolean Board (Spartan-7 `xc7s50csga324-1`) with 0 errors and a compact footprint of 24 cells (6 LUTs and 7 flip-flops).

---

## 5. Known Limitations
* **Fixed 4-Bit Input Width:** The decoder is built around a 4-bit unsigned bus (`xp_in[3:0]`), so it only supports XP values from `0` to `15`. Handling larger XP scores would require widening the input register and comparators.
* **Fixed Level Thresholds:** The four level boundaries (`0–3`, `4–7`, `8–11`, `12–15`) are hardcoded into the combinational logic and cannot be changed dynamically at runtime.
* **No Hardware Pushbutton Debouncing:** Behavioral simulation uses clean, ideal pulses for `reset`, `start`, and `ack`. For reliable manual button presses on a physical FPGA board, simple debouncer circuits should be added (or continuous switch-tracking mode used for live demos).

---

## 6. Conclusion
The 4-level Gaming XP Decoder (Modification H1) met all functional and verification goals. Exhaustive simulation in Vivado XSim confirmed 100% accuracy across all 16 XP values, boundary transitions, and synchronous control signals (`reset`, `start`, and `ack`). Together with the Logisim gate-level verification and error-free Spartan-7 FPGA synthesis and implementation, the results confirm that the design is reliable, lightweight, and ready for hardware demonstration.
