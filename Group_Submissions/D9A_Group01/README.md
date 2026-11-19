# Digital System Design – Group Project

> Complete every mandatory section. Do not delete headings. Replace bracketed prompts. If a section is not applicable, explain why.

## 1. Team Details
| Role | Student name | Roll number | GitHub username |
|---|---|---|---|
| Group leader | Ojas Karmarkar (D9A) | 27 | ojaskarmarkar15 |
| Member 2 | Aaditya Suhanda (D9A) | 55 | [Username to be added] |
| Member 3 | Vedant Sujit Gaikwad (D9B) | 10 | [Username to be added] |
| Member 4 | Soham Sandeep Kundargi (D9B) | 28 | [Username to be added] |

**Class:** D9A (group leader's class; group includes D9A and D9B students)  
**Group ID:** D9A_Group01  
**Repository URL:** https://github.com/ojaskarmarkar15/DSD-2026-D9A-Group01  
**Final Pull Request URL:** [URL]

## 2. Assigned Problem Statement
- **Number/title:** Gray Code Transition Detector (4-bit) – selected modification **H1: N-bit Gray Code Transition Detector**
- **Problem summary:** Design a circuit that outputs 1 only when two consecutive 4-bit inputs differ by exactly one bit (a valid Gray code transition). H1 generalises the design to N bits (N ≥ 4).
- **Objective:** Store the current input X and the previous input P, compute D = X ⊕ P, detect "exactly one bit set" in D, and report the result through a Moore FSM with VALID and INVALID LEDs.
- **Inputs and outputs:**

| Signal | Dir. | Width | Meaning |
|---|---|---:|---|
| `clk` | In | 1 | Clock |
| `rst` | In | 1 | Synchronous, active-high reset |
| `start` | In | 1 | Take a sample (accepted in IDLE): P ← x and the FSM moves to VALID/INVALID |
| `ack` | In | 1 | Return the FSM from VALID/INVALID to IDLE |
| `x` | In | N | Input switches |
| `valid_led` | Out | 1 | Exactly one bit changed |
| `invalid_led` | Out | 1 | Zero or more than one bit changed (IDLE: both LEDs off) |

- **Constraints and assumptions:** P = 0 after reset (the first sample is compared with all zeros, as in the sheet's example table); START is accepted only in IDLE, so ACK is needed after every sample; the FSM result appears on the clock edge that accepts START. Details in `01_Problem_Analysis/README.md`.

## 3. Problem Analysis and Proposed Solution
Requirements, edge cases (no change, multi-bit change, MSB-only change, held START, ACK/START collision, reset) and the proposed solution are documented in `01_Problem_Analysis/README.md`.

The one-bit-change detector uses the general H1 formula `V = (ΣDᵢ) · ¬(Σ_{i<j} Dᵢ·Dⱼ)`, so the same design works for any N. The switches `x` are compared directly with the previous-input register `p`, which is updated when a sample is accepted; the FSM controller is separate from this datapath.

## 4. Architecture
Block diagram (from the problem sheet): **Datapath** = 4-bit (N-bit) input register X, previous register P, one-bit change detector (D = X ⊕ P, V). **FSM controller** = Moore FSM (state register, next-state logic, output logic). **System outputs** = VALID LED (V = 1) and INVALID LED (V = 0).

Data flow: switches → X register → (X, P) → XOR → one-bit detector → V → next-state logic → state register → output logic → LEDs. START loads the registers, ACK/RESET return the FSM to IDLE.

[Block diagram image to be added: `path/to/block_diagram.png`]

## 5. FSM Design
- **Type:** Moore (outputs depend only on the state).
- **States/encoding:** `IDLE = 00` (both LEDs off), `VALID = 01` (VALID LED on), `INVALID = 10` (INVALID LED on).
- **Transitions (as implemented in `gray_code_nbit.v`):** in `IDLE`, `start = 1` takes a sample: `V = 1 → VALID`, `V = 0 → INVALID`. In `VALID`/`INVALID`, `ack = 1 → IDLE`; `start` is ignored until then. `RESET` (synchronous) → `IDLE` from any state.

| Present state | Condition | Next state | VALID LED | INVALID LED |
|---|---|---|:-:|:-:|
| any | `rst` | IDLE | – | – |
| IDLE (00) | `start` and V = 1 | VALID | 0 | 0 |
| IDLE (00) | `start` and V = 0 | INVALID | 0 | 0 |
| IDLE (00) | no `start` | IDLE | 0 | 0 |
| VALID (01) | `ack` | IDLE | 1 | 0 |
| VALID (01) | no `ack` | VALID | 1 | 0 |
| INVALID (10) | `ack` | IDLE | 0 | 1 |
| INVALID (10) | no `ack` | INVALID | 0 | 1 |

The FSM images in `02_FSM_Logisim/` show the V-driven transitions of the sheet's diagram; in the Verilog the return path from VALID/INVALID goes through `ack` and `IDLE`.

**Diagram:** [Path/link to state diagram image – to be added]  
**State table:** above

## 6. Logisim Implementation
- Logisim version: [Version to be recorded]
- Circuit file: `02_FSM_Logisim/H1_NBit_Gray_Detector_N5.circ` (H1, N = 5)
- Test cases and expected/observed behaviour: `02_FSM_Logisim/H1_N5_test_vector.txt` – 31/31 steps pass in the headless run recorded in `STATUS.md`; manual check in the Logisim GUI still to be done.
- Issues and corrections: [Details]
- Screenshot/evidence: [Path/link]

## 7. Verilog HDL Implementation
- Tool/version: Vivado – version to be recorded
- Top module and submodules: `gray_code_nbit #(N)` (single module: previous-input register, one-bit-change detector and Moore FSM; also the FPGA top, N = 4)
- Architecture/coding decisions: parameterised width N; general one-bit-change detector `v = (|d) & ~|(d & (d - 1))` with `d = x ^ p`; single clocked process for the state and previous register; Moore outputs decoded from the state; `start` accepted only in IDLE, `ack` returns to IDLE; synchronous active-high reset.
- Synthesizability considerations: only continuous assignments and one clocked `always` block; no delays or latches in the design.
- RTL: `03_Verilog_Implementation/RTL/`
- Testbench: `03_Verilog_Implementation/Testbench/`

## 8. Verification and Simulation Results
The self-checking testbench `gray_code_nbit_tb.v` drives an N = 4 and an N = 5 instance (H1 check). Each step sets `x`, pulses `start`, checks the LEDs and then pulses `ack`.

| Test ID | Inputs/conditions | Expected output | Observed output | Pass/Fail |
|---|---|---|---|---|
| T01 | N=4: 0000 → 0001, 0011, 0111, 0101, 1101, 1100 (one bit each) | VALID after each | VALID after each (waveform) | Pass |
| T02 | N=4: 1100 → 1111 (two bits change) | INVALID (sheet: V = 0); testbench currently expects VALID – to be corrected | INVALID from the DUT; testbench flagged FAIL because its expected value is wrong | Fail (testbench expectation) |
| T03 | N=4: 1111 → 1111 (no change) | INVALID | INVALID | Pass |
| T04 | N=4: 1111 → 1001 (two bits) | INVALID | INVALID | Pass |
| T05 | N=5: 00000 → 00010, then 10010 (one bit each) | VALID | VALID | Pass |
| T06 | N=5: 10010 → 10111 (two bits) | INVALID | INVALID | Pass |

Tool/version: Vivado 2018.3 (behavioural simulation)  
Number passed/failed: 11 passed, 1 failed (the failure is the wrong expected value for `1100 -> 1111` in the testbench; the DUT output matches the sheet)  
Waveform/log path: `03_Verilog_Implementation/Simulation_Results/gray_code_nbit_tb_waveform.png` (Tcl console log still to be added)

## 9. FPGA Hardware Implementation
- FPGA board/device: Spartan-7 `XC7S50-CSGA324-1` (board to be confirmed)
- Tool/version: Vivado 2018.3
- Clock/constraints: `04_FPGA_Hardware/gray_code_nbit.xdc` (clock F14, `rst` J2, `start` J5, `ack` H2, `x[3:0]` on V2, U2, U1, T2, `valid_led` G1, `invalid_led` G2; all LVCMOS33); N = 4
- Synthesis/implementation summary: synthesis, implementation and bitstream generation completed for `xc7s50csga324-1` (screenshots in `04_FPGA_Hardware/`); utilisation: 8 LUTs, 7 registers, 3 slices, 10 IOBs (`04_FPGA_Hardware/`); timing summary shows NA because no clock constraint is defined
- Programming and hardware test result: [Pending]
- Evidence path: `04_FPGA_Hardware/`

Explain differences between simulation and hardware results, if any.

## 10. Challenges, Debugging and Improvements
| Issue | Root cause | Correction | Outcome |
|---|---|---|---|
| FPGA demo uses 4 data switches | Constraints map x[3:0] only | Top uses N = 4; the module stays parameterised and N = 5 is checked in simulation | Resolved |
| Buttons are not debounced | Constraints/RTL use the raw push-button inputs | START is accepted only in IDLE and ACK is required afterwards | To be confirmed on hardware |

Future improvements: other hints (H2–H5), e.g. Mealy version, ERROR state, valid/invalid counters.

## 11. Task Allocation and Individual Contribution
| Student | Assigned responsibility | Actual contribution/evidence |
|---|---|---|
| Group leader | Logisim circuit and repository management | H1 (N = 5) Logisim circuit and test vector (`02_FSM_Logisim/`) |
| Member 2 | [ ] | [ ] |
| Member 3 | [ ] | [ ] |
| Member 4 | [ ] | [ ] |

Every student must be ready to explain the complete design.

## 12. Progress Log
Maintain time-wise updates in `STATUS.md`.

## 13. Final Results and Conclusion
[To be written after simulation and hardware testing.]

## 14. Team Reflection
[To be written.]

## 15. Final Submission Checklist
- [x] Team details and problem analysis complete (GitHub usernames of three members still missing).
- [ ] Architecture/block diagram included (text description added; diagram image pending).
- [ ] FSM diagram/table or justified alternative included (state table added; diagram image pending).
- [ ] Logisim source and simulation evidence uploaded (N = 5 circuit uploaded; screenshots pending).
- [x] Verilog RTL and testbench uploaded.
- [ ] Simulation results and test cases documented (waveform and 11/12 result uploaded; testbench fix and Tcl log pending).
- [ ] FPGA implementation and hardware evidence uploaded (constraints, schematic and implemented-design screenshots uploaded; reports and hardware photos pending).
- [ ] Results, challenges and conclusion documented.
- [ ] Presentation and final report uploaded.
- [ ] STATUS.md is up to date.
- [ ] Final Pull Request created and URL recorded.
