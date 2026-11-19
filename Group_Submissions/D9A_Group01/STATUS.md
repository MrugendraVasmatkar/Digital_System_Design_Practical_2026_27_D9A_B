# Group Progress Status

## 1. Group Details

| Item | Details |
|---|---|
| Class | D9A |
| Group ID | D9A_Group01 |
| Project Title | Gray Code Transition Detector (4-bit), modification H1: N-bit detector with Moore FSM and datapath |
| Group Leader | Ojas Karmarkar (D9A, Roll 27) |
| Member 2 | Aaditya Suhanda (D9A, Roll 55) |
| Member 3 | Vedant Sujit Gaikwad (D9B, Roll 10) |
| Member 4 | Soham Sandeep Kundargi (D9B, Roll 28) |
| Repository | https://github.com/ojaskarmarkar15/DSD-2026-D9A-Group01 |
| Last Updated | 2026-11-19, 15:40 |

## 2. Problem Statement

Design a circuit that outputs 1 only when two consecutive 4-bit inputs differ by exactly one bit (a valid Gray code transition). Selected modification **H1**: generalise the design to an N-bit input (N ≥ 4) using `D = X ⊕ P` and `V = (ΣDᵢ) · ¬(Σ_{i<j} DᵢDⱼ)`.

### Operating assumptions
- After reset, current register X and previous register P are all zeros.
- `START` (rising edge) loads the switches into X and the old X into P; a held button is one sample.
- `ACK` returns the FSM to IDLE and has priority over `START`; `RESET` is synchronous and active-high.
- VALID LED = exactly one bit changed; INVALID LED = zero or more than one bit changed; IDLE = both LEDs off.

## 3. Functional Inputs and Outputs

| Signal | Direction | Description |
|---|---|---|
| `clk` | Input | System clock |
| `rst` | Input | Synchronous, active-high reset |
| `start` | Input | Load sample (rising edge) |
| `ack` | Input | Return to IDLE |
| `data_in[N-1:0]` | Input | Input switches |
| `valid_led` | Output | Exactly one bit changed |
| `invalid_led` | Output | Zero or >1 bit changed |
| `idle_led`, `state_out[1:0]`, `curr_out`, `prev_out`, `v_out` | Output | Indicator/debug outputs |

## 4. Proposed FSM Architecture

Two blocks: a **datapath** (input register X, previous register P, XOR array, one-bit-change detector) and a **Moore FSM controller**.

| State | Encoding | Function |
|---|---|---|
| `IDLE` | 00 | Both LEDs off; waiting for a sample |
| `VALID` | 01 | VALID LED on (one-bit change detected) |
| `INVALID` | 10 | INVALID LED on (zero or >1 bits changed) |

Sequence: `START` → X, P registers load → next clock V is evaluated → `IDLE → VALID` if V = 1, `IDLE → INVALID` if V = 0; `ACK` or `RESET` → `IDLE`.

**Timing note:** X and P are registered on the load edge and V is evaluated one clock later (`eval` flag), so the FSM never compares stale register values.

## 5. Project Stage-wise Progress

