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
| `start` | In | 1 | Rising edge loads a sample (X ← switches, P ← old X) |
| `ack` | In | 1 | Return FSM to IDLE (priority over `start`) |
| `data_in` | In | N | Input switches |
| `valid_led` | Out | 1 | Exactly one bit changed |
| `invalid_led` | Out | 1 | Zero or more than one bit changed |
| `idle_led`, `state_out`, `curr_out`, `prev_out`, `v_out` | Out | – | Debug/indicator outputs |

- **Constraints and assumptions:** X = P = 0 after reset (first sample is compared with all zeros, as in the sheet's example table); a held START counts as one sample; ACK has priority over START; the FSM result appears one clock after the sample is loaded. Details in `01_Problem_Analysis/README.md`.

## 3. Problem Analysis and Proposed Solution
Requirements, edge cases (no change, multi-bit change, MSB-only change, held START, ACK/START collision, reset) and the proposed solution are documented in `01_Problem_Analysis/README.md`.

The one-bit-change detector uses the general H1 formula `V = (ΣDᵢ) · ¬(Σ_{i<j} Dᵢ·Dⱼ)`, so the same design works for any N. The input register X and previous register P are separate from the FSM controller, matching the sheet's block diagram.

## 4. Architecture
Block diagram (from the problem sheet): **Datapath** = 4-bit (N-bit) input register X, previous register P, one-bit change detector (D = X ⊕ P, V). **FSM controller** = Moore FSM (state register, next-state logic, output logic). **System outputs** = VALID LED (V = 1) and INVALID LED (V = 0).

Data flow: switches → X register → (X, P) → XOR → one-bit detector → V → next-state logic → state register → output logic → LEDs. START loads the registers, ACK/RESET return the FSM to IDLE.

[Block diagram image to be added: `path/to/block_diagram.png`]

## 5. FSM Design
- **Type:** Moore (outputs depend only on the state).
- **States/encoding:** `IDLE = 00` (both LEDs off), `VALID = 01` (VALID LED on), `INVALID = 10` (INVALID LED on).
- **Transitions:** `ACK → IDLE` (highest priority); on a loaded sample, `V = 1 → VALID`, `V = 0 → INVALID`; otherwise hold. `RESET` (synchronous) → IDLE.

| Present state | Condition | Next state | VALID LED | INVALID LED |
|---|---|---|:-:|:-:|
| any | `rst` | IDLE | – | – |
| any | `ack` | IDLE | – | – |
| any | sample loaded and V = 1 | VALID | – | – |
| any | sample loaded and V = 0 | INVALID | – | – |
| IDLE (00) | otherwise | IDLE | 0 | 0 |
| VALID (01) | otherwise | VALID | 1 | 0 |
| INVALID (10) | otherwise | INVALID | 0 | 1 |

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
- Top module and submodules: `gray_code_top_arty` (FPGA top, includes `debounce`) → `gray_code_detector #(N)` (datapath + Moore FSM)
- Architecture/coding decisions: parameterised width N; generalised pair-wise one-bit detector as a static-loop function; three-block Moore FSM; X and P registered first and V evaluated on the next clock (`eval` flag); START rising-edge detection; synchronous active-high reset.
- Synthesizability considerations: no delays or `initial`-only behaviour in the datapath (initial values are only power-up defaults); loops have constant bounds; no latches (all `always @(*)` blocks assign defaults).
- RTL: `03_Verilog_Implementation/RTL/`
- Testbench: `03_Verilog_Implementation/Testbench/`

## 8. Verification and Simulation Results
The self-checking testbench `tb_gray_code_detector.v` drives an N = 4 and an N = 8 instance together and compares them with a behavioural reference model.

| Test ID | Inputs/conditions | Expected output | Observed output | Pass/Fail |
|---|---|---|---|---|
| T01 | Sheet sequence 0001, 0011, 0111, 0101, 1101, 1100 | VALID after each | Pending simulation | Not run |
| T02 | Then 1111 (two bits change) | INVALID | Pending simulation | Not run |
| T03 | Same value twice; 0111 → 1000 (four bits) | INVALID | Pending simulation | Not run |
| T04 | START held for 4 cycles | Only one sample taken | Pending simulation | Not run |
| T05 | RESET, then 0001 | Compared with 0000 → VALID | Pending simulation | Not run |
| T06 | ACK and START in the same cycle | IDLE, sample ignored | Pending simulation | Not run |
| T07 | 300 random samples vs reference model | All match | Pending simulation | Not run |

Tool/version: [To be recorded]  
Number passed/failed: [To be recorded – testbench has not been run yet]  
Waveform/log path: `03_Verilog_Implementation/Simulation_Results/`

## 9. FPGA Hardware Implementation
- FPGA board/device: Digilent Arty S7-50, Spartan-7 `XC7S50-CSGA324-1`
- Tool/version: Vivado – version to be recorded
- Clock/constraints: 100 MHz clock (pin R2), `04_FPGA_Hardware/arty_s7_50_gray_code.xdc`; N = 4 with SW0–SW3 as data, BTN0 = START, BTN1 = ACK, BTN2 = RESET, LD0 = VALID, LD1 = INVALID, LD2 = IDLE, LD3 = V
- Synthesis/implementation summary: [Pending]
- Programming and hardware test result: [Pending]
- Evidence path: `04_FPGA_Hardware/`

Explain differences between simulation and hardware results, if any.

## 10. Challenges, Debugging and Improvements
| Issue | Root cause | Correction | Outcome |
|---|---|---|---|
| Board has only 4 switches | Arty S7 limits the demo to N = 4 | FPGA top uses N = 4; core RTL stays parameterised | Resolved |
| Mechanical button bounce | Push buttons bounce | Added 2-flop synchroniser and ~10 ms debouncer in the top level | Resolved (to be confirmed on hardware) |

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
- [ ] Simulation results and test cases documented.
- [ ] FPGA implementation and hardware evidence uploaded (constraints uploaded; reports and photos pending).
- [ ] Results, challenges and conclusion documented.
- [ ] Presentation and final report uploaded.
- [ ] STATUS.md is up to date.
- [ ] Final Pull Request created and URL recorded.
