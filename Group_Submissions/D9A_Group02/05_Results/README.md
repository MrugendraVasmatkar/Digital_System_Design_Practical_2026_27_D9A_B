# 05 – Results

Upload test-case tables, expected-versus-observed comparisons, accuracy/correctness analysis, known limitations and conclusions here.
## 1. Simulation Summary
* **Simulator:** Xilinx Vivado XSim (`tb_gaming_xp_decoder_behav`)
* **Time Resolution:** `1 ps`
* **Total Simulation Time:** `490 ns` (`$finish` called at `490 ns`)
* **CPU / Elapsed Time:** `5 s` CPU / `10 s` elapsed
* **Overall Result:** **16 / 16 XP Test Cases PASSED (100%)**

---

## 2. Test-Case Table (Expected vs. Observed)

**LED Bus Mapping:** `leds[3:0] = {led_m, led_e, led_i, led_b}`

| Test Case | Control Signal | XP Input (Dec) | XP Input (Hex) | Expected State | Expected `exp[3:0]` (Bin / Hex) | Observed `leds[3:0]` (Bin / Hex) | Status |
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
| Acknowledge | `ack = 1` (after each XP) | `0–15` | `0–f` | `IDLE (000)` | `0000` (`0`) | `0000` (`0`) | **PASS** |

---

## 3. Simulation Evidence

### Vivado Tcl Console Output
![Tcl Console Output](Group_Submissions/D9A_Group02/05_Results/tcl console result.png)

### Behavioral Simulation Waveform
![Behavioral Simulation Waveform](Group_Submissions/D9A_Group02/05_Results/waveform screenshot.png)

---

## 4. Accuracy & Correctness Analysis
* **100% Verification Coverage:** Every 4-bit input from `0` to `f` (`0–15`) produced the exact expected one-hot LED output (`1`, `2`, `4`, `8`) in both the waveform and the self-checking Tcl Console log.
* **Clean Range Boundaries:** Transitions between levels occurred accurately at `3 → 4` (`led_b` to `led_i`), `7 → 8` (`led_i` to `led_e`), and `b → c` (`led_e` to `led_m`) with no overlapping LEDs.
* **Control Signal Verification:**
  * `reset = 1` during `0–10 ns` initialized the FSM to `IDLE` with `leds[3:0] = 0`.
  * Pulsing `start` latched the decoded level and activated the corresponding LED.
  * Pulsing `ack` after each test cleanly returned `leds[3:0]` to `0` (`IDLE`) before the next XP value was evaluated.

---