| Stage | Task / Deliverable | Status | Evidence / Repository Path |
|---|---|---|---|
| 1 — Design | Understand and document the problem statement | Completed | `01_Problem_Analysis/README.md` |
| 1 — Design | Identify inputs, outputs, and operating conditions | Completed | `01_Problem_Analysis/README.md` |
| 1 — Design | Draw FSM state diagram and state table | In Progress | State table in `README.md` §5; diagram image pending |
| 1 — Design | Draw datapath block diagram and define control signals | Completed | `01_Problem_Analysis/block_diagram.png` |
| 1 — Design | Build and test the architecture in Logisim | In Progress | `02_FSM_Logisim/H1_NBit_Gray_Detector_N5.circ` |
| 2 — Verilog | Write synthesizable FSM controller and datapath RTL | In Progress | `03_Verilog_Implementation/RTL/gray_code_nbit.v` (compiled, simulated and implemented in Vivado 2018.3) |
| 2 — Verilog | Top module for FPGA | Completed | `gray_code_nbit` (N = 4) is the top module |
| 2 — Verilog | Create testbench and run functional simulation | In Progress | `03_Verilog_Implementation/Testbench/gray_code_nbit_tb.v` (run in Vivado 2018.3: 11 of 12 steps pass; one wrong expected value to fix) |
| 2 — Verilog | Save waveforms and simulation results | In Progress | `03_Verilog_Implementation/Simulation_Results/gray_code_nbit_tb_waveform.png` (Tcl console log still to be added) |
| 3 — FPGA | Assign FPGA pins and configure constraints | Completed | `04_FPGA_Hardware/gray_code_nbit.xdc` (pins to be checked against the board) |
| 3 — FPGA | Synthesize, implement, and generate bitstream | Completed | `04_FPGA_Hardware/` (schematic, implemented-design, utilisation and timing-summary screenshots; timing is unconstrained – no clock constraint yet) |
| 3 — FPGA | Demonstrate the design on FPGA hardware | Not Started | `04_FPGA_Hardware/` |
| 3 — Results | Record observations and verify expected behaviour | Not Started | `05_Results/` |
| 3 — Presentation | Prepare slides and final demonstration | Not Started | `06_Presentation/` |
| 3 — Submission | Complete final report and checklist | Not Started | `07_Final_Report/` |

## 6. Functional Test Plan

To be run in Logisim and in the Verilog testbench. Actual results are entered only after the tests are run.

| Test No. | Input / Action | Expected Result | Actual Result | Status |
|---:|---|---|---|---|
| 1 | Reset | FSM in `IDLE`; X = P = 0; both LEDs off | Pending | Not Tested |
| 2 | Sample 0001 (after reset) | D = 0001, V = 1, VALID LED on | VALID (waveform) | Pass |
| 3 | Samples 0011, 0111, 0101, 1101, 1100 in turn | V = 1 each time, VALID LED on | VALID each time (waveform) | Pass |
| 4 | Sample 1111 after 1100 | D = 0011, V = 0, INVALID LED on | INVALID (waveform); testbench expects VALID, so it reports a FAIL | DUT matches the sheet; testbench expectation to fix |
| 5 | Same value twice | D = 0000, INVALID | INVALID (waveform) | Pass |
| 6 | START while in VALID or INVALID | Ignored until ACK returns the FSM to IDLE | Pending | Not Tested |
| 7 | ACK | Return to `IDLE` | Pending | Not Tested |
| 8 | RESET in any state | FSM in IDLE; P = 0 | Pending | Not Tested |
| 9 | N = 5 sequence 00010, 10010, 10111 | VALID, VALID, INVALID | VALID, VALID, INVALID (waveform) | Pass |

## 7. Milestone Status

Use: `Not Started`, `In Progress`, `Completed` or `Blocked`.

| No. | Milestone | Status | Evidence path/link | Last updated |
|---:|---|---|---|---|
| 1 | Problem requirements and assumptions documented | Completed | `01_Problem_Analysis/README.md` | 19/11/2026 15:40 |
| 2 | Architecture and block diagram prepared | Completed | `01_Problem_Analysis/block_diagram.png` | 19/11/2026 23:34 |
| 3 | FSM diagram/table completed, if applicable | In Progress | `README.md` §5 (table done; diagram image pending) | 19/11/2026 15:40 |
| 4 | Logisim circuit implemented | Completed | `02_FSM_Logisim/H1_NBit_Gray_Detector_N5.circ` | 19/11/2026 03:30 |
| 5 | Logisim simulation verified | In Progress | `02_FSM_Logisim/H1_N5_test_vector.txt` (31/31 pass, headless) | 19/11/2026 03:30 |
| 6 | Verilog RTL completed | Completed | `03_Verilog_Implementation/RTL/` (compiled, simulated and implemented in Vivado 2018.3) | 19/11/2026 20:15 |
| 7 | Testbench and simulation completed | In Progress | `03_Verilog_Implementation/Testbench/` (simulated: 11 of 12 steps pass; fix one expected value and re-run) | 19/11/2026 20:15 |
| 8 | FPGA synthesis and implementation completed | Completed | `04_FPGA_Hardware/` (bitstream generated; screenshots) | 19/11/2026 20:15 |
| 9 | Hardware demonstration completed | Not Started | - | - |
| 10 | Results, presentation and report uploaded | Not Started | - | - |
| 11 | Final Pull Request created | Not Started | - | - |

