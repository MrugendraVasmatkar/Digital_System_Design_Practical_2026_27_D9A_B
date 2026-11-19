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
| 1 — Design | Draw datapath block diagram and define control signals | In Progress | Described in `README.md` §4; diagram image pending |
| 1 — Design | Build and test the architecture in Logisim | In Progress | `02_FSM_Logisim/H1_NBit_Gray_Detector_N5.circ` |
| 2 — Verilog | Write synthesizable FSM controller and datapath RTL | In Progress | `03_Verilog_Implementation/RTL/gray_code_detector.v` (written; not yet compiled in Vivado) |
| 2 — Verilog | Integrate at top level for FPGA | In Progress | `03_Verilog_Implementation/RTL/gray_code_top_arty_s7.v` |
| 2 — Verilog | Create testbench and run functional simulation | In Progress | `03_Verilog_Implementation/Testbench/tb_gray_code_detector.v` (written; not yet run) |
| 2 — Verilog | Save waveforms and simulation results | Not Started | `03_Verilog_Implementation/Simulation_Results/` |
| 3 — FPGA | Assign FPGA pins and configure constraints | In Progress | `04_FPGA_Hardware/arty_s7_50_gray_code.xdc` (to be checked against the Digilent master XDC) |
| 3 — FPGA | Synthesize, implement, and generate bitstream | Not Started | `04_FPGA_Hardware/` |
| 3 — FPGA | Demonstrate the design on FPGA hardware | Not Started | `04_FPGA_Hardware/` |
| 3 — Results | Record observations and verify expected behaviour | Not Started | `05_Results/` |
| 3 — Presentation | Prepare slides and final demonstration | Not Started | `06_Presentation/` |
| 3 — Submission | Complete final report and checklist | Not Started | `07_Final_Report/` |

## 6. Functional Test Plan

To be run in Logisim and in the Verilog testbench. Actual results are entered only after the tests are run.

| Test No. | Input / Action | Expected Result | Actual Result | Status |
|---:|---|---|---|---|
| 1 | Reset | FSM in `IDLE`; X = P = 0; both LEDs off | Pending | Not Tested |
| 2 | Sample 0001 (after reset) | D = 0001, V = 1, VALID LED on | Pending | Not Tested |
| 3 | Samples 0011, 0111, 0101, 1101, 1100 in turn | V = 1 each time, VALID LED on | Pending | Not Tested |
| 4 | Sample 1111 after 1100 | D = 0011, V = 0, INVALID LED on | Pending | Not Tested |
| 5 | Same value twice | D = 0000, INVALID | Pending | Not Tested |
| 6 | Press and hold START for several clocks | Only one sample is taken | Pending | Not Tested |
| 7 | ACK | Return to `IDLE` | Pending | Not Tested |
| 8 | ACK and START together | ACK wins; sample ignored | Pending | Not Tested |
| 9 | 300 random samples (N = 4 and N = 8) | Match reference model | Pending | Not Tested |

## 7. Milestone Status

Use: `Not Started`, `In Progress`, `Completed` or `Blocked`.

| No. | Milestone | Status | Evidence path/link | Last updated |
|---:|---|---|---|---|
| 1 | Problem requirements and assumptions documented | Completed | `01_Problem_Analysis/README.md` | 19/11/2026 15:40 |
| 2 | Architecture and block diagram prepared | In Progress | `README.md` §4 (text; diagram image pending) | 19/11/2026 15:40 |
| 3 | FSM diagram/table completed, if applicable | In Progress | `README.md` §5 (table done; diagram image pending) | 19/11/2026 15:40 |
| 4 | Logisim circuit implemented | Completed | `02_FSM_Logisim/H1_NBit_Gray_Detector_N5.circ` | 19/11/2026 03:30 |
| 5 | Logisim simulation verified | In Progress | `02_FSM_Logisim/H1_N5_test_vector.txt` (31/31 pass, headless) | 19/11/2026 03:30 |
| 6 | Verilog RTL completed | In Progress | `03_Verilog_Implementation/RTL/` (written; not yet compiled) | 19/11/2026 15:40 |
| 7 | Testbench and simulation completed | In Progress | `03_Verilog_Implementation/Testbench/` (written; not yet run) | 19/11/2026 15:40 |
| 8 | FPGA synthesis and implementation completed | Not Started | Constraints in `04_FPGA_Hardware/` | 19/11/2026 15:40 |
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
| Testbench not yet run in a simulator | No simulation evidence yet | Run in Vivado and save log/waveforms | None at present |

## 12. Current Issues and Action Plan

| Issue / Pending Work | Planned Corrective Action | Responsible Member | Target Completion |
|---|---|---|---|
| Verify Arty S7-50 pin assignments | Compare `arty_s7_50_gray_code.xdc` with Digilent's master XDC | Group leader | To be set |
| Run testbench and record results | Vivado simulation, save log and waveforms in `Simulation_Results/` | To be assigned | To be set |
| Add block diagram and FSM diagram images | Draw from the problem sheet and add to `README.md` | To be assigned | To be set |
| Match Logisim (N=5) and Verilog behaviour | Check first-sample and START/ACK handling are the same in both | To be assigned | To be set |

## 13. Current Overall Status

- **Current stage:** Stage 2 — Verilog implementation (Logisim done, Verilog written)
- **Completed:** Problem analysis, Logisim circuit (N=5), Verilog RTL and testbench written, FPGA constraints written
- **In progress:** Simulation, diagrams, Logisim GUI verification
- **Pending:** Simulation evidence, synthesis/implementation, hardware demonstration, results, presentation, report, final Pull Request
- **Main risk:** Code and pin assignments have not yet been compiled or checked in the tools
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
