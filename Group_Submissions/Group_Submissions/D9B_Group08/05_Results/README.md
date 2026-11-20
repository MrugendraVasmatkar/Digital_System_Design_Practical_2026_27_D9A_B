# 05 – Results, Verification Analysis & Conclusion

**Group:** D9B-Group08 | **Project:** Forbidden Zone Rejector (4-Bit) with H4 Counters  
**Tools & Platform:** Logisim-evolution v4.1.0 · AMD Xilinx Vivado 2022.2 · RealDigital Boolean Board (`xc7s50csga324-1`, Speed `-1`)

## 1. Verification Evidence Sources

* **Stage 1 (Logisim-evolution v4.1.0):** `02_FSM_Logisim/` & Drive folder ([Logisim_Circuit_Simulation_6H4_Group08.mp4](https://drive.google.com/drive/u/4/folders/11ZAlYLtZIfZqkP7gjBKkoZjrsTbID2Iz)) — full `0`–`15` sweep, `ACK`, and `RESET`.
* **Stage 2 (AMD Xilinx Vivado 2022.2):** `03_Verilog_Implementation/Simulation_Results/` (`tb_forbidden_zone_rejector_h4.v`, behavioral waveform, utilization report, RTL & Technology schematics).
* **Stage 3 (RealDigital Boolean Board):** `04_FPGA_Hardware/` & Drive folder ([Group08_FPGA_Hardware_Demo.mp4](https://drive.google.com/drive/u/4/folders/11ZAlYLtZIfZqkP7gjBKkoZjrsTbID2Iz)) — live `xc7s50csga324-1` demo (`0`–`15` sweep, extra allowed sample `d`, and `BTN2` reset).

## 2. Test-Case Table (Expected vs. Observed Across All 3 Stages)

| Test Case | Input `X[3:0]` | Expected Zone & State | Expected LEDs (`Acc`, `Rej`) | Expected Counts (`Acc`, `Rej`) | Stage 1: Logisim | Stage 2: Vivado Sim | Stage 3: Boolean Board | Verdict |
| :--- | :---: | :--- | :---: | :---: | :---: | :---: | :--- | :---: |
| **Reset** | `RESET = 1` | `IDLE (00)` | `1`, `0` | `0`, `0` | `PASS` (`02:31`, `02:55`: `0`, `0`) | `PASS` (`0`, `0`) | `PASS` (`01:32`: Green ON, `D0=0`, `D1=0`) | **PASS** |
| **0–5** | `0000`–`0101` | Allowed / `IDLE (00)` | `1`, `0` | `1..6`, `0` | `PASS` (`00:12`–`00:51`: `6`, `0`) | `PASS` (`6`, `0`) | `PASS` (`00:00`–`00:26`: Green ON, `D0=6`, `D1=0`) | **PASS** |
| **6** | `0110` | **Forbidden** / `REJECT (01)` | `0`, `1` | `6`, `1` | `PASS` (`00:58`: Red ON, `6`, `1`) | `PASS` (`6`, `1`) | `PASS` (`00:30`: Red ON, `D0=6`, `D1=1`) | **PASS** |
| **ACK** | `ACK = 1` | Return `IDLE (00)` | `1`, `0` | Unchanged | `PASS` (`01:01`, `02:51`: Green ON, unchanged) | `PASS` (after `6, 7, 8, 9`, unchanged) | Not pressed in video (`00:46` exited `REJECT` via allowed input `1010`) | **PASS (Sim/Logisim)** |
| **7–9** | `0111`–`1001` | **Forbidden** / `REJECT (01)` | `0`, `1` | `6`, `2..4` | `PASS` (`01:09`–`01:28`: `6`, `4`) | `PASS` (`6`, `4`) | `PASS` (`00:34`–`00:43`: Red ON, `D0=6`, `D1=4`) | **PASS** |
| **10–15** | `1010`–`1111` | Allowed / `IDLE (00)` | `1`, `0` | `7..12 (C)`, `4` | `PASS` (`01:36`–`02:27`: `C`, `4`) | `PASS` (`c`, `4`) | `PASS` (`00:46`–`01:21`: Green ON, `D0=C`, `D1=4`) | **PASS** |
| **Extra Allowed** | `1111` (repeat) | Allowed / `IDLE (00)` | `1`, `0` | `13 (d)`, `4` | — | — | `PASS` (`01:26`: `D0=d`, `D1=4`, verifying Hex `d`) | **PASS** |

## 3. Accuracy & Correctness Analysis

* **Cross-Stage Functional Match:** All `16` binary inputs (`0000`–`1111`) and `RESET` matched identically across Logisim-evolution, Vivado behavioral simulation (`0` errors at `860 ns`), and the Boolean Board. `ACK` clearing `REJECT` without recounting was verified in Logisim (`01:01`, `02:51`) and Vivado simulation, while the hardware video also showed exiting `REJECT` directly on a new allowed sample (`1010` at `00:46`) and counting past `C` to `d` (`13`) at `01:26`.
* **Boundary Verification:** Transitions at `5` → `6` and `9` → `10` confirmed the minimized combinational detector `Y = X3'X2' + X2X1' + X3X1` (eliminating `X0`).
* **Vivado Implementation & Timing (`xc7s50csga324-1`, Speed `-1`):**
  * **Core RTL (`forbidden_zone_rejector_h4`):** `17` `FDRE` flip-flops (`0.03%`), `9` LUTs (`0.03%`), `10` `SLICEL` (`0.12%`), `1` `BUFG`, `0` latches (detector + FSM next-state packed into one `LUT6`).
  * **Full Boolean Board Top (`boolean_top_h4` with 10 ms debouncers + dual 7-segment decoders):** `34` LUTs, `62` FFs, `0` BRAM, `0` DSP, **`WNS = +5.209 ns`**, **`WHS = +0.216 ns`**, **`0` failed routes**, **`0.083 W`** total on-chip power.
* **Hardware Readout Check:** Physical `BTN0` presses incremented counts by `1` with zero bounce double-counts, and binary LEDs (`LD5..LD2`, `LD9..LD6`) matched Hex displays (`D0`, `D1`) bit for bit.

## 4. Known Limitations

* **4-Bit Counter Rollover:** `Accept_Count` and `Reject_Count` are 4-bit (`0`–`F`), wrapping to `0` after `15` samples (adjustable via `COUNT_WIDTH`).
* **Fixed Forbidden Zone (`6`–`9`):** Hardwired via K-map minimization rather than runtime-configurable bounds `[L, H]`.
* **20 ns Internal Pipeline Window:** Asserting `ACK` within `20 ns` (`2` cycles at `100 MHz`) of `START` under an automated high-speed driver could race with `count_pulse` (not reachable by manual pushbutton operation).
* **Logisim Asynchronous Reset:** Logisim's built-in flip-flop `R` pin is asynchronous, whereas Stage 2/3 Verilog enforces strict synchronous active-high reset (`always @(posedge clk) if (reset)`).

## 5. Conclusion & Possible Improvements

### Conclusion
The 4-bit Forbidden Zone Rejector (rejecting `6`–`9`) with Modification H4 (4-bit `Accept_Count` and `Reject_Count`) worked as expected across all three stages: Logisim-evolution (`0`–`15`, `ACK`, and `RESET`), Vivado 2022.2 behavioral simulation (`0` errors at `860 ns`), and live testing on the RealDigital Boolean Board (`xc7s50csga324-1`, `34` LUTs, `62` FFs, `WNS = +5.209 ns`, `0.083 W`). Using dedicated Clock Enable (`CE`) pins instead of gated clocks and adding `10 ms` debouncers kept the hardware counts accurate on physical button presses.

### Possible Improvements
* **Prevent rollover past 15:** Increase `COUNT_WIDTH` (or add a saturation/overflow flag) so counts do not wrap around to `0` after `15` samples.
* **Configurable range:** Replace the fixed `6`–`9` K-map gates with comparator-based bounds `[L, H]` if the forbidden zone needs to be changed without re-synthesizing.
* **Remove the 20 ns `START`/`ACK` window:** If this module is ever driven by a fast digital controller instead of manual buttons, fold `D1`/`D2` into explicit FSM states so `ACK` cannot overlap with an in-flight `count_pulse`.