## 8. Time-wise Progress Log
Update at least once every two hours and at each major milestone. Record actual work and actual times; do not pre-fill future updates.

| Date | Actual time | Work completed | Evidence path | Blocker | Next action | Updated by |
|---|---|---|---|---|---|---|
| 19/11/2026 | 02:13 | Forked faculty repo to leader's account, renamed fork to `DSD-2026-D9A-Group01`, cloned locally, created group folder `Group_Submissions/D9A_Group01/` from `Group_Template/`, filled team details in `STATUS.md` | `Group_Submissions/D9A_Group01/` | Problem statement not yet assigned; collaborators not yet added | Add the three teammates as collaborators; read assigned problem statement in `Problem_Statements/` | Ojas Karmarkar |
| 19/11/2026 | 02:30 | Filled team names, roll numbers and repository URL in the group `README.md` (teammates' GitHub usernames still pending) | `Group_Submissions/D9A_Group01/README.md` | Teammates' GitHub usernames not yet available | Collect usernames and add collaborators | Ojas Karmarkar |
| 19/11/2026 | 03:30 | Built H1 (N=5) Gray code transition detector in Logisim: 5-bit registers, bitwise XOR, pairwise AND/OR detector, Moore FSM. Simulated with Logisim test vector: 31/31 steps pass (5 required tests + reset + SAMPLE gating) | `02_FSM_Logisim/H1_NBit_Gray_Detector_N5.circ`, `H1_N5_test_vector.txt` | None | Verify by hand in Logisim GUI; start Verilog (Stage 2) | Ojas Karmarkar |
| 19/11/2026 | 15:40 | Problem statement (Gray Code Transition Detector, H1) documented; wrote parameterised N-bit Verilog RTL (datapath + Moore FSM), self-checking testbench (N=4 and N=8), Arty S7-50 top level and XDC; filled group README sections | `01_Problem_Analysis/`, `03_Verilog_Implementation/`, `04_FPGA_Hardware/` | No simulator run yet; XDC pins not yet checked against Digilent master file | Run testbench in Vivado and save log/waveforms; verify pins; synthesize | Ojas Karmarkar |
| 19/11/2026 | 20:00 | Replaced the earlier RTL, testbench and constraints with the team's `gray_code_nbit` design (single module, N-bit one-bit-change detector + Moore FSM), `gray_code_nbit_tb.v` (N=4 and N=5) and `gray_code_nbit.xdc`; updated READMEs; added FSM diagram, state table and Logisim screenshots in `02_FSM_Logisim/` | `02_FSM_Logisim/`, `03_Verilog_Implementation/`, `04_FPGA_Hardware/` | Testbench not run yet; one testbench expectation (1100 -> 1111) looks wrong | Run testbench in Vivado, fix expectation, save log/waveforms | Ojas Karmarkar |
| 19/11/2026 | 20:15 | Ran behavioural simulation in Vivado 2018.3 (11 of 12 steps pass; the single fail is a wrong expected value for 1100 -> 1111 in the testbench), ran synthesis, implementation and bitstream generation for xc7s50csga324-1; uploaded waveform, schematic and implemented-design screenshots | `03_Verilog_Implementation/Simulation_Results/`, `04_FPGA_Hardware/` | Testbench expected value to fix; hardware demo not done | Fix testbench and re-run; add Tcl log and utilisation/timing numbers; program the board and record the demo | Ojas Karmarkar |
| 19/11/2026 | 20:30 | Uploaded Vivado utilisation and timing-summary screenshots: 8 LUTs, 7 registers, 3 slices, 10 IOBs of xc7s50csga324-1; timing summary is NA because no clock constraint is defined | `04_FPGA_Hardware/vivado_utilization.png`, `04_FPGA_Hardware/vivado_timing_summary.png` | No `create_clock` in the XDC | Add the clock constraint, re-run implementation, record slack | Ojas Karmarkar |
| 19/11/2026 | 23:34 | Added the architecture / block diagram image and linked it in the group README and problem analysis | `01_Problem_Analysis/block_diagram.png` | None | Fix testbench expected value and re-run; add Logisim step table; hardware demo | Ojas Karmarkar |

Add rows as needed.

## 9. Individual Contributions

| Member | Assigned Responsibility | Work Actually Completed | Evidence / Commit Link |
|---|---|---|---|
| Ojas Karmarkar (leader) | Repository management, Logisim, documentation | H1 (N=5) Logisim circuit and test vector; problem analysis; Verilog RTL, testbench and FPGA files committed | Repository commit history |
| Aaditya Suhanda | To be assigned | To be updated | - |
| Vedant Sujit Gaikwad | To be assigned | To be updated | - |
| Soham Sandeep Kundargi | To be assigned | To be updated | - |

All members must understand the complete design and be prepared to explain the FSM, datapath, Verilog code, simulation, and hardware demonstration during the oral examination.

## 10. Faculty Review Checkpoints

| Review | Planned Time | Items to Demonstrate | Faculty Remarks / Action Items |
|---|---|---|---|
| Review 1 | 19 October 2026 — Afternoon | Problem understanding, FSM architecture, datapath, Logisim progress, GitHub updates | To be filled by faculty |
| Review 2 | 20 October 2026 — Morning | Verilog implementation, simulation evidence, FPGA progress, individual understanding | To be filled by faculty |

## 11. Current Blockers and Support Required
| Blocker | Impact | Action being taken | Faculty support required |
|---|---|---|---|
| Teammates not yet added as GitHub collaborators (usernames needed) | Teammates cannot push with their own accounts | Collecting GitHub usernames from the three members | None at present |
| Testbench has one wrong expected value (1100 -> 1111) | Result shows 11 pass, 1 fail although the DUT is correct | Correct the expected value, re-run and save the Tcl log | None at present |

## 12. Current Issues and Action Plan

| Issue / Pending Work | Planned Corrective Action | Responsible Member | Target Completion |
|---|---|---|---|
| Verify pin assignments and board; add clock constraint | Compare `gray_code_nbit.xdc` with the board's master XDC (clock F14); add `create_clock -period 10.000 [get_ports clk]` and re-run implementation (timing summary currently NA) | Group leader | To be set |
| Fix testbench expectation | `gray_code_nbit_tb.v` expects VALID for 1100 -> 1111, but it is a two-bit change (V = 0 on the sheet); correct to INVALID and re-run | To be assigned | To be set |
| Run testbench and record results | Vivado simulation, save log and waveforms in `Simulation_Results/` | To be assigned | To be set |
| Add block diagram and FSM diagram images | Draw from the problem sheet and add to `README.md` | To be assigned | To be set |
| Match Logisim (N=5) and Verilog behaviour | Check first-sample and START/ACK handling are the same in both | To be assigned | To be set |

## 13. Current Overall Status

- **Current stage:** Stage 3 — FPGA implementation done (bitstream generated); hardware demonstration pending
- **Completed:** Problem analysis, Logisim circuit, Verilog RTL, Vivado simulation (11 of 12 steps pass), synthesis, implementation and bitstream generation
- **In progress:** Testbench fix and re-run, Tcl log, utilisation and timing numbers, diagrams
- **Pending:** Hardware demonstration, results, presentation, report, final Pull Request
- **Main risk:** Hardware behaviour not yet verified on the board (clock pin, buttons without debouncing)
- **Next immediate task:** Run the testbench in Vivado and save the log and waveforms

## 14. End-of-day Summary
### 19 October 2026
- Completed:
- In progress:
- Pending:
- Evidence uploaded:
- Plan for 20 October:

### 20 October 2026
- Completed:
- Pending:
- Evidence uploaded:
- Final submission status:

## 15. Group Leader Confirmation
I confirm that this status reflects the work completed by the group and that the linked evidence has been uploaded.

**Group leader:** Ojas Karmarkar  
**Date/time:** [Actual date and time]

> **Student declaration:** The information in this status report represents the work completed by our group as of the stated update time. We will keep the repository updated and ensure that all submitted diagrams, code, simulations, and results are our group's own work.
