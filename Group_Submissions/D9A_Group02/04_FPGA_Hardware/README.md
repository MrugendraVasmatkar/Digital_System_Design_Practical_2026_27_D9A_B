# 04 – FPGA Hardware

Record FPGA board/device, tool/version, constraints, synthesis/implementation reports, programming details, hardware test cases and demonstration evidence here.

# 04 – FPGA Hardware

## 1. Device & Tool Details
* **Target FPGA Device:** Xilinx Spartan-7 (`xc7s50csga324-1`)
* **EDA Tool / Version:** Xilinx Vivado v2018.3 (64-bit)
* **Top Module:** `gaming_xp_decoder`
* **Constraint File:** `` (100 MHz clock constraint, 10 ns period; 4 switches for `xp_in[3:0]`, 3 pushbuttons for `reset`/`start`/`ack`, and 4 LEDs for level outputs)

---

## 2. Synthesis Summary (`synth_1`)
* **Status:** Completed successfully (**0 Errors, 0 Critical Warnings, 0 Warnings**)
* **Runtime:** `9 s` elapsed (`7 s` CPU)
* **FSM Optimization:** Vivado inferred the 5-state FSM (`state_reg`) and automatically re-encoded it from 3-bit binary (`000`–`100`) to **5-bit one-hot** (`00001`–`10000`) for faster FPGA state decoding.
* **Netlist Check:** Passed (`0` multi-driven nets).

### Resource Utilization (Post-Synthesis)
| Primitive / Cell | Count | Purpose |
| :--- | :---: | :--- |
| `LUT3` | 5 | Combinational range decoder & next-state logic |
| `LUT4` | 1 | Combinational logic |
| `FDRE` | 7 | Flip-flops (`xp_reg` + FSM state registers) |
| `BUFG` | 1 | Global clock buffer |
| `IBUF` | 6 | Input buffers |
| `OBUF` | 4 | Output buffers (`led_beginner` to `led_master`) |
| **Total Cells** | **24** | — |
Group_Submissions/D9A_Group02/03_Verilog_Implementation/LUT ss.png
---

## 3. Implementation Summary (`impl_1`)
* **Stages Completed:** `opt_design`, `place_design`, and `route_design` all completed with **0 Errors** and **0 Critical Warnings**.
* **Routing Status:**
  * **Failed Nets:** `0`
  * **Unrouted Nets:** `0`
  * **Partially Routed Nets:** `0`
  * **Node Overlaps:** `0`
  * **Global Vertical Routing Utilization:** `0.00199%`
  * **Global Horizontal Routing Utilization:** `0.00260%`
  * **Congestion:** None (0 congested regions).

---

## 4. Programming & Hardware Test Status
We have added Constraint file and implementation. Actual FPGA testing is pending.
